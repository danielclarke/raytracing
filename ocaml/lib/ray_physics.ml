let scatter (r : Ray.t) (hit_record : Hit_record.t) =
  let open Ray in
  let open Vec3 in
  match hit_record.material with
  | Material.Metal { aldebo; fuzz } ->
    let reflected =
      r.direction
      |> unit
      |> reflect ~normal:hit_record.normal
      >>+ (fuzz >>* random_vec3_in_unit_sphere ())
    in
    let destructive = Vec3.dot reflected hit_record.normal < 0. in
    if destructive then
      None
    else
      Some { origin = hit_record.point; direction = reflected; color = aldebo }
  | Material.Lambertian _ -> None
  | Material.Dielectric _ -> None