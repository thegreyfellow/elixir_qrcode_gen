defmodule ImagesTest do
  use ExUnit.Case
  doctest Images

  test "greets the world" do
    assert Images.hello() == :world
  end
end
