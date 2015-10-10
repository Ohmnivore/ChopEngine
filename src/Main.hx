package;

import chopengine.gen.Game;
import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.ChopGL;
import snow.types.Types;
import chop.assets.Assets;

@:log_as('chop')
class Main extends snow.App 
{
	public var game:Game;
	
    override function config(config:AppConfig):AppConfig 
    {
        config.window.title = 'ChopEngine';
		config.window.width = 960;
		config.window.height = 640;
        return config;
    }

    override function ready() 
    {
		Assets.init();
		Assets.loadManifest();
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
		if (game == null && Assets.isReady())
		{
			game = new Game(new PlayState());
			app.window.onrender = render;
		}
		if (game != null)
			game.update(delta);
    }

    function render(window:snow.system.window.Window) 
    {
		if (game != null)
			game.draw(delta_time);
    }
}