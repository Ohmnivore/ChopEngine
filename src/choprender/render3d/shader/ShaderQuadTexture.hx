package choprender.render3d.shader;

import choprender.model.data.Face;
import choprender.model.data.Vertex;
import choprender.model.Model;
import choprender.render3d.Camera;
import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.ChopGL;
import choprender.render3d.opengl.GL.GLTexture;
import com.rsredsq.math.Mat4;
import com.rsredsq.math.Vec3;
import chop.assets.Assets;
import chop.math.Util;
import choprender.render3d.opengl.GL.Float32Array;

/**
 * ...
 * @author Ohmnivore
 */
class ShaderQuadTexture extends ChopQuadProgram
{
	public function new(C:Camera) 
	{
		super(C);
		
		type = ChopProgram.ONESHOT;
		
		var id:String = "assets/shader/quad_texture_vertex.glsl";
		new ChopShader(id, Assets.loadText(id), GL.VERTEX_SHADER).attach(prog);
		id = "assets/shader/quad_texture_fragment.glsl";
		new ChopShader(id, Assets.loadText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		inTextures.push(new ChopTextureDescriptor("gPosition", "renderedTexture"));
	}
}