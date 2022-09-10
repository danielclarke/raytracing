#ifndef TRACER_COLOR
#define TRACER_COLOR

#include "Utils.hpp"
#include <cmath>

class Color {
	float r{0.0}, g{0.0}, b{0.0};

  public:
	Color() = default;
	Color(float red, float green, float blue);
	Color operator+(const Color &c) const;
	Color operator*(const Color &c) const;
	Color operator*(float f) const;
	Color &operator+=(const Color &v);
	std::string ppm(int numSamples) const;
};

namespace {
inline int to8Bit(float v, float scale) {
	return static_cast<int>(tracer::clamp(sqrt(scale * v), 0.0, 0.999) *
							255.999);
}
} // namespace

Color::Color(float red, float green, float blue) : r(red), g(green), b(blue){};
Color black() { return {}; };
Color white() { return {1.0, 1.0, 1.0}; };

Color lerp(const Color &a, const Color &b, float t) {
	return a * (1.0 - t) * b * t;
}

inline Color Color::operator+(const Color &c) const {
	return {this->r + c.r, this->g + c.g, this->b + c.b};
}
inline Color &Color::operator+=(const Color &v) {
	this->r += v.r;
	this->g += v.g;
	this->b += v.b;
	return *this;
}
inline Color Color::operator*(const Color &c) const {
	return {this->r * c.r, this->g * c.g, this->b * c.b};
}
inline Color Color::operator*(float f) const {
	return {this->r * f, this->g * f, this->b * f};
}

std::string Color::ppm(int numSamples) const {
	const auto scale = 1.0 / numSamples;
	const auto r = to8Bit(this->r, scale);
	const auto g = to8Bit(this->g, scale);
	const auto b = to8Bit(this->b, scale);
	return std::to_string(r) + " " + std::to_string(g) + " " +
		   std::to_string(b);
}

#endif