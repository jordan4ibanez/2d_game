module game_state;

public interface GameState {
    void start();
    void update();
    void render();
}