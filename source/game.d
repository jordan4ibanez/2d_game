module game;

import std.stdio;
import raylib;
import window;
import camera;
import texture;
import time_keeper;
import mouse;
import keyboard;
import game_states.game_state;
import game_states.map_editor;
import game_states.debug_main_menu;

public class Game {

    Window window;
    Cam camera;
    TextureCache cache;
    TimeKeeper timeKeeper;
    Mouse mouse;
    Keyboard keyboard;
    
    string currentState;

    GameState[string] states;

    this () {
        validateRaylibBinding();
        SetTraceLogLevel(TraceLogLevel.LOG_NONE);
        window = new Window(this);
        camera = new Cam(this);
        cache = new TextureCache();
        timeKeeper = new TimeKeeper(this);
        mouse = new Mouse();
        keyboard = new Keyboard();

        camera.setClearColor(255,120,6,255);

        cache.upload("atlas", "textures/city.png");
        // world.uploadAtlas(cache.get("atlas").get());

        states["MapEditor"] = new MapEditor(this);
        states["MainMenu"]  = new MainMenu(this);

        SetTargetFPS(60);
    }

    void run() {

        setState("MainMenu");

        while (!window.shouldClose()) {

            mouse.update();
            timeKeeper.calculateDelta();
            GameState state = states[currentState];
            state.update();
            // !Camera must update after state in case of camera changes!
            camera.update();

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
        if (currentState != "") {
            states[currentState].cleanUp();
        }
        currentState = newState;
        states[currentState].start();
    }
}