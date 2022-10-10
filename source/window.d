module window;

import raylib;

public class Window {
    
    this() {
        InitWindow(512,512, "2D Game");
    }

    ~this() {
        CloseWindow();
    }

    bool shouldClose() {
        return WindowShouldClose();
    }

}