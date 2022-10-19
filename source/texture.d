module texture;

import raylib;
import std.string: toStringz;

/// Wraps around texture
public class TextureContainer {
    
    Texture texture;

    this(string textureLocation) {
        texture = LoadTexture(toStringz(textureLocation));
    }

    void cleanUp() {
        UnloadTexture(texture);
    }

    Texture get() {
        return texture;
    }
}

/// Holds texture containers
public class TextureCache {

    TextureContainer[string] cache;

    void upload(string name, string textureLocation) {
        if (name !in cache) {
            cache[name] = new TextureContainer(textureLocation);
        }
    }

    TextureContainer get(string name) {
        return cache[name];
    }

    void cleanUp() {
        foreach (textureContainer; cache) {
            textureContainer.cleanUp();
        }
    }
}