#include <chrono>
#include <iostream>
#include <random>

#include "raylib.h"

#include "Aabb.h"
#include "FlowField.h"
#include "Vec2.h"
#include "Vehicle.h"

constexpr int SCALE = 2;
constexpr int SCREEN_WIDTH = 256;
constexpr int SCREEN_HEIGHT = 224;
constexpr int FRAME_RATE = 60;

void renderFlowField(FlowField ff) {
	for (const auto row : ff.field) {
		for (const auto cell : row) {
			
		}
	}
}

int main() {
	InitWindow(SCREEN_WIDTH * SCALE, SCREEN_HEIGHT * SCALE,
			   "raylib cpp - agents");
	SetTargetFPS(FRAME_RATE);

	float t = 0.0;
	while (not WindowShouldClose()) {
		t += 0.0011;
		const auto ff = FlowField(40, 40, 77.0, 10.0, t);
		BeginDrawing();
		ClearBackground(DARKGRAY);
		EndDrawing();
	}
	return 0;
}