module game_states.game_state;

import game;
import std.stdio;
import window;
import camera;
import texture;
import time_keeper;
import mouse;

public class GameState {

    Window window;
    Cam camera;
    TextureCache cache;
    TimeKeeper timeKeeper;
    Mouse mouse;

    // Assign pointer for all GameStates
    this(Game game) {
        window = game.window;
        camera = game.camera;
        cache  = game.cache;
        timeKeeper = game.timeKeeper;
        mouse = game.mouse;
    }
    void start() {
        throw new Exception("Start() is not implimented for a GameState!");
    }
    void update() {
        throw new Exception("Update() is not implimented for a GameState!");
    }
    void render() {
        throw new Exception("Render() is not implimented for a GameState!");
    }
    void reset() {
        throw new Exception("Reset() is not implimented for a GameState!");
    }
    void cleanUp() {
        throw new Exception("CleanUp() is not implimented for a GameState!");
    }
}