use crate::point3::Point3;
use crate::ray::Ray;
use crate::vec3::Vec3;

pub struct Camera {
    pub aspect: f32,
    pub height: f32,
    pub width: f32,
    pub focal_length: f32,
    pub origin: Point3,
    pub horizontal: Vec3,
    pub vertical: Vec3,
    pub lower_left_corner: Vec3,
}

impl Camera {
    pub fn new(aspect: f32, width: f32, focal_length: f32, origin: Point3) -> Camera {
        let height = width / aspect;
        let horizontal = Vec3 {
            x: width,
            y: 0.0,
            z: 0.0,
        };
        let vertical = Vec3 {
            x: 0.0,
            y: height,
            z: 0.0,
        };
        Camera {
            aspect: aspect,
            height: height,
            width: width,
            focal_length: focal_length,
            origin: origin,
            horizontal: horizontal,
            vertical: vertical,
            lower_left_corner: origin
                - horizontal / 2.0
                - vertical / 2.0
                - Vec3 {
                    x: 0.0,
                    y: 0.0,
                    z: focal_length,
                },
        }
    }

    pub fn get_ray(&self, u: f32, v: f32) -> Ray {
        Ray {
            origin: self.origin,
            direction: self.lower_left_corner + u * self.horizontal + v * self.vertical
                - self.origin,
        }
    }
}
