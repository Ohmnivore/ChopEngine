package choprender.render3d.shader;

import choprender.model.data.Face;
import choprender.model.data.Vertex;
import choprender.model.Model;
import choprender.render3d.Camera;
import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.ChopGL;
import choprender.render3d.opengl.GL.GLTexture;
import chop.render3d.Program;
import choprender.render3d.GLUtil;
import hxmath.math.MathUtil;
import hxmath.math.Matrix4x4;
import hxmath.math.Vector2;
import hxmath.math.Vec3;
import chop.math.Util;
import choprender.render3d.opengl.GL.Float32Array;

/**
 * ...
 * @author Ohmnivore
 */
class ShaderGaussianBlur extends ChopQuadProgram
{
	public var horizontal:Bool = true;
	public var blurSize:Int = 9;
	public var sigma:Float = 5.0;
	
	public var gGaussianBlur:ChopTexture;
	
	public function new(C:Camera) 
	{
		super(C);
		
		type = ChopProgram.ONESHOT;
		
		var id:String = "assets/shader/gaussian_blur_vertex.glsl";
		new ChopShader(id, Assets.loadText(id), GL.VERTEX_SHADER).attach(prog);
		id = "assets/shader/gaussian_blur_fragment.glsl";
		new ChopShader(id, Assets.loadText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		inTextures.push(new ChopTextureDescriptor("gLight", "texture"));
		
		gGaussianBlur = new ChopTexture("gGaussianBlur", GL.TEXTURE_2D, 0, ChopGL.RGB16F, C.width, C.height, GL.RGB, GL.FLOAT);
		gGaussianBlur.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.LINEAR));
		gGaussianBlur.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.LINEAR));
		outTextures.push(gGaussianBlur);
	}
	
	override public function render(M:Array<Model>, C:Camera, Mgr:ChopProgramMgr):Void 
	{
		GLUtil.setInt(GLUtil.getLocation(prog, "blurSize"), blurSize);
		var horizInt:Int = 0;
		if (horizontal)
			horizInt = 1;
		GLUtil.setInt(GLUtil.getLocation(prog, "horizontalPass"), horizInt);
		GLUtil.setFloat(GLUtil.getLocation(prog, "sigma"), sigma);
		var inpTex:ChopTexture = Mgr.textures.get(inTextures[0].globalName);
		GLUtil.setUniform(prog, "texOffset", new Vector2(1.0 / inpTex.width, 1.0 / inpTex.height));
		
		super.render(M, C, Mgr);
	}
}