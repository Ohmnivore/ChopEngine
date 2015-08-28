package;

import chop.gen.Game;
import chop.gen.Global;
import chop.gen.State;
import chop.render3d.Camera;
import snow.api.Debug.*;
import snow.types.Types;
import snow.modules.opengl.GL;

@:log_as('app')
class SnowMain extends snow.App 
{
	public var game:Game;
	
    override function config(config:AppConfig):AppConfig 
    {
        config.window.title = 'ChopEngine Demo';
		config.window.width = 640;
		config.window.height = 480;
		config.render.antialiasing = config.runtime.render.antialiasing;
        return config;
    }

    override function ready() 
    {
		game = new Game(new PlayState());
        app.window.onrender = render;
    }

    override function onkeyup(keycode:Int, _,_, mod:ModState, _,_) 
    {
        if( keycode == Key.escape ) 
        {
            app.shutdown();
        }
    }

    override function update(delta:Float)
    {
		game.update(delta);
    }

    function render(window:snow.system.window.Window) 
    {
		game.draw(delta_time);
    }
}