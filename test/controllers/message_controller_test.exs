defmodule Docs.MessageControllerTest do
  use Docs.ConnCase

  alias Docs.Message
  @valid_attrs %{body: "some content", username: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, message_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing messages"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, message_path(conn, :new)
    assert html_response(conn, 200) =~ "New message"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, message_path(conn, :create), message: @valid_attrs
    assert redirected_to(conn) == message_path(conn, :index)
    assert Repo.get_by(Message, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, message_path(conn, :create), message: @invalid_attrs
    assert html_response(conn, 200) =~ "New message"
  end

  test "shows chosen resource", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = get conn, message_path(conn, :show, message)
    assert html_response(conn, 200) =~ "Show message"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, message_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = get conn, message_path(conn, :edit, message)
    assert html_response(conn, 200) =~ "Edit message"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = put conn, message_path(conn, :update, message), message: @valid_attrs
    assert redirected_to(conn) == message_path(conn, :show, message)
    assert Repo.get_by(Message, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = put conn, message_path(conn, :update, message), message: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit message"
  end

  test "deletes chosen resource", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = delete conn, message_path(conn, :delete, message)
    assert redirected_to(conn) == message_path(conn, :index)
    refute Repo.get(Message, message.id)
  end
end
