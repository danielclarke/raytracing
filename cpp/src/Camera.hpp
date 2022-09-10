#ifndef TRACER_CAMERA
#define TRACER_CAMERA

#include "Point3.hpp"
#include "Ray.hpp"
#include "Utils.hpp"
#include "Vec3.hpp"

class Camera {
	float aspect{0.0};
	float height{0.0};
	float width{0.0};
	float focalLength{0.0};
	float lensRadius{0.0};
	Point3 origin{};
	Vec3 horizontal{};
	Vec3 vertical{};
	Point3 lowerLeftCorner{};
	Vec3 u{};
	Vec3 v{};
	Vec3 w{};

  public:
	Camera(float aspect, float focalLength, float aperture,
		   float verticalFovRad, float focusDistance, Point3 origin,
		   Point3 lookAt, Vec3 up);

	Ray getRay(float u, float v) const;
};

Camera::Camera(float aspect, float focalLength, float aperture,
			   float verticalFovRad, float focusDistance, Point3 origin,
			   Point3 lookAt, Vec3 up)
	: aspect(aspect), focalLength(focalLength), origin(origin) {
	this->w = origin.distance(lookAt).unit();
	this->u = up.cross(w).unit();
	this->v = w.cross(this->u);
	this->height = 2.0 * tanf(verticalFovRad / 2.0);
	this->width = aspect * this->height;
	this->horizontal = this->u * focusDistance * this->width;
	this->vertical = this->v * focusDistance * this->height;
	this->lowerLeftCorner =
		this->origin.translate(this->horizontal * -0.5 + this->vertical * -0.5 +
							   this->w * -focusDistance);
};

Ray Camera::getRay(float u, float v) const {
	const auto rd = randomPointInUnitDisc();
	const auto offset =
		this->u * this->lensRadius * rd.x + this->v * this->lensRadius * rd.y;
	const auto rayOrigin = this->origin.translate(offset);
	const auto direction = (this->lowerLeftCorner.translate(
								this->horizontal * u + this->vertical * v))
							   .distance(rayOrigin);
	return {rayOrigin, direction, white()};
}

#endif