import std/options

import color
import vec3
import point3
import ray

type

  Lambertian* = object
    albedo*: Color

  Metal* = object
    albedo*: Color
    fuzz*: float

  Dielectric* = object
    refractiveIndex*: float

  MaterialVariant* = enum
    mvLambertian,
    mvMetal,
    mvDielectric

  Material* = object
    case variant*: MaterialVariant
    of mvLambertian:
      lambertian*: Lambertian
    of mvMetal:
      metal*: Metal
    of mvDielectric:
      dielectric*: Dielectric

  HitRecord* = object
    p*: Point3
    normal*: Vec3
    material*: Material
    t*: float
    frontFace*: bool

func qualifyNormal*(self: HitRecord; ray: Ray; outwardNormal: Vec3): HitRecord =
  let frontFace = dot(ray.direction, outwardNormal) < 0.0;
  let normal = if frontFace:
    outwardNormal
  else:
    -outwardNormal
  result = HitRecord(p: self.p, normal: normal, material: self.material, t: self.t, frontFace: frontFace)

proc scatter(self: Lambertian; ray: Ray; rec: HitRecord): Option[Ray] =
  let scatterDirection = rec.normal + randomUnitVec3()
  let direction = if scatterDirection.nearZero():
    rec.normal
  else:
    scatterDirection
  some(Ray(origin: rec.p, direction: direction, color: self.albedo))

func scatter(self: Metal; ray: Ray; rec: HitRecord): Option[Ray] =
  let reflectDirection = ray.direction.unit.reflect(rec.normal)
  some(Ray(origin: rec.p, direction: reflectDirection, color: self.albedo))

func scatter(self: Dielectric; ray: Ray; rec: HitRecord): Option[Ray] =
  none(Ray)

proc scatter*(self: Material; ray: Ray; rec: HitRecord): Option[Ray] =
  case self.variant
  of mvLambertian:
    self.lambertian.scatter(ray, rec)
  of mvMetal:
    self.metal.scatter(ray, rec)
  of mvDielectric:
    self.dielectric.scatter(ray, rec)
