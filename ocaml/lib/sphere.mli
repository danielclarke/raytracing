type t =
  { center : Point.t
  ; radius : float
  ; material : Material.t
  }

val hit : t -> Ray.t -> t_min:float -> t_max:float -> Hit_record.t option