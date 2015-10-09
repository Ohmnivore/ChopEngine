package choprender.loader.chop;

import choprender.loader.Loader;
import choprender.model.data.Animation;
import choprender.model.data.Face;
import choprender.model.data.Frame;
import choprender.model.data.Material;
import choprender.model.data.Texture;
import choprender.model.data.Vertex;
import model.data.*;
import haxe.xml.Fast;
import haxe.io.Path;

/**
 * ...
 * @author Ohmnivore
 */
class ChopLoader extends Loader
{
	override public function loadSource(S:String):Void
	{
		super.loadSource(S);
		var d:Fast = new Fast(Xml.parse(source)).node.chopmesh;
		
		var materialsNode:Fast = d.node.materials;
		for (materialNode in materialsNode.nodes.material)
		{
			var mat:Material = new Material();
			mat.name = materialNode.att.name;
			mat.id = Std.parseInt(materialNode.att.ID);
			mat.useShading = parseBool(materialNode.att.use_shading);
			mat.shadowsCast = parseBool(materialNode.att.shadows_cast);
			mat.shadowsReceive = parseBool(materialNode.att.shadows_receive);
			mat.diffuseIntensity = Std.parseInt(materialNode.att.diffuse_intensity) / 100.0;
			mat.specularIntensity = Std.parseInt(materialNode.att.specular_intensity) / 100.0;
			mat.ambientIntensity = Std.parseInt(materialNode.att.ambient_intensity) / 100.0;
			mat.emit = Std.parseInt(materialNode.att.emit) / 100.0;
			mat.transparency = Std.parseInt(materialNode.att.transparency) / 100.0;
			mat.diffuseColor.x = Std.parseInt(materialNode.att.diffuse_r) / 100.0;
			mat.diffuseColor.y = Std.parseInt(materialNode.att.diffuse_g) / 100.0;
			mat.diffuseColor.z = Std.parseInt(materialNode.att.diffuse_b) / 100.0;
			mat.specularColor.x = Std.parseInt(materialNode.att.specular_r) / 100.0;
			mat.specularColor.y = Std.parseInt(materialNode.att.specular_g) / 100.0;
			mat.specularColor.z = Std.parseInt(materialNode.att.specular_b) / 100.0;
			data.materials.push(mat);
		}
		
		var texturesNode:Fast = d.node.textures;
		for (textureNode in texturesNode.nodes.texture)
		{
			var tex:Texture = new Texture();
			tex.name = textureNode.att.name;
			tex.id = Std.parseInt(textureNode.att.ID);
			tex.filename = textureNode.att.filename;
			tex.filepath = Path.join([Path.directory(path), tex.filename]);
			tex.read(tex.filepath);
			data.textures.push(tex);
		}
		
		var facesNode:Fast = d.node.faces;
		for (faceNode in facesNode.nodes.face)
		{
			var face:Face = new Face();
			face.matID = Std.parseInt(faceNode.att.material_id);
			face.textureID = Std.parseInt(faceNode.att.texture_id);
			face.geomIdx.push(Std.parseInt(faceNode.att.vertex1_id));
			face.geomIdx.push(Std.parseInt(faceNode.att.vertex2_id));
			face.geomIdx.push(Std.parseInt(faceNode.att.vertex3_id));
			face.normal.push(Std.parseFloat(faceNode.att.normal_x));
			face.normal.push(Std.parseFloat(faceNode.att.normal_y));
			face.normal.push(Std.parseFloat(faceNode.att.normal_z));
			
			face.uv1.push(Std.parseFloat(faceNode.att.u1));
			face.uv1.push(Std.parseFloat(faceNode.att.v1));
			face.uv2.push(Std.parseFloat(faceNode.att.u2));
			face.uv2.push(Std.parseFloat(faceNode.att.v2));
			face.uv3.push(Std.parseFloat(faceNode.att.u3));
			face.uv3.push(Std.parseFloat(faceNode.att.v3));
			
			data.faces.push(face);
		}
		
		var animsNode:Fast = d.node.animations;
		for (animNode in animsNode.nodes.animation)
		{
			var anim:Animation = new Animation();
			anim.name = animNode.att.name;
			anim.length = Std.parseInt(animNode.att.length_ms);
			
			for (frameNode in animNode.nodes.frame)
			{
				var frame:Frame = new Frame();
				frame.id = Std.parseInt(frameNode.att.index);
				frame.time = Std.parseInt(frameNode.att.time_ms);
				
				for (vertNode in frameNode.nodes.vert)
				{
					var vert:Vertex = new Vertex();
					vert.tagID = Std.parseInt(vertNode.att.tag_id);
					vert.x = Std.parseFloat(vertNode.att.x);
					vert.y = Std.parseFloat(vertNode.att.y);
					vert.z = Std.parseFloat(vertNode.att.z);
					vert.nx = Std.parseFloat(vertNode.att.normal_x);
					vert.ny = Std.parseFloat(vertNode.att.normal_y);
					vert.nz = Std.parseFloat(vertNode.att.normal_z);
					frame.vertices.push(vert);
				}
				anim.frames.push(frame);
			}
			data.anims.set(anim.name, anim);
		}
	}
	private function parseBool(S:String):Bool
	{
		return S == "True";
	}
}