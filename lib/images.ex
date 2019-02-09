defmodule Images do
  use Application

  defp poolboy_config do
    [
      {:name, {:local, :worker}},
      {:worker_module, Images.Worker},
      {:size, 20},
      {:max_overflow, 5}
    ]
  end

  def start(_type, _args) do
    children = [
      :poolboy.child_spec(:worker, poolboy_config())
    ]

    opts = [strategy: :one_for_one, name: Images.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def generate_qr_code(text, incrementor) do
    qr_code_content = text <> "-" <> Integer.to_string(incrementor)

    content =
      qr_code_content
      |> EQRCode.encode()
      |> EQRCode.png(width: 500)

    File.write("./results/save#{incrementor}.png", content, [:binary])
    # resize(incrementor)
  end

  # def resize(incrementor) do
  #   file = "./results/save#{incrementor}.png"

  #   Mogrify.open(file)
  #   |> Mogrify.resize_to_fill("500x500")
  #   |> Mogrify.save(in_place: true)
  # end

  # def batch_process(size) do
  #   text = "hello world"

  #   if size > 0 do
  #     {_, pid} = Worker.start_link({})
  #     Worker.call(pid, {text, size})
  #     batch_process(size - 1)
  #   end
  # end
end
