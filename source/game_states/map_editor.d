module game_states.map_editor;

import std.stdio;
import game_states.game_state;
import game;
import raylib;
import world;
import std.math: floor, ceil;
import utility.map_exporter;
import std.algorithm.comparison: clamp;
import std.string: toStringz, capitalize;
import std.array;
import std.conv: to;
import utility.gui;

// TODO: clean this mess up

public class MapEditor : GameState {

    MapExporter exporter;

    Texture atlas;

    World world;

    /*
    modes:
    0 - move
    1 - add/remove
    2 - flood fill
    */

    // GUI fields
    GUI gui;
    int fontSize = 20;

    // Editor fields
    int mode = 1;
    int mapSelectPosX = 0;
    int mapSelectPosY = 0;
    bool layer = 0;
    Vector2 oldEditorOffset = Vector2(0,0);
    float oldEditorZoom;
    string mapName = "tempmap";
    bool namingMode = false;
    static immutable string[] typingInputLetters = [
        "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
    ];
    static immutable string[] typingInputNumbers = [
        "zero","one","two","three","four","five","six","seven","eight","nine"
    ];
    float saveIndicatorTimeout = 0;
    float loadIndicatorTimeout = 0;
    bool loadFailure = false;
    bool guideGrid = true;


    // Atlas browser fields
    immutable int atlasWidth;
    immutable int atlasHeight;
    immutable int atlasLimit;
    int atlasHoverX = 0;
    int atlasHoverY = 0;
    int atlasSelectedTileX = 0;
    int atlasSelectedTileY = 0;
    bool atlasBrowserMode = true;
    Vector2 oldAtlasBrowserOffset = Vector2(0,0);
    float oldAtlasBrowserZoom;


    
    this(Game game) {
        super(game);
        this.world = new World(100, 100);
        atlas = cache.get("atlas").get();
        this.exporter = new MapExporter(this);
        atlasWidth = 37;
        atlasHeight = 28;
        atlasLimit = atlasWidth * atlasHeight;
        oldEditorZoom = camera.getZoom();
        oldAtlasBrowserZoom = camera.getZoom();
        gui = new GUI(window);
    }
    
    override
    void start() {
        camera.setClearColor(0,0,0,0);
        // Let this thing run faster than any monitor on the market
        // !Setting a target FPS lower creates frustrating issues with placing
        SetTargetFPS(500);
    }    
    
    Vector2 getMousePositionOnMap() {
        // Too much math!
        immutable Vector2 mousePos = mouse.getPosition();
        immutable Vector2 center = window.getCenter();
        immutable Vector2 offset = camera.getOffset();
        immutable Vector2 realPos = Vector2Subtract(mousePos, center);
        immutable float zoom = camera.getZoom();
        immutable Vector2 scaledPos = Vector2Divide(realPos, Vector2(zoom, zoom));
        immutable Vector2 adjustedPos = Vector2Subtract(scaledPos, offset);
        return adjustedPos;
    }

