package chop.render3d.opengl;

import chop.render3d.opengl.GL.ArrayBufferView;
import snow.api.Libs;

/**
 * ...
 * @author Ohmnivore
 */
class ChopGL_FFI
{
	public static function drawBuffers(ArrLength:Int, Buffs:Array<Int>):Void
    {
        return chop_gl_draw_buffers(ArrLength, Buffs);
    }
	
	static function load(inName:String, inArgCount:Int):Dynamic {
        try {
            return Libs.load("snow", inName, inArgCount);
        } catch(e:Dynamic) {
            trace(e);
            return null;
        }
    }
	
	static var chop_gl_draw_buffers = load("chop_gl_draw_buffers", 2);
}