module world;

import game;

/// World is what the game takes place in
public class World {
    Game game;

    Map map;

    this(Game game) {
        this.game = game;

    }

}

/// The world has a map
public class Map {

    MapTile[] map;
    
    long width;
    long height;

    final
    MapTile get(int x, int y) {
        if (x < 0 || x > this.width - 1) {
            throw new Exception("X getter is out of bounds for map!");
        }
        if (y < 0 || y > this.height - 1) {
            throw new Exception("Y getter is out of bounds for map!");
        }
        return map[(x * this.width) + y];
    }

}

/// The map has map tiles
public class MapTile {

}

/// The map tiles have layers
public class Layer {
    
}
