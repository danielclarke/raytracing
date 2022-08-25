use crate::hit_record::HitRecord;
use crate::ray::Ray;
use crate::sphere::Sphere;

pub struct World {
    pub objects: Vec<Sphere>,
}

impl World {
    pub fn hit(&self, ray: &Ray, t_min: f32, t_max: f32) -> Option<HitRecord> {
        let mut closest = t_max;
        let mut result = None;
        for h in self.objects.iter() {
            let hr = h.hit(ray, t_min, closest);
            if hr.is_some() {
                result = hr;
                closest = result.as_ref().unwrap().t;
            }
        }
        result
    }
}
