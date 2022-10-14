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
    1 - add/remove
    */
    int mode = 1;

    World world;

    int selectionPositionX = -1;
    int selectionPositionY = -1;

    Texture atlas;

    bool atlasBrowserMode = true;

    int atlasLimit = 37 * 28;

    int atlasSelectionX = 0;
    int atlasSelectionY = 0;

    int selectedTileX = 0;
    int selectedTileY = 0;
    
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
            atlasBrowserMode = !atlasBrowserMode;
        }

        if (atlasBrowserMode) {

                Vector2 mousePosition = mouse.getPosition();

                Vector2 windowSize = window.getSize();

                
                float scaler;
                float scalerX = cast(float)windowSize.x / cast(float)atlas.width;
                float scalerY = cast(float)windowSize.y / cast(float)atlas.height;

                if (scalerX > scalerY) {
                    scaler = scalerY;
                } else {
                    scaler = scalerX;
                }

                // This is imprecise, but we only care about generalities in the selection (1 pixel extra because border)
                atlasSelectionX =  cast(int)floor(mousePosition.x / (17 * scaler));
                atlasSelectionY =  cast(int)floor(mousePosition.y / (17 * scaler));                

                if (atlasSelectionX >= 37 || atlasSelectionY >= 28 || atlasSelectionX < 0 || atlasSelectionY < 0) {
                    atlasSelectionX = 0;
                    atlasSelectionY = 0;
                }

                if (mouse.leftButtonPressed()) {
                    selectedTileX = atlasSelectionX;
                    selectedTileY = atlasSelectionY;
                }
            


        } else {
            if (keyboard.isDown("left_shift")) {
                mode = 0;
            } else {
                mode = 1;
            }

            if (mode == 0) {
                if (mouse.leftButtonDown()) {
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
                    } else {
                        if (mouse.leftButtonPressed()) {
                            writeln("place it at: ", selectionPositionX, selectionPositionY);
                        }
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

            if (!atlasBrowserMode) {
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

        if (atlasBrowserMode) {

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
                int baseXSelection = selectedTileX == 0 ? 1 : cast(int)ceil(((selectedTileX * 16.0) + selectedTileX) * scaler);
                int baseYSelection = selectedTileY == 0 ? 1 : cast(int)ceil(((selectedTileY * 16.0) + selectedTileY) * scaler);

                DrawRectangleLines(baseXSelection, baseYSelection, cast(int)floor(16 * scaler), cast(int)floor(16 * scaler), Color(255, 0, 0, 255));

                int baseXHover = atlasSelectionX == 0 ? 1 : cast(int)ceil(((atlasSelectionX * 16.0) + atlasSelectionX) * scaler);
                int baseYHover = atlasSelectionY == 0 ? 1 : cast(int)ceil(((atlasSelectionY * 16.0) + atlasSelectionY) * scaler);

                DrawRectangleLines(baseXHover, baseYHover, cast(int)floor(16 * scaler), cast(int)floor(16 * scaler), Color(57, 255, 20, 255));
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
                    DrawText("MODE: EDITING", 4,2, 38, Colors.BLACK);
                    DrawText("MODE: EDITING", 2,0, 38, Color(57, 255, 20, 255));
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