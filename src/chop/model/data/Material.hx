package chop.model.data;

import hxmath.math.Vector3;
import chop.render3d.GLUtil;
//import snow.modules.opengl.GL.GLProgram;
import lime.graphics.opengl.GLProgram;

/**
 * ...
 * @author Ohmnivore
 */
class Material
{
	public var name:String;
	public var id:Int;
	public var useShading:Bool;
	public var shadowsCast:Bool;
	public var shadowsReceive:Bool;
	public var diffuseColor:Vector3;
	public var diffuseIntensity:Float;
	public var specularColor:Vector3;
	public var specularIntensity:Float;
	public var ambientIntensity:Float;
	public var emit:Float;
	public var transparency:Float;
	
	public function new() 
	{
		name = "";
		id = 0;
		useShading = true;
		shadowsCast = true;
		shadowsReceive = true;
		diffuseColor = new Vector3(1, 1, 1);
		diffuseIntensity = 1.0;
		specularColor = new Vector3(1, 1, 1);
		specularIntensity = 1.0;
		ambientIntensity = 1.0;
		emit = 0;
		transparency = 1.0;
	}
	
	public function setUniforms(P:GLProgram):Void
	{
		GLUtil.setUniform(P, "material.useShading", useShading);
		GLUtil.setUniform(P, "material.shadowsCast", shadowsCast);
		GLUtil.setUniform(P, "material.shadowsReceive", shadowsReceive);
		GLUtil.setUniform(P, "material.diffuseColor", diffuseColor);
		GLUtil.setUniform(P, "material.diffuseIntensity", diffuseIntensity);
		GLUtil.setUniform(P, "material.specularColor", specularColor);
		GLUtil.setUniform(P, "material.specularIntensity", specularIntensity);
		GLUtil.setUniform(P, "material.ambientIntensity", ambientIntensity);
		GLUtil.setUniform(P, "material.emit", emit);
		GLUtil.setUniform(P, "material.transparency", transparency);
	}
}