// #include "Material.hpp"
// #include "HitRecord.hpp"
// #include "Ray.hpp"

// std::optional<Ray> Lambertian::scatter(const Ray &ray,
// 									   const HitRecord &hitRecord) const {
// 	auto scatterDirection = hitRecord.normal + randomUnitVec3();
// 	if (scatterDirection.closeToZero()) {
// 		scatterDirection = hitRecord.normal;
// 	}
// 	return std::optional<Ray>({hitRecord.point, scatterDirection, ray.color});
// }

// std::optional<Ray> Metal::scatter(const Ray &ray,
// 								  const HitRecord &hitRecord) const {
// 	const auto reflectedDirection =
// 		ray.direction.unit().reflect(hitRecord.normal);
// 	if (0.0 < reflectedDirection.dot(hitRecord.normal)) {
// 		return std::optional<Ray>(
// 			{hitRecord.point, reflectedDirection, ray.color});
// 	} else {
// 		return std::nullopt;
// 	}
// }