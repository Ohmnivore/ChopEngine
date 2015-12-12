package choprender.mint;

import glm.Vec2;
import glm.Vec4;
import chop.util.Color;
import mint.types.Types;
import mint.render.Rendering;

import choprender.mint.ChopMintRender;
import choprender.mint.Convert;

import choprender.model.QuadModel;
import chop.group.Group;
import choprender.render3d.Camera;
import choprender.text.Font;

private typedef ChopMintCanvasOptions = {
    var color: Color;
    var group: Group;
	var cams: Array<Camera>;
	var font: Font;
}

class Canvas extends mint.render.Render {

    public var canvas : mint.Canvas;
    public var visual : QuadModel;

    public var color : Color;

    var render: ChopMintRender;

    public function new( _render:ChopMintRender, _control:mint.Canvas ) {

        canvas = _control;
        render = _render;

        super(render, _control);

        var _opt: ChopMintCanvasOptions = canvas.options.options;

        color = Convert.def(_opt.color, Color.fromRGB(0x0c0c0c));

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
		
		visual.pos.x = Convert.coordX(control.x);
		visual.pos.y = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
		visual.mat.diffuseColor.copy(color);
		visual.mat.transparency = 0;
		visual.pos.z = Convert.coordZ(render.options.depth + control.depth);
		visual.visible = control.visible;
		_opt.group.add(visual);
		
		visual.clip = Convert.bounds(control.clip_with);

    } //new

    override function ondestroy() {

        //visual.drop();
        visual.destroy();

    }

    override function onbounds() {
        //visual.transform.pos.set_xy(control.x, control.y);
        //visual.resize_xy(control.w, control.h);
		visual.pos.x = Convert.coordX(control.x);
		visual.pos.y = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
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
    } //onvisible

    override function ondepth( _depth:Float ) {
        //visual.depth = render.options.depth + _depth;
		visual.pos.z = Convert.coordZ(render.options.depth + _depth);
    } //ondepth

} //Canvas
