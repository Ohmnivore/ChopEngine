package choprender.model.data;

import chop.util.Color;
import choprender.render3d.opengl.GLUtil;
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
	public var diffuseColor:Color;
	public var diffuseIntensity:Float;
	public var specularColor:Color;
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
		diffuseColor = Color.fromValues(1, 1, 1);
		diffuseIntensity = 1.0;
		specularColor = Color.fromValues(1, 1, 1);
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
		GLUtil.setUniformBasic(P, "material.useShading", useShading);
		GLUtil.setUniformBasic(P, "material.shadowsCast", shadowsCast);
		GLUtil.setUniformBasic(P, "material.shadowsReceive", shadowsReceive);
		GLUtil.setUniformVec(P, "material.diffuseColor", diffuseColor);
		GLUtil.setUniformBasic(P, "material.diffuseIntensity", diffuseIntensity);
		GLUtil.setUniformVec(P, "material.specularColor", specularColor);
		GLUtil.setUniformBasic(P, "material.specularIntensity", specularIntensity);
		GLUtil.setUniformBasic(P, "material.ambientIntensity", ambientIntensity);
		GLUtil.setUniformBasic(P, "material.emit", emit);
		GLUtil.setUniformBasic(P, "material.transparency", transparency);
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