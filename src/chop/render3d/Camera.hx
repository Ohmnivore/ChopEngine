package chop.render3d;

import chop.gen.Basic;
import chop.gen.Global;
import chop.render3d.shader.ChopProgramMgr;
import hxmath.math.MathUtil;
import hxmath.math.Matrix4x4;
import hxmath.math.Vector2;
import hxmath.math.Vector3;
import hxmath.math.Vector4;
import chop.math.Util;
import chop.model.Model;
import chop.render3d.opengl.GL;
import chop.render3d.opengl.GL.GLProgram;
import chop.render3d.opengl.GL.GLShader;
import chop.render3d.shader.*;

/**
 * ...
 * @author Ohmnivore
 */
class Camera extends Basic
{
	public var prog:Program;
	public var defaultMgr:ChopProgramMgr;
	
	public var gBuffer:Int;
	public var gPosition:Int;
	public var gNormal:Int;
	public var noiseTexture:Int;
	public var ssaoKernel:Array<Vector3>;
	
	public var screenPos:Vector2;
	public var width:Int;
	public var height:Int;
	public var FOV:Float;
	public var ratio:Float;
	public var displayMin:Float;
	public var displayMax:Float;
	public var pos:Vector3;
	public var rot:Vector3;
	public var bgColor:Vector3;
	
	public var projectionMatrix:Matrix4x4;
	public var viewMatrix:Matrix4x4;
	
	public function new(X:Int = 0, Y:Int = 0, Width:Int = 0, Height:Int = 0) 
	{
		super();
		
		screenPos = new Vector2(0, 0);
		
		if (Width == 0)
			Width = SnowApp._snow.window.width;
		if (Height == 0)
			Height = SnowApp._snow.window.height;
		setView(X, Y, Width, Height);
		
		FOV = 45.0;
		displayMin = 0.1;
		displayMax = 200.0;
		pos = new Vector3(0.0, 0.0, 0.0);
		rot = new Vector3(0.0, 0.0, 0.0);
		bgColor = new Vector3(1.0, 1.0, 1.0);
		projectionMatrix = Matrix4x4.zero;
		viewMatrix = Matrix4x4.zero;
		prog = new Program("assets/shader/default_vertex.glsl",
			"assets/shader/default_fragment.glsl");
		
		createProgramMgrs();
		
		GL.enable(GL.CULL_FACE);
		GL.enable(GL.DEPTH_TEST);
		GL.depthFunc(GL.LESS);
		
		//preDraw(0);
		//postDraw(0);
	}
	
	private function createProgramMgrs():Void
	{
		defaultMgr = new ChopProgramMgr(this);
		
		var gBufferProgram:ShaderGBuffer = new ShaderGBuffer(this);
		defaultMgr.progs.push(gBufferProgram);
		gBufferProgram.readBuffer = defaultMgr.buff.buffer;
		gBufferProgram.drawBuffer = defaultMgr.buff.buffer;
		
		var gLightProgram:ShaderLights = new ShaderLights(this);
		defaultMgr.progs.push(gLightProgram);
		gLightProgram.readBuffer = defaultMgr.buff.buffer;
		//gLightProgram.drawBuffer = defaultMgr.buff.buffer;
		gLightProgram.drawBuffer = new GLFramebuffer(0);
		gLightProgram.outTextures = [];
		
		//var quadTextureProgram:ShaderQuadTexture = new ShaderQuadTexture();
		//defaultMgr.progs.push(quadTextureProgram);
		//quadTextureProgram.readBuffer = defaultMgr.buff.buffer;
		//quadTextureProgram.drawBuffer = new GLFramebuffer(0);
		//quadTextureProgram.inTextures[0].globalName = "gDiffuse";
		////quadTextureProgram.inTextures[0].globalName = "gSpec";
		////quadTextureProgram.inTextures[0].globalName = "gLight";
		
		defaultMgr.init();
	}
	
	public function setView(ScreenX:Int, ScreenY:Int, Width:Int, Height:Int, Ratio:Int = -1):Void
	{
		screenPos.x = ScreenX;
		screenPos.y = ScreenY;
		width = Width;
		height = Height;
		if (Ratio == -1)
			ratio = cast(width, Float) / cast(height, Float);
		else
			ratio = Ratio;
	}
	
	public function preDraw(Elapsed:Float):Void
	{
		GL.viewport(Std.int(screenPos.x), Std.int(SnowApp._snow.window.height - screenPos.y - height), width, height);
		GL.clearColor(bgColor.x, bgColor.y, bgColor.z, 1.0);
		GL.clear(GL.DEPTH_BUFFER_BIT);
	}
	
	public function postDraw(Elapsed:Float):Void
	{
		//for (basic in Global.state.members)
		//{
			//if (Std.is(basic, Model))
			//{
				//var m:Model = cast basic;
				//if (checkIfCam(m))
				//{
					//m.mgr.render(m, this);
					////renderModel(m);
				//}
			//}
		//}
		
		// TODO: mgr array
		for (p in defaultMgr.progs)
		{
			if (p.type == ChopProgram.MULTIPLE)
			{
				var toRender:Array<Model> = [];
				for (basic in Global.state.members)
				{
					if (Std.is(basic, Model))
					{
						var m:Model = cast basic;
						if (m.mgr == defaultMgr)
						{
							toRender.push(m);
						}
					}
				}
				p.preRender(defaultMgr);
				p.render(toRender, this, defaultMgr);
			}
			else if (p.type == ChopProgram.ONESHOT)
			{
				p.preRender(defaultMgr);
				p.render(null, this, defaultMgr);
			}
		}
	}
	private function checkIfCam(M:Model):Bool
	{
		for (c in M.cams)
		{
			if (c == this)
				return true;
		}
		return false;
	}
	private function renderModel(M:Model):Void
	{
		prog.renderModel(M, this);
	}
	
	override public function update(Elapsed:Float):Void 
	{
		super.update(Elapsed);
		computeProjectionMatrix();
		computeViewMatrix();
	}
	
	private function computeProjectionMatrix():Void
	{
		projectionMatrix = Util.perspective(FOV, ratio, displayMin, displayMax);
	}
	
	public function computeViewMatrix():Void
	{
		var nPos:Vector3 = Util.Vector3ToGL(pos);
		var nRot:Vector3 = Util.Vector3ToGLSoft(rot);
		
		var direction:Vector3 = new Vector3(0.0, 0.0, 1.0);
		direction.x = Math.sin(MathUtil.degToRad(nRot.y)) * Math.cos(MathUtil.degToRad(nRot.x));
		direction.y = Math.sin(MathUtil.degToRad(nRot.x));
		direction.z = Math.cos(MathUtil.degToRad(nRot.x)) * Math.cos(MathUtil.degToRad(nRot.y));
		
		//var upVec:Vector4 = new Vector3(0.0, 1.0, 0.0, 1.0) * Util.eulerToMatrix4x4(
			//MathUtil.degToRad(nRot.x),
			//MathUtil.degToRad(nRot.y),
			//MathUtil.degToRad(nRot.z));
		var upVec:Vector4 = Matrix4x4.multiplyVector(Util.eulerToMatrix4x4(
			MathUtil.degToRad(nRot.x),
			MathUtil.degToRad(nRot.y),
			MathUtil.degToRad(nRot.z)), new Vector4(0.0, 1.0, 0.0, 1.0));
		
		viewMatrix = Util.lookAt(nPos, nPos - direction, new Vector3(upVec.x, upVec.y, upVec.z));
	}
}