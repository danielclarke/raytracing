#ifndef TRACER_HIT_RECORD
#define TRACER_HIT_RECORD

#include "Point3.hpp"
#include "Ray.hpp"
#include "Vec3.hpp"

class Material;

struct HitRecord {
	Point3 point{};
	Vec3 normal{};
	std::shared_ptr<Material> material{};
	float t{0.0};
	bool frontFace{false};

	HitRecord() = delete;
	HitRecord(Point3 point, Vec3 normal, std::shared_ptr<Material> material,
			  float t, bool frontFace)
		: point(point), normal(normal), material(material), t(t),
		  frontFace(frontFace) {}
};

HitRecord qualifiedHitRecord(const Ray &ray, std::shared_ptr<Material> material,
							 Point3 point, float t, Vec3 outwardNormal) {
	const auto frontFace = ray.direction.dot(outwardNormal) < 0.0;
	const auto normal = outwardNormal * (frontFace ? 1.0 : -1.0);
	return {point, normal, material, t, frontFace};
}

#endif