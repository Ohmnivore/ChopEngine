package choprender.mint;

import chop.group.Group;
import mint.types.Types;
import mint.Control;
import choprender.mint.Convert;

typedef RenderProperties = {

    /** the visibility */
    @:optional var visible : Bool;
    /** the geometry depth value (see guides)*/
    @:optional var depth : Float;

} //RenderProperties

class ChopMintRender extends mint.render.Rendering {

    public var options: choprender.mint.RenderProperties;

    public function new( ?_options:choprender.mint.RenderProperties ) {

        super();

        options = Convert.def(_options, {});
        Convert.def(options.depth, 10);
		options.depth = 10;
        Convert.def(options.visible, true);

    } //new

    override function get<T:Control, T1>( type:Class<T>, control:T ) : T1 {
        return cast switch(type) {
            case mint.Canvas:       new choprender.mint.Canvas(this, cast control);
            case mint.Label:        new choprender.mint.Label(this, cast control);
            case mint.Button:       new choprender.mint.Button(this, cast control);
            case mint.Image:        new choprender.mint.Image(this, cast control);
			case mint.List:         new choprender.mint.List(this, cast control);
            case mint.Scroll:       new choprender.mint.Scroll(this, cast control);
			case mint.Panel:        new choprender.mint.Panel(this, cast control);
            case mint.Checkbox:     new choprender.mint.Checkbox(this, cast control);
			case mint.Window:       new choprender.mint.Window(this, cast control);
			case mint.TextEdit:     new choprender.mint.TextEdit(this, cast control);
			case mint.Dropdown:     new choprender.mint.Dropdown(this, cast control);
			case mint.Slider:       new choprender.mint.Slider(this, cast control);
            case mint.Progress:     new choprender.mint.Progress(this, cast control);
            case _:                 null;
        }
    } //render

} //ChopMintRender