type t =
  { origin : Point.t
  ; direction : Vec3.t
  ; color : Color.t
  }

val at : t -> float -> Point.t