package choprender.render3d.shader;

import choprender.model.data.Face;
import choprender.model.data.Vertex;
import choprender.model.Model;
import choprender.render3d.Camera;
import choprender.render3d.opengl.ChopProgram;
import choprender.render3d.opengl.ChopQuadProgram;
import choprender.render3d.opengl.ChopShader;
import choprender.render3d.opengl.ChopTexture;
import choprender.render3d.opengl.ChopTextureDescriptor;
import choprender.render3d.opengl.ChopTextureParam;
import choprender.render3d.opengl.GL;
import choprender.render3d.shaderexp.opengl.ChopGL;
import choprender.render3d.opengl.GL.GLTexture;
import glm.Mat4;
import glm.Vec3;
import chop.math.Util;
import choprender.render3d.opengl.GL.Float32Array;

/**
 * ...
 * @author Ohmnivore
 */
class ShaderSSAOBlend extends ChopQuadProgram
{
	public var blended:ChopTexture;
	
	public function new(C:Camera) 
	{
		super(C);
		
		type = ChopProgram.ONESHOT;
		
		var id:String = "assets/shader/ssao_blend_vertex.glsl";
		new ChopShader(id, Main.assets.getText(id), GL.VERTEX_SHADER).attach(prog);
		id = "assets/shader/ssao_blend_fragment.glsl";
		new ChopShader(id, Main.assets.getText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		inTextures.push(new ChopTextureDescriptor("gForwardLight", "gForwardLight"));
		inTextures.push(new ChopTextureDescriptor("gGaussianBlurV", "gSSAO"));
		
		blended = new ChopTexture("blended", GL.TEXTURE_2D, 0, GL.RGBA, C.width, C.height, GL.RGBA, GL.FLOAT);
		blended.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.LINEAR));
		blended.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.LINEAR));
		outTextures.push(blended);
	}
}