package choprender.model.data;

import choprender.render3d.shader.ChopTexture;
import choprender.render3d.shader.ChopTextureParam;
import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.GL.Float32Array;

import snow.system.module.Assets;
import snow.api.Promise;
import snow.types.Types.ImageInfo;
import snow.types.Types.AssetImage;

/**
 * ...
 * @author Ohmnivore
 */
class Texture
{
	public var name:String;
	public var id:Int;
	public var filename:String;
	public var filepath:String;
	public var width:Int;
	public var height:Int;
	public var data:Uint8Array;
	public var choptex:ChopTexture;
	
	public function new()
	{
		name = "";
		id = 0;
		filename = "";
		filepath = "";
		width = 0;
		height = 0;
		data;
	}
	
	public function read(P:String):Void
	{
		var _load:Promise = SnowApp._snow.assets.image(filepath);
		_load.then(
		function (i:AssetImage)
		{
			data = i.image.pixels;
			choptex = new ChopTexture("", GL.TEXTURE_2D, 0, GL.RGBA, i.image.width, i.image.height,
						GL.RGBA, GL.UNSIGNED_BYTE, i.image.pixels);
			choptex.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
			choptex.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
			choptex.create();
		}).error(function(){trace("texture loading failed: " + filepath);});
	}
	
	public function copy(T:Texture):Void
	{
		name = T.name;
		id = T.id;
		filename = T.filename;
		filepath = T.filepath;
		width = T.width;
		height = T.height;
		
		//data.splice(0, data.length);
		//for (i in T.data)
			//data.push(i);
	}
}