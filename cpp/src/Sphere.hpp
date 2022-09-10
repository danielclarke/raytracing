#ifndef TRACER_SPHERE
#define TRACER_SPHERE

#include "Color.hpp"
#include "HitRecord.hpp"
#include "Material.hpp"
#include "Point3.hpp"
#include <optional>

class Sphere {
	float radius{1.0};
	Point3 center{};
	std::shared_ptr<Material> material{};

  public:
	Sphere(float radius, Point3 center, std::shared_ptr<Material> material)
		: radius(radius), center(center), material(material){};

	std::optional<HitRecord> hit(const Ray &ray, float t_min,
								 float t_max) const;
};

std::optional<HitRecord> Sphere::hit(const Ray &ray, float t_min,
									 float t_max) const {
	const auto oc = ray.origin - this->center;
	const auto a = ray.direction.dot(ray.direction);
	const auto halfB = oc.dot(ray.direction);
	const auto c = oc.dot(oc) - this->radius * this->radius;

	const auto determinant = halfB * halfB - a * c;
	if (determinant < 0.0) {
		return std::nullopt;
	}
	const auto sqrtD = sqrtf(determinant);
	auto root = (-halfB - sqrtD) / a;
	if (root < t_min or t_max < root) {
		root = (-halfB + sqrtD) / a;
		if (root < t_min or t_max < root) {
			return std::nullopt;
		}
	}

	const auto p = ray.at(root);
	const auto normal = (p - this->center) / this->radius;
	return std::optional<HitRecord>(
		qualifiedHitRecord(ray, this->material, p, root, normal));
}

#endif