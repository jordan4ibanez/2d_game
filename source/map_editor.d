module map_editor;

import std.stdio;
import game_state;
import game;
import raylib;


public class MapEditor : GameState {

    int size = 10;
    bool up = true;

    this(Game game) {
        super(game);
    }
    
    override
    void start() {

    }

    override
    void update() {

        float scrollDelta = mouse.getScrollDelta();
        float zoom = camera.getZoom();
        camera.setZoom(zoom + (scrollDelta / 10));

        writeln(zoom);

    }

    override
    void render() {
        BeginDrawing();
        BeginMode2D(camera.get());
        {

            float delta = timeKeeper.getDelta();

            camera.clear();

            /*
            if (up) {
                zoom += delta;
                up = zoom < 5 ? true : false;
            } else {
                zoom -= delta;
                up = zoom > 1 ? false : true;
            }
            */


            foreach (x; 0..37) {
                foreach (y; 0..28) {
                    DrawRectangleLines(x * 16, y * 16, 16, 16, Colors.BLACK);
                    // world.drawTile(x,y,x,y,1);
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