module utility.gui;

import raylib;
import std.stdio;
import window;
import std.string: toStringz;
import std.conv: to;
import mouse;
import keyboard;
import std.ascii: toUpper;
import std.traits: EnumMembers;

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
    INPUT,         //! DONE
    BUTTON,
    IMAGE,
    DROP_MENU,
    // Windows are going to be real fun to debug
    WINDOW
}

// Memory is cheap, predefine everything
static immutable enum KeyIndexes {
    //! Alphabetic
    a             = ["a", "A"],
    b             = ["b", "B"],
    c             = ["c", "C"],
    d             = ["d", "D"],
    e             = ["e", "E"],
    f             = ["f", "F"],
    g             = ["g", "G"],
    h             = ["h", "H"],
    i             = ["i", "I"],
    j             = ["j", "J"],
    k             = ["k", "K"],
    l             = ["l", "L"],
    m             = ["m", "M"],
    n             = ["n", "N"],
    o             = ["o", "O"],
    p             = ["p", "P"],
    q             = ["q", "Q"],
    r             = ["r", "R"],
    s             = ["s", "S"],
    t             = ["t", "T"],
    u             = ["u", "U"],
    v             = ["v", "V"],
    w             = ["w", "W"],
    x             = ["x", "X"],
    y             = ["y", "Y"],
    z             = ["z", "Z"],
    //! Numeric
    zero          = ["0", ")"],
    one           = ["1", "!"],
    two           = ["2", "@"],
    three         = ["3", "#"],
    four          = ["4", "$"],
    five          = ["5", "%"],
    six           = ["6", "^"],
    seven         = ["7", "&"],
    eight         = ["8", "*"],
    nine          = ["9", "("],
    //! Symbolic
    apostrophe    = ["'",  "\""], // Key: '
    comma         = [",",  "<" ], // Key: ,
    minus         = ["-",  "_" ], // Key: -
    period        = [".",  ">" ], // Key: .
    slash         = ["/",  "?" ], // Key: /
    semicolon     = [";",  ":" ], // Key: ;
    equal         = ["=",  "+" ], // Key: =
    left_bracket  = ["[",  "{" ], // Key: [
    backslash     = ["\\", "|" ], // Key: '\'
    right_bracket = ["]",  "}" ], // Key: ]
    grave         = ["`",  "~" ], // Key: `

    //! Space - The final frontier
    space        = [" ", " "],
}

//! I've never made a generic GUI before so this might be a disaster
public class GUI {

    Mouse mouse;
    Keyboard keyboard;
    
    int windowWidth;
    int windowHeight;
    int windowOffsetX;
    int windowOffsetY;

    Window window;

    // todo: layers?
    GUIText[string] textElements;
    GUIImage[string] imageElements;
    GUIInput[string] textInputElements;
    GUIButton[string] buttonElements;

