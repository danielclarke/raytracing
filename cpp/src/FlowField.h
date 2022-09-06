#pragma once

#include "PerlinNoise.h"
#include "Vec2.h"

class FlowField {

  public:
	int width{0}, height{0}, resolution{0};
	std::vector<std::vector<Vec2>> field{{}};
	Vec2 getFlow(Vec2 index) const;

	FlowField(int width, int height, int resolution, float mag, float t);
};

FlowField::FlowField(int width, int height, int resolution, float mag, float t)
	: width(width), height(height), resolution(resolution),
	  field(std::vector<std::vector<Vec2>>(
		  width, std::vector<Vec2>(height, {0.0, 0.0}))) {
	for (int i = 0; i < width; i++) {
		for (int j = 0; j < height; j++) {
			field[i][j] =
				mag *
				vec2FromAngle(2.0 * PI *
							  perlin::noise(float(i) / this->resolution,
											float(j) / this->resolution, t));
		}
	}
}

Vec2 FlowField::getFlow(Vec2 index) const {
	return this->field[index.x][index.y];
}