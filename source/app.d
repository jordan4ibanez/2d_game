import std.stdio;

import raylib;

void main() {
	validateRaylibBinding();

    InitWindow(512,512, "2D Game");

    Camera2D camera = Camera2D(Vector2(0,0), Vector2(0,0), 0, 0.25);

    Texture blah = LoadTexture("textures/modernCity/0.png");

    while (!WindowShouldClose()) {
        BeginDrawing();

        BeginMode2D(camera);
        {
            ClearBackground(Colors.BLACK);

            foreach (x; 0..32) {
                foreach (y; 0..32) {                    
                    // DrawTexture(blah,x * 16, y * 16, Colors.RAYWHITE);
                    DrawTextureEx(blah,Vector2(x * 32, y * 32), 0, 2, Colors.WHITE);
                }
            }


            
        }
        EndMode2D();

        EndDrawing();
    }
    CloseWindow();
}
