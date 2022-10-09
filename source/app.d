import std.stdio;

import raylib;

/// World is what the game takes place in
public class World {
    Map map;

}

/// The world has a map
public class Map {
    int width;
    int height;

    final
    float get(int x, int y) {
        if (x < 0 || x > this.width - 1) {
            throw new Exception("X getter is out of bounds for heightmap!");
        }
        if (y < 0 || y > this.height - 1) {
            throw new Exception("Y getter is out of bounds for heightmap!");
        }
        return heightMap[(x * this.heightMapSize) + y];
    }

}

/// The map has map tiles
public class MapTile {

}

/// The map tiles have layers
public class Layer {
    
}

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

            foreach (float x; 0..32) {
                foreach (float y; 0..32) {
                    writefln("%f, %f", x, y);
                    // DrawTexture(blah,x * 16, y * 16, Colors.RAYWHITE);
                    // DrawTextureEx(blah,Vector2(x * 32, y * 32), 0, 2, Colors.WHITE);
                }
            }


            
        }
        EndMode2D();

        EndDrawing();
    }
    CloseWindow();
}
