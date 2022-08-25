let scatter (ray : Ray.t) (hit_record : Hit_record.t) =
  let open Ray in
  let open Vec3 in
  match hit_record.material with
  | Material.Metal { aldebo; fuzz } ->
    let scatter_direction =
      ray.direction
      |> unit
      |> reflect ~normal:hit_record.normal
      >>+ (fuzz >>* random_vec3_in_unit_sphere ())
    in
    let destructive = Vec3.dot scatter_direction hit_record.normal < 0. in
    if destructive then
      None
    else
      Some { origin = hit_record.point; direction = scatter_direction; color = aldebo }
  | Material.Lambertian { aldebo } ->
    let scatter_direction = hit_record.normal >>+ random_unit_vec3 () in
    let scatter_direction =
      if Vec3.close_to_zero scatter_direction then
        hit_record.normal
      else
        scatter_direction
    in
    Some { origin = hit_record.point; direction = scatter_direction; color = aldebo }
  | Material.Dielectric _ -> None