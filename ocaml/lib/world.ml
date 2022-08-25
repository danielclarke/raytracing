type t = Sphere.t list

let make list_of_spheres : Sphere.t list = (list_of_spheres : t)
let add (world : Sphere.t list) sphere = sphere :: world

let rec hit_helper ~world ~ray ~t_min ~closest_distance ~hit_sphere =
  match world with
  | [] -> hit_sphere
  | h :: t ->
    (match Sphere.hit h ray ~t_min ~t_max:closest_distance with
    | None -> hit_helper ~world:t ~ray ~t_min ~closest_distance ~hit_sphere
    | Some hit_record ->
      hit_helper
        ~world:t
        ~ray
        ~t_min
        ~closest_distance:hit_record.t
        ~hit_sphere:(Some hit_record))


let hit world ray ~t_min ~t_max =
  (hit_helper [@tailcall]) ~world ~ray ~t_min ~closest_distance:t_max ~hit_sphere:None