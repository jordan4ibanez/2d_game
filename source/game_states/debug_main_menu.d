module game_states.debug_main_menu;

import raylib;
import game_states.game_state;
import game;
import utility.gui;
import std.random;
import std.stdio: writeln;
import std.math.rounding: floor;


public class MainMenu : GameState {

    GUI gui;

    float progress = 0;
    static immutable Vector3 startClearColor = Vector3(0,0,0);
    static immutable Vector3 goalClearColor = Vector3(255, 117, 24);
    bool up = true;
    Texture pumpkin;
    Music music;


    string[8] runners = [
        "debug1",
        "debug2",
        "debug3",
        "debug4",
        "debug5",
        "debug6",
        "debug7",
        "debug8",
        // "debug9",
    ];

    this(Game game) {
        super(game);

        gui = new GUI(window);

        Color pumpkinOrange = Color(255, 117, 24,255);

        gui.addTextElement(Anchor.TOP_LEFT,     "debug1", "my test", 0,0, 20, pumpkinOrange, true);
        gui.addTextElement(Anchor.TOP,          "debug2", "my test", 0,0, 20, pumpkinOrange, true);
        gui.addTextElement(Anchor.TOP_RIGHT,    "debug3", "my test", 0,0, 20, pumpkinOrange, true);

        gui.addTextElement(Anchor.BOTTOM_LEFT,  "debug4", "my test", 0,0, 20, pumpkinOrange, true);
        gui.addTextElement(Anchor.BOTTOM,       "debug5", "my test", 0,0, 20, pumpkinOrange, true);
        gui.addTextElement(Anchor.BOTTOM_RIGHT, "debug6", "my test", 0,0, 20, pumpkinOrange, true);

        gui.addTextElement(Anchor.LEFT,         "debug7", "my test", 0,0, 20, pumpkinOrange, true);
        //gui.addTextElement(Anchor.CENTER,       "debug9", "my test", 0,0, 20, pumpkinOrange, true);
        gui.addTextElement(Anchor.RIGHT,        "debug8", "my test", 0,0, 20, pumpkinOrange, true);
        

        
        void test(float delta) {
            writeln(delta);
        }

        gui.addAnimatedTextElement(Anchor.CENTER,       "debug9", "my test", 0,0, 20, pumpkinOrange, true,
            (GUITextAnimated object, float delta) {
                // writeln(object.getText());
            }
        );

        // gui.addTextElement(Anchor.CENTER,       "HAPPY", "HAPPY", 0, -150, 50, Colors.BLACK, true);
        // gui.addTextElement(Anchor.CENTER,       "HALLOWEEN", "HALLOWEEN", 0, 150, 50, Colors.BLACK, true);


        cache.upload("jackolantern", "textures/jackolantern.png");

        pumpkin = cache.get("jackolantern").get();

        gui.addImageElement(Anchor.CENTER, "pumpkin", 10,0, pumpkin, 0.75);

    }

    override
    void start() {
        camera.setClearColor(0,0,0,255);

        camera.setOffset(Vector2(0,0));

        InitAudioDevice();

        music = LoadMusicStream("music/a_distant_memory.ogg");

        PlayMusicStream(music);
    }

    override
    void update() {

        UpdateMusicStream(music);

        float delta = timeKeeper.getDelta();

        final switch (up) {
            case true: {
                progress += delta / 10.0;
                up = progress >= 1.0 ? false : true;
                // Don't allow interpolation overshoot
                progress = up ? progress : 1.0;
                break;
            }
            case false: {
                progress -= delta / 10.0;
                up = progress <= 0.0 ? true : false;
                // Don't allow interpolation overshoot
                progress = up ? 0.0 : progress;
                break;
            }
        }

        Vector3 clearColor = Vector3Lerp(startClearColor, goalClearColor, progress);

        camera.setClearColor(
            cast(ubyte)floor(clearColor.x),
            cast(ubyte)floor(clearColor.y),
            cast(ubyte)floor(clearColor.z),
            255
        );

        Random randy;

        foreach (key; runners) {

            string blorf;

            foreach (_; 0..uniform(5,15, randy)) {
                randy = Random(unpredictableSeed());
                blorf ~= cast(char)uniform(0, 127, randy);
            }

            gui.getTextElement(key).setText(blorf);
            
        }

        string shmoop;
        foreach (_; 0..uniform(5,15, randy)) {
            randy = Random(unpredictableSeed());
            shmoop ~= cast(char)uniform(0, 127, randy);
        }

        window.setTitle(shmoop);
    }

    override
    void render() {
        BeginDrawing();
        BeginMode2D(camera.get());
        {
            camera.clear();
        }
        EndMode2D();

        gui.render(timeKeeper.getDelta());

        EndDrawing();
        
    }

    override
    void reset() {
        
    }

    override
    void cleanUp() {
        UnloadMusicStream(music);
        CloseAudioDevice();
        
    }

}