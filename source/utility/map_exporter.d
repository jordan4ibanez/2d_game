module utility.map_exporter;

import game_states.map_editor;
import world;
import std.stdio;
import std.conv: to;
import std.json;
import std.variant;

// This makes -1 sense but everything is an object!
public class MapExporter {

    MapEditor editor;

    this(MapEditor editor) {
        this.editor = editor;
    }

    void flushToDisk() {

        string[string] data;

        JSONValue mapJson = ["GameMap" : true];
        mapJson.object["width"] = JSONValue(editor.world.width);
        mapJson.object["height"] = JSONValue(editor.world.height);

        foreach (x; 0..editor.world.map[0].width) {
            foreach (y; 0..editor.world.map[0].height) {
                MapTile thisTile = editor.world.map[0].get(x,y);
                if (thisTile is null) {
                    mapJson.object[to!string(x) ~ " " ~ to!string(y)] = JSONValue(null);
                } else {
                    mapJson.object[to!string(x) ~ " " ~ to!string(y)] = JSONValue(thisTile);
                }                
            }
        }
        
    }
}