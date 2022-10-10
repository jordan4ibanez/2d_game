module camera;

import raylib;
import game;

public class Cam {

    Game game;

    Camera2D camera;

    Color background;

    this(Game game) {
        this.game = game;
        this.camera = Camera2D(Vector2(0,0),Vector2(0,0), 0, 1);
        this.background = Colors.RAYWHITE;
    }

    void setClearColor(ubyte r, ubyte g, ubyte b, ubyte a) {
        this.background = Color(r,g,b,a);
    }

    void clear() {
        ClearBackground(this.background);
    }

    void setOffset(Vector2 offset) {
        this.camera.offset = offset;
    }

    void setTarget(Vector2 target) {
        this.camera.target = target;
    }

    void setRotation(float rotation) {
        this.camera.rotation = rotation;
    }

    void setZoom(float zoom) {
        this.camera.zoom = zoom;
    }

    Camera2D get() {
        return this.camera;
    }    
}