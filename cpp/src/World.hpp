#ifndef TRACER_WORLD
#define TRACER_WORLD

#include "HitRecord.hpp"
#include "Material.hpp"
#include "Sphere.hpp"

class World {
	std::vector<Sphere> spheres{};

  public:
	void addSphere(Sphere &&sphere);

	std::optional<HitRecord> hit(const Ray &ray, float t_min,
								 float t_max) const;
};

void World::addSphere(Sphere &&sphere) {
	this->spheres.push_back(std::move(sphere));
}

std::optional<HitRecord> World::hit(const Ray &ray, float t_min,
									float t_max) const {
	auto closest = t_max;
	std::optional<HitRecord> result = {};
	for (const auto &sphere : this->spheres) {
		auto hitRecord = sphere.hit(ray, t_min, closest);
		if (hitRecord.has_value()) {
			result = std::move(hitRecord);
			closest = result.value().t;
		}
	}
	return result;
}

#endif