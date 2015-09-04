package chop.render3d.shader;

import chop.model.data.Face;
import chop.model.data.Vertex;
import chop.model.Model;
import chop.render3d.Camera;
import chop.render3d.light.Light;
import chop.render3d.opengl.GL;
import chop.render3d.opengl.ChopGL;
import chop.render3d.opengl.GL.GLTexture;
import hxmath.math.MathUtil;
import hxmath.math.Matrix4x4;
import hxmath.math.Vector3;
import chop.assets.Assets;
import chop.math.Util;
import chop.render3d.opengl.GL.Float32Array;
import chop.gen.Global;

/**
 * ...
 * @author Ohmnivore
 */
class ShaderLights extends ChopProgram
{
	public var gLight:ChopTexture;
	
	public function new(C:Camera) 
	{
		super(C);
		
		type = ChopProgram.ONESHOT;
		
		var id:String = "assets/shader/light_vertex.glsl";
		new ChopShader(id, Assets.loadText(id), GL.VERTEX_SHADER).attach(prog);
		id = "assets/shader/light_fragment.glsl";
		new ChopShader(id, Assets.loadText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		inTextures.push(new ChopTextureDescriptor("gPosition", "gPosition"));
		inTextures.push(new ChopTextureDescriptor("gNormal", "gNormal"));
		inTextures.push(new ChopTextureDescriptor("gDiffuse", "gDiffuse"));
		inTextures.push(new ChopTextureDescriptor("gSpec", "gSpec"));
		
		gLight = new ChopTexture("gLight", GL.TEXTURE_2D, 0, ChopGL.RGB16F, C.width, C.height, GL.RGB, GL.FLOAT);
		//gLight = new ChopMultisampleTexture("gLight", ChopGL.TEXTURE_2D_MULTISAMPLE, 4, GL.RGB, C.width, C.height, GL.RGB, GL.FLOAT);
		gLight.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.LINEAR));
		gLight.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.LINEAR));
		outTextures.push(gLight);
	}
	
	override public function render(M:Array<Model>, C:Camera, Mgr:ChopProgramMgr):Void 
	{
		super.render(M, C, Mgr);
		
		GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
		
		// Transformation matrices
		GLUtil.setUniform(prog, "v", C.viewMatrix);
		GLUtil.setUniform(prog, "p", C.projectionMatrix);
		GLUtil.setUniform(prog, "viewPos", Util.Vector3ToGL(C.pos));
		
		// LightState globals
		GLUtil.setUniform(prog, "ambientColor", Global.state.lights.ambientColor);
		//GLUtil.setUniform(prog, "ambientIntensity", Global.state.lights.ambientIntensity);
		//GLUtil.setUniform(prog, "gamma", Global.state.lights.gamma);
		GLUtil.setFloat(GLUtil.getLocation(prog, "ambientIntensity"), Global.state.lights.ambientIntensity);
		GLUtil.setFloat(GLUtil.getLocation(prog, "gamma"), Global.state.lights.gamma);
		
		// Lights uniforms
		//GLUtil.setUniform(prog, "numLights", Global.state.lights.lights.length);
		GLUtil.setInt(GLUtil.getLocation(prog, "numLights"), Global.state.lights.lights.length);
		for (i in 0...Global.state.lights.lights.length)
		{
			var light:Light = Global.state.lights.lights[i];
			light.setUniforms(prog, i);
		}
		
		var vData:Array<Float> = [];
		vData = [
			-1.0, -1.0, 0.0,
		    1.0, -1.0, 0.0,
		    -1.0, 1.0, 0.0,
		    -1.0, 1.0, 0.0,
		    1.0, -1.0, 0.0,
		    1.0,  1.0, 0.0
		];
		var dataBuffer:GLBuffer = GL.createBuffer();
		GL.bindBuffer(GL.ARRAY_BUFFER, dataBuffer);
		GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(vData), GL.STATIC_DRAW);
		
		GL.enableVertexAttribArray(0);
		GL.vertexAttribPointer(0, 3, GL.FLOAT, false, 0, 0);
		
		GL.drawArrays(GL.TRIANGLES, 0, 6);
		GL.disableVertexAttribArray(0);
	}
}