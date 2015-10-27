package choprender.render3d.opengl;

import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.GL.GLProgram;
import choprender.render3d.opengl.GL.GLShader;

/**
 * ...
 * @author Ohmnivore
 */
class ChopShader
{
	public var source:String;
	public var path:String;
	public var shader:GLShader;
	public var kind:Int;
	
	public function new(Path:String, Source:String, Kind:Int) 
	{
		path = Path;
		source = Source;
		kind = Kind;
		
		shader = GL.createShader(kind);
		GL.shaderSource(shader, source);
		GL.compileShader(shader);
		trace(path + " " + GL.getShaderInfoLog(shader));
	}
	
	public function attach(P:GLProgram):Void
	{
		GL.attachShader(P, shader);
	}
}