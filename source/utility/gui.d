module utility.gui;

import raylib;
import std.stdio;
import window;
import std.string: toStringz;
import std.conv: to;

// Needs to expose externally
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

static immutable enum ElementType {
    NULL,          //! DONE
    TEXT,          //! DONE
    ANIMATED_TEXT, //! DONE
    INPUT,
    BUTTON,
    IMAGE,
    DROP_MENU,
    // Windows are going to be real fun to debug
    WINDOW
}


//! I've never made a generic GUI before so this might be a disaster
public class GUI {
    
    int windowWidth;
    int windowHeight;
    int windowOffsetX;
    int windowOffsetY;

    Window window;

    // todo: layers?
    GUIText[string] textElements;
    GUIImage[string] imageElements;

    this(Window window) {
        this.window = window;
        windowOffsetX = 0;
        windowOffsetY = 0;
    }

    /* 
    todo: window constructor
    this(Window window, bool isWindow) {
        this.window = window;
    }
    */

    //! Text Elements
    void addTextElement(Anchor anchor, string ID, string text, int offsetX, int offsetY, int fontSize, Color color, bool shadowed) {
        this.textElements[ID] = new GUIText(anchor, offsetX,offsetY, text, fontSize, color, shadowed);
    }
    void removeTextElement(string ID) {
        this.textElements.remove(ID);
    }
    GUIText getTextElement(string ID) {
        return this.textElements[ID];
    }
    
    //! Animated Text Elements    
    void addAnimatedTextElement(Anchor anchor, string ID, string text, int offsetX, int offsetY, int fontSize, Color color, bool shadowed, void delegate(GUITextAnimated) initialFunc, void delegate(GUITextAnimated, float) func) {
        this.textElements[ID] = new GUITextAnimated(anchor, offsetX,offsetY, text, fontSize, color, shadowed, initialFunc, func);
    }
    void removeAnimatedTextElement(string ID) {
        this.textElements.remove(ID);
    }
    GUIText getAnimatedTextElement(string ID) {
        return this.textElements[ID];
    }

    //! Image Elements
    void addImageElement(Anchor anchor, string ID, int offsetX, int offsetY, Texture texture, float scale) {
        this.imageElements[ID] = new GUIImage(anchor, offsetX,offsetY, texture, scale);
    }
    void removeImageElement(string ID) {
        this.imageElements.remove(ID);
    }
    GUIImage getImageElement(string ID) {
        return this.imageElements[ID];
    }
    

    void render(float delta) {

        Vector2 wSize = window.getSize();
        windowWidth = cast(int)wSize.x;
        windowHeight = cast(int)wSize.y;

        foreach (element; textElements) {
            element.update(windowWidth, windowHeight, delta);
            element.render();
        }

        foreach (element; imageElements) {
            element.update(windowWidth, windowHeight, delta);
            element.render();            
        }
    }
}



private class GUIElement {

    ElementType elementType = ElementType.NULL;

    Anchor anchor = Anchor.TOP_LEFT;

    private float scale;
    private Vector2 size;
    private Vector2 offset;

    int windowHeight;
    int windowWidth;

    private bool visible = true;

