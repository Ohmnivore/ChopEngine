package choprender.model.data;

import com.rsredsq.math.Vec3;
import choprender.render3d.GLUtil;
import choprender.render3d.opengl.GL.GLProgram;

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
	public var diffuseColor:Vec3;
	public var diffuseIntensity:Float;
	public var specularColor:Vec3;
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
		diffuseColor = Vec3.fromValues(1, 1, 1);
		diffuseIntensity = 1.0;
		specularColor = Vec3.fromValues(1, 1, 1);
		specularIntensity = 1.0;
		ambientIntensity = 1.0;
		emit = 0;
		transparency = 1.0;
	}
	
	public function copy(M:Material):Void
	{
		name = M.name;
		id = M.id;
		useShading = M.useShading;
		shadowsCast = M.shadowsCast;
		shadowsReceive = M.shadowsReceive;
		diffuseColor.copy(M.diffuseColor);
		diffuseIntensity = M.diffuseIntensity;
		specularColor.copy(M.specularColor);
		specularIntensity = M.specularIntensity;
		ambientIntensity = M.ambientIntensity;
		emit = M.emit;
		transparency = M.transparency;
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
	
	public function toFlagInt():Int
	{
		var res:Int = 0x0;
		res = addField(res, useShading, 0x1);
		res = addField(res, shadowsCast, 0x2);
		res = addField(res, shadowsReceive, 0x4);
		return res;
	}
	
	public function toFlagFloat():Float
	{
		return toFlagInt() / 7.0;
	}
	
	private function addField(To:Int, Field:Bool, Bit:Int):Int
	{
		if (Field)
			return To | Bit;
		else
			return To;
	}
}