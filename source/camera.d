module camera;

import std.stdio;
import raylib;
import game;
import std.algorithm.comparison: clamp;

public class Cam {

    Game game;

    Camera2D camera;

    Color background;

    Vector2 offset = Vector2(0,0);

    this(Game game) {
        this.game = game;
        this.camera = Camera2D(Vector2(0,0),Vector2(0,0), 0, 5);
        this.background = Colors.RAYWHITE;
    }

    void update() {
        Vector2 windowSize = game.window.getSize();
        windowSize.x /= 2.0;
        windowSize.y /= 2.0;
        this.camera.offset = Vector2Add(offset, windowSize);
    }

    void setClearColor(ubyte r, ubyte g, ubyte b, ubyte a) {
        this.background = Color(r,g,b,a);
    }

    void clear() {
        ClearBackground(this.background);
    }

    void setOffset(Vector2 offset) {
        this.offset = offset;
    }

    void addOffset(Vector2 addingOffset) {
        this.offset = Vector2Add(offset, addingOffset);
    }

    void setTarget(Vector2 target) {
        this.camera.target = target;
    }

    void setRotation(float rotation) {
        this.camera.rotation = rotation;
    }

    void setZoom(float zoom) {
        this.camera.zoom = clamp(zoom, 5, 12);
    }

    float getZoom() {
        return this.camera.zoom;
    }

    Camera2D get() {
        return this.camera;
    }    
}