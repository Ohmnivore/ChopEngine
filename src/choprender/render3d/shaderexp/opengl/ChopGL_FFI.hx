package choprender.render3d.shaderexp.opengl;

import choprender.render3d.opengl.GL.ArrayBufferView;
import snow.api.Libs;

/**
 * ...
 * @author Ohmnivore
 */
class ChopGL_FFI2
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
	
	/*
	 * Add the following code to snow/project/src/render/opengl/snow_render_opengl.cpp
	 * and build the ndlls
	*/
	
	/*
		value chop_gl_draw_buffers(value length, value arr) {	
			GLenum* bufs = (GLenum*)val_array_int(arr);
			glDrawBuffers(val_int(length), bufs);
			return alloc_null();
		} DEFINE_PRIM(chop_gl_draw_buffers,2); 
	*/
	static var chop_gl_draw_buffers = load("chop_gl_draw_buffers", 2);
}