use crate::point3::Point3;
use crate::vec3::Vec3;

const PI: f32 = std::f32::consts::PI;

pub fn clamp(f: f32, min: f32, max: f32) -> f32 {
    if f < min {
        min
    } else if max < f {
        max
    } else {
        f
    }
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

pub fn random_point_in_unit_hemisphere(v: Vec3) -> Point3 {
    let u = random_point_in_unit_sphere();
    if 0.0 < u.dot(v) {
        u
    } else {
        -u
    }
}

pub fn random_unit_vec3() -> Vec3 {
    random_point_in_unit_sphere().unit()
}

pub fn lerp(a: Vec3, b: Vec3, t: f32) -> Vec3 {
    (1.0 - t) * a + t * b
}
