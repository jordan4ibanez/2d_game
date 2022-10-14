module game_states.map_editor;

import std.stdio;
import game_states.game_state;
import game;
import raylib;
import world;


public class MapEditor : GameState {

    int size = 10;
    bool up = true;

    /*
    modes:
    0 - move
    1 - add
    2 - remove
    */
    int mode = 0;

    World world;
    
    this(Game game) {
        super(game);
        this.world = new World(50, 50);
    }
    
    override
    void start() {
        camera.setClearColor(0,0,0,0);

    }


    override
    void update() {

        float scrollDelta = mouse.getScrollDelta();
        float zoom = camera.getZoom();
        camera.setZoom(zoom + (scrollDelta / 10));

        if (mouse.leftButton) {
            Vector2 mouseDelta = mouse.getDelta();
            camera.addOffset(mouseDelta);
        }
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

            foreach (x; 0..world.map.width) {
                foreach (y; 0..world.map.height) {
                    if (world.map.get(x,y) is null) {
                        DrawRectangleLines(x * 16, y * 16, 16, 16, Colors.BLACK);
                    }
                    // world.drawTile(x,y,x,y,1);
                }
            }
        }
        EndMode2D();

        final switch (mode) {
            case 0: {
                DrawText("MODE: MOVE", 4,2, 38, Colors.BLACK);
                DrawText("MODE: MOVE", 2,0, 38, Color(57, 255, 20, 255));
                break;
            }
            case 1: {
                DrawText("MODE: PLACE", 4,2, 38, Colors.BLACK);
                DrawText("MODE: PLACE", 2,0, 38, Color(57, 255, 20, 255));
                break;
            }

            case 2: {
                DrawText("MODE: REMOVE", 4,2, 38, Colors.BLACK);
                DrawText("MODE: REMOVE", 2,0, 38, Color(57, 255, 20, 255));
                break;
            }

        }
        EndDrawing();
    }

    override
    void reset() {
        
    }

    override
    void cleanUp() {
        
    }
}