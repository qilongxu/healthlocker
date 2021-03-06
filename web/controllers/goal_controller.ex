defmodule Healthlocker.GoalController do
  use Healthlocker.Web, :controller

  plug :authenticate

  alias Healthlocker.Goal

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    goals = Goal
           |> Goal.get_goals(user_id)
           |> Repo.all
    if Kernel.length(goals) == 0 do
      conn
      |> redirect(to: goal_path(conn, :new))
    else
      important_goals =  Enum.filter(goals, fn(g) -> g.important end)
      |> Enum.sort(&(&1.updated_at > &2.updated_at))
      unimportant_goals = Enum.filter(goals, fn(g) -> !g.important end)
      |> Enum.sort(&(&1.updated_at > &2.updated_at))
      all_goals = Enum.concat(important_goals, unimportant_goals)
      render conn, "index.html", goals: all_goals
    end
  end

  def new(conn, _params) do
    changeset =  Goal.changeset(%Goal{})
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => id}) do
    user_id = conn.assigns.current_user.id
    goal = Goal
          |> Goal.get_goal_by_user(id, user_id)
          |> Repo.one!
    render conn, "show.html", goal: goal
  end

  def mark_important(conn, %{"id" => id}) do
    goal = Repo.get!(Goal, id)
    changeset = Goal.mark_important_changeset(goal, %{important: !goal.important})

    case Repo.update(changeset) do
      {:ok, goal} ->
        conn
        |> redirect(to: goal_path(conn, :show, goal))
      {:error, _changeset} ->
        conn
        |> put_flash(:info, "Could not mark as important. Try again later.")
        |> render("show.html", goal: goal)
    end
  end

  def create(conn, %{"goal" => goal_params}) do
    content = get_content(goal_params)
    user_id = get_session(conn, :user_id)
    changeset = Goal.changeset(%Goal{}, content)
              |> Ecto.Changeset.put_change(:user_id, user_id)

    case Repo.insert(changeset) do
      {:ok, _goal} ->
        conn
        |> put_flash(:info, "Goal added!")
        |> redirect(to: goal_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user_id = conn.assigns.current_user.id
    goal = Goal
          |> Goal.get_goal_by_user(id, user_id)
          |> Repo.one
          |> Map.update!(:content, &(String.trim_trailing(&1, " #Goal")))
    changeset = Goal.changeset(goal)
    render(conn, "edit.html", goal: goal, changeset: changeset)
  end

  def update(conn, %{"id" => id, "goal" => goal_params}) do
    goal = Repo.get!(Goal, id)
    content = get_content(goal_params)
    changeset = Goal.changeset(goal, content)

    case Repo.update(changeset) do
      {:ok, goal} ->
        conn
        |> put_flash(:info, "Goal updated successfully.")
        |> redirect(to: goal_path(conn, :show, goal))
      {:error, changeset} ->
        render(conn, "edit.html", goal: goal, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_id = conn.assigns.current_user.id
    goal = Goal
          |> Goal.get_goal_by_user(id, user_id)
          |> Repo.one

    Repo.delete!(goal)

    conn
    |> put_flash(:info, "Goal deleted successfully.")
    |> redirect(to: goal_path(conn, :index))
  end

  def get_content(params) do
    if Map.has_key?(params, "content") && params["content"] != "" do
      Map.update(params, "content", params["content"], &(&1 <> " #Goal"))
    else
      params
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error,  "You must be logged in to access that page!")
      |> redirect(to: login_path(conn, :index))
      |> halt()
    end
  end
end
