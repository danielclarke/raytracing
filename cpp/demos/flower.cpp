#include "raylib.h"
#include <random>

const int SCREEN_WIDTH = 256 * 2;
const int SCREEN_HEIGHT = 224;

typedef struct {
	int x;
	int y;
} Walker;

int main() {
	InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "C++");

	SetTargetFPS(60);

	std::default_random_engine generator;
	std::normal_distribution<double> distribution(0.0, 1.0);

	Walker walker = {0, 0};

	RenderTexture2D buffer = LoadRenderTexture(SCREEN_WIDTH, SCREEN_HEIGHT);

	BeginTextureMode(buffer);
	ClearBackground((Color){245, 245, 245, 255});
	EndTextureMode();

	while (!WindowShouldClose()) {

		// int dx = GetRandomValue(-2, 1);
		// int dy = GetRandomValue(-2, 1);

		// int mouseX = GetMouseX();
		// int mouseY = GetMouseY();

		// if (dx < 0) {
		// 	walker.x += mouseX > walker.x ? 1 : -1;
		// } else if (dx == 1) {
		// 	walker.x += mouseX > walker.x ? -1 : 1;
		// }

		// if (dy < 0) {
		// 	walker.y += mouseY > walker.y ? 1 : -1;
		// } else if (dy == 1) {
		// 	walker.y += mouseY > walker.y ? -1 : 1;
		// }

		BeginTextureMode(buffer);
		for (int i = 0; i < 1000; i++) {
			double dx = distribution(generator);
			double dy = distribution(generator);
			walker.x = dx * 20.0 + SCREEN_WIDTH / 2;
			walker.y = dy * 20.0 + SCREEN_HEIGHT / 2;

			DrawCircle(walker.x, SCREEN_HEIGHT - walker.y, 2,
					   ColorFromHSV((dx * dx * 20) + (dy * dy * 20), 1, 1));
			//    (Color){200, 50, 50, 255});
		}
		EndTextureMode();

		BeginDrawing();
		DrawTexture(buffer.texture, 0, 0, (Color){245, 245, 245, 255});
		DrawFPS(10, 10);
		EndDrawing();
	}

	return 0;
}