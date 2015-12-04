package choprender.render3d.shader;

import chop.math.Mat4;
import chop.math.Util;
import chop.math.Vec3;
import choprender.model.data.Face;
import choprender.model.data.ModelData;
import choprender.model.data.Texture;
import choprender.model.data.Vertex;
import choprender.model.loader.obj.ObjLoader;
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
class ShaderSkyBoxLegacy extends ChopProgram
{
	public var gSkyBoxLegacy:ChopTexture;
	public var boxTex:ChopTexture;
	public var box:ModelData;
	
	private var fovBackup:Float;
	
	public function new(C:Camera) 
	{
		super(C);
		
		type = ChopProgram.ONESHOT;
		
		var id:String = "assets/shader/skybox_legacy_vertex.glsl";
		new ChopShader(id, Main.assets.getText(id), GL.VERTEX_SHADER).attach(prog);
		id = "assets/shader/skybox_legacy_fragment.glsl";
		new ChopShader(id, Main.assets.getText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		gSkyBoxLegacy = new ChopTexture("gSkyBoxLegacy", GL.TEXTURE_2D, 0, GL.RGBA, C.width, C.height, GL.RGB, GL.FLOAT);
		gSkyBoxLegacy.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.LINEAR));
		gSkyBoxLegacy.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.LINEAR));
		outTextures.push(gSkyBoxLegacy);
		
		var objLoader:ObjLoader = new ObjLoader();
		objLoader.loadFile("assets/obj/skybox.obj", null);
		
		box = objLoader.data;
	}
	
	public function loadSkyBoxFile(Img:String):Void
	{
		var t:Texture = new Texture();
		t.loadFile(Img);
		boxTex = t.choptex;
		
		boxTex.params[0].param = GL.LINEAR;
		boxTex.params[1].param = GL.LINEAR;
		boxTex.updateParams();
	}
	
	override public function preRender(Mgr:ChopProgramMgr):Void 
	{
		super.preRender(Mgr);
		GL.depthMask(false);
		fovBackup = Mgr.cam.FOV;
		Mgr.cam.FOV = 60.0;
		Mgr.cam.computeProjectionMatrix();
	}
	
	override public function postRender(Mgr:ChopProgramMgr):Void 
	{
		super.postRender(Mgr);
		GL.depthMask(true);
		Mgr.cam.FOV = fovBackup;
		Mgr.cam.computeProjectionMatrix();
	}
	
	override public function render(Models:Array<Model>, C:Camera, Mgr:ChopProgramMgr):Void 
	{
		super.render(Models, C, Mgr);
		
		if (boxTex != null)
		{
			GL.activeTexture(GL.TEXTURE7);
			GL.bindTexture(GL.TEXTURE_2D, boxTex.texture);
			GLUtil.setInt(GLUtil.getLocation(prog, "skybox"), 7);
			
			// Transformation matrices
			GLUtil.setUniform(prog, "view", C.viewMatrix);
			GLUtil.setUniform(prog, "projection", C.projectionMatrix);
			
			var vData:Array<Float> = [];
			for (f in box.faces)
			{
				var v1:Vertex = box.anims.get("static").frames[0].vertices[f.geomIdx[0]];
				var v2:Vertex = box.anims.get("static").frames[0].vertices[f.geomIdx[1]];
				var v3:Vertex = box.anims.get("static").frames[0].vertices[f.geomIdx[2]];
				vData.push(v1.x);
				vData.push(v1.y);
				vData.push(v1.z);
				vData.push(f.uv1[0]);
				vData.push(f.uv1[1]);
				vData.push(v2.x);
				vData.push(v2.y);
				vData.push(v2.z);
				vData.push(f.uv2[0]);
				vData.push(f.uv2[1]);
				vData.push(v3.x);
				vData.push(v3.y);
				vData.push(v3.z);
				vData.push(f.uv3[0]);
				vData.push(f.uv3[1]);
			}
			
			var vertexBuffer:GLBuffer = GL.createBuffer();
			GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
			GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(vData), GL.STATIC_DRAW);
			
			var sizeOfFloat:Int = 4;
			GL.enableVertexAttribArray(0);
			GL.bindAttribLocation(prog, 0, "position");
			GL.vertexAttribPointer(0, 3, GL.FLOAT, false, sizeOfFloat * 5, sizeOfFloat * 0);
			GL.enableVertexAttribArray(1);
			GL.bindAttribLocation(prog, 1, "uv");
			GL.vertexAttribPointer(1, 2, GL.FLOAT, false, sizeOfFloat * 5, sizeOfFloat * 3);
			
			GL.drawArrays(GL.TRIANGLES, 0, Std.int(vData.length / 5));
			
			GL.disableVertexAttribArray(0);
			GL.disableVertexAttribArray(1);
			GL.deleteBuffer(vertexBuffer);
		}
	}
}