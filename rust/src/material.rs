use crate::color::Color;
use crate::hit_record::HitRecord;
use crate::point3::Point3;
use crate::ray::Ray;
use crate::utils;
use crate::vec3::Vec3;

#[derive(Clone, Copy, Debug)]
pub enum Material {
    None,
    Metal { aldebo: Color, fuzz: f32 },
    Lambertian { aldebo: Color },
    Dielectric { refractive_index: f32 },
}

fn refract(uv: Vec3, n: Vec3, etai_over_etat: f32) -> Vec3 {
    let cos_theta = f32::min((-uv).dot(n), 1.0);
    let r_out_perp = etai_over_etat * (uv + cos_theta * n);
    let r_out_parallel = -(1.0 - r_out_perp.dot(r_out_perp)).abs().sqrt() * n;
    return r_out_perp + r_out_parallel;
}

impl Material {
    pub fn scatter(&self, ray: &Ray, hit_record: &HitRecord) -> Option<Ray> {
        match self {
            Material::None => None,
            Material::Metal { aldebo, fuzz } => {
                let reflected = ray.direction.unit().reflect(hit_record.normal);
                let scattered = Ray {
                    origin: hit_record.p,
                    direction: reflected + *fuzz * utils::random_point_in_unit_sphere(),
                    color: *aldebo,
                };
                if 0.0 < reflected.dot(hit_record.normal) {
                    Some(scattered)
                } else {
                    None
                }
            }
            Material::Lambertian { aldebo } => {
                let scatter_direction = hit_record.normal + utils::random_unit_vec3();
                let scatter_direction = if scatter_direction.close_to_zero() {
                    hit_record.normal
                } else {
                    scatter_direction
                };
                let scattered = Ray {
                    origin: hit_record.p,
                    direction: scatter_direction,
                    color: *aldebo,
                };
                return Some(scattered);
            }
            Material::Dielectric { refractive_index } => {
                let refraction_ratio = if hit_record.front_face {
                    1.0 / refractive_index
                } else {
                    *refractive_index
                };

                let cos_theta = f32::min((-ray.direction.unit()).dot(hit_record.normal), 1.0);
                let sin_theta = (1.0 - cos_theta * cos_theta).sqrt();
                if 1.0 < refraction_ratio * sin_theta {
                    return Some(Ray {
                        origin: hit_record.p,
                        direction: ray.direction.unit().reflect(hit_record.normal),
                        color: ray.color,
                    });
                } else {
                    let r_out_perp =
                        refraction_ratio * (ray.direction.unit() + cos_theta * hit_record.normal);
                    let r_out_parallel =
                        -(1.0 - r_out_perp.dot(r_out_perp)).abs().sqrt() * hit_record.normal;
                    return Some(Ray {
                        origin: hit_record.p,
                        direction: r_out_perp + r_out_parallel,
                        color: ray.color,
                    });
                }
            }
        }
    }
}
