type t =
  { r : float
  ; g : float
  ; b : float
  }

let from_rgb ~r ~g ~b = { r; g; b }
let white = { r = 1.; g = 1.; b = 1. }
let black = { r = 0.; g = 0.; b = 0. }
let random () = { r = Random.float 1.; g = Random.float 1.; b = Random.float 1. }
let add c c' = { r = c.r +. c'.r; g = c.g +. c'.g; b = c.b +. c'.b }
let combine c c' = { r = c.r *. c'.r; g = c.g *. c'.g; b = c.b *. c'.b }
let scale c f = { r = c.r *. f; g = c.g *. f; b = c.b *. f }
let lerp ~u ~v ~fraction = add (scale u (1.0 -. fraction)) (scale v fraction)

let bit8 v ~samples =
  let lower = 0.
  and upper = 0.999
  and scale = 1. /. Int.to_float samples in
  255.999 *. (scale *. v |> sqrt |> Utils.clamp ~lower ~upper) |> Float.to_int


let ppm t ~samples =
  let r = t.r |> bit8 ~samples in
  let g = t.g |> bit8 ~samples in
  let b = t.b |> bit8 ~samples in
  Printf.sprintf "%i %i %i" r g b


let to_string { r; g; b } = Printf.sprintf "{r=%f, g=%f, b= %f}" r g b
