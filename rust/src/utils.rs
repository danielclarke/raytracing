use rand::prelude::*;

use crate::point3::Point3;
use crate::vec3::Vec3;

const PI: f32 = std::f32::consts::PI;

pub fn deg_2_rad(deg: f32) -> f32 {
    deg * PI / 180.0
}

pub fn rad_2_deg(rad: f32) -> f32 {
    rad * 180.0 / PI
}

pub fn clamp(f: f32, min: f32, max: f32) -> f32 {
    let result = if f < min {
        min
    } else if max < f {
        max
    } else {
        f
    };
    result
}

pub fn random_point_in_unit_sphere() -> Point3 {
    let r = rand::random::<f32>();
    let theta = rand::random::<f32>() * 2.0 * PI;
    let phi = rand::random::<f32>() * 2.0 * PI;

    Point3 {
        x: r * phi.sin() * theta.cos(),
        y: r * phi.sin() * theta.sin(),
        z: r * phi.cos(),
    }
}

pub fn lerp(a: Vec3, b: Vec3, t: f32) -> Vec3 {
    (1.0 - t) * a + t * b
}
