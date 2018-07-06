defmodule Discuss.CommentsChannel do
  use Discuss.Web , :channel
  alias Discuss.Topic
  alias Discuss.Comment

  def join("comments:" <> topic_id, _params , socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic
    |>Repo.get(topic_id)
    |>Repo.preload(:comments)
    {:ok, %{comments: topic.comments} , assign(socket, :topic, topic) }
  end


  def handle_in(name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    IO.puts("+++")
    IO.inspect(content)
    changeset = topic
      |>build_assoc(:comments)
      |>Comment.changeset(%{content: content})
    case Repo.insert(changeset) do
      {:ok, comment} ->
        IO.puts("++++++++++++++++")
        IO.puts("evento broadcast")
        IO.puts("comments:#{topic.id}:new")
        IO.puts("++++++++++++++++")
        broadcast!(socket, "comments:#{topic.id}:new", %{comment: comment})
        {:reply, :ok, socket}

      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end

  end

end
