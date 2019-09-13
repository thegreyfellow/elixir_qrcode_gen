defmodule Images.Test do
  @timeout 60000

  def start do
    time1 = DateTime.utc_now()

    1..1000
    |> Enum.map(fn i -> async_call_generate_qr_code("Some text here to encode", i) end)
    |> Enum.each(fn task -> await_and_inspect(task) end)

    IO.puts Time.diff(DateTime.utc_now(), time1)
  end

  defp async_call_generate_qr_code(text, i) do
    Task.async(fn ->
      :poolboy.transaction(
        :worker,
        fn pid -> GenServer.call(pid, {:generate_qr_code, text, i}) end,
        @timeout
      )
    end)
  end

  defp await_and_inspect(task), do: task |> Task.await(@timeout) |> IO.inspect()
end
