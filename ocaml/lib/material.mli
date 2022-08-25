type t =
  | Metal of
      { aldebo : Color.t
      ; fuzz : float
      }
  | Lambertian of { aldebo : Color.t }
  | Dielectric of { refractive_index : float }