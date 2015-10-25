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
	private var assets:Map<String, Asset>;
	public var totalAssets:Int;
	public var currentAssets:Int;
	
	public function new()
	{
		reset();
	}
	public function reset():Void
	{
		assets = new Map<String, Asset>();
		totalAssets = 0;
		currentAssets = 0;
	}
	public function loadManifest():Void
	{
		totalAssets = 1;
		currentAssets = 0;
		SnowApp._snow.assets.json("manifest").then(
		function (A:AssetJSON) {
			totalAssets = 0;
			currentAssets = 0;
			var list:Array<String> = cast A.json;
			
			for (id in list)
			{
				var ext:String = Path.extension(id);
				
				if (ext == "png") loadImage(id);
				else if (ext == "json") loadJSON(id);
				else if (ext == "xml") loadText(id);
				else if (ext == "glsl") loadText(id);
				else if (ext == "chopmesh") loadText(id);
			}
		}).error(
		function () {
			trace("Couldn't find manifest");
		});
	}
	public function isReady():Bool
	{
		return currentAssets == totalAssets;
	}
	
	private function setAsset(ID:String, A:Asset):Void
	{
		assets.set(ID, A);
		currentAssets++;
	}
	private function loadAsset(ID:String, P:Promise):Void
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
	public function loadBytes(ID:String):Void
	{
		loadAsset(ID, SnowApp._snow.assets.bytes(ID));
	}
	public function loadImage(ID:String):Void
	{
		loadAsset(ID, SnowApp._snow.assets.image(ID));
	}
	public function loadImageFromBytes(ID:String, B:Uint8Array):Void
	{
		loadAsset(ID, SnowApp._snow.assets.image_from_bytes(ID, B));
	}
	public function loadImageFromPixels(ID:String, Width:Int, Height:Int, P:Uint8Array):Void
	{
		totalAssets++;
		setAsset(ID, SnowApp._snow.assets.image_from_pixels(ID, Width, Height, P));
	}
	public function loadJSON(ID:String):Void
	{
		loadAsset(ID, SnowApp._snow.assets.json(ID));
	}
	public function loadText(ID:String):Void
	{
		loadAsset(ID, SnowApp._snow.assets.text(ID));
	}
	
	private function check(ID:String):Void
	{
		if (!assets.exists(ID))
			trace("Couldn't find loaded asset: " + ID);
	}
	public function getBytes(ID:String):Uint8Array
	{
		check(ID);
		return cast(assets.get(ID), AssetBytes).bytes;
	}
	public function getImage(ID:String):ImageInfo
	{
		check(ID);
		return cast(assets.get(ID), AssetImage).image;
	}
	public function getJSON(ID:String):Dynamic
	{
		check(ID);
		return cast(assets.get(ID), AssetJSON).json;
	}
	public function getText(ID:String):String
	{
		check(ID);
		return cast(assets.get(ID), AssetText).text;
	}
}