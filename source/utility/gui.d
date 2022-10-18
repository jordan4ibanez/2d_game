module utility.gui;

import raylib;

//! I've never made a generic GUI before so this might be a disaster
public class GUI {


    //! Literally no idea what to put here
    static immutable enum ElementType {
        // I don't think I have to explain this one :P
        NULL,
        // Root node ignores everything
        ROOT,
        TEXT,
        ANIMATED_TEXT,
        INPUT,
        BUTTON,
        IMAGE,
        DROP_MENU,
        // Windows are going to be real fun to debug
        WINDOW
    }

    GUIElement[string] nodes;



    private class GUIElement {

        ElementType elementType = ElementType.NULL;

        private float scale;
        private Vector2 size;
        private Vector2 position;
        // ? holds a pointer or what? it's on the heap anyways
        private Texture texture;

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
    }

    private class GUIRoot : GUIElement {
        this(Vector2 position, Vector2 size) {
            this.position = position;
            this.size = size;
        }
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
    }


}