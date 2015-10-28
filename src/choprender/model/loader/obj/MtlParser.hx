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
class MtlParser
{
	public var tokens:Array<Token>;
	public var mats:Array<Material>;
	
	private var curMat:Material;
	private var p:Int;
	
	public function new() 
	{
		init();
	}
	
	public function init():Void
	{
		p = 0;
		tokens = [];
		mats = [];
	}
	
	public function parse(Tokens:Array<Token>):Void
	{
		init();
		tokens = Tokens;
		
		while (p < tokens.length && LA(1) != MtlLexer.LEOF)
		{
			while (LA(1) != MtlLexer.LNEWLINE && LA(1) != MtlLexer.LEOF)
			{
				if (LA(1) == MtlLexer.LNEWMTL)
				{
					consume();
					parseNewMtl();
				}
				else if (LA(1) == MtlLexer.LDIFFUSE)
				{
					consume();
					parseDiffuse();
				}
				else if (LA(1) == MtlLexer.LSPEC)
				{
					consume();
					parseSpecular();
				}
				else if (LA(1) == MtlLexer.LTRANS)
				{
					consume();
					parseTrans();
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
	
	public function parseNewMtl():Void
	{
		curMat = new Material();
		
		curMat.name = LT(1).text;
		curMat.id = mats.length;
		curMat.ambientIntensity = 0.3;
		curMat.diffuseIntensity = 1.0;
		curMat.specularIntensity = 1.0;
		curMat.emit = 0.0;
		curMat.useShading = true;
		curMat.shadowsCast = true;
		curMat.shadowsReceive = true;
		curMat.transparency = 1.0;
		
		consume();
		mats.push(curMat);
	}
	
	public function parseDiffuse():Void
	{
		var r:Float = Std.parseFloat(LT(1).text);
		consume();
		var g:Float = Std.parseFloat(LT(1).text);
		consume();
		var b:Float = Std.parseFloat(LT(1).text);
		consume();
		
		curMat.diffuseColor.set(r, g, b);
	}
	
	public function parseSpecular():Void
	{
		var r:Float = Std.parseFloat(LT(1).text);
		consume();
		var g:Float = Std.parseFloat(LT(1).text);
		consume();
		var b:Float = Std.parseFloat(LT(1).text);
		consume();
		
		curMat.specularColor.set(r, g, b);
	}
	
	public function parseTrans():Void
	{
		var trans:Float = Std.parseFloat(LT(1).text);
		consume();
		
		curMat.transparency = trans;
	}
}