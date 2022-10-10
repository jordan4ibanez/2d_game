module texture;

import raylib;
import std.string: toStringz;

/// Wraps around texture
public class TextureContainer {
    
    Texture texture;

    this(string textureLocation) {
        texture = LoadTexture(toStringz(textureLocation));
    }

    ~this() {
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
        cache[name] = new TextureContainer(textureLocation);
    }

    TextureContainer get(string name) {
        return cache[name];
    }
}