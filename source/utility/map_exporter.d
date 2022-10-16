module utility.map_exporter;

import game_states.map_editor;
import world;
import std.stdio;
import std.conv: to;
import std.json;

// This makes -1 sense but everything is an object!
public class MapExporter {

    MapEditor editor;

    this(MapEditor editor) {
        this.editor = editor;
    }

    void flushToDisk() {

        string[string] data;

        foreach (x; 0..editor.world.map[0].width) {
            foreach (y; 0..editor.world.map[0].height) {
                
            }
        }

        // writeln(blah);

        // JSONValue blah = [ "language": "D" ];
        
    }
}