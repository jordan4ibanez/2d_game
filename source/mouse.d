module mouse;

import raylib;

public class Mouse {
    private Vector2 delta = Vector2(0,0);
    private Vector2 position = Vector2(0,0);
    private Vector2 oldPosition = Vector2(0,0);
    private float scrollDelta = 0;
    bool leftButtonIsPressed = false;
    bool rightButtonIsPressed = false;
    bool leftButtonIsDown = false;
    bool rightButtonIsDown = false;

    this() {
        position = GetMousePosition();
        oldPosition = position;
    }

    void update() {
        this.delta = Vector2Subtract(position, oldPosition);
        this.oldPosition = position;
        this.position = GetMousePosition();

        scrollDelta = GetMouseWheelMove();

        this.leftButtonIsDown  = IsMouseButtonDown(MouseButton.MOUSE_LEFT_BUTTON);
        this.rightButtonIsDown = IsMouseButtonDown(MouseButton.MOUSE_RIGHT_BUTTON);

        this.leftButtonIsPressed  = IsMouseButtonPressed(MouseButton.MOUSE_LEFT_BUTTON);
        this.rightButtonIsPressed = IsMouseButtonPressed(MouseButton.MOUSE_RIGHT_BUTTON);
    }

    Vector2 getDelta() {
        return delta;
    }

    float getScrollDelta() {
        return scrollDelta;
    }

    bool leftButtonDown() {
        return leftButtonIsDown;
    }

    bool rightButtonDown() {
        return rightButtonIsDown;
    }

    bool leftButtonPressed() {
        return leftButtonIsPressed;
    }
    
    bool rightButtonPressed() {
        return rightButtonIsPressed;
    }

    Vector2 getPosition() {
        return this.position;
    }
}