type t =
  { center : Point.t
  ; radius : float
  ; material : Material.t
  }

let outside_bounds root ~t_min ~t_max =
  if root < t_min || root > t_max then true else false


let find_hit_root sphere ray ~t_min ~t_max =
  let open Ray in
  let oc = Point.distance ray.origin sphere.center in
  let half_b = Vec3.dot oc ray.direction
  and c = Vec3.dot oc oc -. (sphere.radius *. sphere.radius)
  and a = Vec3.dot ray.direction ray.direction in
  let discriminant = (half_b *. half_b) -. (a *. c) in
  if discriminant < 0. then
    None
  else (
    let outside_bounds = outside_bounds ~t_min ~t_max in
    let sqrtd = sqrt discriminant in
    let root = (-.half_b -. sqrtd) /. a in
    if outside_bounds root then (
      let root = (-.half_b +. sqrtd) /. a in
      if outside_bounds root then
        None
      else
        Some root)
    else
      Some root)


let hit sphere ray ~t_min ~t_max =
  match find_hit_root sphere ray ~t_min ~t_max with
  | None -> None
  | Some root ->
    let open Vec3 in
    let point = Ray.at ray root in
    let normal = Point.distance point sphere.center >>/ sphere.radius in
    Some
      (Hit_record.qualified_hit_record
         ray
         sphere.material
         point
         ~t:root
         ~outward_normal:normal)
