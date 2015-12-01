package choprender.mint;

import choprender.render3d.Camera;
import mint.types.Types;
import mint.render.Rendering;

import choprender.mint.ChopMintRender;
import choprender.mint.Convert;

import chop.util.Color;
import choprender.model.QuadModel;
import chop.group.Group;

private typedef ChopMintProgressOptions = {
    var color: Color;
    var color_bar: Color;
}

class Progress extends mint.render.Render {

    public var progress : mint.Progress;
    public var visual : QuadModel;
    public var bar : QuadModel;

    public var color: Color;
    public var color_bar: Color;

    var render: ChopMintRender;
    var margin: Float = 2.0;

    public function new( _render:ChopMintRender, _control:mint.Progress ) {

        progress = _control;
        render = _render;

        super(render, _control);

        var _opt: ChopMintProgressOptions = progress.options.options;

        color = Convert.def(_opt.color, Color.fromRGB(0x242424));
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
            //x:control.x+margin,
            //y:control.y+margin,
            //w:get_bar_width(progress.progress),
            //h:control.h-(margin*2),
            //color: color_bar,
            //depth: render.options.depth + control.depth + 0.001,
            //group: render.options.group,
            //visible: control.visible,
            //clip_rect: Convert.bounds(control.clip_with)
        //});
		bar = new QuadModel();
		bar.mat.useShading = false;
		bar.pos.x = Convert.coordX(control.x+margin);
		bar.pos.y = Convert.coordY(control.y+margin);
		bar.setSize(Convert.coord(get_bar_width(progress.progress)), Convert.coord(control.h-(margin*2)));
		bar.mat.diffuseColor.copy(color_bar);
		bar.pos.z = Convert.coordZ(render.options.depth + control.depth + 1);
		bar.visible = control.visible;
		bar.cams = _control.canvas._options_.options.cams;
		_control.canvas._options_.options.group.add(bar);

        progress.onchange.listen(function(cur, prev){
			bar.setSize(Convert.coord(get_bar_width(cur)), Convert.coord(control.h - (margin * 2)));
        });

    } //new

    function get_bar_width(_progress:Float) {
        var _width = (control.w-(margin*2)) * _progress;
        if(_width <= 1) _width = 1;
        var _control_w = (control.w - margin);
        if(_width >= _control_w) _width = _control_w;
        return _width;
    }

    override function ondestroy() {

        visual = null;
        bar = null;

    }

    override function onbounds() {
		visual.pos.x = Convert.coordX(control.x);
		visual.pos.y = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
		bar.pos.x = Convert.coordX(control.x+margin);
		bar.pos.y = Convert.coordY(control.y+margin);
		bar.setSize(Convert.coord(get_bar_width(progress.progress)), Convert.coord(control.h-(margin*2)));
    }

    override function onvisible( _visible:Bool ) {
        visual.visible = bar.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
		visual.pos.z = Convert.coordZ(render.options.depth + _depth);
		bar.pos.z = Convert.coordZ(render.options.depth + _depth + 1);
    } //ondepth

} //Progress
