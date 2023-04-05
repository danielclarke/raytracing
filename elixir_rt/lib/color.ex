defmodule Color do
  defstruct r: 0.0, g: 0.0, b: 0.0

  @doc ~S"""
  Parses the given `line` into a command.

  ## Examples
      iex> Color.lerp %Color{r: 0.0, g: 0.0, b: 0.0}, %Color{r: 1.0, g: 1.0, b: 1.0}, 0.5
      %Color{r: 0.5, g: 0.5, b: 0.5}

      iex> Color.ppm %Color{r: 1.0, g: 1.0, b: 1.0}, 1
      "255 255 255"

      iex> Color.ppm %Color{r: 0.0, g: 0.0, b: 0.0}, 1
      "0 0 0"
  """

  def black() do
    %Color{r: 0.0, g: 0.0, b: 0.0}
  end

  def white() do
    %Color{r: 1.0, g: 1.0, b: 1.0}
  end

  def add(%Color{r: r, g: g, b: b}, %Color{r: u, g: v, b: w}) do
    %Color{r: r + u, g: g + v, b: b + w}
  end

  def scale(%Color{r: r, g: g, b: b}, f) do
    %Color{r: f * r, g: f * g, b: f * b}
  end

  def lerp(%Color{} = u, %Color{} = v, f) do
    u |> scale(1.0 - f) |> add(v |> scale(f))
  end

  defp clamp(value, lower, upper) do
    cond do
      value < lower -> lower
      value > upper -> upper
      true -> value
    end
  end

  defp bit8(v, samples) do
    lower = 0.0
    upper = 0.999
    scale = 1.0 / samples

    (v * scale) |> :math.sqrt() |> clamp(lower, upper) |> Kernel.*(255.999) |> trunc()
  end

  def ppm(%Color{r: r, g: g, b: b}, samples) do
    "#{r |> bit8(samples)} #{g |> bit8(samples)} #{b |> bit8(samples)}"
  end
end
