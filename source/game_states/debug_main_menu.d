module game_states.debug_main_menu;

import raylib;
import game_states.game_state;
import game;
import utility.gui;


public class MainMenu : GameState {

    GUI gui;

    this(Game game) {
        super(game);

        gui = new GUI(window);
        gui.addText(Anchor.TOP_LEFT,     "debug1", "my test",0,0,20);
        gui.addText(Anchor.TOP,          "debug2", "my test",0,0,20);
        gui.addText(Anchor.TOP_RIGHT,    "debug3", "my test",0,0,20);
        gui.addText(Anchor.BOTTOM_LEFT,  "debug4", "my test",0,0,20);
        gui.addText(Anchor.BOTTOM,       "debug5", "my test",0,0,20);
        gui.addText(Anchor.BOTTOM_RIGHT, "debug6", "my test",0,0,20);
    }

    override
    void start() {

        camera.setClearColor(0,0,0,255);
        
    }

    override
    void update() {
        
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