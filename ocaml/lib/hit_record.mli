type t =
  { point : Point.t
  ; normal : Vec3.t
  ; material : Material.t
  ; t : float
  ; front_face : bool
  }

val qualified_hit_record: Ray.t -> Material.t -> Point.t -> t:float -> outward_normal:Vec3.t -> t
