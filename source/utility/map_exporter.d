module utility.map_exporter;

import game_states.map_editor;
import world;
import std.stdio;

// This makes -1 sense but everything is an object!
public class MapExporter {

    MapEditor editor;

    this(MapEditor editor) {
        this.editor = editor;
    }

    void flushToDisk() {
        writeln(editor.world.map);
    }
}