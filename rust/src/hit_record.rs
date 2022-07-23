use crate::material::Material;
use crate::point3::Point3;
use crate::ray::Ray;
use crate::vec3::Vec3;

pub struct HitRecord {
    pub p: Point3,
    pub normal: Vec3,
    pub material: Material,
    pub t: f32,
    pub front_face: bool,
}

impl HitRecord {
    pub fn qualified_hit_record(
        ray: &Ray,
        m: Material,
        p: Point3,
        t: f32,
        outward_normal: Vec3,
    ) -> HitRecord {
        let front_face = ray.direction.dot(outward_normal) < 0.0;
        let normal = if front_face {
            outward_normal
        } else {
            -outward_normal
        };
        HitRecord {
            p: p,
            normal: normal,
            material: m,
            t: t,
            front_face: front_face,
        }
    }
}
