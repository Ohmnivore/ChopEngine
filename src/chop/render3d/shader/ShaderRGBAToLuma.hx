package chop.render3d.shader;

import chop.model.data.Face;
import chop.model.data.Vertex;
import chop.model.Model;
import chop.render3d.Camera;
import chop.render3d.opengl.GL;
import chop.render3d.opengl.ChopGL;
import chop.render3d.opengl.GL.GLTexture;
import hxmath.math.MathUtil;
import hxmath.math.Matrix4x4;
import hxmath.math.Vector3;
import chop.assets.Assets;
import chop.math.Util;
import chop.render3d.opengl.GL.Float32Array;

/**
 * ...
 * @author Ohmnivore
 */
class ShaderRGBAToLuma extends ChopQuadProgram
{
	public var gLuma:ChopTexture;
	
	public function new(C:Camera) 
	{
		super(C);
		
		type = ChopProgram.ONESHOT;
		
		var id:String = "assets/shader/rgba_to_luma_vertex.glsl";
		new ChopShader(id, Assets.loadText(id), GL.VERTEX_SHADER).attach(prog);
		id = "assets/shader/rgba_to_luma_fragment.glsl";
		new ChopShader(id, Assets.loadText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		inTextures.push(new ChopTextureDescriptor("gLight", "renderedTexture"));
		
		gLuma = new ChopTexture("gLuma", GL.TEXTURE_2D, 0, ChopGL.RGB16F, C.width, C.height, GL.RGB, GL.FLOAT);
		gLuma.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.LINEAR));
		gLuma.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.LINEAR));
		outTextures.push(gLuma);
	}
}