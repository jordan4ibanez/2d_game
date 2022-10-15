module keyboard;

import raylib;
import std.stdio;
import std.uni: toLower;
import std.string: strip;
import std.conv: to;

alias Key = KeyboardKey;

public class Keyboard {

    private int[string] keys;
    private bool[string] pressed;
    private bool[string] down;

    this() {
        // string interface becomes left_control, left_shift, etc
        Key[] newKeys = [
            Key.KEY_LEFT_CONTROL,
            Key.KEY_LEFT_SHIFT,
            Key.KEY_TAB,
            Key.KEY_F5
        ];
        insertKeys(newKeys);
    }

    private
    void insertKeys(KeyboardKey[] newKeys) {
        foreach (thisKey; newKeys) {
            string stringKey = strip(to!string(thisKey).toLower, "key_");
            keys[stringKey] = thisKey;
            pressed[stringKey] = false;
            down[stringKey] = false;
        }
    }

    void update() {
        // duplicate keys, can parse one for both iterators (press/down)
        foreach (key, value; keys){
            down[key] = IsKeyDown(value);
            pressed[key] = IsKeyPressed(value);
        }
    }

    bool isDown(string keyName) {
        return down[keyName];
    }

    bool isPressed(string keyName) {
        return pressed[keyName];
    }
}