type t =
  { origin : Point.t
  ; direction : Vec3.t
  ; color : Color.t
  }

let at t f =
  let v = Vec3.(f * t.direction) in
  Point.translate t.origin v
