#include "raylib.h"
#include <chrono>
#include <random>

#include "Vec2.h"

const int SCREEN_WIDTH = 256 * 2;
const int SCREEN_HEIGHT = 224;

typedef struct {
	float x;
	float y;
} Walker;

int main() {
	const Vec2 v{1.0, 2.0};
	const Vec2 u{3.0, 5.0};

	const auto w = u + v;
	const auto a = u - v;

	printf("v.x: %f, v.y: %f", a.x, a.y);

	InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "C++");

	SetTargetFPS(60);

	unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
	std::default_random_engine generator(seed);
	std::normal_distribution<float> distribution(0.0, 1.0);

	Walker walker = {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2};

	float sum = 0.0;
	for (int i = 0; i < 10000; i++) {
		sum += distribution(generator);
	}
	char charBuffer[10];
	sprintf(charBuffer, "MEAN: %.2f", sum / 10000.0);

	RenderTexture2D buffer = LoadRenderTexture(SCREEN_WIDTH, SCREEN_HEIGHT);
	BeginTextureMode(buffer);
	ClearBackground((Color){245, 245, 245, 255});
	EndTextureMode();

	while (!WindowShouldClose()) {
		float dx = distribution(generator);
		float dy = distribution(generator);
		walker.x += dx;
		walker.y += dy;

		BeginTextureMode(buffer);
		DrawCircle(walker.x, walker.y, 2,
				   //    ColorFromHSV((dx * dx * 20) + (dy * dy * 20), 1, 1));
				   (Color){200, 50, 50, 255});
		EndTextureMode();

		BeginDrawing();
		DrawTexture(buffer.texture, 0, 0, (Color){245, 245, 245, 255});
		DrawFPS(10, 10);
		sprintf(charBuffer, "DX: %.2f", dx);
		DrawText(charBuffer, 10, 40, 18, (Color){0, 0, 0, 255});
		sprintf(charBuffer, "DY: %.2f", dy);
		DrawText(charBuffer, 10, 70, 18, (Color){0, 0, 0, 255});
		EndDrawing();
	}

	return 0;
}