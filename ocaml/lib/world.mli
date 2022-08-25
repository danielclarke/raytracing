type t

val make : Sphere.t list -> t
val add : t -> Sphere.t -> t
val hit : t -> Ray.t -> t_min:float -> t_max:float -> Hit_record.t option