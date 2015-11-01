package choprender.mint;

import mint.types.Types;
import mint.render.Rendering;

import choprender.mint.ChopMintRender;
import choprender.mint.Convert;

import chop.util.Color;
import choprender.model.QuadModel;
import chop.group.Group;

private typedef ChopMintPanelOptions = {
    var color: Color;
	var group:Group;
}

class Panel extends mint.render.Render {

    public var panel : mint.Panel;
    public var visual : QuadModel;

    public var color: Color;

    var render: ChopMintRender;

    public function new( _render:ChopMintRender, _control:mint.Panel ) {

        panel = _control;
        render = _render;

        super(render, _control);

        var _opt: ChopMintPanelOptions = panel.options.options;

        color = Convert.def(_opt.color, Color.fromRGB(0x242424));

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
		visual.pos.x = Convert.coord(control.x);
		visual.pos.y = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
		visual.mat.diffuseColor.copy(color);
		visual.pos.z = Convert.coordZ(control.depth);
		visual.visible = control.visible;
		_opt.group.add(visual);

    } //new

    override function ondestroy() {

        visual = null;

    } //ondestroy

    override function onbounds() {
		visual.pos.x = Convert.coord(control.x);
		visual.pos.y = Convert.coord(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
    }

    override function onvisible( _visible:Bool ) {
        visual.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        visual.pos.z = Convert.coordZ(render.options.depth + _depth);
    } //ondepth

} //Panel
