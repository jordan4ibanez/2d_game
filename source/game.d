module game;

import std.stdio;
import raylib;
import world;
import window;
import camera;
import texture;
import time_keeper;

public class Game {

    World world;
    Window window;
    Cam camera;
    TextureCache cache;
    TimeKeeper timeKeeper;


    this () {
        validateRaylibBinding();
        window = new Window(this);
        world  = new World(this);
        camera = new Cam(this);
        cache = new TextureCache();
        timeKeeper = new TimeKeeper(this);

        camera.setClearColor(255,120,6,255);

        cache.upload("thing", "textures/modernCity/1 x 1.png");


        SetTargetFPS(60);
    }

    void run() {
        while (!window.shouldClose()) {
            update();
            render();
        }
    }

    void cleanUp() {
        cache.cleanUp();
    }

    void update() {

    }

    int size = 10;
    bool up = true;

    void render() {
        BeginDrawing();
        BeginMode2D(camera.get());
        {

            camera.clear();

            Texture blah =  cache.get("thing").get();

            if (up) {
                size += 1;
                up = size < 100 ? true : false;
            } else {
                size -= 1;
                up = size > 10 ? false : true;
            }

            writeln(size);

            /*
            foreach (int x; 0..32) {
                foreach (int y; 0..32) {
                    DrawTexture(blah, x*16,y*16, Colors.RAYWHITE);
                }
            }
            */

            Rectangle source = Rectangle(0,0, blah.width, blah.height);

            Rectangle goal = Rectangle(0,0,size, 30);

            DrawTexturePro(blah, source, goal, Vector2(0,0),0, Colors.WHITE);


        }
        EndMode2D();
        EndDrawing();
    }
}