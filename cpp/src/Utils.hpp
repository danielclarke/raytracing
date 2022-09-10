#ifndef TRACER_UTILS
#define TRACER_UTILS

#include <random>

namespace tracer {
unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
std::default_random_engine generator(seed);
std::normal_distribution<float> distribution(0.0, 1.0);

float clamp(float v, float min, float max) {
	if (v < min) {
		return min;
	} else if (v > max) {
		return max;
	} else {
		return v;
	}
}

float randNorm() { return distribution(generator); }
} // namespace tracer

#endif