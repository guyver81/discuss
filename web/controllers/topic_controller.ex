defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  alias Discuss.Topic

  plug Discuss.Plugs.RequireAuth when action in [:create, :new, :edit, :update , :delete ]
  plug :check_owner when action in [:edit,:update, :delete]

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{})
    render conn , "new.html", changeset: changeset
  end

  def create(conn, %{"topic"=> topic}) do
    changeset  = Topic.changeset(%Topic{},topic)

    changeset = conn.assigns.user
    |>build_assoc(:topics)
    |>Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |>put_flash(:info,"Topic Created")
        |>redirect(to: topic_path(conn,:index))
      {:error, changeset} -> render conn , "new.html" , changeset: changeset
    end
  end

  def index(conn,_params) do
    render conn, "index.html" , topics: Repo.all(Topic)
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)
    render conn , "edit.html" , changeset: changeset , topic: topic
  end


  def update(conn,%{"id" => topic_id , "topic" => topic}) do
    oldtopic = Repo.get(Topic, topic_id)
    changeset =

      Topic.changeset(oldtopic,topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |>put_flash(:info,"Topic Updated")
        |>redirect(to: topic_path(conn,:index))

      {:error, changeset} -> render conn , "edit.html" , changeset: changeset, topic: oldtopic
    end
  end

 def delete(conn , %{"id" => topic_id}) do

   Repo.get!(Topic, topic_id)
   |>Repo.delete!

   conn
   |>put_flash(:info, "Topic Deleted")
   |>redirect(to: topic_path(conn, :index))
 end

 def show(conn, %{"id" => topic_id}) do
   topic = Repo.get!(Topic, topic_id)
   render conn, "show.html", topic: topic
 end




  def list(conn, _params) do
    #list = Repo.all(Topic)

    map = %{danno: 10}
    json conn , map
  end

 def check_owner(conn,_params) do
   %{params: %{"id" => topic_id}} = conn

   if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
     conn
   else
     conn
     |>put_flash(:error, "You don't have permission")
     |>redirect(to: topic_path(conn, :index))
     |>halt()
   end
 end
end
