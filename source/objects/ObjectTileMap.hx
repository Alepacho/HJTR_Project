package objects;

import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import resources.ResGame;

class ObjectTileMap extends FlxTilemap {
    public function new() {
        super();
    }

    public function removeTileAt(point:FlxPoint) {
        // point.x = Math.floor(point.x / 16);
        // point.y = Math.floor(point.y / 16);
        var tile = this.getTileData(point);
        if (tile == null) return false;
        if (tile.index == 0) return false;
        if (tile.index == 3) return false; // bedrock or something...

        var check = this.setTileIndex(point, 0, true);
        trace('remove tile at ${point}: ${check}');
        if (check) {
            if (tile.index == 4) {
                ResGame.score += 100;
                ResGame.gold++;
            }
            if (tile.index == 5) {
                ResGame.score += 200;
                ResGame.diamond++;
            }
            if (tile.index == 6) {
                ResGame.score += 300;
                ResGame.ruby++;
            }
            if (tile.index == 7) {
                ResGame.score += 400;
                ResGame.emerald++;
            }
        }
        return check;
    }
}
