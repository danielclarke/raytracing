use crate::color::Color;
use crate::point3::Point3;
use crate::vec3::Vec3;

#[derive(Debug)]
pub struct Ray {
    pub origin: Point3,
    pub direction: Vec3,
    pub color: Color,
}

impl Ray {
    pub fn at(&self, t: f32) -> Point3 {
        self.origin + t * self.direction
    }
}
