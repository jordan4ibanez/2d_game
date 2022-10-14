module mouse;

import raylib;

public class Mouse {
    private Vector2 delta = Vector2(0,0);
    private Vector2 position = Vector2(0,0);
    private Vector2 oldPosition = Vector2(0,0);
    private float scrollDelta = 0;
    bool leftButton = false;
    bool rightButton = false;

    this() {
        position = GetMousePosition();
        oldPosition = position;
    }

    void update() {
        this.delta = Vector2Subtract(position, oldPosition);
        this.oldPosition = position;
        this.position = GetMousePosition();

        scrollDelta = GetMouseWheelMove();

        this.leftButton = IsMouseButtonDown(MouseButton.MOUSE_LEFT_BUTTON);
        this.rightButton = IsMouseButtonDown(MouseButton.MOUSE_RIGHT_BUTTON);
    }

    Vector2 getDelta() {
        return delta;
    }

    float getScrollDelta() {
        return scrollDelta;
    }

    float getLeftButton() {
        return leftButton;
    }
    
    float getRightButton() {
        return rightButton;
    }

    Vector2 getPosition() {
        return this.position;
    }
}