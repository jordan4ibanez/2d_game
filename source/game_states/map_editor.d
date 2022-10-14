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

    int mapSelectPosX = -1;
    int mapSelectPosY = -1;

    Texture atlas;

    bool atlasBrowserMode = true;

    int atlasLimit = 37 * 28;

    int atlasHoverX = 0;
    int atlasHoverY = 0;

    int atlasSelectedTileX = 0;
    int atlasSelectedTileY = 0;
    
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
                atlasHoverX =  cast(int)floor(mousePosition.x / (17 * scaler));
                atlasHoverY =  cast(int)floor(mousePosition.y / (17 * scaler));                

                if (atlasHoverX >= 37 || atlasHoverY >= 28 || atlasHoverX < 0 || atlasHoverY < 0) {
                    atlasHoverX = 0;
                    atlasHoverY = 0;
                }

                if (mouse.leftButtonPressed()) {
                    atlasSelectedTileX = atlasHoverX;
                    atlasSelectedTileY = atlasHoverY;
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
                    mapSelectPosX = cast(int)floor(adjustedPos.x / 16.0);
                    mapSelectPosY = cast(int)floor(adjustedPos.y / 16.0);
                    if (mapSelectPosX >= world.map.width || mapSelectPosY >= world.map.height) {
                        mapSelectPosX = -1;
                        mapSelectPosY = -1;    
                    } else {
                        if (mouse.leftButtonPressed()) {
                            writeln("place it at: ", mapSelectPosX, mapSelectPosY);
                        }
                    }
                } else {
                    mapSelectPosX = -1;
                    mapSelectPosY = -1;
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

                if (mapSelectPosX > -1 && mapSelectPosY > -1) {
                    DrawRectangleLines(mapSelectPosX * 16, mapSelectPosY * 16, 16, 16, Color(57, 255, 20, 255));
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
                int baseXSelection = atlasSelectedTileX == 0 ? 1 : cast(int)ceil(((atlasSelectedTileX * 16.0) + atlasSelectedTileX) * scaler);
                int baseYSelection = atlasSelectedTileY == 0 ? 1 : cast(int)ceil(((atlasSelectedTileY * 16.0) + atlasSelectedTileY) * scaler);

                DrawRectangleLines(baseXSelection, baseYSelection, cast(int)floor(16 * scaler), cast(int)floor(16 * scaler), Color(255, 0, 0, 255));

                int baseXHover = atlasHoverX == 0 ? 1 : cast(int)ceil(((atlasHoverX * 16.0) + atlasHoverX) * scaler);
                int baseYHover = atlasHoverY == 0 ? 1 : cast(int)ceil(((atlasHoverY * 16.0) + atlasHoverY) * scaler);

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