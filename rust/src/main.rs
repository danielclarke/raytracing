use std::fs::File;
use std::io::prelude::*;
use std::io::LineWriter;

mod camera;
mod color;
mod hit_record;
mod material;
mod point3;
mod ray;
mod sphere;
mod utils;
mod vec3;
mod world;

use camera::Camera;
use color::Color;
use material::Material;
use point3::Point3;
use ray::Ray;
use sphere::Sphere;
use world::World;

fn ray_color(ray: Ray, world: &World, depth: i32) -> Color {
    // if log {
    //     println!("{:?}", ray);
    // }
    if depth <= 0 {
        Color::black()
    } else {
        let hr = world.hit(&ray, 0.001, f32::INFINITY);
        if let Some(hit_record) = hr {
            if let Some(scattered) = hit_record.material.scatter(&ray, &hit_record) {
                scattered.color * ray_color(scattered, world, depth - 1)
            } else {
                Color::black()
            }
        } else {
            let t = (ray.direction.unit().y + 1.0) * 0.5;
            utils::lerp(
                Color::white(),
                Color {
                    x: 0.5,
                    y: 0.7,
                    z: 1.0,
                },
                t,
            )
        }
    }
}

fn main() -> std::io::Result<()> {
    const ASPECT: f32 = 16.0 / 9.0;
    const IM_WIDTH: i32 = 400;
    const IM_HEIGHT: i32 = (IM_WIDTH as f32 / ASPECT) as i32;

    let world = World {
        objects: vec![
            Sphere {
                center: Point3 {
                    x: 0.0,
                    y: -100.5,
                    z: -1.0,
                },
                radius: 100.0,
                material: Material::Lambertian {
                    aldebo: Color {
                        x: 0.8,
                        y: 0.8,
                        z: 0.0,
                    },
                },
            },
            Sphere {
                center: Point3 {
                    x: -1.0,
                    y: 0.0,
                    z: -1.0,
                },
                radius: 0.5,
                material: Material::Lambertian {
                    aldebo: Color {
                        x: 0.1,
                        y: 0.2,
                        z: 0.5,
                    },
                },
            },
            Sphere {
                center: Point3 {
                    x: 0.0,
                    y: 0.25,
                    z: -1.0,
                },
                radius: 0.5,
                material: Material::Dielectric {
                    refractive_index: 1.5,
                },
            },
            Sphere {
                center: Point3 {
                    x: 0.0,
                    y: 0.25,
                    z: -1.0,
                },
                radius: -0.2,
                material: Material::Dielectric {
                    refractive_index: 1.5,
                },
            },
            Sphere {
                center: Point3 {
                    x: 1.0,
                    y: 0.0,
                    z: -1.0,
                },
                radius: 0.5,
                material: Material::Metal {
                    aldebo: Color {
                        x: 0.8,
                        y: 0.6,
                        z: 0.2,
                    },
                    fuzz: 1.0,
                },
            },
        ],
    };

    const FOCAL_LENGTH: f32 = 1.0;
    const ORIGIN: Point3 = Point3 {
        x: 0.0,
        y: 0.0,
        z: 0.0,
    };
    let camera: Camera = Camera::new(std::f32::consts::PI / 2.0, ASPECT, FOCAL_LENGTH, ORIGIN);

    const NUM_SAMPLES: i32 = 500;
    const MAX_DEPTH: i32 = 500;

    let file = File::create("helloworld.ppm")?;
    let mut file = LineWriter::new(file);

    file.write_all(
        format!(
            "P3\n{im_width} {im_height}\n255\n",
            im_width = IM_WIDTH,
            im_height = IM_HEIGHT
        )
        .as_bytes(),
    )?;

    for j in 0..IM_HEIGHT {
        // println!("Scan lines remaining {}", j);
        for i in 0..IM_WIDTH {
            let mut color = Color::black();
            for _ in 0..NUM_SAMPLES {
                let u = (i as f32 + rand::random::<f32>()) / (IM_WIDTH - 1) as f32;
                let v = ((IM_HEIGHT - j) as f32 + rand::random::<f32>()) / (IM_HEIGHT - 1) as f32;
                let ray = camera.get_ray(u, v);
                // let log = if i == IM_WIDTH / 2 && j == IM_HEIGHT / 2 {
                //     true
                // } else {
                //     false
                // };
                color += ray_color(ray, &world, MAX_DEPTH);
            }
            file.write_all(format!("{color}\n", color = color.ppm(NUM_SAMPLES)).as_bytes())?;
        }
    }

    Ok(())
}
