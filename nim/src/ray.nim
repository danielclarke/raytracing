import vec3
import point3

type
  Ray* = object
    origin*: Point3
    direction*: Vec3

func at*(self: Ray; t: float): Point3 =
  self.origin + t * self.direction
