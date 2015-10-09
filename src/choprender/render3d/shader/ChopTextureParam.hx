package choprender.render3d.shader;

import choprender.render3d.opengl.GL;

/**
 * ...
 * @author Ohmnivore
 */
class ChopTextureParam
{
	public var name:Int;
	public var param:Dynamic;
	
	public function new(Name:Int, Param:Dynamic)
	{
		name = Name;
		param = Param;
	}
	
	public function addToTexture(T:ChopTexture):Void
	{
		if (Std.is(param, Int))
			GL.texParameteri(T.target, name, cast param);
		else
			GL.texParameterf(T.target, name, cast param);
	}
}