package choprender.text.loader;

import chop.assets.Assets;
import choprender.model.data.Bitmap;
import choprender.text.loader.FontBuilderNGL.Font;
import choprender.text.loader.FontBuilderNGL.FontChar;
import haxe.xml.Fast;
import snow.types.Types.AssetImage;
import haxe.io.Path;
import snow.api.Promise;
import snow.types.Types.ImageInfo;

/**
 * ...
 * @author Ohmnivore
 */
class FontBuilderNGL
{
	public var path:String;
	public var source:String;
	public var font:Font;
	
	public function new() 
	{
		
	}
	
	public function loadFile(P:String):Void
	{
		path = P;
		var source:String = Assets.getText(P);
		loadSource(source);
	}
	
	public function loadSource(Source:String):Void
	{
		source = Source;
		font = new Font();
		
		var f:Fast = new Fast(Xml.parse(source));
		var fontNode:Fast = f.node.font;
		var descriptionNode:Fast = fontNode.node.description;
		var metricsNode:Fast = fontNode.node.metrics;
		var textureNode:Fast = fontNode.node.texture;
		var charsNode:Fast = fontNode.node.chars;
		
		font.size = Std.parseInt(descriptionNode.att.size);
		font.family = descriptionNode.att.family;
		
		font.ascender = Std.parseInt(metricsNode.att.ascender);
		font.height = Std.parseInt(metricsNode.att.height);
		font.descender = Std.parseInt(metricsNode.att.descender);
		
		font.texWidth = Std.parseInt(textureNode.att.width);
		font.texHeight = Std.parseInt(textureNode.att.height);
		font.texFile = textureNode.att.file;
		
		for (cNode in charsNode.nodes.char)
		{
			var c:FontChar = new FontChar();
			c.offsetX = Std.parseInt(cNode.att.offset_x);
			c.offsetY = Std.parseInt(cNode.att.offset_y);
			c.advance = Std.parseInt(cNode.att.advance);
			c.rectX = Std.parseInt(cNode.att.rect_x);
			c.rectY = Std.parseInt(cNode.att.rect_y);
			c.rectWidth = Std.parseInt(cNode.att.rect_w);
			c.rectHeight = Std.parseInt(cNode.att.rect_h);
			c.id = cNode.att.id;
			
			font.chars.set(c.id, c);
		}
		
		var fullPath = Path.join([Path.directory(path), font.texFile]);
		var img:ImageInfo = Assets.getImage(fullPath);
		font.tex = new Bitmap();
		font.tex.pixels = img.pixels;
		font.tex.width = img.width;
		font.tex.height = img.height;
	}
}

class Font
{
	public var size:Int;
	public var family:String;
	public var ascender:Int;
	public var height:Int;
	public var descender:Int;
	public var texWidth:Int;
	public var texHeight:Int;
	public var texFile:String;
	public var tex:Bitmap;
	
	public var chars:Map<String, FontChar>;
	
	public function new() 
	{
		chars = new Map<String, FontChar>();
	}
}

class FontChar
{
	public var offsetX:Int;
	public var offsetY:Int;
	public var advance:Int;
	public var rectX:Int;
	public var rectY:Int;
	public var rectWidth:Int;
	public var rectHeight:Int;
	public var id:String;
	
	public function new() 
	{
		
	}
}