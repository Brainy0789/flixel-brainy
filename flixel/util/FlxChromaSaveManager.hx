package flixel.util;

import save.ChromaSave;
import save.util.ChromaConvert;

typedef FlxChromaSaveSoundData =
{
	@:optional var volume:Float;
	@:optional var mute:Bool;
}

class FlxChromaSaveManager
{
    public var saves:Map<String, ChromaSave> = new Map();

    public inline static function getSoundData(volume:Float, mute:Bool):FlxChromaSaveSoundData
        return {
			volume: volume,
			mute: mute
	    };


    public static inline function getSlotString(saveName:String, slot:Int):String
        return 
        #if FLX_USE_SAVE_SLOTS
        '${saveName}_${slot}'
        #else
        saveName
        #end;

    public function new() {}

    public function parse(key:String)
    {
        if (saves.exists(key))
            saves.get(key).parse();
        else
            throw 'ChromaSave instance of key "${key}" does not exist!';
    }

    public function save(key:String)
    {
        if (saves.exists(key))
            saves.get(key).save();
        else
            throw 'ChromaSave instance of key "${key}" does not exist!';
    }

    public function createSave(save:String, slot:Int = 0):ChromaSave
    {
        var saveKey = getSlotString(save, slot);

        if (saves.exists(saveKey))
            return saves.get(saveKey);

        var curSave = new ChromaSave(saveKey);
        saves.set(saveKey, curSave);

        curSave.parse();

        return curSave;
    }


    public function setField(saveName:String, key:String, v:Dynamic, slot:Int = 0):Void
    {
        var saveKey = getSlotString(saveName, slot);

        saves.get(saveKey).set(key, v);
        save(saveKey);
    }

    public function getField(save:String, key:String, slot:Int = 0):Dynamic
    {
        var saveKey = getSlotString(save, slot);

        var v = (saves.get(saveKey).data.exists(key)) ? saves.get(saveKey).get(key) : null;

        return v;
    }

    public function fromFlxG(save:String, slot:Int = 0):ChromaSave {
        var key = getSlotString(save, slot);
        var newChromaSave = ChromaConvert.fromFlxG(save);
        saves.set(key, newChromaSave);
        return newChromaSave;
    }

}