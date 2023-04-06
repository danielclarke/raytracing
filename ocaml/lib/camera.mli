type t

val make
  :  aspect:float
  -> aperture:float
  -> vertical_fov_rad:float
  -> origin:Point.t
  -> focus_distance:float
  -> look_at:Point.t
  -> v_up:Vec3.t
  -> t

val get_ray : t -> u:float -> v:float -> Ray.t