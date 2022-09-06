use crate::hit_record::HitRecord;
use crate::material::Material;
use crate::point3::Point3;
use crate::ray::Ray;

pub struct Sphere {
    pub center: Point3,
    pub radius: f32,
    pub material: Material,
}

impl Sphere {
    pub fn hit(&self, ray: &Ray, t_min: f32, t_max: f32) -> Option<HitRecord> {
        let oc = ray.origin - self.center;
        let a = ray.direction.dot(ray.direction);
        let half_b = oc.dot(ray.direction);
        let c = oc.dot(oc) - self.radius * self.radius;

        let discriminant = half_b * half_b - a * c;
        if discriminant < 0.0 {
            return None;
        }

        let sqrtd = discriminant.sqrt();
        let mut root = (-half_b - sqrtd) / a;
        if root < t_min || t_max < root {
            root = (-half_b + sqrtd) / a;
            if root < t_min || t_max < root {
                return None;
            }
        }

        let p = ray.at(root);
        let normal = (p - self.center) / self.radius;
        Some(HitRecord::qualified_hit_record(
            ray,
            self.material,
            p,
            root,
            normal,
        ))
    }
}
