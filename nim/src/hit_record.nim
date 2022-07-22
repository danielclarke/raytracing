import vec3
import point3
import ray

type
  HitRecord* = object
    p*: Point3
    normal*: Vec3
    t*: float
    frontFace*: bool

func qualifyNormal*(self: HitRecord; ray: Ray; outwardNormal: Vec3): HitRecord =
  let frontFace = dot(ray.direction, outwardNormal) < 0.0;
  let normal = if frontFace:
    outwardNormal
  else:
    -outwardNormal
  result = HitRecord(p: self.p, normal: normal, t: self.t, frontFace: frontFace)
