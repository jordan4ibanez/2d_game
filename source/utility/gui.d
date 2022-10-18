module utility.gui;

import raylib;
import std.stdio;

// Needs to expose externally
static immutable enum Anchor {
    // Corners
    TOP_LEFT,
    TOP_RIGHT,
    BOTTOM_LEFT,
    BOTTOM_RIGHT,

    // Center edges
    TOP,
    BOTTOM,
    LEFT,
    RIGHT,

    // Center
    CENTER
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

    

    GUIElement[string] elements;

    void render() {
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
        private Vector2 position;
        // ? holds a pointer or what? it's on the heap anyways
        private Texture texture;

        private bool visible = true;

        Texture getTexture() {
            return texture;
        }

        void setTexture(Texture texture) {
            this.texture = texture;
        }

        Vector2 getPosition() {
            return position;
        }

        void setPosition(Vector2 position) {
            this.position = position;
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


    void addText(string ID, string text) {
        this.elements[ID] = new GUIText(text);
    }

    private class GUIText : GUIElement {

        //! Now with more words!
        private string text;

        this(string text) {
            this.text = text;
            this.elementType = ElementType.TEXT;
        }

        string getText() {
            return text;
        }

        void setText(string text) {
            this.text = text;
        }

        override
        void render() {
            writeln("rendering " ~ text);
        }
    }
}