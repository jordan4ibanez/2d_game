module keyboard;

import raylib;
import std.stdio: writeln;
import std.uni: toLower;
import std.string: strip;
import std.conv: to;
import std.array: replace;
import std.variant: Variant;

alias Key = KeyboardKey;

public class Keyboard {

    @property 
    private int[string] keys;

    @property 
    private Variant[string] values;

    alias values this;

    this() {
        // string interface becomes left_control, left_shift, etc
        Key[] newKeys = [
            Key.KEY_LEFT_CONTROL,
            Key.KEY_LEFT_SHIFT,
            Key.KEY_TAB,
            Key.KEY_F5,
            Key.KEY_GRAVE, // Squiggly boi "~"
            Key.KEY_EQUAL,
            Key.KEY_MINUS
        ];
        insertKeys(newKeys);
    }

    private
    void insertKeys(KeyboardKey[] newKeys) {
        foreach (thisKey; newKeys) {
            string stringKey = to!string(thisKey).toLower.replace("key_", "");
            this.keys[stringKey] = thisKey;
            this[stringKey ~ "_down"] = false;
            this[stringKey ~ "_pressed"] = false;
        }
    }

    @property
    Variant opDispatch(string name)() {
        return values[name];
    }

    @property
    void opDispatch(string name, T)(T value) {
        values[name] = value;
    }

    void update() {
        // duplicate keys, can parse one for both iterators (press/down)
        foreach (key, value; keys){
            this[key ~ "_down"] = IsKeyDown(value);
            this[key ~ "_pressed"] = IsKeyPressed(value);
        }
    }
}