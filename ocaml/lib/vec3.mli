type t =
{ x : float
; y : float
; z : float
}

val ones : t

val zeros : t

val random_vec3_in_unit_sphere : unit -> t

val ( >>+ ) : t -> t -> t

val ( >>- ) : t -> t -> t

val ( >>* ) : float -> t -> t

val ( >>/ ) : t -> float -> t

val dot : t -> t -> float

val mag : t -> float

val unit : t -> t

val close_to_zero : t -> bool

val reflect : t -> normal:t -> t

val print_vec3 : t -> unit