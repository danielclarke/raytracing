use crate::point3::Point3;
use crate::vec3::Vec3;

pub struct Ray {
    pub origin: Point3,
    pub direction: Vec3,
}

impl Ray {
    pub fn at(&self, t: f32) -> Point3 {
        self.origin + t * self.direction
    }
}
