module utility.gui;

import raylib;
import std.stdio;
import window;
import std.string: toStringz;

// Needs to expose externally
// Todo: Check if these calculations are even correct

static immutable enum Anchor {
    // Corners
    TOP_LEFT     = Vector2(0,0),
    TOP_RIGHT    = Vector2(1,0),
    BOTTOM_LEFT  = Vector2(0,1),
    BOTTOM_RIGHT = Vector2(1,1),

    // Center edges
    TOP     = Vector2(0.5, 0  ),
    BOTTOM  = Vector2(0.5, 1  ),
    LEFT    = Vector2(0  , 0.5),
    RIGHT   = Vector2(1  , 0.5),

    // Center
    CENTER = Vector2(0.5 , 0.5)
}

//! I've never made a generic GUI before so this might be a disaster
public class GUI {


    //! Literally no idea what to put here
    static immutable enum ElementType {
        NULL,
        TEXT,
        ANIMATED_TEXT,
        INPUT,
        BUTTON,
        IMAGE,
        DROP_MENU,
        // Windows are going to be real fun to debug
        WINDOW
    }

    int windowWidth;
    int windowHeight;

    Window window;

    GUIElement[string] elements;

    this(Window window) {
        this.window = window;
    }

    void render() {

        Vector2 wSize = window.getSize();
        windowWidth = cast(int)wSize.x;
        windowHeight = cast(int)wSize.y;

        
        foreach (element; elements) {
            element.render();
        }
    }

    void removeElement(string ID) {
        this.elements.remove(ID);
    }

    private class GUIElement {

        ElementType elementType = ElementType.NULL;

        Anchor anchor = Anchor.TOP_LEFT;

        private float scale;
        private Vector2 size;
        private Vector2 offset;

        // ? holds a pointer or what? it's on the heap anyways
        private Texture texture;

        private bool visible = true;

        Texture getTexture() {
            return texture;
        }

        void setTexture(Texture texture) {
            this.texture = texture;
        }

        Vector2 getOffset() {
            return offset;
        }

        void setOffset(Vector2 offset) {
            this.offset = offset;
        }

        Vector2 getSize() {
            return size;
        }

        void setSize(Vector2 size) {
            this.size = size;
        }

        float getScale() {
            return scale;
        }        

        void setScale(float scale) {
            this.scale = scale;
        }

        bool isVisible() {
            return visible;
        }

        void setVisible(bool visibility) {
            this.visible = visibility;
        }

        void render() {
            throw new Exception("Render is not implemented for this element!");
        }
    }


    void addText(Anchor anchor, string ID, string text, int offsetX, int offsetY, int fontSize) {
        this.elements[ID] = new GUIText(anchor, offsetX,offsetY, text, fontSize);
    }

    private class GUIText : GUIElement {

        //! Now with more words!
        private string text;
        private bool shadowed;
        private int fontSize;
        private int length;
        private Vector2 textSize;

        this(Anchor anchor, int offsetX, int offsetY, string text, int fontSize) {
            this.text = text;
            this.elementType = ElementType.TEXT;
            this.fontSize = fontSize;
            this.length = cast(int)text.length;
            this.offset = Vector2(offsetX, offsetY);
            this.textSize = MeasureTextEx(GetFontDefault(),toStringz(text), fontSize,0);
            this.anchor = anchor;
        }

        string getText() {
            return text;
        }

        void setText(string text) {
            this.text = text;
            this.length = cast(int)text.length;
            this.textSize = MeasureTextEx(GetFontDefault(),toStringz(text), fontSize,0);
        }

        int getFontSize() {
            return fontSize;
        }

        void setFontSize(int fontSize) {
            this.fontSize = fontSize;
            this.textSize = MeasureTextEx(GetFontDefault(),toStringz(text), fontSize,0);
        }

        override
        void render() {

            // !float here, cast later
            float widthAdjust = anchor.x == 1? length : length / 2.0;
            

            float positionRenderX = ((anchor.x * windowWidth)  - (anchor.x * fontSize)) + offset.x;
            float positionRenderY = ((anchor.y * windowHeight) - (anchor.y * fontSize)) + offset.y;

            DrawText(
                toStringz(text),
                cast(int)positionRenderX,
                cast(int)positionRenderY,
                fontSize,
                Color(255,255,255,255)
            );
        }
    }
}