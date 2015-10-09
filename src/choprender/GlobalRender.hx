package choprender;

import choprender.render3d.Camera;
import chop.gen.Basic;
import choprender.render3d.light.LightState;

/**
 * ...
 * @author Ohmnivore
 */
class GlobalRender
{
	static public var cam:Camera = null;
	static public var cams:Array<Camera> = [];
	static public var members:Array<Basic> = [];
	static public var lights:LightState = null;
}