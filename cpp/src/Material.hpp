#ifndef TRACER_MATERIAL
#define TRACER_MATERIAL

#include "Color.hpp"
#include "HitRecord.hpp"
#include "Ray.hpp"
#include "Vec3.hpp"
#include <optional>

namespace {
float reflectance(float cosTheta, float refractiveIndex) {
	const auto r0 = (1.0f - refractiveIndex) / (1.0f + refractiveIndex);
	const auto r02 = r0 * r0;
	return r02 + (1.0f - r02) * powf((1.0f - cosTheta), 5.0);
}

Vec3 refract(const Vec3 &uv, const Vec3 &normal, float refractionRatio) {
	const auto costTheta = fminf(1.0f, (-uv).dot(normal));
	const auto rOutPerp = (uv + normal * costTheta) * refractionRatio;
	const auto rOutParallel =
		normal * -sqrtf(fabsf(1.0f - rOutPerp.dot(rOutPerp)));
	return rOutPerp + rOutParallel;
}
} // namespace

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
			{hitRecord.point, scatterDirection, this->albedo});
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
				{hitRecord.point, reflectedDirection, this->albedo});
		} else {
			return std::nullopt;
		}
	}
};

class Dielectric : public Material {
	float refractiveIndex{};

  public:
	Dielectric(float refractiveIndex) : refractiveIndex(refractiveIndex){};
	virtual std::optional<Ray>
	scatter(const Ray &ray, const HitRecord &hitRecord) const override {
		const auto refractionRatio = hitRecord.frontFace
										 ? 1.0f / this->refractiveIndex
										 : this->refractiveIndex;
		const auto cosTheta =
			fminf(1.0f, (-ray.direction.unit()).dot(hitRecord.normal));
		const auto sinTheta = sqrtf(1.0f - cosTheta * cosTheta);

		if (1.0f < refractionRatio * sinTheta or
			tracer::randUnif() < reflectance(cosTheta, refractionRatio)) {
			return std::optional<Ray>(
				{hitRecord.point,
				 ray.direction.unit().reflect(hitRecord.normal), ray.color});
		} else {
			const auto refractedDirection = refract(
				ray.direction.unit(), hitRecord.normal, refractionRatio);
			return std::optional<Ray>(
				{hitRecord.point, refractedDirection, ray.color});
		}
	}
};

#endif