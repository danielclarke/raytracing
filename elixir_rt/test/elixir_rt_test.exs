defmodule ElixirRtTest do
  use ExUnit.Case
  doctest ElixirRt

  test "greets the world" do
    assert ElixirRt.hello() == :world
  end
end
