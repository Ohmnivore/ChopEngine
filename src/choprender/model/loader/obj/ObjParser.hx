package choprender.model.loader.obj;

import choprender.model.data.Animation;
import choprender.model.data.Face;
import choprender.model.data.Frame;
import choprender.model.data.Material;
import choprender.model.data.Vertex;
import model.data.*;
import choprender.model.data.ModelData;

/**
 * ...
 * @author Ohmnivore
 */
class ObjParser
{
	public var tokens:Array<Token>;
	public var data:ModelData;
	
	private var curMat:Int;
	private var p:Int;
	
	public function new() 
	{
		init();
	}
	
	public function init():Void
	{
		p = 0;
		data = new ModelData();
		tokens = [];
		curMat = 0;
		
		var mat:Material = new Material();
		mat.name = "default";
		mat.id = 0;
		mat.useShading = true;
		mat.shadowsCast = true;
		mat.shadowsReceive = true;
		mat.diffuseColor.r = 1.0;
		mat.diffuseColor.g = 1.0;
		mat.diffuseColor.b = 1.0;
		mat.diffuseIntensity = 1.0;
		mat.specularColor.r = 1.0;
		mat.specularColor.g = 1.0;
		mat.specularColor.b = 1.0;
		mat.specularIntensity = 0.5;
		mat.ambientIntensity = 0.3;
		mat.emit = 0;
		mat.transparency = 1.0;
		data.materials.push(mat);
		
		var anim:Animation = new Animation();
		anim.name = "static";
		anim.length = 0;
		data.anims.set(anim.name, anim);
		
		var frame:Frame = new Frame();
		frame.id = 0;
		frame.time = 0;
		anim.frames.push(frame);
	}
	
	public function parse(Tokens:Array<Token>, Mats:Array<Material>):Void
	{
		init();
		data.materials = Mats;
		tokens = Tokens;
		
		while (p < tokens.length && LA(1) != ObjLexer.LEOF)
		{
			while (LA(1) != ObjLexer.LNEWLINE && LA(1) != ObjLexer.LEOF)
			{
				if (LA(1) == ObjLexer.LGEOM)
				{
					consume();
					parseGeom();
				}
				if (LA(1) == ObjLexer.LNORM)
				{
					consume();
					parseNorm();
				}
				if (LA(1) == ObjLexer.LTEX)
				{
					consume();
					parseTex();
				}
				if (LA(1) == ObjLexer.LPARAM)
				{
					consume();
					parseParam();
				}
				else if (LA(1) == ObjLexer.LFACE)
				{
					consume();
					parseFace();
				}
				else if (LA(1) == ObjLexer.LUSEMTL)
				{
					consume();
					parseUseMtl();
				}
				else
				{
					consume();
				}
			}
			consume();
		}
	}
	
	public function consume():Void
	{
		p++;
	}
	
	public function LT(I:Int):Token
	{
		return tokens[p + I - 1];
	}
	
	public function LA(I:Int):Int
	{
		return LT(I).type;
	}
	
	public function parseGeom():Void
	{
		var pos:Array<Float> = [0.0, 0.0, 0.0, 0.0];
		var i:Int = 0;
		while (LA(1) != ObjLexer.LEOF && LA(1) != ObjLexer.LNEWLINE)
		{
			pos[i] = Std.parseFloat(LT(1).text);
			consume();
			i++;
		}
		
		var vert:Vertex = new Vertex();
		vert.tagID = -1;
		vert.x = pos[0];
		vert.y = pos[1];
		vert.z = pos[2];
		
		data.anims.get("static").frames[0].vertices.push(vert);
	}
	
	public function parseNorm():Void
	{
		
	}
	
	public function parseTex():Void
	{
		
	}
	
	public function parseParam():Void
	{
		
	}
	
	public function parseFace():Void
	{
		var f:Face = new Face();
		f.matID = curMat;
		
		while (LA(1) != ObjLexer.LEOF && LA(1) != ObjLexer.LNEWLINE)
		{
			parseIdx(f);
		}
		
		//convertNegativeIdx(f.geomIdx);
		
		f.geomIdx[0]--;
		f.geomIdx[1]--;
		f.geomIdx[2]--;
		
		data.faces.push(f);
	}
	
	public function convertNegativeIdx(Vert:Array<Int>, TotalLength:Int):Void
	{
		for (i in 0...Vert.length)
		{
			var v:Int = Vert[i];
			if (v < 0)
			{
				v = TotalLength - v + 1;
				Vert[i] = v;
			}
		}
	}
	
	public function parseIdx(F:Face):Void
	{
		var vid:Int = 0;
		var texid:Int = 0;
		var normid:Int = 0;
		
		vid = Std.parseInt(LT(1).text);
		consume();
		
		if (LA(1) == ObjLexer.LFSLASH)
		{
			consume();
			if (LA(1) == ObjLexer.LINT)
			{
				texid = Std.parseInt(LT(1).text);
				consume();
				
				if (LA(1) == ObjLexer.LFSLASH)
				{
					consume();
					normid = Std.parseInt(LT(1).text);
					consume();
				}
			}
			else if (LA(1) == ObjLexer.LFSLASH)
			{
				consume();
				normid = Std.parseInt(LT(1).text);
				consume();
			}
		}
		
		F.geomIdx.push(vid);
		// f->texIdx.push_back(texid);
		// f->normIdx.push_back(normid);
	}
	
	public function parseUseMtl():Void
	{
		var name:String = LT(1).text;
		consume();
		
		for (mat in data.materials)
		{
			if (mat.name == name)
			{
				curMat = mat.id;
				trace(mat.id);
				break;
			}
		}
	}
}