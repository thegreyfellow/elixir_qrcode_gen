defmodule Images do
  require Images.ImageWorker, as: Worker

  @moduledoc """
  Documentation for Images.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Images.hello()
      :world

  """
  def generate_qr_code(text, incrementor) do
    qr_code_content = text <> "-" <> Integer.to_string(incrementor)

    content =
      qr_code_content
      |> EQRCode.encode()
      |> EQRCode.png()

    File.write("./results/save#{incrementor}.png", content, [:binary])
    resize(incrementor)
  end

  def resize(incrementor) do
    file = "./results/save#{incrementor}.png"

    Mogrify.open(file)
    |> Mogrify.resize_to_fill("500x500")
    |> Mogrify.save(in_place: true)
  end

  def batch_process(size) do
    text = "hello world"

    if size > 0 do
      {_, pid} = Worker.start_link({})
      Worker.call(pid, {text, size})
      batch_process(size - 1)
    end
  end
end
