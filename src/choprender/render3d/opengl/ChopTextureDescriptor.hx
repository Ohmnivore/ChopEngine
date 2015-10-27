package choprender.render3d.opengl;

/**
 * ...
 * @author Ohmnivore
 */
class ChopTextureDescriptor
{
	public var globalName:String;
	public var shaderName:String;
	
	public function new(GlobalName:String, ShaderName:String) 
	{
		globalName = GlobalName;
		shaderName = ShaderName;
	}
}