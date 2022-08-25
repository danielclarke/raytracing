type t =
  { x : float
  ; y : float
  ; z : float
  }

val origin : t

val random_point_in_unit_sphere : unit -> t

val translate : t -> Vec3.t -> t

val distance : t -> t -> Vec3.t