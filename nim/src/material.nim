import color
import vec3
import point3
import ray
import hit_record

type
  Material = object

func scatter*(self: Material; ray: Ray; rec: HitRecord;
    attenuation: Color): Ray =
  result
