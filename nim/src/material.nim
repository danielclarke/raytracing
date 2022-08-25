import std/options
import std/math
import std/random

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
    albedo*: Color
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

func qualifiedHitRecord*(ray: Ray; p: Point3; outwardNormal: Vec3; material: Material; t: float): HitRecord =
  let frontFace = dot(ray.direction, outwardNormal) < 0.0;
  let normal = if frontFace:
    outwardNormal
  else:
    -outwardNormal
  result = HitRecord(p: p, normal: normal, material: material, t: t, frontFace: frontFace)

proc scatter(self: Lambertian; ray: Ray; rec: HitRecord): Option[Ray] =
  let scatterDirection = rec.normal + randomUnitVec3()
  let direction = if scatterDirection.nearZero():
    rec.normal
  else:
    scatterDirection
  some(Ray(origin: rec.p, direction: direction, color: self.albedo))

proc scatter(self: Metal; ray: Ray; rec: HitRecord): Option[Ray] =
  let reflectDirection = ray.direction.unit.reflect(rec.normal) + self.fuzz * randomPointInUnitSphere()
  some(Ray(origin: rec.p, direction: reflectDirection, color: self.albedo))

func refract(uv: Vec3; n: Vec3; etai_over_etat: float): Vec3 =
  let cosTheta = min(dot(-uv, n), 1.0);
  let rOutPerp = etai_over_etat * (uv + cosTheta * n)
  let rOutParallel = - (1.0 - rOutPerp.dot(rOutPerp)).abs().sqrt() * n
  return rOutPerp + rOutParallel

func reflectance(cosine: float; refIdx: float): float =
  let r0 = (1.0 - refIdx) / (1.0 + refIdx)
  let r02 = r0 * r0
  return r02 + (1.0 - r02) * (1.0 - cosine).pow(5.0)

proc scatter(self: Dielectric; ray: Ray; rec: HitRecord): Option[Ray] =
  let refractionRatio = if rec.frontFace:
    1.0 / self.refractiveIndex
  else:
    self.refractiveIndex
  let cosTheta = min(dot(-ray.direction.unit, rec.normal), 1.0);
  let sinTheta = sqrt(1.0 - cosTheta * cosTheta)

  if 1.0 < refractionRatio * sinTheta or rand(1.0) < reflectance(cosTheta, refractionRatio):
    return some(Ray(origin: rec.p, direction: ray.direction.reflect(rec.normal), color: ray.color))
  else:
    let refractedDirection = refract(ray.direction.unit, rec.normal, refractionRatio)
    return some(Ray(origin: rec.p, direction: refractedDirection, color: ray.color))

proc scatter*(self: Material; ray: Ray; rec: HitRecord): Option[Ray] =
  case self.variant
  of mvLambertian:
    self.lambertian.scatter(ray, rec)
  of mvMetal:
    self.metal.scatter(ray, rec)
  of mvDielectric:
    self.dielectric.scatter(ray, rec)
