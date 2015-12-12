package choprender.mint;

import glm.Vec4;
import choprender.render3d.Camera;
import mint.types.Types;
import mint.render.Rendering;

import choprender.mint.ChopMintRender;
import choprender.mint.Convert;

import chop.util.Color;
import choprender.model.QuadModel;
import chop.group.Group;

private typedef ChopMintSliderOptions = {
    var color: Color;
    var color_bar: Color;
}

class Slider extends mint.render.Render {

    public var slider : mint.Slider;

    public var visual : QuadModel;
    public var bar : QuadModel;

    public var color: Color;
    public var color_bar: Color;

    var render: ChopMintRender;

    public function new( _render:ChopMintRender, _control:mint.Slider ) {

        slider = _control;
        render = _render;

        super(render, _control);

        var _opt: ChopMintSliderOptions = slider.options.options;

        color = Convert.def(_opt.color, Color.fromRGB(0x373739));
        color_bar = Convert.def(_opt.color_bar, Color.fromRGB(0x9dca63));

        //visual = Luxe.draw.box({
            //id: control.name+'.visual',
            //batcher: render.options.batcher,
            //x:control.x,
            //y:control.y,
            //w:control.w,
            //h:control.h,
            //color: color,
            //depth: render.options.depth + control.depth,
            //group: render.options.group,
            //visible: control.visible,
            //clip_rect: Convert.bounds(control.clip_with)
        //});
		visual = new QuadModel();
		visual.mat.useShading = false;
		visual.pos.x = Convert.coordX(control.x);
		visual.pos.y = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
		visual.mat.diffuseColor.copy(color);
		visual.pos.z = Convert.coordZ(render.options.depth + control.depth);
		visual.visible = control.visible;
		visual.cams = _control.canvas._options_.options.cams;
		_control.canvas._options_.options.group.add(visual);

        //bar = Luxe.draw.box({
            //id: control.name+'.bar',
            //batcher: render.options.batcher,
            //x:control.x + slider.bar_x,
            //y:control.y + slider.bar_y,
            //w:slider.bar_w,
            //h:slider.bar_h,
            //color: color_bar,
            //depth: render.options.depth + control.depth + 0.001,
            //group: render.options.group,
            //visible: control.visible,
            //clip_rect: Convert.bounds(control.clip_with)
        //});
		bar = new QuadModel();
		bar.mat.useShading = false;
		bar.pos.x = Convert.coordX(control.x + slider.bar_x);
		bar.pos.y = Convert.coordY(control.y + slider.bar_y);
		bar.setSize(Convert.coord(slider.bar_w), Convert.coord(slider.bar_h));
		bar.mat.diffuseColor.copy(color_bar);
		bar.pos.z = Convert.coordZ(render.options.depth + control.depth + 1);
		bar.visible = control.visible;
		bar.cams = _control.canvas._options_.options.cams;
		_control.canvas._options_.options.group.add(bar);
		
		visual.clip = Convert.bounds(control.clip_with);
		bar.clip = Convert.bounds(control.clip_with);

        slider.onchange.listen(onchange);

    } //new

    function onchange(value:Float, prev_value:Float) {

		bar.pos.x = Convert.coordX(control.x + slider.bar_x);
		bar.pos.y = Convert.coordY(control.y + slider.bar_y);
		bar.setSize(Convert.coord(slider.bar_w), Convert.coord(slider.bar_h));

    } //onchange

    override function ondestroy() {

        visual = null;
        bar = null;

    } //ondestroy

    override function onbounds() {
		visual.pos.x = Convert.coordX(control.x);
		visual.pos.y = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
		bar.pos.x = Convert.coordX(control.x + slider.bar_x);
		bar.pos.y = Convert.coordY(control.y + slider.bar_y);
		bar.setSize(Convert.coord(slider.bar_w), Convert.coord(slider.bar_h));
    }
	
	override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        if(_disable) {
            visual.clip = null;
        } else {
            visual.clip = new Vec4(_x, _y, _w, _h);
        }
    } //onclip

    override function onvisible( _visible:Bool ) {
        visual.visible = _visible;
        bar.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
		visual.pos.z = Convert.coordZ(render.options.depth + _depth);
		bar.pos.z = Convert.coordZ(render.options.depth + _depth + 1);
    } //ondepth

} //Slider
