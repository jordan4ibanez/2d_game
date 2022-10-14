module mouse;

import raylib;

public class Mouse {
    private Vector2 delta = Vector2(0,0);
    private Vector2 position = Vector2(0,0);
    private Vector2 oldPosition = Vector2(0,0);
    private float scrollDelta = 0;

    this() {
        position = GetMousePosition();
        oldPosition = position;
    }

    void update() {
        this.delta = Vector2Subtract(position, oldPosition);
        this.oldPosition = position;
        this.position = GetMousePosition();

        scrollDelta = GetMouseWheelMove();
    }

    Vector2 getDelta() {
        return delta;
    }

    float getScrollDelta() {
        return scrollDelta;
    }
        
}