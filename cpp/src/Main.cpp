#include <assert.h>
#include <chrono>
#include <iostream>
#include <random>

#include "Camera.hpp"
#include "Color.hpp"
#include "HitRecord.hpp"
#include "Material.hpp"
#include "Point3.hpp"
#include "Ray.hpp"
#include "Sphere.hpp"
#include "Vec3.hpp"
#include "World.hpp"

std::shared_ptr<Material> randMaterial() {
	const auto m = tracer::randUnif();
	if (m < 0.8) {
		return std::make_shared<Lambertian>(tracer::randColor());
	} else if (m < 0.95) {
		return std::make_shared<Metal>(tracer::randColor(), tracer::randUnif());
	} else {
		return std::make_shared<Dielectric>(1.5);
	}
}

World makeWorld() {
	auto world = World{};
	world.addSphere(Sphere{1000.0f, Point3{0.0, -1000.0, -1.0},
						   std::make_shared<Lambertian>(Color{0.5, 0.5, 0.5})});
	world.addSphere(Sphere{1.0f, Point3{-4.0, 1.0, 0.0},
						   std::make_shared<Lambertian>(Color{0.1, 0.2, 0.5})});
	world.addSphere(
		Sphere{1.0f, Point3{0.0, 1.0, 0.0}, std::make_shared<Dielectric>(1.5)});
	world.addSphere(Sphere{1.0f, Point3{4.0, 1.0, 0.0},
						   std::make_shared<Metal>(Color{0.8, 0.6, 0.2})});

	const auto dimA = 10;
	const auto dimB = 10;

	for (auto i = -dimA; i < dimA; i++) {
		for (auto j = -dimB; j < dimB; j++) {
			const auto center = Point3{i + 0.9f * tracer::randUnif(), 0.2f,
									   j + 0.9f * tracer::randUnif()};
			const auto material = randMaterial();
			world.addSphere(Sphere(0.2, center, material));
		}
	}

	return world;
}

Color rayColor(const World &world, const Ray &ray, int depth) {
	if (depth <= 0) {
		return tracer::black();
	}
	const auto opHitRecord = world.hit(ray, 0.001, MAXFLOAT);
	if (opHitRecord.has_value()) {
		const auto hitRecord = opHitRecord.value();
		assert(hitRecord.material != nullptr);
		const auto scatteredRay = hitRecord.material->scatter(ray, hitRecord);
		if (scatteredRay.has_value()) {
			return scatteredRay.value().color *
				   rayColor(world, scatteredRay.value(), depth - 1);
		} else {
			return tracer::black();
		}
	} else {
		const auto t = (ray.direction.unit().y + 1.0) * 0.5;
		return tracer::lerp(tracer::white(), {0.5, 0.7, 1.0}, t);
	};
}

int main() {
	test::vec3Tests();

	constexpr auto aspect = 16.0 / 9.0;
	constexpr auto imWidth = 400;
	constexpr auto imHeight = int(imWidth / aspect);

	const auto world = makeWorld();

	constexpr auto focalLength = 1.0;
	constexpr auto aperture = 0.1;
	const auto lookFrom = Point3{9.0, 2.0, 3.0};
	const auto lookAt = Point3{0.0, 0.0, 0.0};
	constexpr auto distToFocus = 10.0;
	constexpr auto numSamples = 100;
	constexpr auto maxDepth = 500;

	const auto camera =
		Camera{aspect,		focalLength, aperture, M_PI / 8.0,
			   distToFocus, lookFrom,	 lookAt,   Vec3(0.0, 1.0, 0.0)};

	std::cout << "P3"
			  << "\n";
	std::cout << imWidth << " " << imHeight << "\n";
	std::cout << "255"
			  << "\n";

	for (int j = imHeight - 1; j >= 0; j--) {
		std::cerr << "\rScanlines remaining: " << j << '\n' << std::flush;
		for (int i = 0; i < imWidth; i++) {
			auto color = tracer::black();
			for (int s = 0; s < numSamples; s++) {
				const auto u = (i + tracer::randUnif()) / (imWidth - 1);
				const auto v = (j + tracer::randUnif()) / (imHeight - 1);
				const auto ray = camera.getRay(u, v);
				color += rayColor(world, ray, maxDepth);
			}
			std::cout << color.ppm(numSamples) << '\n';
		}
	}

	return 0;
}