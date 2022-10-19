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
        gui.addText("debug", "my test");
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