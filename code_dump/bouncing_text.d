module code_dump.bouncing_text;

// Constructor function
        void init(GUITextAnimated animation) {
            animation.singularIntMemory = 1;
            animation.singularBoolMemory = true;
            animation.singularFloatMemory = 0;
        }

        // Bouncing text - treating the entire object as the animation
        void update(GUITextAnimated animation, float delta) {                
            string text = animation.getText();
            int textLength = cast(int) text.length;

            bool  goUp        = animation.singularBoolMemory;
            float height      = animation.singularFloatMemory;
            int   stage       = animation.singularIntMemory;

            static immutable float bounceAmount = 7;
            static immutable float bounceSpeed = 50;

            if (goUp) {
                height += delta * bounceSpeed;
                if (height >= bounceAmount) {
                    stage += 1;
                    goUp = false;
                    height = bounceAmount;
                }
            } else {
                height -= delta * bounceSpeed;
                if (height <= 0) {
                    stage += 1;
                    goUp = true;
                    height = 0;
                }
            }
            if (stage > 4) {
                stage = 1;
            }


            bool odd = true;
            foreach (i; 0..textLength){
                if (stage < 3) {
                    if (odd) {                            
                        animation.offsetMemory[i].y = height;
                    }
                } else {
                    if (!odd) {                            
                        animation.offsetMemory[i].y = height;
                    }
                }
                odd = !odd;
            }

            animation.singularBoolMemory  = goUp;
            animation.singularFloatMemory = height;
            animation.singularIntMemory  = stage;

        }
        
        gui.addAnimatedTextElement("HAPPY",     Anchor.CENTER, "HAPPY",     0, -150, 50, Colors.BLACK, false, &init, &update);
        gui.addAnimatedTextElement("HALLOWEEN", Anchor.CENTER, "HALLOWEEN", 0,  150, 50, Colors.BLACK, false, &init, &update);