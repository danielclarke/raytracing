#ifndef TRACER_MATERIAL
#define TRACER_MATERIAL

#include "Color.hpp"
#include "HitRecord.hpp"
#include "Ray.hpp"
#include <optional>

class Material {
  public:
	virtual std::optional<Ray> scatter(const Ray &ray,
									   const HitRecord &hitRecord) const = 0;
};

class Lambertian : public Material {
	Color albedo{};

  public:
	Lambertian(Color color) : albedo(color){};
	virtual std::optional<Ray>
	scatter(const Ray &ray, const HitRecord &hitRecord) const override {
		auto scatterDirection = hitRecord.normal + randomUnitVec3();
		if (scatterDirection.closeToZero()) {
			scatterDirection = hitRecord.normal;
		}
		return std::optional<Ray>(
			{hitRecord.point, scatterDirection, ray.color});
	}
};

class Metal : public Material {
	Color albedo{};
	float fuzz{0.0};

  public:
	Metal(Color color) : albedo(color), fuzz(0.0){};
	Metal(Color color, float fuzz) : albedo(color), fuzz(fuzz){};
	virtual std::optional<Ray>
	scatter(const Ray &ray, const HitRecord &hitRecord) const override {
		const auto reflectedDirection =
			ray.direction.unit().reflect(hitRecord.normal);
		if (0.0 < reflectedDirection.dot(hitRecord.normal)) {
			return std::optional<Ray>(
				{hitRecord.point, reflectedDirection, ray.color});
		} else {
			return std::nullopt;
		}
	}
};

#endif