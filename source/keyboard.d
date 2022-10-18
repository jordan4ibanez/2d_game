module keyboard;

import raylib;
import std.stdio: writeln;
import std.uni: toLower;
import std.conv: to;
import std.traits: EnumMembers;
import std.string;

// Thanks for the help Schveiguy!
public class Keyboard {

    class MicroKey {
        int key;
        this(int key) {
            this.key = key;
        }
        bool action() {
            return false;
        }
    }
    class MicroKeyPressed : MicroKey{
        this(int key) {
            super(key);
        }
        override
        bool action() {
            return IsKeyPressed(this.key);
        }
    }
    class MicroKeyDown : MicroKey {
        this(int key) {
            super(key);
        }
        override
        bool action() {
            return IsKeyDown(this.key);
        }
    }

    private MicroKey[string] redirects;

    this() {
        // string interface becomes left_control, left_shift, etc
        foreach (thisKey; EnumMembers!KeyboardKey){
            string stringKey = to!string(thisKey).toLower.replace("key_", "");
            this.redirects[stringKey ~ "_pressed"] = new MicroKeyPressed(thisKey);
            this.redirects[stringKey ~ "_down"] = new MicroKeyDown(thisKey);
        }
    }

    @property
    bool opIndex()(string name) {
        return this.redirects[name].action();        
    }


    @property
    bool opDispatch(string name)() {
        return this.redirects[name].action();
    }
    
}