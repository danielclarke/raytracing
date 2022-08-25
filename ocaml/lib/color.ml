type t =
  { r : float
  ; g : float
  ; b : float
  }

let from_rgb ~r ~g ~b = { r; g; b }
let white = { r = 1.; g = 1.; b = 1. }
let black = { r = 0.; g = 0.; b = 0. }
let add c c' = { r = c.r +. c'.r; g = c.g +. c'.g; b = c.b +. c'.b }
let combine c c' = { r = c.r *. c'.r; g = c.g *. c'.g; b = c.b *. c'.b }
let scale c f = { r = c.r *. f; g = c.g *. f; b = c.b *. f }
let lerp ~u ~v ~fraction = add (scale u (1.0 -. fraction)) (scale v fraction)

let ppm t ~samples =
  let lower = 0.
  and upper = 0.999
  and scale = 1. /. Int.to_float samples in
  let r = 255.999 *. Utils.clamp ~value:(sqrt (scale *. t.r)) ~lower ~upper in
  let g = 255.999 *. Utils.clamp ~value:(sqrt (scale *. t.g)) ~lower ~upper in
  let b = 255.999 *. Utils.clamp ~value:(sqrt (scale *. t.b)) ~lower ~upper in
  Printf.sprintf "%i %i %i" (Float.to_int r) (Float.to_int g) (Float.to_int b)


let to_string { r; g; b } = Printf.sprintf "{r=%f, g=%f, b= %f}" r g b
