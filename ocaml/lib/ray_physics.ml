open Ray

let reflectance ~cos_theta ~refractive_index =
  let r0 = (1. -. refractive_index) /. (1. +. refractive_index) in
  let r02 = r0 *. r0 in
  r02 +. ((1. -. r02) *. ((1. -. cos_theta) ** 5.))


let refract uv ~normal ~etai_over_etat =
  let open Vec3 in
  let cos_theta = min (dot (negate uv) normal) 1. in
  let r_out_perp = etai_over_etat * (uv + (cos_theta * normal)) in
  let r_out_parallel =
    -.(1. -. dot r_out_perp r_out_perp |> abs_float |> sqrt) * normal
  in
  r_out_perp + r_out_parallel


let scatter (ray : Ray.t) (hit_record : Hit_record.t) =
  let open Vec3 in
  match hit_record.material with
  | Material.Metal { aldebo; fuzz } ->
    let scatter_direction =
      (ray.direction |> unit |> reflect ~normal:hit_record.normal)
      + (fuzz * random_vec3_in_unit_sphere ())
    in
    let destructive = Vec3.dot scatter_direction hit_record.normal < 0. in
    if destructive then
      None
    else
      Some { origin = hit_record.point; direction = scatter_direction; color = aldebo }
  | Material.Lambertian { aldebo } ->
    let scatter_direction = hit_record.normal + random_unit_vec3 () in
    let scatter_direction =
      if Vec3.close_to_zero scatter_direction then
        hit_record.normal
      else
        scatter_direction
    in
    Some { origin = hit_record.point; direction = scatter_direction; color = aldebo }
  | Material.Dielectric { refractive_index } ->
    let cos_theta = min (dot (negate (unit ray.direction)) hit_record.normal) 1.0 in
    let sin_theta = sqrt (1. -. (cos_theta *. cos_theta)) in
    let refractive_index =
      if hit_record.front_face then
        1. /. refractive_index
      else
        refractive_index
    in
    if
      1. < refractive_index *. sin_theta
      || Random.float 1. < reflectance ~cos_theta ~refractive_index
    then
      Some
        { origin = hit_record.point
        ; direction = reflect (unit ray.direction) ~normal:hit_record.normal
        ; color = ray.color
        }
    else (
      let refracted_direction =
        refract
          (unit ray.direction)
          ~normal:hit_record.normal
          ~etai_over_etat:refractive_index
      in
      Some
        { origin = hit_record.point; direction = refracted_direction; color = ray.color })
