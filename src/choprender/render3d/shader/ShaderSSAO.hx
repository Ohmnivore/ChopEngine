package choprender.render3d.shader;

import choprender.render3d.opengl.ChopProgram;
import choprender.render3d.opengl.ChopQuadProgram;
import choprender.render3d.opengl.ChopShader;
import choprender.render3d.opengl.ChopTexture;
import choprender.render3d.opengl.ChopTextureDescriptor;
import choprender.render3d.opengl.ChopTextureParam;
import choprender.render3d.shader.*;
import choprender.model.data.Face;
import choprender.model.data.Vertex;
import choprender.model.Model;
import choprender.render3d.Camera;
import choprender.render3d.opengl.GL;
import choprender.render3d.shaderexp.opengl.ChopGL;
import choprender.render3d.opengl.GL.GLTexture;
import choprender.render3d.opengl.ChopProgramMgr;
import choprender.render3d.opengl.GLUtil;
import chop.math.Util;
import chop.math.Vec3;
import choprender.render3d.opengl.GL.Float32Array;

/**
 * ...
 * @author Ohmnivore
 */
class ShaderSSAO extends ChopQuadProgram
{
	public var ssaoKernel:Array<Vec3>;
	public var texNoise:ChopTexture;
	
	public var gSSAO:ChopTexture;
	
	public function new(C:Camera) 
	{
		super(C);
		
		type = ChopProgram.ONESHOT;
		
		var id:String = "assets/shader/ssao_vertex.glsl";
		new ChopShader(id, Main.assets.getText(id), GL.VERTEX_SHADER).attach(prog);
		id = "assets/shader/ssao_fragment.glsl";
		new ChopShader(id, Main.assets.getText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		inTextures.push(new ChopTextureDescriptor("gPosition", "gPositionDepth"));
		inTextures.push(new ChopTextureDescriptor("gNormal", "gNormal"));
		
		gSSAO = new ChopTexture("gSSAO", GL.TEXTURE_2D, 0, ChopGL.RED, C.width, C.height, GL.RGB, GL.FLOAT);
		gSSAO.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.LINEAR));
		gSSAO.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.LINEAR));
		outTextures.push(gSSAO);
		
		// Sample kernel
		ssaoKernel = [];
		for (i in 0...64)
		{
			var sample:Vec3 = Vec3.fromValues(Math.random() * 2.0 - 1.0, Math.random() * 2.0 - 1.0, Math.random());
			sample = sample.norm();
			sample = sample * Math.random();
			var scale:Float = i / 64.0;
			
			scale = lerp(0.1, 1.0, scale * scale);
			sample = sample * scale;
			ssaoKernel.push(sample);
		}
		
		// Noise texture
		var ssaoNoise:Array<Float> = [];
		for (i in 0...16)
		{
			var noise:Vec3 = Vec3.fromValues(Math.random() * 2.0 - 1.0, Math.random() * 2.0 - 1.0, 0.0);
			ssaoNoise.push(noise.x);
			ssaoNoise.push(noise.y);
			ssaoNoise.push(noise.z);
		}
		
		texNoise = new ChopTexture("texNoise", GL.TEXTURE_2D, 0, ChopGL.RGB16F, 4, 4, GL.RGB, GL.FLOAT, new Float32Array(ssaoNoise));
		texNoise.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		texNoise.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		texNoise.params.push(new ChopTextureParam(GL.TEXTURE_WRAP_S, GL.REPEAT));
		texNoise.params.push(new ChopTextureParam(GL.TEXTURE_WRAP_T, GL.REPEAT));
		GL.bindTexture(texNoise.target, texNoise.texture);
		GL.texImage2D(texNoise.target, texNoise.level, texNoise.internalFormat, texNoise.width, texNoise.height, 0, texNoise.format, texNoise.type, texNoise.pixels);
		for (p in texNoise.params)
			p.addToTexture(texNoise);
	}
	
	private function lerp(A:Float, B:Float, F:Float):Float
	{
		return A + F * (B - A);
	}
	
	override public function preRender(Mgr:ChopProgramMgr):Void 
	{
		super.preRender(Mgr);
		GL.clear(GL.COLOR_BUFFER_BIT);
	}
	
	override public function render(M:Array<Model>, C:Camera, Mgr:ChopProgramMgr):Void 
	{
		for (i in 0...ssaoKernel.length)
		{
			var vec:Vec3 = ssaoKernel[i];
			GLUtil.setUniformElementSimple(prog, "samples", i, vec);
		}
		GLUtil.setUniform(prog, "projection", C.projectionMatrix);
		
		GL.activeTexture(GL.TEXTURE2);
		GL.bindTexture(texNoise.target, texNoise.texture);
		GLUtil.setInt(GLUtil.getLocation(prog, texNoise.name), 2);
		
		super.render(M, C, Mgr);
	}
}