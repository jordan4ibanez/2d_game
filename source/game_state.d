module game_state;

import game;
import std.stdio;

public class GameState {

    Game game;

    // Assign pointer for all GameStates
    this(Game game) {
        this.game = game;
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