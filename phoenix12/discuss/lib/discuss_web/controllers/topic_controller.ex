defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias Discuss.Topic
  alias Discuss.Repo

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    Topic.changeset(%Topic{}, topic)
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
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    Topic
    |> Repo.get(topic_id)
    |> Topic.changeset(topic)
    |> Repo.update()
    |> case do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated!")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset
    end
  end
end
