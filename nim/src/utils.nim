import std/math
import std/random
import vec3

func degToRad*(deg: float): float =
  deg * PI / 180.0

func radToDeg*(rad: float): float =
  rad * 180.0 / PI

func clamp*(f, min, max: float): float =
  if f < min:
    result = min
  elif max < f:
    result = max
  else:
    result = f

func lerp*[T](a, b: T; t: float): T =
  result = (1.0 - t) * a + t * b
