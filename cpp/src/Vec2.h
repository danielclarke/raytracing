#pragma once

class Vec2 {
  public:
	float x{0.0};
	float y{0.0};

	Vec2 copy() { return (*this); }

	float mag() const { return sqrt(this->x * this->x + this->y * this->y); }

	Vec2 norm() const;
	Vec2 limit(float f) const;
};

Vec2 operator+(const Vec2 &v, const Vec2 &u) { return {v.x + u.x, v.y + u.y}; }

Vec2 operator-(const Vec2 &v, const Vec2 &u) { return {v.x - u.x, v.y - u.y}; }

Vec2 operator-(const Vec2 &v) { return {-v.x, -v.y}; }

Vec2 operator*(const Vec2 &v, const Vec2 &u) { return {v.x * u.x, v.y * u.y}; }

Vec2 operator*(float f, const Vec2 &v) { return {v.x * f, v.y * f}; }

Vec2 operator*(const Vec2 &v, float f) { return {v.x * f, v.y * f}; }

Vec2 operator/(const Vec2 &v, float f) { return {v.x / f, v.y / f}; }

void operator+=(Vec2 &v, const Vec2 &u) {
	v.x += u.x;
	v.y += u.y;
}

Vec2 Vec2::norm() const {
	const float m = this->mag();
	if (m == 0.0) {
		return (*this);
	} else {
		return (*this) / m;
	}
}

Vec2 Vec2::limit(float f) const {
	const float m = this->mag();
	if (m <= f) {
		return (*this);
	} else {
		return (*this) / m * f;
	}
}

Vec2 vec2FromAngle(float theta) { return {cos(theta), sin(theta)}; }

void testVec2() {
	Vec2 v{1.0, -1.0};
	const Vec2 u{3.0, 5.0};

	const auto a = u + v;
	const auto b = u - v;
	const auto c = -v;
	const auto d = u * v;
	const auto e = 5.0 * v;
	const auto f = u.norm();
	const auto g = v.norm();
	const auto h = v.limit(0.5);
	auto i = v.copy();
	i.x = 10.0;
	const auto j = vec2FromAngle(0.0);
	const auto k = vec2FromAngle(PI / 4.0);

	printf("v.mag: %f\n", v.mag());
	printf("a.x: %f, a.y: %f\n", a.x, a.y);
	printf("b.x: %f, b.y: %f\n", b.x, b.y);
	printf("c.x: %f, c.y: %f\n", c.x, c.y);
	printf("d.x: %f, d.y: %f\n", d.x, d.y);
	printf("e.x: %f, e.y: %f\n", e.x, e.y);
	printf("f.x: %f, f.y: %f\n", f.x, f.y);
	printf("g.x: %f, g.y: %f\n", g.x, g.y);
	printf("h.x: %f, h.y: %f\n", h.x, h.y);
	printf("h.mag: %f\n", h.mag());
	printf("v.x: %f, v.y: %f\n", v.x, v.y);
	printf("i.x: %f, i.y: %f\n", i.x, i.y);
	printf("j.x: %f, j.y: %f\n", j.x, j.y);
	printf("k.x: %f, k.y: %f\n", k.x, k.y);

	v += u;
	printf("v.x: %f, v.y: %f\n", v.x, v.y);
}