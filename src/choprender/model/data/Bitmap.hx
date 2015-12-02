package choprender.model.data;

import chop.math.Vec2;
import chop.math.Vec3;
import chop.math.Vec4;
import choprender.render3d.opengl.GL.ArrayBuffer;
import choprender.render3d.opengl.GL.Uint8Array;
#if !js
import snow.api.buffers.ArrayBufferIO;
#else
import snow.api.buffers.DataView;
#end

/**
 * ...
 * @author Ohmnivore
 */
class Bitmap
{
	public var pixels:Uint8Array;
	public var width:Int;
	public var height:Int;
	
	static private function getUint8(Arr:ArrayBuffer, Pos:Int):Int
	{
		#if !js
		return ArrayBufferIO.getUint8(Arr, Pos);
		#else
		var dv:DataView = new DataView(cast Arr);
		return dv.getUint8(Pos);
		#end
	}
	
	static private function setUint8(Arr:ArrayBuffer, Pos:Int, V:Int):Void
	{
		#if !js
		ArrayBufferIO.setUint8(Arr, Pos, V);
		#else
		var dv:DataView = new DataView(cast Arr);
		dv.setUint8(Pos, V);
		#end
	}
	
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
	
	public function replace(K:Array<Int>, V:Array<Int>):Void
	{
		for (x in 0...width)
		{
			for (y in 0...height)
			{
				var old:Array<Int> = getPixel(x, y);
				if (old[0] == K[0] && old[1] == K[1] && old[2] == K[2] && old[3] == K[3])
					setPixel(x, y, V);
			}
		}
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
					setUint8(newArr.buffer, id, p[0]);
					setUint8(newArr.buffer, id + 1, p[1]);
					setUint8(newArr.buffer, id + 2, p[2]);
					setUint8(newArr.buffer, id + 3, p[3]);
					
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
			getUint8(pixels.buffer, id),
			getUint8(pixels.buffer, id + 1),
			getUint8(pixels.buffer, id + 2),
			getUint8(pixels.buffer, id + 3)
		];
	}
	
	public function setPixel(X:Int, Y:Int, Arr:Array<Int>):Void
	{
		var id:Int = X * 4 + Y * width * 4;
		setUint8(pixels.buffer, id, Arr[0]);
		setUint8(pixels.buffer, id + 1, Arr[1]);
		setUint8(pixels.buffer, id + 2, Arr[2]);
		setUint8(pixels.buffer, id + 3, Arr[3]);
	}
	
	public function blitPixel(X:Int, Y:Int, Arr:Array<Int>):Void
	{
		var id:Int = X * 4 + Y * width * 4;
		
		// Alpha blending
		var old:Array<Int> = getPixel(X, Y);
		var srca:Float = Arr[3] / 255.0;
		var dsta:Float = old[3] / 255.0;
		var srcrgb:Vec3 = Vec3.fromValues(Arr[0] / 255.0, Arr[1] / 255.0, Arr[2] / 255.0);
		var dstrgb:Vec3 = Vec3.fromValues(old[0] / 255.0, old[1] / 255.0, old[2] / 255.0);
		
		var outa:Float = srca + dsta * (1.0 - srca);
		if (outa == 0)
			Arr = [0, 0, 0, 0];
		else
		{
			var outrgb:Vec3 = (srcrgb.scale(srca) + dstrgb.scale(dsta).scale(1.0 - srca)).scale(1.0 / outa);
			Arr = [Std.int(outrgb.x * 255), Std.int(outrgb.y * 255), Std.int(outrgb.z * 255), Std.int(outa * 255)];
		}
		
		setUint8(pixels.buffer, id, Arr[0]);
		setUint8(pixels.buffer, id + 1, Arr[1]);
		setUint8(pixels.buffer, id + 2, Arr[2]);
		setUint8(pixels.buffer, id + 3, Arr[3]);
	}
	
	public function displace(Rect:Vec4, Delta:Vec2, Clear:Vec4 = null):Void
	{
		var arr:Array<Int> = [];
		for (y in 0...Std.int(Rect[3]))
		{
			for (x in 0...Std.int(Rect[2]))
			{
				var pX:Int = x + Std.int(Rect[0]);
				var pY:Int = y + Std.int(Rect[1]);
				var p:Array<Int> = getPixel(pX, pY);
				arr.push(p[0]);
				arr.push(p[1]);
				arr.push(p[2]);
				arr.push(p[3]);
				if (Clear != null)
				{
					setPixel(pX, pY, [Std.int(Clear[0]), Std.int(Clear[1]), Std.int(Clear[2]), Std.int(Clear[3])]);
				}
			}
		}
		var i:Int = 0;
		for (y in 0...cast Rect[3])
		{
			for (x in 0...cast Rect[2])
			{
				var pX:Int = x + Std.int(Rect[0]);
				var pY:Int = y + Std.int(Rect[1]);
				var npX:Int = pX + Std.int(Delta[0]);
				var npY:Int = pY + Std.int(Delta[1]);
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
				var p:Array<Int> = Source.getPixel(Std.int(SourceRect[0]) + x, Std.int(SourceRect[1]) + y);
				Dest.blitPixel(Std.int(DestPoint.x) + x, Std.int(DestPoint.y) + y, p);
			}
		}
	}
	
	public function getSubRect(X:Int, Y:Int, W:Int, H:Int):Uint8Array
	{
		var buff:Array<Int> = [];
		for (y in 0...H)
			for (x in 0...W)
			{
				var p:Array<Int> = getPixel(X + x, Y + y);
				buff.push(p[0]);
				buff.push(p[1]);
				buff.push(p[2]);
				buff.push(p[3]);
			}
		return new Uint8Array(buff);
	}
}