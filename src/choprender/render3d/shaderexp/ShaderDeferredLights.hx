package choprender.render3d.shaderexp;

import choprender.render3d.shader.*;
import choprender.GlobalRender;
import choprender.model.data.Face;
import choprender.model.data.Vertex;
import choprender.model.Model;
import choprender.render3d.Camera;
import choprender.render3d.light.Light;
import choprender.render3d.opengl.GL;
import choprender.render3d.shaderexp.opengl.ChopGL;
import choprender.render3d.opengl.GL.GLTexture;
import choprender.render3d.opengl.GLUtil;
import chop.math.Mat4;
import chop.math.Vec3;
import chop.math.Util;
import choprender.render3d.opengl.GL.Float32Array;

/**
 * ...
 * @author Ohmnivore
 */
class ShaderDeferredLights extends ChopQuadProgram
{
	public var gLight:ChopTexture;
	
	public function new(C:Camera) 
	{
		super(C);
		
		type = ChopProgram.ONESHOT;
		
		var id:String = "assets/shader/deferred_light_vertex.glsl";
		new ChopShader(id, Main.assets.getText(id), GL.VERTEX_SHADER).attach(prog);
		id = "assets/shader/deferred_light_fragment.glsl";
		new ChopShader(id, Main.assets.getText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		inTextures.push(new ChopTextureDescriptor("gPosition", "gPosition"));
		inTextures.push(new ChopTextureDescriptor("gNormal", "gNormal"));
		inTextures.push(new ChopTextureDescriptor("gDiffuse", "gDiffuse"));
		inTextures.push(new ChopTextureDescriptor("gSpec", "gSpec"));
		inTextures.push(new ChopTextureDescriptor("gRealPosition", "gRealPosition"));
		
		gLight = new ChopTexture("gLight", GL.TEXTURE_2D, 0, ChopGL.RGB16F, C.width, C.height, GL.RGB, GL.FLOAT);
		gLight.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.LINEAR));
		gLight.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.LINEAR));
		outTextures.push(gLight);
	}
	
	override public function render(M:Array<Model>, C:Camera, Mgr:ChopProgramMgr):Void 
	{
		// Transformation matrices
		GLUtil.setUniform(prog, "viewPos", C.pos);
		
		// LightState globals
		GLUtil.setUniform(prog, "ambientColor", GlobalRender.lights.ambientColor);
		GLUtil.setFloat(GLUtil.getLocation(prog, "ambientIntensity"), GlobalRender.lights.ambientIntensity);
		GLUtil.setFloat(GLUtil.getLocation(prog, "gamma"), GlobalRender.lights.gamma);
		
		// Lights uniforms
		GLUtil.setInt(GLUtil.getLocation(prog, "numLights"), GlobalRender.lights.lights.length);
		for (i in 0...GlobalRender.lights.lights.length)
		{
			var light:Light = GlobalRender.lights.lights[i];
			light.setUniforms(prog, i);
		}
		
		super.render(M, C, Mgr);
	}
}