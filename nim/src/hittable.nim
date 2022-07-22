import std/options
import point3
import ray
import sphere
import hit_record

type
  HittableVariant* = enum
    hvSphere,
    hvCube

  Hittable* = object
    case variant*: HittableVariant
    of hvSphere:
      sphere*: Sphere
    of hvCube:
      cube*: Sphere

  HittableList* = object
    objects: seq[Hittable]

func newHittableSphere*(center: Point3; radius: float): Hittable =
  result = Hittable(variant: hvSphere, sphere: Sphere(center: center,
      radius: radius))

func newHittableSphere*(s: Sphere): Hittable =
  result = Hittable(variant: hvSphere, sphere: s)

func hit*(self: Hittable; ray: Ray; t_min, t_max: float): Option[HitRecord] =
  case self.variant:
  of hvSphere:
    result = self.sphere.hit(ray, t_min, t_max)
  of hvCube:
    result = self.cube.hit(ray, t_min, t_max)

func hit*(self: HittableList; ray: Ray; t_min, t_max: float): Option[HitRecord] =
  var closest = t_max
  for h in self.objects:
    let hr = h.hit(ray, t_min, closest)
    if hr.isSome():
      result = hr
      closest = hr.get().t

func add*(self: var HittableList; h: Hittable) =
  self.objects.add(h)
