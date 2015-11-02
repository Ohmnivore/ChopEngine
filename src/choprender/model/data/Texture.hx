package choprender.model.data;

import choprender.render3d.opengl.ChopTexture;
import choprender.render3d.opengl.ChopTextureParam;
import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.GL.Float32Array;

import snow.types.Types.ImageInfo;

/**
 * ...
 * @author Ohmnivore
 */
class Texture
{
	static public var BLEND_ALPHA_BLEND:Int = 0;
	static public var BLEND_SRC:Int = 1;
	static public var BLEND_SRC_OVER:Int = 2;
	static public var BLEND_DST_IN:Int = 3;
	
	public var name:String;
	public var id:Int;
	public var filename:String;
	public var filepath:String;
	public var data:Bitmap;
	public var choptex:ChopTexture;
	public var blendMode:Int;
	
	public function new()
	{
		name = "";
		id = 0;
		filename = "";
		filepath = "";
		blendMode = BLEND_ALPHA_BLEND;
	}
	
	public function loadFile(P:String):Void
	{
		loadImage(Main.assets.getImage(P));
		
	}
	public function loadImage(I:ImageInfo):Void
	{
		loadData(I.pixels, I.width, I.height);
	}
	public function loadData(D:Uint8Array, Width:Int, Height:Int):Void
	{
		data = new Bitmap();
		data.pixels = new Uint8Array(D);
		data.width = Width;
		data.height = Height;
		choptex = new ChopTexture("", GL.TEXTURE_2D, 0, GL.RGBA, Width, Height,
					GL.RGBA, GL.UNSIGNED_BYTE, data.pixels);
		choptex.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		choptex.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		choptex.params.push(new ChopTextureParam(GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE));
		choptex.params.push(new ChopTextureParam(GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE));
		choptex.create();
	}
	
	public function copy(T:Texture):Void
	{
		name = T.name;
		id = T.id;
		filename = T.filename;
		filepath = T.filepath;
		blendMode = T.blendMode;
		
		data.copy(T.data);
	}
}