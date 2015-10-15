package choprender.mint;

import chop.math.Vec2;
import mint.types.Types;
import mint.render.Rendering;

import choprender.mint.ChopMintRender;
import choprender.mint.Convert;

import choprender.model.QuadModel;
import chop.math.Vec4;
import chop.group.Group;

private typedef ChopMintCanvasOptions = {
    var color: Vec4;
    var group: Group;
}

class Canvas extends mint.render.Render {

    public var canvas : mint.Canvas;
    public var visual : QuadModel;

    public var color : Vec4;

    var render: ChopMintRender;

    public function new( _render:ChopMintRender, _control:mint.Canvas ) {

        canvas = _control;
        render = _render;

        super(render, _control);

        var _opt: ChopMintCanvasOptions = canvas.options.options;

        color = Convert.def(_opt.color, Vec4.fromValues(0.04, 0.04, 0.04, 0));

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
            //clip_rect: Convert.bounds(control.clip_with),
        //});
		
		visual = new QuadModel();
		visual.mat.useShading = false;
		
		visual.pos.x = Convert.coord(control.x);
		visual.pos.z = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
		visual.mat.diffuseColor.set(color.x, color.y, color.z);
		visual.pos.y = -render.options.depth - control.depth;
		visual.visible = control.visible;
		_opt.group.add(visual);

    } //new

    override function ondestroy() {

        //visual.drop();
        visual.destroy();

    }

    override function onbounds() {
        //visual.transform.pos.set_xy(control.x, control.y);
        //visual.resize_xy(control.w, control.h);
		visual.pos.x = Convert.coord(control.x);
		visual.pos.z = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
    }

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        //if(_disable) {
            //visual.clip_rect = null;
        //} else {
            //visual.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
        //}
    } //onclip


    override function onvisible( _visible:Bool ) {
        visual.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        //visual.depth = render.options.depth + _depth;
		visual.pos.y = Convert.coordZ(render.options.depth + _depth);
    } //ondepth

} //Canvas
