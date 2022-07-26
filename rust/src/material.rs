use crate::color::Color;
use crate::hit_record::HitRecord;
use crate::ray::Ray;
use crate::utils;

#[derive(Clone, Copy, Debug)]
pub enum Material {
    Metal { aldebo: Color, fuzz: f32 },
    Lambertian { aldebo: Color },
    Dielectric { refractive_index: f32 },
}

fn reflectance(cosine: f32, ref_idx: f32) -> f32 {
    let r0 = (1.0 - ref_idx) / (1.0 + ref_idx);
    let r0 = r0 * r0;
    r0 + (1.0 - r0) * (1.0 - cosine).powf(5.0)
}

impl Material {
    pub fn scatter(&self, ray: &Ray, hit_record: &HitRecord) -> Option<Ray> {
        match self {
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
                Some(scattered)
            }
            Material::Dielectric { refractive_index } => {
                let refraction_ratio = if hit_record.front_face {
                    1.0 / refractive_index
                } else {
                    *refractive_index
                };

                let cos_theta = f32::min((-ray.direction.unit()).dot(hit_record.normal), 1.0);
                let sin_theta = (1.0 - cos_theta * cos_theta).sqrt();
                if 1.0 < refraction_ratio * sin_theta
                    || rand::random::<f32>() < reflectance(cos_theta, refraction_ratio)
                {
                    Some(Ray {
                        origin: hit_record.p,
                        direction: ray.direction.unit().reflect(hit_record.normal),
                        color: ray.color,
                    })
                } else {
                    let r_out_perp =
                        refraction_ratio * (ray.direction.unit() + cos_theta * hit_record.normal);
                    let r_out_parallel =
                        -(1.0 - r_out_perp.dot(r_out_perp)).abs().sqrt() * hit_record.normal;
                    Some(Ray {
                        origin: hit_record.p,
                        direction: r_out_perp + r_out_parallel,
                        color: ray.color,
                    })
                }
            }
        }
    }
}
