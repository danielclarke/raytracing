use crate::utils::clamp;
use crate::vec3::Vec3;

pub type Color = Vec3;

impl Color {
    pub fn ppm(&self, samples: i32) -> String {
        let scale = 1.0 / samples as f32;
        let r = (clamp((scale * self.x).sqrt(), 0.0, 0.999) * 255.999) as i32;
        let g = (clamp((scale * self.y).sqrt(), 0.0, 0.999) * 255.999) as i32;
        let b = (clamp((scale * self.z).sqrt(), 0.0, 0.999) * 255.999) as i32;
        format!("{r} {g} {b}", r = r, g = g, b = b).to_owned()
    }
}
