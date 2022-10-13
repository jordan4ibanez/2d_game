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
        SetTraceLogLevel(TraceLogLevel.LOG_NONE);
        window = new Window(this);
        world  = new World(this);
        camera = new Cam(this);
        cache = new TextureCache();
        timeKeeper = new TimeKeeper(this);

        camera.setClearColor(255,120,6,255);

        cache.upload("atlas", "textures/city.png");

        world.uploadAtlas(cache.get("atlas").get());


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
        world.cleanUp();
        window.cleanUp();


        cache.destroy();
        world.destroy();
        camera.destroy();
        timeKeeper.destroy();
        window.destroy();
    }

    void update() {
        timeKeeper.calculateDelta();

    }

    int size = 10;
    bool up = true;

    float zoom = 6;

    void render() {
        BeginDrawing();
        BeginMode2D(camera.get());
        {

            float delta = timeKeeper.getDelta();

            camera.clear();

            if (up) {
                zoom += delta;
                up = zoom < 5 ? true : false;
            } else {
                zoom -= delta;
                up = zoom > 1 ? false : true;
            }

            writeln(zoom);

            camera.setZoom(zoom);


            foreach (x; 0..37) {
                foreach (y; 0..28) {
                    world.drawTile(x,y,x,y,1);
                }
            }           


        }
        EndMode2D();
        EndDrawing();
    }
}