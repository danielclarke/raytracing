import std/options
import std/math

import vec3
import point3
import ray
import hit_record

type
  Sphere* = object
    center*: Point3
    radius*: float

func unitSphere*(): Sphere =
  Sphere(center: zerosVec3(), radius: 1.0)

func hit*(self: Sphere; ray: Ray; t_min, t_max: float): Option[HitRecord] =
  # -b +- sqrt(b ** 2 - 4*a*c)
  # --------------------------
  #          2*a
  let oc = ray.origin - self.center
  let a = dot(ray.direction, ray.direction)
  let halfB = dot(oc, ray.direction)
  let c = dot(oc, oc) - self.radius * self.radius

  let determinant = halfB * halfB - a * c
  if determinant < 0.0:
    return none(HitRecord)

  let sqrtd = sqrt(determinant)
  let root = (-halfB - sqrtd) / a
  if root < t_min or t_max < root:
    let root = (-halfB + sqrtd) / a
    if root < t_min or t_max < root:
      return none(HitRecord)

  let p = ray.at(root)
  let normal = (p - self.center) / self.radius
  return some(HitRecord(p: p, normal: normal, t: root).qualifyNormal(ray, normal))