    override
    void update() {
        float delta = timeKeeper.getDelta();

        if (saveIndicatorTimeout > 0) {            
            saveIndicatorTimeout -= delta;
            if (saveIndicatorTimeout <= 0) {
                saveIndicatorTimeout = 0;
            }
        }
        if (loadIndicatorTimeout > 0) {
            loadIndicatorTimeout -= delta;
            if (loadIndicatorTimeout <= 0) {
                loadIndicatorTimeout = 0;
            }
        }

        if (keyboard.f1_pressed) {
            namingMode = !namingMode;
        }

        if (keyboard.f2_pressed) {
            if (exporter.loadMap(mapName)) {
                loadIndicatorTimeout = 3;
                loadFailure = false;
            } else {
                loadIndicatorTimeout = 3;
                loadFailure = true;
            }
        }
        
        if (keyboard.f3_pressed) {
            guideGrid = !guideGrid;
        }

        if (keyboard.minus_pressed) {
            fontSize -= 1;
            if (fontSize < 5) {
                fontSize = 5;
            }
        } else if (keyboard.equal_pressed){
            fontSize += 1;
        }

        if (namingMode) {
            mode = 0;
            foreach (letter; typingInputLetters.dup) {
                if (keyboard[letter ~ "_pressed"]) {
                    if (keyboard.left_shift_down || keyboard.right_shift_down) {
                        mapName ~= letter.capitalize;
                    } else {
                        mapName ~= letter;
                    }
                }
            }
            foreach (actual, number; typingInputNumbers) {
                if (keyboard[number ~ "_pressed"]) {
                    mapName ~= to!string(actual);
                }
            }
            if (keyboard.backspace_pressed && mapName.length > 0) {
                mapName.popBack();
            }
            return;
        }

        if (keyboard.tab_pressed) {
            atlasBrowserMode = !atlasBrowserMode;

            final switch(atlasBrowserMode) {
                case true: {
                    camera.setZoom(oldAtlasBrowserZoom);
                    camera.setOffset(oldAtlasBrowserOffset);
                    break;
                }
                case false: {
                    camera.setZoom(oldEditorZoom);
                    camera.setOffset(oldEditorOffset);
                    break;
                }
            }
        } else if (keyboard.f5_pressed) {
            exporter.flushToDisk(mapName);
            saveIndicatorTimeout = 3;
        } else if (keyboard.grave_pressed) {
            layer = !layer;
        }

        // Hold shift to be able to drag the camera around
        if (keyboard.left_shift_down) {
            mode = 0;
        } else if (keyboard.left_control_down) {
            mode = 2;
        } else {
            mode = 1;
        }

        { // !Scope zoom for clarity
            immutable float scrollDelta = mouse.getScrollDelta();
            immutable float zoom = camera.getZoom();
            camera.setZoom(zoom + (scrollDelta / 10));
            final switch(atlasBrowserMode) {
                case true: {
                    oldAtlasBrowserZoom = camera.getZoom();
                    break;
                }
                case false: {
                    oldEditorZoom = camera.getZoom();
                    break;
                }
            }
        }

        // !Drag camera
        if (mode == 0 && mouse.leftButtonDown()) {
            immutable float zoom = camera.getZoom();
            immutable Vector2 mouseDelta = Vector2Divide(mouse.getDelta(), Vector2(zoom, zoom));
            camera.addOffset(mouseDelta);

            final switch(atlasBrowserMode) {
                case true: {
                    oldAtlasBrowserOffset = camera.getOffset();
                    break;
                }
                case false: {
                    oldEditorOffset = camera.getOffset();
                    break;
                }
            }
        }

        // Todo: Simplify this into 1 scope
        if (atlasBrowserMode) {
            immutable Vector2 adjustedPos = getMousePositionOnMap();
            atlasHoverX = clamp(cast(int)floor(adjustedPos.x / 16.0), 0, atlasWidth  - 1);
            atlasHoverY = clamp(cast(int)floor(adjustedPos.y / 16.0), 0, atlasHeight - 1);
            if (mode != 0 && mouse.leftButtonPressed()) {
                atlasSelectedTileX = atlasHoverX;
                atlasSelectedTileY = atlasHoverY;
            }
        } else {

            if (mode != 0) {
                immutable Vector2 adjustedPos = getMousePositionOnMap();
            
                mapSelectPosX = clamp(cast(int)floor(adjustedPos.x / 16.0), 0, world.width);
                mapSelectPosY = clamp(cast(int)floor(adjustedPos.y / 16.0), 0, world.height);
            
                if (mode == 1) {
                    if (mouse.leftButtonDown()) {
                        world.map[layer].set(mapSelectPosX, mapSelectPosY,atlasSelectedTileX, atlasSelectedTileY);
                    } else if (mouse.rightButtonDown()) {
                        world.map[layer].remove(mapSelectPosX, mapSelectPosY);
                    }
                } else if (mode == 2) {
                    // Do not allow flood filling the foreground, it's annoying
                    if (mouse.leftButtonPressed() && layer == 0) {
                        
                        MapTile currentSelection = world.map[layer].get(mapSelectPosX, mapSelectPosY);

                        foreach (x; 0..world.map[layer].width) {
                            foreach (y; 0..world.map[layer].height) {
                                if (
                                currentSelection is null && world.map[layer].get(x,y) is null) {// ||
                                // This needs a crawler algorithm to work better
                                // (currentSelection !is null && world.map.get(x,y) !is null && world.map.get(x,y).equals(currentSelection)) ) {
                                    world.map[layer].set(x, y,atlasSelectedTileX, atlasSelectedTileY);
                                }
                            }
                        }
                    } else if (mouse.rightButtonPressed() && layer == 0) {
                        MapTile currentSelection = world.map[layer].get(mapSelectPosX, mapSelectPosY);

                        foreach (x; 0..world.map[layer].width) {
                            foreach (y; 0..world.map[layer].height) {
                                MapTile gottenTile = world.map[layer].get(x,y);
                                if (
                                currentSelection !is null && gottenTile !is null && gottenTile.equals(currentSelection)) {// ||
                                // This needs a crawler algorithm to work better
                                // (currentSelection !is null && world.map.get(x,y) !is null && world.map.get(x,y).equals(currentSelection)) ) {
                                    world.map[layer].remove(x,y);
                                }
                            }
                        }
                    }
                }

            }
        }
    }

