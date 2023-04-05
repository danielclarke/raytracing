defmodule Ray do
  defstruct origin: Vec3, direction: Vec3, color: Color

  @doc ~S"""
  Parses the given `line` into a command.

  ## Examples
      iex> Ray.at(%Ray{origin: %Vec3{x: 0.0, y: 0.0, z: 0.0}, direction: %Vec3{x: 1.0, y: 0.0, z: 0.0}}, 0.5)
      %Vec3{x: 0.5, y: 0.0, z: 0.0}
  """

  def at(%Ray{origin: origin, direction: direction}, t) do
    direction |> Vec3.scale(t) |> Vec3.add(origin)
  end
end
