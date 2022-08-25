type t

val make : aspect:float -> focal_length:float -> vertical_fov_rad:float -> origin:Point.t -> t
val get_ray : t -> u:float -> v:float -> Ray.t