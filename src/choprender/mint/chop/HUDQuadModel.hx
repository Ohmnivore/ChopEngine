package choprender.mint.chop;
import choprender.model.QuadModel;
import hxmath.math.Vector3;

/**
 * ...
 * @author Ohmnivore
 */
class HUDQuadModel extends QuadModel
{
	public var color(get, set):Vector3;
	public function get_color():Vector3
	{
		return mat.diffuseColor;
	}
	public function set_color(V:Vector3):Vector3
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