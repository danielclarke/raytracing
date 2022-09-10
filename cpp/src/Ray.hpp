#ifndef TRACER_RAY
#define TRACER_RAY

#include "Color.hpp"
#include "Point3.hpp"
#include "Vec3.hpp"

class Ray {
  public:
	Point3 origin{};
	Vec3 direction{};
	Color color{white()};

	Ray() = default;
	Ray(Point3 origin, Vec3 direction);
	Ray(Point3 origin, Vec3 direction, Color color);
	Point3 at(float t) const;
};

Ray::Ray(Point3 origin, Vec3 direction)
	: origin(origin), direction(direction), color(white()){};

Ray::Ray(Point3 origin, Vec3 direction, Color color)
	: origin(origin), direction(direction), color(color){};

inline Point3 Ray::at(float t) const {
	return this->origin.translate(this->direction * t);
}

#endif