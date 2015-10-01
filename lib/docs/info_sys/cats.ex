defmodule Docs.InfoSys.Cats do

  def compute_img(opts) do
    :random.seed(:os.timestamp())
    :timer.sleep(10_000)

    if String.contains?(opts[:expr], "cat") do
      %{score: 100, img_url: random_cat()}
    else
      :noresult
    end
  end

  defp random_cat() do
    Enum.random([
      "http://stylonica.com/wp-content/uploads/2014/03/cats_animals_kittens_cat_kitten_cute_desktop_1680x1050_hd-wallpaper-753974.jpeg",
      "https://upload.wikimedia.org/wikipedia/commons/1/1e/Large_Siamese_cat_tosses_a_mouse.jpg",
      "http://www.hintsandthings.co.uk/garden/cats.h1.jpg"
    ])
  end
end
