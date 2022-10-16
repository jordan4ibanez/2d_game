module keyboard;

import raylib;
import std.stdio: writeln;
import std.uni: toLower;
import std.conv: to;
import std.array: replace;
import std.traits: EnumMembers;

// Thanks for the help Schveiguy!
public class Keyboard {
     
    private int[string] keys;
    private bool[string] values;

    alias values this;

    this() {
        // string interface becomes left_control, left_shift, etc
        foreach (thisKey; EnumMembers!KeyboardKey){
            string stringKey = to!string(thisKey).toLower.replace("key_", "");
            this.keys[stringKey] = thisKey;
            this[stringKey ~ "_down"] = false;
            this[stringKey ~ "_pressed"] = false;
        }
    }
    @property
    bool opDispatch(string name)() {
        return values[name];
    }

    @property
    void opDispatch(string name)(bool val) {
        values[name] = val;
    }

    void update() {
        // duplicate keys, can parse one for both iterators (press/down)
        foreach (key, value; keys){
            this[key ~ "_down"] = IsKeyDown(value);
            this[key ~ "_pressed"] = IsKeyPressed(value);
        }
    }
}