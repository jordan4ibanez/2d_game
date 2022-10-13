module window;

import raylib;
import game;

public class Window {

    Game game;
    
    this(Game game) {
        this.game = game;
        InitWindow(512,512, "2D Game");
    }

    void cleanUp() {
        CloseWindow();
    }

    bool shouldClose() {
        return WindowShouldClose();
    }

}