    void drawTile(int posX, int posY, int tileX, int tileY, int border) {

        immutable int baseX = tileX == 0 ? 0 : (tileX * 16) + (tileX * border);        
        immutable int baseY = tileY == 0 ? 0 : (tileY * 16) + (tileY * border);

        immutable Rectangle source = Rectangle(
            baseX,
            baseY,
            16,
            16
        );

        immutable Rectangle goal = Rectangle(
            posX * 16,
            posY * 16,
            16,
            16,
        );

        DrawTexturePro(atlas, source, goal, Vector2(0,0), 0, Colors.WHITE);
    }

    override
    void render() {
        BeginDrawing();
        BeginMode2D(camera.get());
        {
            camera.clear();

            if (atlasBrowserMode) {
                foreach (x; 0..atlasWidth) {
                    foreach (y; 0..atlasHeight) {
                        drawTile(x,y,x,y,1);
                    }
                }
                DrawRectangleLines(atlasHoverX * 16, atlasHoverY * 16, 16, 16, Color(57, 255, 20, 255));
                DrawRectangleLines(atlasSelectedTileX * 16, atlasSelectedTileY * 16, 16, 16, Color(255, 0, 20, 255));
            } else {
                Color filler;
                if (layer == 0) {
                    filler = Color(255,255,255,255);
                } else {
                    filler = Color(0,  0,  255,255);
                }
                foreach (x; 0..world.map[layer].width) {
                    foreach (y; 0..world.map[layer].height) {

                        foreach (layerIndex; 0..2) {
                            MapTile thisTile = world.map[layerIndex].get(x,y);
                            if (thisTile is null && guideGrid) {
                                DrawRectangleLines(x * 16, y * 16, 16, 16, filler);
                            } else if (thisTile !is null) {
                                drawTile(x, y, thisTile.x, thisTile.y, 1);
                            }
                        }
                    }
                }
                
                DrawRectangleLines(mapSelectPosX * 16, mapSelectPosY * 16, 16, 16, Color(57, 255, 20, 255));
                
            }
        }
        EndMode2D();

        if (atlasBrowserMode) {
            DrawText("ATLAS BROWSER", 4,2, fontSize, Colors.BLACK);
            DrawText("ATLAS BROWSER", 2,0, fontSize, Color(57, 255, 20, 255));
        } else {
            final switch (mode) {
                case 0: {
                    DrawText("MOVE", 4,2, fontSize, Colors.BLACK);
                    DrawText("MOVE", 2,0, fontSize, Color(57, 255, 20, 255));
                    break;
                }
                case 1: {
                    DrawText("EDIT", 4,2, fontSize, Colors.BLACK);
                    DrawText("EDIT", 2,0, fontSize, Color(57, 255, 20, 255));
                    break;
                }
                case 2: {
                    DrawText("FLOOD FILL", 4,2, fontSize, Colors.BLACK);
                    DrawText("FLOOD FILL", 2,0, fontSize, Color(57, 255, 20, 255));
                    break;
                }
            }

            final switch (layer) {
                case 0: {
                    DrawText("BACKGROUND", 4,fontSize + 2, fontSize, Colors.BLACK);
                    DrawText("BACKGROUND", 2,fontSize    , fontSize, Color(57, 255, 20, 255));
                    break;
                }
                case 1: {
                    DrawText("FOREGROUND", 4,fontSize + 2, fontSize, Colors.BLACK);
                    DrawText("FOREGROUND", 2,fontSize    , fontSize, Color(57, 255, 20, 255));
                    break;
                }
            }
        }

        if (namingMode) {
            Vector2 position = window.getCenter();
            DrawText(toStringz("Name: " ~ mapName), cast(int)(position.x - ((mapName.length / 2) * (fontSize / 2)))    ,cast(int)position.y + 2, fontSize, Colors.BLACK);
            DrawText(toStringz("Name: " ~ mapName), cast(int)(position.x - ((mapName.length / 2) * (fontSize / 2))) + 2,cast(int)position.y    , fontSize, Color(57, 255, 20, 255));
        }

        if (saveIndicatorTimeout > 0) {
            DrawText(toStringz(mapName ~ " SAVED!"), 4,(fontSize * 2) + 2, fontSize, Colors.BLACK);
            DrawText(toStringz(mapName ~ " SAVED!"), 2,(fontSize * 2)    , fontSize, Color(57, 255, 20, 255));
        }
        if (loadIndicatorTimeout > 0) {
            if (loadFailure) {
                DrawText(toStringz(mapName ~ " DOES NOT EXIST!"), 4,(fontSize * 3) + 2, fontSize, Colors.BLACK);
                DrawText(toStringz(mapName ~ " DOES NOT EXIST!"), 2,(fontSize * 3)    , fontSize, Color(57, 255, 20, 255));
            } else {
                DrawText(toStringz(mapName ~ " LOADED!"), 4,(fontSize * 3) + 2, fontSize, Colors.BLACK);
                DrawText(toStringz(mapName ~ " LOADED!"), 2,(fontSize * 3)    , fontSize, Color(57, 255, 20, 255));
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