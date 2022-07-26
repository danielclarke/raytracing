import std/options

import sphere
import ray
import hit_record

type
  World* = object
    objects: seq[Sphere]

func hit*(self: World; ray: Ray; t_min, t_max: float): Option[HitRecord] =
  var closest = t_max
  for h in self.objects:
    let hr = h.hit(ray, t_min, closest)
    if hr.isSome():
      result = hr
      closest = hr.get().t

func add*(self: var World; s: Sphere) =
  self.objects.add(s)
