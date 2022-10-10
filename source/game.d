module game;

import raylib;
import world;
import window;
import camera;

public class Game {

    World world;
    Window window;
    Cam camera;

    this () {
        validateRaylibBinding();
        window = new Window();
        world  = new World();
        camera = new Cam();
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









        }
        EndMode2D();
        EndDrawing();
    }
}