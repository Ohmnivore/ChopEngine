package choprender.render3d.shader;

import choprender.model.data.Face;
import choprender.model.data.Vertex;
import choprender.model.Model;
import choprender.render3d.Camera;
import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.ChopGL;
import choprender.render3d.opengl.GL.GLTexture;
import choprender.render3d.GLUtil;
import chop.math.Mat4;
import chop.math.Vec2;
import chop.math.Vec3;
import chop.assets.Assets;
import chop.math.Util;
import choprender.render3d.opengl.GL.Float32Array;

/**
 * ...
 * @author Ohmnivore
 */
class ShaderFXAA extends ChopQuadProgram
{
	public var qualitySubpix:Float = 0.75;
	public var edgeThreshold:Float = 0.125;
	public var edgeThresholdMin:Float = 0.0312;
	
	public var gFXAA:ChopTexture;
	
	public function new(C:Camera) 
	{
		super(C);
		
		type = ChopProgram.ONESHOT;
		
		var id:String = "assets/shader/fxaa_vertex.glsl";
		new ChopShader(id, Assets.loadText(id), GL.VERTEX_SHADER).attach(prog);
		id = "assets/shader/fxaa_fragment.glsl";
		new ChopShader(id, Assets.loadText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		inTextures.push(new ChopTextureDescriptor("gLight", "textureSampler"));
		
		gFXAA = new ChopTexture("gFXAA", GL.TEXTURE_2D, 0, ChopGL.RGB16F, C.width, C.height, GL.RGB, GL.FLOAT);
		gFXAA.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.LINEAR));
		gFXAA.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.LINEAR));
		outTextures.push(gFXAA);
	}
	
	override public function render(M:Array<Model>, C:Camera, Mgr:ChopProgramMgr):Void 
	{
		var inpTex:ChopTexture = Mgr.textures.get(inTextures[0].globalName);
		GLUtil.setUniform(prog, "texOffset", Vec2.fromValues(1.0 / inpTex.width, 1.0 / inpTex.height));
		GLUtil.setFloat(GLUtil.getLocation(prog, "qualitySubpix"), qualitySubpix);
		GLUtil.setFloat(GLUtil.getLocation(prog, "edgeThreshold"), edgeThreshold);
		GLUtil.setFloat(GLUtil.getLocation(prog, "edgeThresholdMin"), edgeThresholdMin);
		
		super.render(M, C, Mgr);
	}
}