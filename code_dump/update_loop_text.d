module code_dump.update_loop_text;

        if (keyboard.f1_pressed) {

            gui.getAnimatedTextElement("HAPPY").setVisible(false);

            gui.getAnimatedTextElement("HALLOWEEN").setVisible(false);

            gui.getImageElement("pumpkin").setVisible(false);

            gui.getTextElement("question").setVisible(true);

            GUIInput blah =  gui.getTextInputElement("namePrompt");
            blah.setText("");
            blah.focused = false; // oops forgot this one
            blah.setVisible(true);

            camera.setClearColor(90, 90, 90,255);

            musicPlaying = false;
            SeekMusicStream(music, 0);
            
            sassIndex = 0;
            
        }
