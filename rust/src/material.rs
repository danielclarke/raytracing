use crate::color::Color;
use crate::hit_record::HitRecord;
use crate::point3::Point3;
use crate::ray::Ray;
use crate::utils;
use crate::vec3::Vec3;

#[derive(Clone, Copy, Debug)]
pub enum Material {
    None,
    Metal { aldebo: Color },
    Lambertian { aldebo: Color },
}

impl Material {
    pub fn scatter(&self, ray: &Ray, hit_record: &HitRecord) -> Option<Ray> {
        match self {
            Material::None => None,
            Material::Metal { aldebo } => {
                let reflected = ray.direction.unit().reflect(hit_record.normal);
                let scattered = Ray {
                    origin: hit_record.p,
                    direction: reflected,
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
        }
    }
}
