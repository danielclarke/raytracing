import std/math
import std/random

type
  Vec3* = object
    x*, y*, z*: float

  Vec3Tuple = tuple
    x, y, z: float

converter toVec3*(v: Vec3Tuple): Vec3 =
  Vec3(x: v.x, y: v.y, z: v.z)

func zerosVec3*(): Vec3 =
  Vec3(x: 0.0, y: 0.0, z: 0.0)

func onesVec3*(): Vec3 =
  Vec3(x: 1.0, y: 1.0, z: 1.0)

func `+`*(u, v: Vec3): Vec3 =
  Vec3(x: u.x + v.x, y: u.y + v.y, z: u.z + v.z)

func `+`*(u: Vec3; v: Vec3Tuple): Vec3 =
  Vec3(x: u.x + v.x, y: u.y + v.y, z: u.z + v.z)

func `-`*(u, v: Vec3): Vec3 =
  Vec3(x: u.x - v.x, y: u.y - v.y, z: u.z - v.z)

func `-`*(v: Vec3): Vec3 =
  Vec3(x: -v.x, y: -v.y, z: -v.z)

func `*`*(u, v: Vec3): Vec3 =
  Vec3(x: u.x * v.x, y: u.y * v.y, z: u.z * v.z)

func `*`*(v: Vec3; s: float): Vec3 =
  Vec3(x: v.x * s, y: v.y * s, z: v.z * s)

func `+=`*(u: var Vec3; v: Vec3) =
  u = u + v

func `-=`*(u: var Vec3; v: Vec3) =
  u = u - v

func `*=`*(v: var Vec3; s: float) =
  v = v * s

func `*`*(s: float; v: Vec3): Vec3 =
  v * s

func `/`*(v: Vec3; s: float): Vec3 =
  Vec3(x: v.x / s, y: v.y / s, z: v.z / s)

func dot*(u, v: Vec3): float =
  u.x * v.x + u.y * v.y + u.z * v.z

func cross*(u, v: Vec3): Vec3 =
  Vec3(
    x: u.y * v.z - u.z * v.y,
    y: u.z * v.x - u.x * v.z,
    z: u.x * v.y - u.y * v.x
  )

func mag*(v: Vec3): float =
  sqrt(v.x * v.x + v.y * v.y + v.z * v.z)

func unit*(v: Vec3): Vec3 =
  let m = mag(v)
  if m == 0.0:
    return v
  else:
    return v / m

func limit*(v: Vec3; l: float): Vec3 =
  let m = mag(v)
  if l < m:
    return v / m * l
  else:
    return v

proc randomVec3*(min, max: Vec3): Vec3 =
  Vec3(x: rand(max.x - min.x) + min.x, y: rand(max.y - min.y) + min.y, z: rand(
      max.z - min.z) + min.z)

proc randomPointInUnitSphere*(): Vec3 =
  let r = rand(1.0)
  let theta = rand(2.0 * PI)
  let phi = rand(2.0 * PI)

  Vec3(x: r * sin(phi) * cos(theta), y: r * sin(phi) * sin(theta), z: r * cos(phi))

proc randomUnitVec3*(): Vec3 =
  randomPointInUnitSphere().unit()

proc randomInHemisphere*(v: Vec3): Vec3 =
  let u = randomPointInUnitSphere()
  if 0.0 < dot(u, v):
    return u
  else:
    return -u