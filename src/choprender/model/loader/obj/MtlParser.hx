package choprender.model.loader.obj;

import chop.util.Color;
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
class MtlParser extends Parser
{
	public var mats:Array<Material>;
	private var curMat:Material;
	
	override public function init():Void
	{
		super.init();
		mats = [];
	}
	
	override public function parse(Tokens:Array<Token>):Void
	{
		super.parse(Tokens);
		
		while (p < tokens.length && LA(1) != Lexer.LEOF)
		{
			while (LA(1) != MtlLexer.LNEWLINE && LA(1) != Lexer.LEOF)
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
	
	private function parseNewMtl():Void
	{
		curMat = new Material();
		
		curMat.name = match(MtlLexer.LMTLNAME).text;
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
	
	private function getRGB():Color
	{
		var r:Color = new Color();
		r.r = Std.parseFloat(match(Lexer.LFLOAT).text);
		consume();
		r.g = Std.parseFloat(match(Lexer.LFLOAT).text);
		consume();
		r.b = Std.parseFloat(match(Lexer.LFLOAT).text);
		consume();
		return r;
	}
	
	private function parseDiffuse():Void
	{
		var rgb:Color = getRGB();
		curMat.diffuseColor.copy(rgb);
	}
	
	private function parseSpecular():Void
	{
		var rgb:Color = getRGB();
		curMat.specularColor.copy(rgb);
	}
	
	private function parseTrans():Void
	{
		var trans:Float = Std.parseFloat(match(Lexer.LFLOAT).text);
		consume();
		curMat.transparency = trans;
	}
}