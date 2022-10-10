module camera;

import raylib;

public class Cam {

    Camera2D camera;

    Color background;

    this() {
        this.camera = Camera2D(Vector2(0,0),Vector2(0,0), 0, 1);
        this.background = Colors.RAYWHITE;
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