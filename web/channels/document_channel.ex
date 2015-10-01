defmodule Docs.DocumentChannel do
  use Docs.Web, :channel
  alias Docs.Document

  def join("documents:" <> doc_id, _params, socket) do
    {:ok, assign(socket, :doc_id, doc_id)}
  end

  def handle_in("text_change", %{"ops" => ops}, socket) do
    broadcast_from! socket, "text_change", %{
      ops: ops
    }
    {:reply, :ok, socket}
  end

  def handle_in("save", params, socket) do
    Document
    |> Repo.get(socket.assigns.doc_id)
    |> Document.changeset(params)
    |> Repo.update()
    |> case do
      {:ok, _document} ->
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{reasons: changeset}}, socket}
    end
  end
end
