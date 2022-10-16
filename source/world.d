module world;

import game;
import std.stdio;
import raylib;
import std.conv: to;
import std.json;

/// World is what the game takes place in
public class World {

    // background, foreground
    Map[2] map;

    Texture atlas;

    immutable int width;
    immutable int height;

    this(int width, int height) {
        this.width = width;
        this.height = height;
        map[0] = new Map(width, height);
        map[1] = new Map(width, height);
    }

    void cleanUp() {
        map = null;
    }

    void uploadAtlas(Texture atlas) {
        this.atlas = atlas;
    }
}

/// The world has a map
public class Map {

    MapTile[] tiles;
    
    int width;
    int height;

    this(int width, int height) {
        this.width = width;
        this.height = height;
        this.tiles = new MapTile[width*height];
    }

    final
    MapTile get(int posX, int posY) {
        rangeCheck(posX, posY);
        return tiles[(posX * this.width) + posY];
    }

    final
    void set(int posX, int posY, int tileX, int tileY) {
        rangeCheck(posX, posY);
        // Let the GC go at it, this isn't a high performance section
        tiles[(posX * this.width) + posY] = new MapTile(tileX, tileY);
    }

    final remove(int posX, int posY) {
        tiles[(posX * this.width) + posY] = null;
    }

    final
    void rangeCheck(int x, int y) {
        if (x < 0 || x >= this.width) {
            throw new Exception("X getter is out of bounds for map!");
        }
        if (y < 0 || y >= this.height) {
            throw new Exception("Y getter is out of bounds for map!");
        }
    }

}


/// The map has map tiles
public class MapTile {

    int x;
    int y;

    this(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public JSONValue asJSON() const @system {
        JSONValue returningValue = ["MapTile" : true, "x" : x, "y" : y];
        return returningValue;
    }
    alias asJSON this;

    bool equals(MapTile other) {
        return this.x == other.x && this.y == other.y;
    }
}
