module utility.gui;

import raylib;

//! I've never made a generic GUI before so this might be a disaster
public class GUI {


    //! Literally no idea what to put here
    static enum Type {
        TEXT,
        INPUT,
        BUTTON,
        ANIMATED,
        DROP_MENU
    }

    float scale;
    
    GUI[string] nodes;


}