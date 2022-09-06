#include "Vec2.h"

class Vehicle {
  public:
	Vec2 location{0.0, 0.0}, velocity{0.0, 0.0}, acceleration{0.0, 0.0};
	float mass{0.0}, maxSpeed{0.0}, maxForce{0.0};

	void applyForce(const Vec2 force);
	void seek(const Vec2 target);
	void update(const float dt);
};

void Vehicle::applyForce(const Vec2 force) {
	const auto da = force / this->mass;
	this->acceleration += da;
}

void Vehicle::seek(const Vec2 target) {
	const auto desired = (target - this->location).norm() * this->maxSpeed;
	const auto steer = (desired - this->velocity).limit(this->maxForce);
	this->applyForce(steer);
}

void Vehicle::update(const float dt) {
	this->velocity =
		(this->velocity + this->acceleration * dt).limit(this->maxSpeed);
	this->location += this->velocity * dt;
	this->acceleration = {0.0, 0.0};
}