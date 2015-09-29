# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Docs.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Docs.Repo
alias Docs.Document
alias Docs.Message
import Ecto.Changeset

Repo.insert!(change(%Document{}, %{
  title: "Elixir",
  body: """
  Elixir is a dynamic, functional language designed for building scalable and maintainable applications.
  Elixir leverages the Erlang VM, known for running low-latency, distributed and fault-tolerant systems, while also being successfully used in web development and the embedded software domain.
  To learn more about Elixir, check our getting started guide. Or keep reading to get an overview of the platform, language and tools.
  """,
  messages: [%Message{body: "<3 <3 elixir"}]
}))

Repo.insert!(change(%Document{}, %{
  title: "Phoenix",
  body: """
  Phoenix is a framework for building HTML5 apps, API backends and distributed systems. Written in Elixir, you get beautiful syntax, productive tooling and a fast runtime.
  """,
  messages: [%Message{body: "<3 <3 phoenix"}]
}))
