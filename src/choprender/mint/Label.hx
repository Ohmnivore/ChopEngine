package choprender.mint;

import chop.math.Vec4;
import choprender.render3d.Camera;
import choprender.text.Font;
import mint.types.Types;
import mint.render.Rendering;

import choprender.mint.ChopMintRender;
import choprender.mint.Convert;

import choprender.text.Text;
import chop.util.Color;
import chop.group.Group;

private typedef ChopMintLabelOptions = {
    var color: Color;
    var color_hover: Color;
	var font: Font;
}

class Label extends mint.render.Render {

    public var label : mint.Label;
    public var text : Text;

    public var color_hover: Color;
    public var color: Color;
	
	private var yOffset:Float;

    var render: ChopMintRender;

    public function new( _render:ChopMintRender, _control:mint.Label ) {

        label = _control;
        render = _render;

        super(render, _control);

        var _opt: ChopMintLabelOptions = label.options.options;

        color = Convert.def(_opt.color, Color.fromRGB(0xffffff));
        color_hover = Convert.def(_opt.color_hover, Color.fromRGB(0x9dca63));
		_opt.font = Convert.def(_opt.font, _control.canvas._options_.options.font);

        //text = new luxe.Text({
            //name: control.name+'.text',
            //batcher: render.options.batcher,
            //bounds: new luxe.Rectangle(control.x, control.y, control.w, control.h),
            //color: color,
            //text: label.text,
            //bounds_wrap: label.options.bounds_wrap,
            //align: Convert.text_align(label.options.align),
            //align_vertical: Convert.text_align(label.options.align_vertical),
            //point_size: label.options.text_size,
            //depth: render.options.depth + control.depth,
            //group: render.options.group,
            //visible: control.visible,
        //});
		
		text = new Text(_opt.font);
		text.mat.useShading = false;
		text.pos.x = Convert.coordX(control.x);
		text.pos.y = Convert.coordY(control.y);
		text.pos.z = Convert.coordZ(render.options.depth + control.depth);
		text.visible = control.visible;
		text.mat.diffuseColor.copy(color);
		text.setMetrics(Convert.textWrap(label.options.bounds_wrap), Convert.textAlign(label.options.align), Convert.coord(label.options.text_size), Convert.coord(control.w));
		text.setText(label.text);
		text.cams = _control.canvas._options_.options.cams;
		_control.canvas._options_.options.group.add(text);
		
		yOffset = 0;
		onbounds();
		
		text.clip = Convert.bounds(control.clip_with);

        label.onchange.listen(ontext);

        control.onmouseenter.listen(function(e,c){ text.mat.diffuseColor.copy(color_hover); });
        control.onmouseleave.listen(function(e,c){ text.mat.diffuseColor.copy(color); });

    }

    override function onbounds() {
		// Vertical align not handled by ChopEngine's Text class
		if (text.textHeight > 0)
		{
			if (label.options.align_vertical == mint.types.Types.TextAlign.center)
				yOffset = -Convert.coord((label.h - (text.textHeight * label.options.text_size / text.font.size)) / 2.0);
			else if (label.options.align_vertical == mint.types.Types.TextAlign.bottom)
				yOffset = -Convert.coord(label.h - (text.textHeight * label.options.text_size / text.font.size));
		}
		
		text.pos.x = Convert.coordX(control.x);
		text.pos.y = Convert.coordY(control.y) + yOffset;
		text.setMetrics(Convert.textWrap(label.options.bounds_wrap), Convert.textAlign(label.options.align), Convert.coord(label.options.text_size), Convert.coord(control.w));
		text.setText(label.text);
    }
	
	override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        if(_disable) {
            text.clip = null;
        } else {
            text.clip = Vec4.fromValues(_x, _y, _w, _h);
        }
    } //onclip

    function ontext(_text:String) {
		text.setText(_text);
    }

    override function ondestroy() {
        label.onchange.remove(ontext);

        text.destroy();
        text = null;
    }

    override function onvisible( _visible:Bool ) {
        text.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        text.pos.z = Convert.coordZ(render.options.depth + _depth);
    } //ondepth

} //Label
