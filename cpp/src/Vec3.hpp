#ifndef TRACER_VEC3
#define TRACER_VEC3

#include "Utils.hpp"
#include <cmath>

class Vec3 {
  public:
	float x{0.0}, y{0.0}, z{0.0};
	Vec3() = default;
	Vec3(float x, float y, float z) : x(x), y(y), z(z){};
	Vec3 operator+(const Vec3 &v) const;
	Vec3 operator-() const;
	Vec3 operator-(const Vec3 &v) const;
	Vec3 operator*(const Vec3 &v) const;
	Vec3 operator*(float f) const;
	Vec3 operator/(float f) const;
	Vec3 &operator+=(const Vec3 &v);
	float dot(const Vec3 &v) const;
	Vec3 cross(const Vec3 &v) const;
	Vec3 unit() const;
	float mag() const;
	Vec3 reflect(const Vec3 &normal) const;
	bool closeToZero() const;
};

inline Vec3 randomUnitVec3() {
	return Vec3(tracer::randUnif(), tracer::randUnif(), tracer::randUnif())
		.unit();
}

inline Vec3 Vec3::operator+(const Vec3 &v) const {
	return {this->x + v.x, this->y + v.y, this->z + v.z};
}

inline Vec3 Vec3::operator-() const { return {-this->x, -this->y, -this->z}; }

inline Vec3 Vec3::operator-(const Vec3 &v) const {
	return {this->x - v.x, this->y - v.y, this->z - v.z};
}

inline Vec3 Vec3::operator*(const Vec3 &v) const {
	return {this->x * v.x, this->y * v.y, this->z * v.z};
}

inline Vec3 Vec3::operator*(float f) const {
	return {this->x * f, this->y * f, this->z * f};
}

inline Vec3 Vec3::operator/(float f) const {
	return {this->x / f, this->y / f, this->z / f};
}

inline Vec3 &Vec3::operator+=(const Vec3 &v) {
	this->x += v.x;
	this->y += v.y;
	this->z += v.z;
	return *this;
}

inline float Vec3::dot(const Vec3 &v) const {
	return this->x * v.x + this->y * v.y + this->z * v.z;
}

inline Vec3 Vec3::cross(const Vec3 &v) const {
	return {this->y * v.z - this->z * v.y, this->z * v.x - this->x * v.z,
			this->x * v.y - this->y * v.x};
}

inline float Vec3::mag() const { return sqrtf(this->dot(*this)); }

inline Vec3 Vec3::unit() const { return (*this) / (this->mag()); }

inline Vec3 Vec3::reflect(const Vec3 &normal) const {
	return (*this) - normal * 2.0 * this->dot(normal);
}

inline bool Vec3::closeToZero() const {
	constexpr auto S = 1e-8;
	return fabsf(this->x) < S and fabsf(this->y) < S and fabsf(this->z) < S;
}

namespace test {
void vec3Tests() {
	const auto v = randomUnitVec3();
	const auto u = randomUnitVec3() + Vec3{0.0, 1.0, 0.0};
	const auto z = Vec3{0.0, 0.0, 0.0};
	const auto b = z.closeToZero();
	const auto b2 = u.closeToZero();
}
} // namespace test

#endif