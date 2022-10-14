module game;

import std.stdio;
import raylib;
import window;
import camera;
import texture;
import time_keeper;
import mouse;
import game_state;
import map_editor;

public class Game {

    Window window;
    Cam camera;
    TextureCache cache;
    TimeKeeper timeKeeper;
    Mouse mouse;
    string currentState = "MapEditor";

    GameState[string] states;

    this () {
        validateRaylibBinding();
        SetTraceLogLevel(TraceLogLevel.LOG_NONE);
        window = new Window(this);
        camera = new Cam(this);
        cache = new TextureCache();
        timeKeeper = new TimeKeeper(this);
        mouse = new Mouse();

        camera.setClearColor(255,120,6,255);

        cache.upload("atlas", "textures/city.png");
        // world.uploadAtlas(cache.get("atlas").get());

        states["MapEditor"] = new MapEditor(this);

        SetTargetFPS(60);
    }

    void run() {

        setState("MapEditor");

        while (!window.shouldClose()) {

            mouse.update();
            timeKeeper.calculateDelta();
            camera.update();

            GameState state = states[currentState];

            state.update();
            state.render();
        }
    }

    void cleanUp() {
        cache.cleanUp();
        window.cleanUp();

        foreach (state; states) {
            state.cleanUp();
        }

        cache.destroy();
        camera.destroy();
        timeKeeper.destroy();
        window.destroy();
    }

    void setState(string newState) {
        states[currentState].cleanUp();
        currentState = newState;
        states[currentState].start();
    }
}