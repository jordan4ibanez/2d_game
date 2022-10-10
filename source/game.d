module game;

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
    }

    void run() {
        while (!window.shouldClose()) {
            update();
            render();
        }
    }

    void update() {

    }

    void render() {
        BeginDrawing();
        BeginMode2D(camera.get());
        {

            camera.clear();

            Texture blah =  cache.get("thing").get();

            /*
            foreach (int x; 0..32) {
                foreach (int y; 0..32) {
                    DrawTexture(blah, x*16,y*16, Colors.RAYWHITE);
                }
            }
            */


        }
        EndMode2D();
        EndDrawing();
    }
}