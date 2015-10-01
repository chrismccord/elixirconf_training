defmodule Docs.MessageController do
  use Docs.Web, :controller

  alias Docs.Message

  plug :find_document
  plug :scrub_params, "message" when action in [:create, :update]

  def index(conn, _params) do
    doc = conn.assigns.document

    messages = Repo.all(from m in assoc(doc, :messages))
    render(conn, "index.html", messages: messages)
  end

  def new(conn, _params) do
    changeset = Message.changeset(%Message{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"message" => message_params}) do
    doc = conn.assigns.document
    changeset =
      doc
      |> Ecto.Model.build(:messages)
      |> Message.changeset(message_params)

    case Repo.insert(changeset) do
      {:ok, msg} ->
        Docs.Endpoint.broadcast("documents:#{doc.id}", "new_message", %{
          id: msg.id, body: msg.body
        })

        conn
        |> put_flash(:info, "Message created successfully.")
        |> redirect(to: document_message_path(conn, :index, conn.assigns.document))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    message = Repo.get!(Message, id)
    render(conn, "show.html", message: message)
  end

  def edit(conn, %{"id" => id}) do
    message = Repo.get!(Message, id)
    changeset = Message.changeset(message)
    render(conn, "edit.html", message: message, changeset: changeset)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Repo.get!(Message, id)
    changeset = Message.changeset(message, message_params)

    case Repo.update(changeset) do
      {:ok, message} ->
        conn
        |> put_flash(:info, "Message updated successfully.")
        |> redirect(to: document_message_path(conn, :show, conn.assigns.document, message))
      {:error, changeset} ->
        render(conn, "edit.html", message: message, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Repo.get!(Message, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(message)

    conn
    |> put_flash(:info, "Message deleted successfully.")
    |> redirect(to: document_message_path(conn, :index, conn.assigns.document))
  end


  defp find_document(conn, _) do
    assign(conn, :document, Repo.get!(Docs.Document, conn.params["document_id"]))
  end
end
