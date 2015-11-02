package;

import chop.math.Vec4;
import chopengine.gen.Game;
import chopengine.input.Mouse;
import choprender.render3d.opengl.GL;
import choprender.render3d.shaderexp.opengl.ChopGL;
import snow.types.Types;
import chop.assets.Assets;

import choprender.mint.ChopMintRender;
import mint.layout.margins.Margins;
import choprender.mint.Convert;
import mint.types.Types.InteractState;

@:log_as('chop')
class Main extends snow.App 
{
	public static var assets:Assets;
	public static var game:Game;
    public static var rendering:ChopMintRender;
	
    override function config(config:AppConfig):AppConfig 
    {
        config.window.title = 'ChopEngine';
		config.window.width = 960;
		config.window.height = 640;
		config.render.antialiasing = 8;
        return config;
    }
	
    override function ready() 
    {
		assets = new Assets();
		assets.loadManifest();
    }

    override function update(delta:Float)
    {
		if (game == null && assets.isReady())
		{
			rendering = new ChopMintRender();
			game = new Game(new PlayState());
			app.window.onrender = render;
		}
		if (assets.isReady())
			game.update(delta);
    }
	
    function render(window:snow.system.window.Window) 
    {
		if (assets.isReady())
			game.draw(delta_time);
    }
	
	override public function onmousemove(x:Int, y:Int, xrel:Int, yrel:Int, timestamp:Float, window_id:Int) 
	{
		super.onmousemove(x, y, xrel, yrel, timestamp, window_id);
		if (assets.isReady())
		{
			game.state.canvas.mousemove(Convert.mouseEvent(x, y, xrel, yrel, 0, timestamp, InteractState.move));
			game.mouse.onmousemove(x, y, xrel, yrel);
		}
	}
	override public function onmousedown(x:Int, y:Int, button:Int, timestamp:Float, window_id:Int) 
	{
		super.onmousedown(x, y, button, timestamp, window_id);
		if (assets.isReady())
		{
			game.state.canvas.mousedown(Convert.mouseEvent(x, y, 0, 0, button, timestamp, InteractState.down));
			game.mouse.onmousedown(button);
		}
	}
	override public function onmouseup(x:Int, y:Int, button:Int, timestamp:Float, window_id:Int) 
	{
		super.onmouseup(x, y, button, timestamp, window_id);
		if (assets.isReady())
		{
			game.state.canvas.mouseup(Convert.mouseEvent(x, y, 0, 0, button, timestamp, InteractState.up));
			game.mouse.onmouseup(button);
		}
	}
	override public function onmousewheel(x:Int, y:Int, timestamp:Float, window_id:Int) 
	{
		super.onmousewheel(x, y, timestamp, window_id);
		if (assets.isReady())
		{
			game.state.canvas.mousewheel(Convert.mouseEvent(x, y, 0, 0, 0, timestamp, InteractState.wheel));
			game.mouse.onmousewheel(y);
		}
	}
	
	override public function onkeydown(keycode:Int, scancode:Int, repeat:Bool, mod:ModState, timestamp:Float, window_id:Int) 
	{
		super.onkeydown(keycode, scancode, repeat, mod, timestamp, window_id);
		if (assets.isReady())
		{
			game.state.canvas.keydown(Convert.keyEvent(keycode, mod, timestamp, InteractState.down));
		}
	}
	override public function onkeyup(keycode:Int, scancode:Int, repeat:Bool, mod:ModState, timestamp:Float, window_id:Int) 
	{
		super.onkeyup(keycode, scancode, repeat, mod, timestamp, window_id);
		if (assets.isReady())
		{
			game.state.canvas.keyup(Convert.keyEvent(keycode, mod, timestamp, InteractState.up));
		}
	}
	override public function ontextinput(text:String, start:Int, length:Int, type:TextEventType, timestamp:Float, window_id:Int) 
	{
		super.ontextinput(text, start, length, type, timestamp, window_id);
		if (assets.isReady())
		{
			game.state.canvas.textinput(Convert.textEvent(text, start, length, type, timestamp));
		}
	}
}