    void update(int windowWidth, int windowHeight, float delta) {
        this.windowWidth = windowWidth;
        this.windowHeight = windowHeight;
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

public class GUIText : GUIElement {

    //! Now with more words!
    private string text;
    private bool shadowed;
    private int fontSize;
    private Vector2 textSize;
    float spacing;
    Color color;

    this(Anchor anchor, int offsetX, int offsetY, string text, int fontSize, Color color, bool shadowed) {
        this.text = text;
        this.elementType = ElementType.TEXT;
        this.anchor = anchor;
        this.fontSize = fontSize;
        this.offset = Vector2(offsetX, offsetY);
        this.spacing = fontSize/GetFontDefault().baseSize;
        this.textSize = MeasureTextEx(GetFontDefault(),toStringz(text), fontSize, spacing);
        this.color = color;
        this.shadowed = shadowed;
    }

    string getText() {
        return text;
    }

    void setText(string text) {
        this.text = text;
        this.spacing = fontSize/GetFontDefault().baseSize;
        this.textSize = MeasureTextEx(GetFontDefault(),toStringz(text), fontSize, spacing);
    }

    int getFontSize() {
        return fontSize;
    }

    void setFontSize(int fontSize) {
        this.fontSize = fontSize;
        this.spacing = fontSize/GetFontDefault().baseSize;
        this.textSize = MeasureTextEx(GetFontDefault(),toStringz(text), fontSize, spacing);
    }

    override
    void render() {            

        float positionRenderX = ((anchor.x * windowWidth)  - (anchor.x * textSize.x)) + offset.x;
        float positionRenderY = ((anchor.y * windowHeight) - (anchor.y * textSize.y)) + offset.y;
    
        if (shadowed) {
            DrawText(
                toStringz(text),
                cast(int)positionRenderX + 2,
                cast(int)positionRenderY + 2,
                fontSize,
                Color(0,0,0,255)
            );
        }

        DrawText(
            toStringz(text),
            cast(int)positionRenderX,
            cast(int)positionRenderY,
            fontSize,
            color
        );
    }
}

/*
 * This is designed for single line only! No carriage returns!
 */
public class GUITextAnimated : GUIText {

    //* If you need more memory, voilà​​ 
    bool[] boolMemory;
    int[] intMemory;
    float[] floatMemory;
    //* If you don't need much, here you are
    bool singularBoolMemory;
    int singularIntMemory;
    float singularFloatMemory = 0.0;
    //* The offsets you are modifying with the animation. These are the side effects you put your data into.
    Vector2[] offsetMemory;

    void delegate(GUITextAnimated, float) func;

    this(Anchor anchor, int offsetX, int offsetY, string text, int fontSize, Color color, bool shadowed, void delegate(GUITextAnimated) initialFunc, void delegate(GUITextAnimated, float) func) {
        super(anchor, offsetX, offsetY, text, fontSize, color, shadowed);
        this.func = func;
        offsetMemory = new Vector2[text.length];
        initialFunc(this);
    }
    
    override
    void setText(string text) {
        this.text = text;
        this.spacing = fontSize/GetFontDefault().baseSize;
        this.textSize = MeasureTextEx(GetFontDefault(),toStringz(text), fontSize, spacing);
        offsetMemory = new Vector2[text.length];
    }

    override
    void update(int windowWidth, int windowHeight, float delta) {
        this.windowWidth = windowWidth;
        this.windowHeight = windowHeight;
        this.func(this, delta);
    }

    override
    void render() {

        float positionRenderX = ((anchor.x * windowWidth)  - (anchor.x * textSize.x)) + offset.x;
        float positionRenderY = ((anchor.y * windowHeight) - (anchor.y * textSize.y)) + offset.y;

        int i = 0;
        foreach (character; text) {
            //! Weird reconversion due to C unsafely shoveling in pointers, can't iterate by index either
            immutable(char)* letter = toStringz(to!string(character));

            // Do this in relative position, invert it
            Vector2 position = Vector2(
                positionRenderX + offsetMemory[i].x,
                positionRenderY - offsetMemory[i].y
            );

            if (shadowed) {
                DrawTextEx(
                    GetFontDefault(),
                    letter,
                    Vector2(position.x + 2, position.y + 2),
                    fontSize,
                    spacing,
                    Colors.BLACK
                );    
            }

            DrawTextEx(
                GetFontDefault(),
                letter,
                position,
                fontSize,
                spacing,
                color
            );

            //! This was a nightmare to reverse engineer
            int bytes;
            char thisChar = text[i];
            int codepoint = GetCodepoint(&thisChar, &bytes);
            int glyphIndex = GetGlyphIndex(GetFontDefault(), codepoint);
            float rightShifter = GetFontDefault().recs[glyphIndex].width * spacing + spacing;

            positionRenderX += rightShifter;
            i++;
        }
    }
}

public class GUIInput : GUIElement{
    string inputText;
    int width;

    this() {
        
    }
}


public class GUIImage : GUIElement {

    private Texture texture;

    float width;
    float height;
    float scale;

    this(Anchor anchor, int offsetX, int offsetY, Texture texture, float scale) {
        this.elementType = ElementType.IMAGE;
        this.anchor = anchor;
        this.offset = Vector2(offsetX, offsetY);
        this.texture = texture;
        this.scale = scale;
        width = texture.width;
        height = texture.height;
    }

    override
    void render() {

        float positionRenderX = ((anchor.x * windowWidth)  - (anchor.x * width * scale)) + offset.x;
        float positionRenderY = ((anchor.y * windowHeight) - (anchor.y * height * scale)) + offset.y;
        
        DrawTextureEx(texture, Vector2(positionRenderX, positionRenderY), 0, scale, Colors.WHITE);            
    }

}