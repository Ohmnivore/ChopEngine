package choprender.model.data;

import chop.math.Vec2;
import chop.math.Vec4;
import choprender.render3d.opengl.GL.Uint8Array;
import snow.api.buffers.ArrayBufferIO;

/**
 * ...
 * @author Ohmnivore
 */
class Bitmap
{
	public var pixels:Uint8Array;
	public var width:Int;
	public var height:Int;
	
	public function new() 
	{
		pixels = new Uint8Array([]);
		width = 0;
		height = 0;
	}
	
	public function copy(B:Bitmap):Void
	{
		pixels = new Uint8Array(B.pixels);
		width = B.width;
		height = B.height;
	}
	
	public function setSize(Width:Int, Height:Int):Void
	{
		var newSize:Int = Width * Height;
		var oldSize:Int = width * height;
		if (newSize > oldSize)
		{
			var newArr:Uint8Array = new Uint8Array(newSize * 4);
			for (y in 0...height)
			{
				for (x in 0...width)
				{
					var p:Array<Int> = getPixel(x, y);
					
					var id:Int = x * 4 + y * Width * 4;
					ArrayBufferIO.setUint8(newArr.buffer, id, p[0]);
					ArrayBufferIO.setUint8(newArr.buffer, id + 1, p[1]);
					ArrayBufferIO.setUint8(newArr.buffer, id + 2, p[2]);
					ArrayBufferIO.setUint8(newArr.buffer, id + 3, p[3]);
					
				}
			}
			pixels = newArr;
		}
		width = Width;
		height = Height;
	}
	
	public function getPixel(X:Int, Y:Int):Array<Int>
	{
		var id:Int = X * 4 + Y * width * 4;
		return [
			ArrayBufferIO.getUint8(pixels.buffer, id),
			ArrayBufferIO.getUint8(pixels.buffer, id + 1),
			ArrayBufferIO.getUint8(pixels.buffer, id + 2),
			ArrayBufferIO.getUint8(pixels.buffer, id + 3)
		];
	}
	
	public function setPixel(X:Int, Y:Int, Arr:Array<Int>):Void
	{
		var id:Int = X * 4 + Y * width * 4;
		ArrayBufferIO.setUint8(pixels.buffer, id, Arr[0]);
		ArrayBufferIO.setUint8(pixels.buffer, id + 1, Arr[1]);
		ArrayBufferIO.setUint8(pixels.buffer, id + 2, Arr[2]);
		ArrayBufferIO.setUint8(pixels.buffer, id + 3, Arr[3]);
	}
	
	public function displace(Rect:Vec4, Delta:Vec2, Clear:Vec4 = null):Void
	{
		var arr:Array<Int> = [];
		for (y in 0...cast Rect[3])
		{
			for (x in 0...cast Rect[2])
			{
				var pX:Int = cast x + Rect[0];
				var pY:Int = cast y + Rect[1];
				var p:Array<Int> = getPixel(pX, pY);
				arr.push(p[0]);
				arr.push(p[1]);
				arr.push(p[2]);
				arr.push(p[3]);
				if (Clear != null)
				{
					setPixel(pX, pY, [cast Clear[0], cast Clear[1], cast Clear[2], cast Clear[3]]);
				}
			}
		}
		var i:Int = 0;
		for (y in 0...cast Rect[3])
		{
			for (x in 0...cast Rect[2])
			{
				var pX:Int = cast x + Rect[0];
				var pY:Int = cast y + Rect[1];
				var npX:Int = cast pX + Delta[0];
				var npY:Int = cast pY + Delta[1];
				if (npX <= width && npY <= height && npX >= 0 && npY >= 0)
				{
					i += 4;
					var r:Int = arr[i];
					var g:Int = arr[i + 1];
					var b:Int = arr[i + 2];
					var a:Int = arr[i + 3];
					
					setPixel(npX, npY, [r, g, b, a]);
				}
			}
		}
	}
	
	public function copyPixels(Source:Bitmap, Dest:Bitmap, SourceRect:Vec4, DestPoint:Vec2):Void
	{
		for (y in 0...cast SourceRect[3])
		{
			for (x in 0...cast SourceRect[2])
			{
				var p:Array<Int> = Source.getPixel(cast SourceRect[0] + x, cast SourceRect[1] + y);
				if (p[3] > 0)
					Dest.setPixel(cast DestPoint.x + x, cast DestPoint.y + y, p);
			}
		}
	}
}