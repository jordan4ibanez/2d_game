module keyboard;

import raylib;
import std.stdio: writeln;
import std.uni: toLower;
import std.conv: to;
import std.traits: EnumMembers;
import std.string;
import std.typecons: tuple, Tuple;

// Thanks for the help Schveiguy!
public class Keyboard {

    Tuple!(int, "key", bool, "type") decompile(string input) {

        long breaker = input.lastIndexOf("_");
        string key = input[0..breaker];
        string command = input[breaker+1..input.length];
        
        static foreach (thisKey; EnumMembers!KeyboardKey) {
            if (to!string(thisKey)[4..$].toLower == key) {
                return tuple!("key", "type")(cast(int)thisKey, command == "pressed" ? false : true);
            }
        }
        throw new Exception(key ~ " is not a keyboard key!");
    }

    bool interpret(string name) {
        auto input = decompile(name);
        final switch(input.type) {
            case false: return IsKeyPressed(input.key);
            case true: return IsKeyDown(input.key);
        }
        
    }

    @property
    bool opIndex()(string name) {
        return interpret(name);
    }

    @property
    bool opDispatch(string name)() {
        return interpret(name);
    }
    
}