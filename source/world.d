module world;

import game;
import std.stdio;
import raylib;

/// World is what the game takes place in
public class World {

    Map map;

    Texture atlas;

    this(int width, int height) {
        map = new Map(width, height);
    }

    void cleanUp() {
        map = null;
    }

    void uploadAtlas(Texture atlas) {
        this.atlas = atlas;
    }
    /*
    void drawTile(int posX, int posY, int tileX, int tileY, int border) {

        int baseX = tileX == 0 ? 0 : (tileX * 16) + (tileX * border);        
        int baseY = tileY == 0 ? 0 : (tileY * 16) + (tileY * border);

        Rectangle source = Rectangle(
            baseX,
            baseY,
            16,
            16
        );

        Rectangle goal = Rectangle(
            posX * 16,
            posY * 16,
            16,
            16,
        );

        DrawTexturePro(atlas, source, goal, Vector2(0,0), 0, Colors.WHITE);
        // DrawRectangle(cast(int)goal.x, cast(int)goal.y + 16, cast(int)goal.width, cast(int)goal.height, Colors.BLACK);

    } 
    */

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
    MapTile get(int x, int y) {
        if (x < 0 || x >= this.width) {
            throw new Exception("X getter is out of bounds for map!");
        }
        if (y < 0 || y >= this.height) {
            throw new Exception("Y getter is out of bounds for map!");
        }
        return tiles[(x * this.width) + y];
    }

}

/// The map has map tiles
public class MapTile {

}

/// The map tiles have layers
public class Layer {
    
}
