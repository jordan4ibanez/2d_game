module game_states.debug_main_menu;

import raylib;
import game_states.game_state;
import game;
import utility.gui;
import std.random;


public class MainMenu : GameState {

    GUI gui;

    string[9] runners = [
        "debug1",
        "debug2",
        "debug3",
        "debug4",
        "debug5",
        "debug6",
        "debug7",
        "debug8",
        "debug9",
    ];

    this(Game game) {
        super(game);

        gui = new GUI(window);

        gui.addTextElement(Anchor.TOP_LEFT,     "debug1", "my test",0,0,20);
        gui.addTextElement(Anchor.TOP,          "debug2", "my test",0,0,20);
        gui.addTextElement(Anchor.TOP_RIGHT,    "debug3", "my test",0,0,20);

        gui.addTextElement(Anchor.BOTTOM_LEFT,  "debug4", "my test",0,0,20);
        gui.addTextElement(Anchor.BOTTOM,       "debug5", "my test",0,0,20);
        gui.addTextElement(Anchor.BOTTOM_RIGHT, "debug6", "my test",0,0,20);

        gui.addTextElement(Anchor.LEFT,         "debug7", "my test",0,0,20);
        gui.addTextElement(Anchor.CENTER,       "debug9", "my test",0,0,20);
        gui.addTextElement(Anchor.RIGHT,        "debug8", "my test",0,0,20);

    }

    override
    void start() {

        camera.setClearColor(0,0,0,255);
        
    }

    override
    void update() {
        foreach (key; runners) {

            string blorf;

            Random randy = Random(unpredictableSeed());
            foreach (_; 0..uniform(5,15, randy)) {
                randy = Random(unpredictableSeed());
                blorf ~= cast(char)uniform(0, 127, randy);
            }

            gui.getTextElement(key).setText(blorf);
            
        }
    }

    override
    void render() {
        BeginDrawing();
        BeginMode2D(camera.get());
        {
            camera.clear();

        }
        EndMode2D();

        gui.render();

        EndDrawing();
        
    }

    override
    void reset() {
        
    }

    override
    void cleanUp() {
        
    }

}