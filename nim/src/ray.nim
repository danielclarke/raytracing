import color
import vec3
import point3

type
  Ray* = object
    origin*: Point3
    direction*: Vec3
    color*: Color

func at*(self: Ray; t: float): Point3 =
  self.origin + t * self.direction
