package choprender.model.data;

import chop.assets.Assets;
import choprender.render3d.shader.ChopTexture;
import choprender.render3d.shader.ChopTextureParam;
import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.GL.Float32Array;

import snow.types.Types.ImageInfo;

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
	
	public function loadFile(P:String):Void
	{
		loadImage(Assets.getImage(P));
		
	}
	public function loadImage(I:ImageInfo):Void
	{
		loadData(I.pixels, I.width, I.height);
	}
	public function loadData(D:Uint8Array, Width:Int, Height:Int):Void
	{
		data = D;
		choptex = new ChopTexture("", GL.TEXTURE_2D, 0, GL.RGBA, Width, Height,
					GL.RGBA, GL.UNSIGNED_BYTE, data);
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
		width = T.width;
		height = T.height;
		
		data = new Uint8Array(T.data);
	}
}