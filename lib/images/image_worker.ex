defmodule Images.ImageWorker do
  use GenServer

  def start_link({}) do
    :gen_server.start_link(__MODULE__, {}, [])
  end

  def init(_state) do
    IO.puts("GenServer Init...")
    state = 0
    {:ok, state}
  end

  def call(pid, {text, inc}) do
    GenServer.call(pid, {text, inc})
  end

  def handle_call({text, incrementor}, from, state) do
    Images.generate_qr_code(text, incrementor)
    {:reply, from, state}
  end
end
