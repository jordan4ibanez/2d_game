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
    int mode = 1;

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

        if (keyboard.isDown("left_control")) {
            mode = 1;
        } else if (keyboard.isDown("left_shift")) {
            mode = 2;
        } else {
            mode = 0;
        }

        if (mode == 0) {
            if (mouse.leftButton) {
                Vector2 mouseDelta = mouse.getDelta();
                mouseDelta.x /= camera.getZoom();
                mouseDelta.y /= camera.getZoom();

                camera.addOffset(mouseDelta);
            }
        }

        float scrollDelta = mouse.getScrollDelta();
        float zoom = camera.getZoom();
        camera.setZoom(zoom + (scrollDelta / 10));
    }

    override
    void render() {
        BeginDrawing();
        BeginMode2D(camera.get());
        {

            float delta = timeKeeper.getDelta();

            camera.clear();

            foreach (x; 0..world.map.width) {
                foreach (y; 0..world.map.height) {
                    if (world.map.get(x,y) is null) {
                        DrawRectangleLines(x * 16, y * 16, 16, 16, Colors.WHITE);
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