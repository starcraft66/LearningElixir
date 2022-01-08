defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias Discuss.Topic
  alias Discuss.Repo
  import Ecto

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_existence when action in [:update, :edit, :delete]
  plug :check_topic_owner when action in [:update, :edit, :delete]

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    conn.assigns.user
    |> build_assoc(:topics)
    |> Topic.changeset(topic)
    |> Repo.insert()
    |> case do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Topic created!")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} -> render conn, "new.html", changeset: changeset
    end
  end

  def index(conn, _params) do
    IO.inspect(conn.assigns)
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)

    old_topic
    |> Topic.changeset(topic)
    |> Repo.update()
    |> case do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated!")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Topic
    |> Repo.get!(topic_id)
    |> Repo.delete!()

    conn
    |> put_flash(:info, "Topic deleted!")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn

    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You don't have permission to perform that action")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end

  def check_topic_existence(conn, _params) do
    %{params: %{"id" => topic_id}} = conn

    Repo.get(Topic, topic_id)
    |> case do
      %Discuss.Topic{} ->
        conn
      nil ->
        conn
        |> put_flash(:error, "That topic doesn't exist!")
        |> redirect(to: Routes.topic_path(conn, :index))
        |> halt()
    end
  end
end
