import std/strformat
import std/math
import vec3
import utils

type
  Color* = Vec3

func white*(): Color =
  Color(x: 1.0, y: 1.0, z: 1.0)

func black*(): Color =
  Color(x: 0.0, y: 0.0, z: 0.0)

func ppm*(c: Color; samples: int): string =
  let scale = 1.0 / samples.float
  let r = (clamp(sqrt(scale * c.x), 0, 0.999) * 255.999).int
  let g = (clamp(sqrt(scale * c.y), 0, 0.999) * 255.999).int
  let b = (clamp(sqrt(scale * c.z), 0, 0.999) * 255.999).int
  result = fmt("{r} {g} {b}")
