package choprender.model.loader.obj;

import choprender.model.data.ModelData;

/**
 * ...
 * @author Ohmnivore
 */
class ObjLoader
{
	public var path:String;
	public var source:String;
	public var data:ModelData;
	
	public var pathMtl:String;
	public var sourceMtl:String;
	
	public function new()
	{
		
	}
	
	public function loadFile(P:String, PMtl:String = null):Void 
	{
		path = P;
		var source:String = Main.assets.getText(P);
		pathMtl = PMtl;
		var sourceMtl:String = null;
		if (pathMtl != null)
			sourceMtl = Main.assets.getText(PMtl);
		loadSource(source, sourceMtl);
	}
	
	public function loadSource(Source:String, SourceMtl:String = null):Void
	{
		source = Source;
		sourceMtl = SourceMtl;
		
		var lexerMtl:MtlLexer = new MtlLexer();
		var parserMtl:MtlParser = new MtlParser();
		if (sourceMtl != null)
		{
			lexerMtl.tokenize(sourceMtl);
			parserMtl.parse(lexerMtl.tokens);
		}
		
		var lexer:ObjLexer = new ObjLexer();
		lexer.tokenize(source);
		var parser:ObjParser = new ObjParser();
		if (sourceMtl != null)
			parser.mats = parserMtl.mats;
		parser.parse(lexer.tokens);
		data = parser.data;
	}
}