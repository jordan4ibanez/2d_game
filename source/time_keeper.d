module time_keeper;

import core.time;

import game;

public class TimeKeeper {

    private Game game;

    // Start with delta of a HUGE amount, limited by maxDelta
    private MonoTime before;
    private MonoTime after;

    // High precision delta for users with powerful computers
    private double delta = 0;

    this(Game game){
        this.game = game;
        before = MonoTime.currTime();
        after = MonoTime.currTime();
    }

    // Calculates the delta time between frames. First will always be 0
    void calculateDelta() {
        after = MonoTime.currTime;
        Duration duration = after - before;
        delta = cast(double)duration.total!("nsecs") / 1_000_000_000.0;        
        before = MonoTime.currTime;
    }

    // Allows any function or object to get the delta anywhere in the program
    double getDelta() {
        return delta;
    }
}