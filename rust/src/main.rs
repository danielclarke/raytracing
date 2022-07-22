use std::fs::{self, File};
use std::io::prelude::*;
use std::io::LineWriter;

use rand::prelude::*;

mod camera;
mod color;
mod hit_record;
mod point3;
mod ray;
mod sphere;
mod utils;
mod vec3;
mod world;

use camera::Camera;
use color::Color;
use point3::Point3;
use ray::Ray;
use sphere::Sphere;
use vec3::Vec3;
use world::World;

fn ray_color(ray: &Ray, world: &World, depth: i32) -> Color {
    if depth <= 0 {
        return Color {
            x: 0.0,
            y: 0.0,
            z: 0.0,
        };
    } else {
        let hr = world.hit(ray, 0.001, f32::INFINITY);
        if hr.is_some() {
            let hit_record = hr.unwrap();
            let target = hit_record.p + hit_record.normal + utils::random_point_in_unit_sphere();
            return 0.5
                * ray_color(
                    &Ray {
                        origin: hit_record.p,
                        direction: target - hit_record.p,
                    },
                    world,
                    depth - 1,
                );
        } else {
            let t = (ray.direction.unit().y + 1.0) * 0.5;
            return utils::lerp(
                Color {
                    x: 1.0,
                    y: 1.0,
                    z: 1.0,
                },
                Color {
                    x: 0.5,
                    y: 0.7,
                    z: 1.0,
                },
                t,
            );
        }
    }
}

fn main() -> std::io::Result<()> {
    const aspect: f32 = 16.0 / 9.0;
    const im_width: i32 = 400;
    const im_height: i32 = (im_width as f32 / aspect) as i32;

    let mut world = World {
        objects: vec![
            Sphere {
                center: Point3 {
                    x: 0.0,
                    y: 0.0,
                    z: -1.0,
                },
                radius: 0.5,
            },
            Sphere {
                center: Point3 {
                    x: 0.0,
                    y: -100.5,
                    z: -1.0,
                },
                radius: 100.0,
            },
        ],
    };

    const viewport_height: f32 = 2.0;
    const viewport_width: f32 = aspect as f32 * viewport_height;
    const focalLength: f32 = 1.0;
    const origin: Point3 = Point3 {
        x: 0.0,
        y: 0.0,
        z: 0.0,
    };
    let camera: Camera = Camera::new(aspect, viewport_width, focalLength, origin);

    const num_samples: i32 = 50;
    const max_depth: i32 = 50;

    let file = File::create("helloworld.ppm")?;
    let mut file = LineWriter::new(file);

    file.write_all(
        format!(
            "P3\n{im_width} {im_height}\n255\n",
            im_width = im_width,
            im_height = im_height
        )
        .as_bytes(),
    )?;

    for j in 0..im_height {
        println!("Scan lines remaining {}", j);
        for i in 0..im_width {
            let mut color = Color {
                x: 0.0,
                y: 0.0,
                z: 0.0,
            };
            for s in 0..num_samples {
                let u = (i as f32 + rand::random::<f32>()) / (im_width - 1) as f32;
                let v = ((im_height - j) as f32 + rand::random::<f32>()) / (im_height - 1) as f32;
                let ray = camera.get_ray(u, v);
                color += ray_color(&ray, &world, max_depth);
            }
            file.write_all(color.ppm(num_samples).as_bytes())?;
            file.write_all("\n".as_bytes())?;
        }
    }

    Ok(())
}
