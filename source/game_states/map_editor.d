module game_states.map_editor;

import std.stdio;
import game_states.game_state;
import game;
import raylib;
import world;
import std.math: floor;


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

    int selectionPositionX = -1;
    int selectionPositionY = -1;
    
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
                float zoom = camera.getZoom();
                mouseDelta.x /= zoom;
                mouseDelta.y /= zoom;

                camera.addOffset(mouseDelta);
            }
        }

        {
            Vector2 mousePos = mouse.getPosition();
            Vector2 center = window.getCenter();
            Vector2 offset = camera.getOffset();

            Vector2 realPos = Vector2Subtract(mousePos, center);

            float zoom = camera.getZoom();

            Vector2 scaledPos = Vector2Divide(realPos, Vector2(zoom, zoom));

            Vector2 adjustedPos = Vector2Subtract(scaledPos, offset);

            writeln(adjustedPos);

            if (adjustedPos.x >= 0 && adjustedPos.y >= 0) {
                selectionPositionX = cast(int)floor(adjustedPos.x / 16.0);
                selectionPositionY = cast(int)floor(adjustedPos.y / 16.0);
                if (selectionPositionX >= world.map.width || selectionPositionY >= world.map.height) {
                    selectionPositionX = -1;
                    selectionPositionY = -1;    
                }
            } else {
                selectionPositionX = -1;
                selectionPositionY = -1;
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

            if (selectionPositionX > -1 && selectionPositionY > -1) {
                DrawRectangleLines(selectionPositionX * 16, selectionPositionY * 16, 16, 16, Color(57, 255, 20, 255));
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