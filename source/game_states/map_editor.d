module game_states.map_editor;

import std.stdio;
import game_states.game_state;
import game;
import raylib;
import world;
import std.math: floor, ceil;


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

    Texture atlas;

    bool showAtlasSelection = true;

    int atlasLimit = 37 * 28;

    int atlasSelection = 0;
    
    this(Game game) {
        super(game);
        this.world = new World(50, 50);
        atlas = cache.get("atlas").get();
    }
    
    override
    void start() {
        camera.setClearColor(0,0,0,0);
    }    


    override
    void update() {

        if (keyboard.isPressed("tab")) {
            showAtlasSelection = !showAtlasSelection;
        }

        if (showAtlasSelection) {
            atlasSelection -= cast(int)floor(mouse.getScrollDelta());
            if (atlasSelection < 0) {
                atlasSelection = atlasLimit - 1;
            } else if (atlasSelection >= atlasLimit) {
                atlasSelection = 0;
            }
        } else {
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
    }

    override
    void render() {
        BeginDrawing();
        BeginMode2D(camera.get());
        {
            camera.clear();

            if (!showAtlasSelection) {
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
        }
        EndMode2D();

        if (showAtlasSelection) {

            Vector2 windowSize = window.getSize();

            
            float scaler;
            float scalerX = cast(float)windowSize.x / cast(float)atlas.width;
            float scalerY = cast(float)windowSize.y / cast(float)atlas.height;

            if (scalerX > scalerY) {
                scaler = scalerY;
            } else {
                scaler = scalerX;
            }

            {
                Rectangle source = Rectangle(
                    0,
                    0,
                    atlas.width,
                    atlas.height
                );
                
                Rectangle goal = Rectangle(
                    0,
                    0,
                    atlas.width * scaler,
                    atlas.height * scaler,
                );

                DrawTexturePro(atlas, source, goal, Vector2(0,0), 0, Colors.WHITE);
            }
            {
                int tileX = atlasSelection % 37;
                int tileY = (atlasSelection / 37);
                int baseX = tileX == 0 ? 1 : cast(int)ceil(((tileX * 16.0) + tileX) * scaler);
                int baseY = tileY == 0 ? 1 : cast(int)ceil(((tileY * 16.0) + tileY) * scaler);



                // writeln(atlasSelection);
                // int baseY = tileY == 0 ? 0 : (tileY * 16) + tileY;

                DrawRectangleLines(baseX, baseY, cast(int)floor(16 * scaler), cast(int)floor(16 * scaler), Color(57, 255, 20, 255));
            }


            // DrawText("TILE SELECTION", 4,2, 38, Colors.BLACK);
            // DrawText("TILE SELECTION", 2,0, 38, Color(57, 255, 20, 255));
        } else {
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