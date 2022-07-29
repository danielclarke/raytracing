import std/math
import color
import point3
import vec3
import ray

type
  Camera = object
    aspect, height, width, focalLength: float
    origin: Point3
    horizontal, vertical, lowerLeftCorner: Vec3

func newCamera*(verticalFOV, aspect, focalLength: float, lookFrom, lookAt, vUp: Point3): Camera =
  # let theta = verticalFOV * PI / 180.0
  let height = 2.0 * tan(verticalFOV / 2)
  let width = aspect * height

  let w = (lookFrom - lookAt).unit()
  let u = vUp.cross(w).unit()
  let v = w.cross(u)

  Camera(
    aspect: aspect,
    height: height,
    width: width,
    focalLength: focalLength,
    origin: lookFrom,
    horizontal: width * u,
    vertical: height * v,
    lowerLeftCorner: lookFrom - (width * u) / 2.0 - (height * v) / 2.0 - w
  )

func getRay*(self: Camera; s, t: float): Ray =
  Ray(
    origin: self.origin,
    direction: self.lowerLeftCorner + s * self.horizontal + t * self.vertical - self.origin,
    color: Color(x: 1.0, y: 1.0, z: 1.0)
  )
