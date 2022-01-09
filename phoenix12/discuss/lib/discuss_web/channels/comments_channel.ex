defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel
  alias Discuss.Topic
  alias Discuss.Repo
  alias Discuss.Comment
  import Ecto

  @impl true
  def join("comments:" <> topic_id, payload, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic
    |> Repo.get(topic_id)
    |> Repo.preload(comments: [:user])
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  @impl true
  def handle_in(name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user_id = socket.assigns.user_id

    changeset = topic
    |> build_assoc(:comments, user_id: user_id)
    |> Comment.changeset(%{content: content})

    changeset
    |> Repo.insert()
    |> case do
      {:ok, comment} ->
        comment = Repo.preload(comment, :user)
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new",
          %{comment: comment}
        )
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
    {:reply, {:ok, content}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
