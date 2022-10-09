import std.stdio;

import raylib;

void main() {
	validateRaylibBinding();

    InitWindow(512,512, "2D Game");

    Camera2D camera = Camera2D();

    while (!WindowShouldClose()) {
        BeginDrawing();

        BeginMode2D(camera);
        {
            ClearBackground(Colors.BLACK);
        }
        EndMode2D();

        EndDrawing();
    }
    CloseWindow();
}
