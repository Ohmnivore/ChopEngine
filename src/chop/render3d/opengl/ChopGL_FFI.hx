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
	
	public static function texImage2DMultisample(
		Target:Int,
		Samples:Int,
		InternalFormat:Int,
		Width:Int,
		Height:Int,
		FixedSampleLocation:Bool
		):Void
    {
        //return chop_gl_tex_image_2d_multisample(Target, Samples, InternalFormat, Width, Height, FixedSampleLocation);
        return chop_gl_tex_image_2d_multisample(Target, Samples, InternalFormat, Width, Height);
    }
	
	public static function renderbufferStorageMultisample(
		Target:Int,
		Samples:Int,
		InternalFormat:Int,
		Width:Int,
		Height:Int
		):Void
    {
        return chop_gl_renderbuffer_storage_multisample(Target, Samples, InternalFormat, Width, Height);
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
	static var chop_gl_tex_image_2d_multisample = load("chop_gl_tex_image_2d_multisample", 5);
	static var chop_gl_renderbuffer_storage_multisample = load("chop_gl_renderbuffer_storage_multisample", 5);
}