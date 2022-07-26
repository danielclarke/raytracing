import std/options

import sphere
import ray
import material

type
  World* = object
    objects: seq[Sphere]

func hit*(self: World; ray: Ray; t_min, t_max: float): Option[HitRecord] =
  var closest = t_max
  for sphere in self.objects:
    let hr = sphere.hit(ray, t_min, closest)
    if hr.isSome():
      result = hr
      closest = hr.get().t

func add*(self: var World; s: Sphere) =
  self.objects.add(s)
