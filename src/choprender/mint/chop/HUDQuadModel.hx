package choprender.mint.chop;
import choprender.model.QuadModel;
import hxmath.math.Vec3;

/**
 * ...
 * @author Ohmnivore
 */
class HUDQuadModel extends QuadModel
{
	public var color(get, set):Vec3;
	public function get_color():Vec3
	{
		return mat.diffuseColor;
	}
	public function set_color(V:Vec3):Vec3
	{
		mat.diffuseColor.copyFromShape(V);
		return get_color();
	}
	
	public function new() 
	{
		super();
		mat.useShading = false;
	}
}