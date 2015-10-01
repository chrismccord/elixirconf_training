defmodule Docs.InfoSys.Cats do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(opts) do
    send(self, :request)
    :random.seed(:os.timestamp())
    {:ok, opts}
  end

  def handle_info(:request, opts) do
    if String.contains?(opts[:expr], "cat") do
      img_url = random_cat()
      send(opts[:client_pid], {:result, self, %{
                                score: 100, img_url: img_url}})
    else
      send(opts[:client_pid], {:noresult, self})
    end

    {:stop, :shutdown, opts}
  end

  defp random_cat() do
    Enum.random([
      "http://stylonica.com/wp-content/uploads/2014/03/cats_animals_kittens_cat_kitten_cute_desktop_1680x1050_hd-wallpaper-753974.jpeg",
      "https://upload.wikimedia.org/wikipedia/commons/1/1e/Large_Siamese_cat_tosses_a_mouse.jpg",
      "http://www.hintsandthings.co.uk/garden/cats.h1.jpg"
    ])
  end

end
