package choprender.mint;

import choprender.render3d.Camera;
import mint.types.Types;
import mint.render.Rendering;

import choprender.mint.ChopMintRender;
import choprender.mint.Convert;

import chop.util.Color;
import choprender.model.QuadModel;
import chop.group.Group;

private typedef ChopMintScrollOptions = {
    var color: Color;
    var color_handles: Color;
	var group: Group;
	var cam: Camera;
}

class Scroll extends mint.render.Render {

    public var scroll : mint.Scroll;
    public var visual : QuadModel;

    public var scrollh : QuadModel;
    public var scrollv : QuadModel;

    public var color: Color;
    public var color_handles: Color;

    var render: ChopMintRender;

    public function new( _render:ChopMintRender, _control:mint.Scroll ) {

        scroll = _control;
        render = _render;

        super(render, _control);

        var _opt: ChopMintScrollOptions = scroll.options.options;

        color = Convert.def(_opt.color, Color.fromRGB(0x343434));
        color_handles = Convert.def(_opt.color_handles, Color.fromRGB(0x9dca63));

        //visual = new luxe.Sprite({
            //name: control.name+'.visual',
            //batcher: render.options.batcher,
            //centered: false,
            //pos: new Vector(control.x, control.y),
            //size: new Vector(control.w, control.h),
            //color: color,
            //depth: render.options.depth + control.depth,
            //group: render.options.group,
            //visible: control.visible,
        //});
		visual = new QuadModel();
		visual.mat.useShading = false;
		visual.pos.x = Convert.coord(control.x);
		visual.pos.y = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
		visual.mat.diffuseColor.copy(color);
		visual.pos.z = Convert.coordZ(render.options.depth + control.depth);
		visual.visible = control.visible;
		visual.cams = [_opt.cam];
		_opt.group.add(visual);

        //scrollh = new luxe.Sprite({
            //name: control.name+'.scrollh',
            //batcher: render.options.batcher,
            //centered: false,
            //pos: new Vector(scroll.scrollh.x, scroll.scrollh.y),
            //size: new Vector(scroll.scrollh.w, scroll.scrollh.h),
            //color: color_handles,
            //depth: render.options.depth + scroll.scrollh.depth,
            //group: render.options.group,
            //visible: scroll.visible_h,
        //});
		scrollh = new QuadModel();
		scrollh.mat.useShading = false;
		scrollh.pos.x = Convert.coord(scroll.scrollh.x);
		scrollh.pos.y = Convert.coordY(scroll.scrollh.y);
		scrollh.setSize(Convert.coord(scroll.scrollh.w), Convert.coord(scroll.scrollh.h));
		scrollh.mat.diffuseColor.copy(color_handles);
		scrollh.pos.z = Convert.coordZ(render.options.depth + scroll.scrollh.depth);
		scrollh.visible = scroll.visible_h;
		scrollh.cams = [_opt.cam];
		_opt.group.add(scrollh);

        //scrollv = new luxe.Sprite({
            //name: control.name+'.scrollv',
            //batcher: render.options.batcher,
            //centered: false,
            //pos: new Vector(scroll.scrollv.x, scroll.scrollv.y),
            //size: new Vector(scroll.scrollv.w, scroll.scrollv.h),
            //color: color_handles,
            //depth: render.options.depth + scroll.scrollv.depth,
            //group: render.options.group,
            //visible: scroll.visible_v
        //});
		scrollv = new QuadModel();
		scrollv.mat.useShading = false;
		scrollv.pos.x = Convert.coord(scroll.scrollv.x);
		scrollv.pos.y = Convert.coordY(scroll.scrollv.y);
		scrollv.setSize(Convert.coord(scroll.scrollv.w), Convert.coord(scroll.scrollv.h));
		scrollv.mat.diffuseColor.copy(color_handles);
		scrollv.pos.z = Convert.coordZ(render.options.depth + scroll.scrollv.depth);
		scrollv.visible = scroll.visible_v;
		scrollv.cams = [_opt.cam];
		_opt.group.add(scrollv);

        //visual.clip_rect = Convert.bounds(control.clip_with);

        scroll.onchange.listen(onchange);
        scroll.onhandlevis.listen(onhandlevis);

    }

    override function ondestroy() {

        scroll.onchange.remove(onchange);

        scrollh.destroy();
        scrollv.destroy();
        visual.destroy();
        visual = null;

    } //ondestroy

    override function onbounds() {
		visual.pos.x = Convert.coord(control.x);
		visual.pos.y = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
        //
		scrollh.pos.x = Convert.coord(scroll.scrollh.x);
		scrollh.pos.y = Convert.coordY(scroll.scrollh.y);
		scrollv.pos.x = Convert.coord(scroll.scrollv.x);
		scrollv.pos.y = Convert.coordY(scroll.scrollv.y);
    }

    function onhandlevis(_h:Bool, _v:Bool) {
        scrollh.visible = _h && scroll.visible;
        scrollv.visible = _v && scroll.visible;
    }

    function onchange() {
        scrollh.pos.x = Convert.coord(scroll.scrollh.x);
        scrollv.pos.y = Convert.coordY(scroll.scrollv.y);
    }


    override function onvisible( _visible:Bool ) {
        visual.visible = _visible;
        scrollh.visible = scroll.visible_h && _visible;
        scrollv.visible = scroll.visible_v && _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
		visual.pos.z = Convert.coordZ(render.options.depth + _depth);
		scrollv.pos.z = Convert.coordZ(render.options.depth + _depth + scroll.scrollv.depth);
		scrollh.pos.z = Convert.coordZ(render.options.depth + _depth + scroll.scrollh.depth);
    } //ondepth

} //Scroll
