module game;

import raylib;
import world;
import window;

public class Game {
    World world;
    Window window;

    this () {
        validateRaylibBinding();
        window = new Window();

    }

    void run() {
        while (!window.shouldClose()) {

        }
    }

    void update() {

    }

    void render() {
        
    }
}