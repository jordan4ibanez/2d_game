module map_editor;

import std.stdio;
import game_state;
import game;
import raylib;


public class MapEditor : GameState {

    int size = 10;
    bool up = true;

    float zoom = 6;

    this(Game game) {
        super(game);
    }
    
    override
    void start() {

    }

    override
    void update() {
        game.timeKeeper.calculateDelta();
    }

    override
    void render() {
        BeginDrawing();
        BeginMode2D(game.camera.get());
        {

            float delta = game.timeKeeper.getDelta();

            game.camera.clear();

            if (up) {
                zoom += delta;
                up = zoom < 5 ? true : false;
            } else {
                zoom -= delta;
                up = zoom > 1 ? false : true;
            }

            writeln(zoom);

            game.camera.setZoom(zoom);


            foreach (x; 0..37) {
                foreach (y; 0..28) {
                    game.world.drawTile(x,y,x,y,1);
                }
            }
        }
        EndMode2D();
        EndDrawing();
    }

    override
    void reset() {
        
    }

    override
    void cleanUp() {
        
    }
}