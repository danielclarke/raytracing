#ifndef TRACER_POINT3
#define TRACER_POINT3

#include "Utils.hpp"
#include "Vec3.hpp"
#include <cmath>

class Point3 {
  public:
	float x{0.0}, y{0.0}, z{0.0};
	Point3() = default;
	Point3(float x, float y, float z) : x(x), y(y), z(z){};
	Vec3 distance(const Point3 &p) const;
	Point3 translate(const Vec3 &v) const;
	Vec3 operator-(const Point3 &p) const;
	Point3 operator+(const Vec3 &v) const;
};

inline Point3 origin() { return {}; }

Point3 randomPointInUnitSphere() {
	const auto r = tracer::randNorm();
	const auto theta = tracer::randNorm() * 2.0 * M_PI;
	const auto phi = tracer::randNorm() * 2.0 * M_PI;
	return {r * sinf(phi) * cosf(theta), r * sinf(phi) * sinf(theta),
			r * cosf(phi)};
}

Point3 randomPointInUnitDisc() {
	const auto r = tracer::randNorm();
	const auto theta = tracer::randNorm() * 2.0 * M_PI;
	return {r * cosf(theta), r * sinf(theta), 0.0};
}

inline Vec3 Point3::distance(const Point3 &p) const {
	return {this->x - p.x, this->y - p.y, this->z - p.z};
}

inline Point3 Point3::translate(const Vec3 &v) const {
	return {this->x + v.x, this->y + v.y, this->z + v.z};
}

inline Vec3 Point3::operator-(const Point3 &p) const {
	return {this->x - p.x, this->y - p.y, this->z - p.z};
}

inline Point3 Point3::operator+(const Vec3 &v) const {
	return {this->x + v.x, this->y + v.y, this->z + v.z};
}

#endif