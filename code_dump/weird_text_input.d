module code_dump.weird_text_input;

// Sass is eternal
        static immutable string[] sass = [
            "What is your name?",
            "Surely, you must have a name!",
            "Oh come on, type your name..",
            "I don't have all day here, type that name!",
            "Name! Now!",
            "Okay fine, don't type your name",
            "See if I care!",
            "I'm getting tired of this",
            "I bet your name is Bob. Hi Bob.",
            "That's it, I'm resetting back to the first index."
        ];

        gui.addTextInputElement("namePrompt", "", "*input name here*", Anchor.CENTER, 0, 0, 60, 350, 30, 3, Colors.WHITE, Colors.GRAY, Colors.BLACK, Colors.WHITE,
            (GUIInput textInput) {

                if (textInput.getText().length == 0) {
                    sassIndex++;
                    if (sassIndex >= sass.length) {
                        sassIndex = 0;
                    }
                    gui.getTextElement("question").setText(sass[sassIndex]);
                } else {
                    gui.getTextElement("question").setText("What is your name?");
                    gui.getAnimatedTextElement("HAPPY").setVisible(true);
                    GUIText greeting =  gui.getAnimatedTextElement("HALLOWEEN");
                    greeting.setText("HALLOWEEN " ~ textInput.getText() ~ "!");
                    greeting.setVisible(true);

                    gui.getImageElement("pumpkin").setVisible(true);

                    gui.getTextElement("question").setVisible(false);
                    textInput.setVisible(false);

                    camera.setClearColor(255, 117, 24,255);

                    musicPlaying = true;
                }

            }
        );

        gui.getAnimatedTextElement("HAPPY").setVisible(false);
        gui.getAnimatedTextElement("HALLOWEEN").setVisible(false);