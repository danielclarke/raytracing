import point3
import vec3
import ray

type
  Camera = object
    aspect, height, width, focalLength: float
    origin: Point3
    horizontal, vertical, lowerLeftCorner: Vec3

func newCamera*(aspect, width, focalLength: float, origin: Point3): Camera =
  let height = width / aspect
  let horizontal = Vec3(x: width, y: 0.0, z: 0.0)
  let vertical = Vec3(x: 0.0, y: height, z: 0.0)
  Camera(
    aspect: aspect,
    height: height,
    width: width,
    focalLength: focalLength,
    origin: origin,
    horizontal: horizontal,
    vertical: vertical,
    lowerLeftCorner: origin - horizontal / 2.0 - vertical / 2.0 - Vec3(x: 0.0,
        y: 0.0, z: focalLength)
  )

func getRay*(self: Camera; u, v: float): Ray =
  Ray(origin: self.origin, direction: self.lowerLeftCorner + u *
      self.horizontal + v * self.vertical - self.origin)
