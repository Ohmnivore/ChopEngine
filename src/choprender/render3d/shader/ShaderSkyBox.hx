package choprender.render3d.shader;

import chop.math.Mat4;
import chop.math.Util;
import chop.math.Vec3;
import choprender.model.data.Face;
import choprender.model.data.Texture;
import choprender.model.data.Vertex;
import choprender.model.Model;
import choprender.render3d.Camera;
import choprender.render3d.light.Light;
import choprender.render3d.opengl.ChopProgram;
import choprender.render3d.opengl.ChopProgramMgr;
import choprender.render3d.opengl.ChopShader;
import choprender.render3d.opengl.ChopTexture;
import choprender.render3d.opengl.ChopTextureParam;
import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.GL.Float32Array;
import choprender.render3d.opengl.GLUtil;

/**
 * ...
 * @author Ohmnivore
 */
class ShaderSkyBox extends ChopProgram
{
	public var gSkyBox:ChopTexture;
	public var boxTex:ChopTexture;
	
	public function new(C:Camera) 
	{
		super(C);
		
		type = ChopProgram.ONESHOT;
		
		var id:String = "assets/shader/skybox_vertex.glsl";
		new ChopShader(id, Main.assets.getText(id), GL.VERTEX_SHADER).attach(prog);
		id = "assets/shader/skybox_fragment.glsl";
		new ChopShader(id, Main.assets.getText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		gSkyBox = new ChopTexture("gSkyBox", GL.TEXTURE_2D, 0, GL.RGBA, C.width, C.height, GL.RGB, GL.FLOAT);
		gSkyBox.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.LINEAR));
		gSkyBox.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.LINEAR));
		outTextures.push(gSkyBox);
	}
	
	override public function preRender(Mgr:ChopProgramMgr):Void 
	{
		super.preRender(Mgr);
		GL.depthMask(false);
	}
	
	override public function postRender(Mgr:ChopProgramMgr):Void 
	{
		super.postRender(Mgr);
		GL.depthMask(true);
	}
	
	override public function render(Models:Array<Model>, C:Camera, Mgr:ChopProgramMgr):Void 
	{
		super.render(Models, C, Mgr);
		
		if (boxTex != null)
		{
			GL.activeTexture(GL.TEXTURE7);
			GL.bindTexture(GL.TEXTURE_CUBE_MAP, boxTex.texture);
			GLUtil.setInt(GLUtil.getLocation(prog, "skybox"), 7);
			
			// Transformation matrices
			GLUtil.setUniform(prog, "view", C.viewMatrix);
			GLUtil.setUniform(prog, "projection", C.projectionMatrix);
			
			var vData:Array<Float> = getVertices();
			
			var vertexBuffer:GLBuffer = GL.createBuffer();
			GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
			GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(vData), GL.STATIC_DRAW);
			
			var sizeOfFloat:Int = 4;
			GL.enableVertexAttribArray(0);
			GL.bindAttribLocation(prog, 0, "position");
			GL.vertexAttribPointer(0, 3, GL.FLOAT, false, sizeOfFloat * 3, sizeOfFloat * 0);
			
			GL.drawArrays(GL.TRIANGLES, 0, Std.int(vData.length / 3));
			
			GL.disableVertexAttribArray(0);
			GL.deleteBuffer(vertexBuffer);
		}
	}
	
	public function getVertices():Array<Float>
	{
		return [
		// Positions
		-1.0,  1.0, -1.0,
		-1.0, -1.0, -1.0,
		 1.0, -1.0, -1.0,
		 1.0, -1.0, -1.0,
		 1.0,  1.0, -1.0,
		-1.0,  1.0, -1.0,
		
		-1.0, -1.0,  1.0,
		-1.0, -1.0, -1.0,
		-1.0,  1.0, -1.0,
		-1.0,  1.0, -1.0,
		-1.0,  1.0,  1.0,
		-1.0, -1.0,  1.0,
		
		 1.0, -1.0, -1.0,
		 1.0, -1.0,  1.0,
		 1.0,  1.0,  1.0,
		 1.0,  1.0,  1.0,
		 1.0,  1.0, -1.0,
		 1.0, -1.0, -1.0,
		
		-1.0, -1.0,  1.0,
		-1.0,  1.0,  1.0,
		1.0,  1.0,  1.0,
		1.0,  1.0,  1.0,
		1.0, -1.0,  1.0,
		-1.0, -1.0,  1.0,
		
		-1.0,  1.0, -1.0,
		 1.0,  1.0, -1.0,
		 1.0,  1.0,  1.0,
		 1.0,  1.0,  1.0,
		-1.0,  1.0,  1.0,
		-1.0,  1.0, -1.0,
		
		-1.0, -1.0, -1.0,
		-1.0, -1.0,  1.0,
		 1.0, -1.0, -1.0,
		 1.0, -1.0, -1.0,
		-1.0, -1.0,  1.0,
		 1.0, -1.0,  1.0
		];
	}
}