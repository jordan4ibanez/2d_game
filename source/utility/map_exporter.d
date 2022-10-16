module utility.map_exporter;

import game_states.map_editor;
import world;
import std.stdio;
import std.conv: to;
import std.json;
import std.variant;
import std.file;
import std.zlib;

// This makes -1 sense but everything is an object!
public class MapExporter {

    MapEditor editor;

    this(MapEditor editor) {
        this.editor = editor;
    }

    void flushToDisk(string mapName) {

        JSONValue mapJson = ["GameMap" : true];
        mapJson.object["width"] = JSONValue(editor.world.width);
        mapJson.object["height"] = JSONValue(editor.world.height);

        foreach (layer; 0..2){
            foreach (x; 0..editor.world.map[layer].width) {
                foreach (y; 0..editor.world.map[layer].height) {
                    MapTile thisTile = editor.world.map[layer].get(x,y);
                    if (thisTile is null) {
                        mapJson.object[to!string(layer) ~ " " ~ to!string(x) ~ " " ~ to!string(y)] = JSONValue(null);
                    } else {
                        mapJson.object[to!string(layer) ~ " " ~ to!string(x) ~ " " ~ to!string(y)] = JSONValue(thisTile);
                    }                
                }
            }
        }

        writeToDisk(mapName, mapJson.toString());
    }

    void writeToDisk(string mapName, string data) {
        if (!std.file.exists("maps")) {
            mkdir("maps");
        }
        ubyte[] compressed = compress(data);
        std.file.write("maps/" ~ mapName ~ ".map", compressed);
    }

    bool loadMap(string mapName) {
        // Nothing to load
        if (!std.file.exists("maps")) {
            return false;
        }
        if (!std.file.exists("maps/" ~ mapName ~ ".map")) {
            return false;
        }
        void[] compressed = std.file.read("maps/" ~ mapName ~ ".map");
        string decompressed = cast(string)uncompress(compressed);

        JSONValue mapJson = parseJSON(decompressed);

        // !This is handled fast and loose because if someone manually edits the file, somehow, that's their problem
        int width = cast(int)mapJson.object["width"].integer();
        int height = cast(int)mapJson.object["height"].integer();

        World world = new World(width, height);

        foreach (layer; 0..2) {            
            foreach (x; 0..width) {
                foreach (y; 0..height) {
                    JSONValue blah =  mapJson.object[to!string(layer) ~ " " ~ to!string(x) ~ " " ~ to!string(y)];

                    if (blah.type() != JSONType.null_) {

                        JSONValue[string] thisTile = blah.object;

                        int tileX = cast(int)thisTile["x"].integer();
                        int tileY = cast(int)thisTile["y"].integer();

                        world.map[layer].set(x,y,tileX,tileY);
                    }
                }
            }
        }

        editor.world = world;

        return true;
    }
}