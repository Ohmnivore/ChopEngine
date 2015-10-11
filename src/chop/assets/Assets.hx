package chop.assets;

import choprender.render3d.opengl.GL.Uint8Array;
import snow.api.Promise;
import snow.system.assets.Asset;
import snow.types.Types;
import haxe.io.Path;

/**
 * ...
 * @author Ohmnivore
 */
class Assets
{
	static private var assets:Map<String, Asset>;
	static private var totalAssets:Int;
	static private var currentAssets:Int;
	
	public function new()
	{
		
	}
	static public function init():Void
	{
		assets = new Map<String, Asset>();
		totalAssets = 0;
		currentAssets = 0;
	}
	static public function loadManifest():Void
	{
		for (id in SnowApp._snow.assets.list)
		{
			var ext:String = Path.extension(id);
			
			if (ext == "png") loadImage(id);
			else if (ext == "json") loadJSON(id);
			else if (ext == "xml") loadText(id);
			else if (ext == "glsl") loadText(id);
			else if (ext == "chopmesh") loadText(id);
		}
	}
	static public function isReady():Bool
	{
		return currentAssets == totalAssets;
	}
	
	static private function setAsset(ID:String, A:Asset):Void
	{
		assets.set(ID, A);
		currentAssets++;
	}
	static private function loadAsset(ID:String, P:Promise):Void
	{
		totalAssets++;
		P.then(
		function (A:Asset)
		{
			setAsset(ID, A);
		}
		).error(
		function ()
		{
			trace("Error loading asset: " + ID);
		}
		);
	}
	static public function loadBytes(ID:String):Void
	{
		loadAsset(ID, SnowApp._snow.assets.bytes(ID));
	}
	static public function loadImage(ID:String):Void
	{
		loadAsset(ID, SnowApp._snow.assets.image(ID));
	}
	static public function loadImageFromBytes(ID:String, B:Uint8Array):Void
	{
		loadAsset(ID, SnowApp._snow.assets.image_from_bytes(ID, B));
	}
	static public function loadImageFromPixels(ID:String, Width:Int, Height:Int, P:Uint8Array):Void
	{
		totalAssets++;
		setAsset(ID, SnowApp._snow.assets.image_from_pixels(ID, Width, Height, P));
	}
	static public function loadJSON(ID:String):Void
	{
		loadAsset(ID, SnowApp._snow.assets.json(ID));
	}
	static public function loadText(ID:String):Void
	{
		loadAsset(ID, SnowApp._snow.assets.text(ID));
	}
	
	static private function check(ID:String):Void
	{
		if (!assets.exists(ID))
			trace("Couldn't find loaded asset: " + ID);
	}
	static public function getBytes(ID:String):Uint8Array
	{
		check(ID);
		return cast(assets.get(ID), AssetBytes).bytes;
	}
	static public function getImage(ID:String):ImageInfo
	{
		check(ID);
		return cast(assets.get(ID), AssetImage).image;
	}
	static public function getJSON(ID:String):Dynamic
	{
		check(ID);
		return cast(assets.get(ID), AssetJSON).json;
	}
	static public function getText(ID:String):String
	{
		check(ID);
		return cast(assets.get(ID), AssetText).text;
	}
}