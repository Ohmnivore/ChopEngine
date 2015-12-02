package choprender.render3d.cubemap;
import choprender.model.data.Texture;
import choprender.render3d.opengl.ChopTexture;
import choprender.render3d.opengl.GL;

/**
 * ...
 * @author Ohmnivore
 */
class Cubemap
{
	public var mainTex:Texture;
	public var texWidth:Int;
	public var texHeight:Int;
	public var cubeTex:ChopTexture;
	
	public function new(Img:String)
	{
		mainTex = new Texture();
		mainTex.loadFile(Img);
		
		texWidth = Math.floor(mainTex.data.width / 4.0);
		texHeight = texWidth;
		
		cubeTex = new ChopTexture("CubeMap", GL.TEXTURE_CUBE_MAP, 0, GL.RGBA, texWidth, texHeight, GL.RGBA, GL.UNSIGNED_BYTE, mainTex.data.getSubRect(texWidth * 2, texHeight, texWidth, texHeight));
		applyTex(cubeTex, 0, mainTex.data.getSubRect(texWidth * 2, texHeight, texWidth, texHeight)); //right
		applyTex(cubeTex, 1, mainTex.data.getSubRect(0, texHeight, texWidth, texHeight)); //left
		applyTex(cubeTex, 2, mainTex.data.getSubRect(texWidth, 0, texWidth, texHeight)); //top
		applyTex(cubeTex, 3, mainTex.data.getSubRect(texWidth, texHeight * 2, texWidth, texHeight)); //bottom
		applyTex(cubeTex, 4, mainTex.data.getSubRect(texWidth * 3, texHeight, texWidth, texHeight)); //back
		applyTex(cubeTex, 5, mainTex.data.getSubRect(texWidth, texHeight, texWidth, texHeight)); //front
	}
	
	private function applyTex(T:ChopTexture, Offset:Int, Pixels:ArrayBufferView):Void
	{
		T.image2D(GL.TEXTURE_CUBE_MAP_POSITIVE_X + Offset, texWidth, texHeight, Pixels);
	}
}