    this(Window window, Mouse mouse, Keyboard keyboard) {
        this.window   = window;
        this.mouse    = mouse;
        this.keyboard = keyboard;
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
    void addTextElement(string ID, Anchor anchor, string text, int offsetX, int offsetY, int fontSize, Color color, bool shadowed) {
        this.textElements[ID] = new GUIText(anchor, offsetX,offsetY, text, fontSize, color, shadowed);
    }
    void removeTextElement(string ID) {
        this.textElements.remove(ID);
    }
    GUIText getTextElement(string ID) {
        if (ID in textElements) {
            return this.textElements[ID];
        }
        return null;
    }

    //! Text Input Element
    void addTextInputElement(string ID, string initialText, string textPlaceHolder, Anchor anchor, int offsetX, int offsetY, int textLimit, int inputBoxWidth, int fontSize, int padding, Color fontColor, Color textPlaceHolderColor, Color backgroundColor, Color borderColor, void delegate(GUIInput) enterAction = null) {
        this.textInputElements[ID] = new GUIInput(initialText, textPlaceHolder, anchor, offsetX, offsetY, textLimit, inputBoxWidth, fontSize, padding, fontColor, textPlaceHolderColor, backgroundColor, borderColor, enterAction);
    }
    void removeTextInputElement(string ID) {
        this.textInputElements.remove(ID);
    }
    GUIInput getTextInputElement(string ID) {
        if (ID in textInputElements) {
            return this.textInputElements[ID];
        }
        return null;
    }
    
    //! Animated Text Elements    
    void addAnimatedTextElement(string ID, Anchor anchor, string text, int offsetX, int offsetY, int fontSize, Color color, bool shadowed, void delegate(GUITextAnimated) initialFunc, void delegate(GUITextAnimated, float) func) {
        this.textElements[ID] = new GUITextAnimated(anchor, offsetX,offsetY, text, fontSize, color, shadowed, initialFunc, func);
    }
    void removeAnimatedTextElement(string ID) {
        this.textElements.remove(ID);
    }
    GUIText getAnimatedTextElement(string ID) {
        if (ID in textElements) {
            return this.textElements[ID];
        }
        return null;
    }

    //! Button Elements
    void addButtonElement(string ID, Anchor anchor, int offsetX, int offsetY, string text, int fontSize, Color color, bool shadowed, void delegate() clickProcedure = null) {
        this.buttonElements[ID] = new GUIButton(anchor, offsetX, offsetY, text, fontSize, color, shadowed, clickProcedure);
    }
    void removeButtonElement(string ID) {
        this.buttonElements.remove(ID);
    }
    GUIButton getButtonElement(string ID) {
        if (ID in buttonElements) {
            return this.buttonElements[ID];
        }
        return null;
    }

    //! Image Elements
    void addImageElement(string ID, Anchor anchor, int offsetX, int offsetY, Texture texture, float scale) {
        this.imageElements[ID] = new GUIImage(anchor, offsetX,offsetY, texture, scale);
    }
    void removeImageElement(string ID) {
        this.imageElements.remove(ID);
    }
    GUIImage getImageElement(string ID) {
        if (ID in imageElements) {
            return this.imageElements[ID];
        }
        return null;
    }
    

    void render(float delta) {

        Vector2 wSize = window.getSize();
        windowWidth = cast(int)wSize.x;
        windowHeight = cast(int)wSize.y;

        foreach (element; textElements) {
            if (element.isVisible()) {
                element.update(windowWidth, windowHeight, delta, mouse, keyboard);
                element.render();
            }
        }

        foreach (element; imageElements) {
            if (element.isVisible()) {
                element.update(windowWidth, windowHeight, delta, mouse, keyboard);
                element.render();
            }
        }

        foreach (element; textInputElements) {
            if (element.isVisible()) {
                element.update(windowWidth, windowHeight, delta, mouse, keyboard);
                element.render();
            }
        }

        foreach (element; buttonElements) {
            if (element.isVisible()) {
                element.update(windowWidth, windowHeight, delta, mouse, keyboard);
                element.render();
            }
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

    void update(int windowWidth, int windowHeight, float delta, Mouse mouse, Keyboard keyboard) {
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
    void update(int windowWidth, int windowHeight, float delta, Mouse mouse, Keyboard keyboard) {
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

public class GUIInput : GUIText {

    immutable string textPlaceHolder;
    int textLimit = 10;
    int inputBoxWidth;
    float height;
    bool focused;
    Color textPlaceHolderColor;
    Color backgroundColor;
    Color borderColor;    
    bool cursor;
    float cursorTimer = 0;
    int padding;

    float deleteHoldTimer = 0;
    bool deleteHold = false;

    void delegate(GUIInput) enterAction;

    this(string initialText, string textPlaceHolder, Anchor anchor, int offsetX, int offsetY, int textLimit, int inputBoxWidth, int fontSize, int padding, Color fontColor, Color textPlaceHolderColor, Color backgroundColor, Color borderColor, void delegate(GUIInput) enterAction) {
        super(anchor, offsetX, offsetY, initialText, fontSize, fontColor, false);
        this.textPlaceHolder = textPlaceHolder;
        this.textLimit = textLimit;
        this.inputBoxWidth = inputBoxWidth + padding;        
        this.textPlaceHolderColor = textPlaceHolderColor;
        this.backgroundColor = backgroundColor;
        this.borderColor = borderColor;
        this.padding = padding;
        this.height = measureBoxHeightPadded();
        this.enterAction = enterAction;
    }

    override
    void setText(string text) {
        this.text = text;
        this.spacing = fontSize/GetFontDefault().baseSize;
        string temp = text ~ "_";
        this.textSize = MeasureTextEx(GetFontDefault(),toStringz(temp), fontSize, spacing);
        
    }

    private float measureBoxHeightPadded() {
        return Vector2Add(MeasureTextEx(GetFontDefault(), toStringz("abgcefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"), fontSize, fontSize / GetFontDefault().baseSize), Vector2(padding, padding)).y;
    }

    override
    void setFontSize(int fontSize) {
        this.fontSize = fontSize;
        this.spacing = fontSize/GetFontDefault().baseSize;
        string temp = text ~ "_";
        this.textSize = MeasureTextEx(GetFontDefault(),toStringz(temp), fontSize, spacing);
        this.height = measureBoxHeightPadded();        
    }

    override
    void update(int windowWidth, int windowHeight, float delta, Mouse mouse, Keyboard keyboard) {
        this.windowWidth = windowWidth;
        this.windowHeight = windowHeight;

        if (focused) {
            cursorTimer += delta;
            if (cursorTimer > 0.3) {
                cursor = !cursor;
                cursorTimer = 0;
            }

            if (text.length < textLimit) {
                static foreach (key; EnumMembers!KeyIndexes) {
                    if (keyboard[to!string(key) ~ "_pressed"]) {
                        setText(text ~= (keyboard.left_shift_down || keyboard.right_shift_down) ? key[1] : key[0]);
                    }
                }
            }

            // Simulate repeat key - Tapping delete to delete a bunch of chars is annoying
            if (keyboard.backspace_down && text.length > 0) {
                // Poll single press or holding
                if (!deleteHold) {
                    if (deleteHoldTimer > 0) {
                        deleteHoldTimer += delta;
                        if (deleteHoldTimer >= 0.5) {
                            deleteHold = true;
                            deleteHoldTimer = 0;
                        }
                    } else if (!deleteHold && deleteHoldTimer == 0) {
                        text.length -= 1;
                        setText(text);
                        deleteHoldTimer += delta;
                    }
                // Begin the deletion repeat
                } else {
                    deleteHoldTimer += delta;
                    if (deleteHoldTimer >= 0.1) {
                        text.length -= 1;
                        setText(text);
                        deleteHoldTimer = 0;
                    }
                }
            // Reset if not pressed
            } else if (!keyboard.backspace_down) {
                deleteHoldTimer = 0;
                deleteHold = false;
            }

            if (keyboard.enter_pressed && enterAction !is null) {
                enterAction(this);
            }
        }

        if (mouse.leftButtonPressed()) {
            // Poll mouse position
            Vector2 mousePos = mouse.getPosition();
            if (CheckCollisionPointRec(
                mousePos,
                Rectangle(
                    cast(int)(((anchor.x * windowWidth)  - (anchor.x * inputBoxWidth)) + offset.x),
                    cast(int)(((anchor.y * windowHeight) - (anchor.y * height)) + offset.y),
                    inputBoxWidth,
                    cast(int)height
                )
            )) {
                focused = true;
                
            } else {
                focused = false;
            }
        }
        
    }

    override
    void render() {

        float positionRenderX = ((anchor.x * windowWidth)  - (anchor.x * inputBoxWidth)) + offset.x;
        float positionRenderY = ((anchor.y * windowHeight) - (anchor.y * height)) + offset.y;

        BeginScissorMode(cast(int)positionRenderX, cast(int)positionRenderY, inputBoxWidth, cast(int)height);

        DrawRectangle(cast(int)positionRenderX, cast(int)positionRenderY, inputBoxWidth, cast(int)height, backgroundColor);
        DrawRectangleLines(cast(int)positionRenderX, cast(int)positionRenderY, inputBoxWidth, cast(int)height, borderColor);

        if (text == "" && !focused) {
            // cursor blink goes here
            // positionRenderX = ((anchor.x * windowWidth)  - (anchor.x * textPlaceHolderSize.x)) + offset.x;
            positionRenderY = ((anchor.y * windowHeight) - (anchor.y * textSize.y)) + offset.y;
            DrawText(
                toStringz(textPlaceHolder),
                cast(int)positionRenderX + padding,
                cast(int)positionRenderY,
                fontSize,
                textPlaceHolderColor
            );
        } else {
            // positionRenderX = ((anchor.x * windowWidth)  - (anchor.x * textSize.x)) + offset.x;
            if (textSize.x + padding > inputBoxWidth) {
                positionRenderX -= textSize.x - inputBoxWidth + padding;
            }
            positionRenderY = ((anchor.y * windowHeight) - (anchor.y * textSize.y)) + offset.y;
            // By some insane coincidence 0 and 1 match up to the chars of " " and "_"
            DrawText(
                toStringz(text ~ (focused && cursor)),
                cast(int)positionRenderX + padding,
                cast(int)positionRenderY,
                fontSize,
                color
            );
        }

        EndScissorMode();
    }

    
}

/*
 * Inherit from text because buttons need words.
 */
public class GUIButton : GUIText {
    Texture texture;
    void delegate() clickProcedure;

    this(Anchor anchor, int offsetX, int offsetY, string text, int fontSize, Color color, bool shadowed, void delegate() clickProcedure = null) {
        super(anchor, offsetX, offsetY, text, fontSize, color, shadowed);
        this.clickProcedure = clickProcedure;
    }

    override
    void render() {
        writeln("I am a button, amazing");
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