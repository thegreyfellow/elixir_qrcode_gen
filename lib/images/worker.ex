defmodule Images.Worker do
  use GenServer

  def start_link([]) do
    :gen_server.start_link(__MODULE__, [], [])
  end

  def init(_state) do
    {:ok, nil}
  end

  def call(pid, {text, inc}) do
    GenServer.call(pid, {:generate_qr_code, text, inc})
  end

  def handle_call({:generate_qr_code, text, incrementor}, from, state) do
    Images.generate_qr_code(text, incrementor)
    {:reply, from, state}
  end
end
