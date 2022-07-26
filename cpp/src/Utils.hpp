#ifndef TRACER_UTILS
#define TRACER_UTILS

#include <assert.h>
#include <random>

namespace tracer {
std::mt19937 generator(0.0);
std::uniform_real_distribution<float> distribution(0.0, 1.0);

float clamp(float v, float min, float max) {
	if (v < min) {
		return min;
	} else if (v > max) {
		return max;
	} else {
		return v;
	}
}

float randUnif() { return distribution(generator); }
} // namespace tracer

#endif