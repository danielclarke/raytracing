type t

val from_rgb : r:float -> g:float -> b:float -> t
val white : t
val black : t
val add : t -> t -> t
val combine : t -> t -> t
val lerp : u:t -> v:t -> fraction:float -> t
val ppm : t -> samples:int -> string
val to_string : t -> string