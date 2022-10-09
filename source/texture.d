module texture;

import raylib;
import std.string: toStringz;

public class TextureContainer {
    
    Texture texture;

    this(string textureLocation) {
        texture = LoadTexture(toStringz(textureLocation));
    }
    ~this() {
        UnloadTexture(texture);
    }
}

public class TextureCache {

    TextureContainer[string] cache;

    void upload(string name, string textureLocation) {
        cache[name] = new TextureContainer(textureLocation);
    }

    TextureContainer get(string name) {
        return cache[name];
    }
}