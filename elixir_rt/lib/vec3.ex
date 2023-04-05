defmodule Vec3 do
  defstruct x: 0.0, y: 0.0, z: 0.0

  @doc ~S"""
  Parses the given `line` into a command.

  ## Examples

      iex> Vec3.add %Vec3{x: 1.0, y: 1.0, z: 1.0}, %Vec3{x: 2, y: 2, z: 2}
      %Vec3{x: 3.0, y: 3.0, z: 3.0}

      iex> Vec3.sub %Vec3{x: 1.0, y: 1.0, z: 1.0}, %Vec3{x: 2, y: 2, z: 2}
      %Vec3{x: -1.0, y: -1.0, z: -1.0}

      iex> Vec3.cross %Vec3{x: 1.0, y: 1.0, z: 1.0}, %Vec3{x: 1.0, y: 0.0, z: 0.0}
      %Vec3{x: 0.0, y: 1.0, z: -1.0}

      iex> Vec3.dot %Vec3{x: 1.0, y: 1.0, z: 1.0}, %Vec3{x: 1.0, y: 0.0, z: 0.0}
      1.0

      iex> Vec3.mag %Vec3{x: 1.0, y: 0.0, z: 0.0}
      1.0

      iex> Vec3.scale %Vec3{x: 1.0, y: 1.0, z: 1.0}, 0.5
      %Vec3{x: 0.5, y: 0.5, z: 0.5}

      iex> Vec3.unit %Vec3{x: 1.0, y: 1.0, z: 1.0}
      %Vec3{x: 1.0 / :math.sqrt(3), y: 1.0 / :math.sqrt(3), z: 1.0 / :math.sqrt(3)}

      iex> Vec3.negate %Vec3{x: 1.0, y: 1.0, z: 1.0}
      %Vec3{x: -1.0, y: -1.0, z: -1.0}

      iex> Vec3.close_to_zero %Vec3{x: 1.0, y: 0.0, z: 0.0}
      false

      iex> Vec3.close_to_zero %Vec3{x: 0.0, y: 0.0, z: 0.0}
      true

      iex> Vec3.close_to_zero %Vec3{x: 1.0e-9, y: -1.0e-9, z: 0.5e-8}
      true

  """

  def add(%Vec3{x: x, y: y, z: z}, %Vec3{x: u, y: v, z: w}) do
    %Vec3{x: x + u, y: y + v, z: z + w}
  end

  def sub(%Vec3{x: x, y: y, z: z}, %Vec3{x: u, y: v, z: w}) do
    %Vec3{x: x - u, y: y - v, z: z - w}
  end

  def cross(%Vec3{x: x, y: y, z: z}, %Vec3{x: u, y: v, z: w}) do
    %Vec3{
      x: y * w - z * v,
      y: z * u - x * w,
      z: x * v - y * u
    }
  end

  def dot(%Vec3{x: x, y: y, z: z}, %Vec3{x: u, y: v, z: w}) do
    x * u + y * v + z * w
  end

  def mag(%Vec3{} = v) do
    dot(v, v) |> :math.sqrt()
  end

  def scale(%Vec3{x: x, y: y, z: z}, f) do
    %Vec3{x: f * x, y: f * y, z: f * z}
  end

  def unit(%Vec3{} = v) do
    v |> scale(1.0 / mag(v))
  end

  def negate(%Vec3{x: x, y: y, z: z}) do
    %Vec3{x: -x, y: -y, z: -z}
  end

  def close_to_zero(%Vec3{x: x, y: y, z: z}) do
    epsilon = 1.0e-8
    abs(x) < epsilon and abs(y) < epsilon and abs(z) < epsilon
  end

  def random_point_in_unit_sphere() do
    r = :rand.uniform()
    theta = :rand.uniform() * 2.0 * :math.pi()
    phi = :rand.uniform() * 2.0 * :math.pi()

    %Vec3{
      x: r * :math.sin(phi) * :math.cos(theta),
      y: r * :math.sin(phi) * :math.sin(theta),
      z: r * :math.cos(phi)
    }
  end

  def random() do
    random_point_in_unit_sphere() |> unit()
  end
end
