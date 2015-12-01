package choprender.mint;

import choprender.model.data.Texture;
import choprender.render3d.Camera;
import mint.types.Types;
import mint.render.Rendering;

import choprender.mint.ChopMintRender;
import choprender.mint.Convert;

import chop.util.Color;
import choprender.model.QuadModel;
import chop.group.Group;

import chop.math.Vec4;
import choprender.render3d.opengl.GL;

private typedef ChopMintImageOptions = {
    @:optional var uv: Vec4;
    @:optional var sizing: String; //:todo: type
	var group: Group;
	var cam: Camera;
}

class Image extends mint.render.Render {

    public var image : mint.Image;
    public var visual : QuadModel;

    var ratio_w : Float = 1.0;
    var ratio_h : Float = 1.0;

    var render: ChopMintRender;

    public function new( _render:ChopMintRender, _control:mint.Image ) {

        image = _control;
        render = _render;

        super(render, _control);

        var _opt: ChopMintImageOptions = image.options.options;

		var texture:Texture = new Texture();
		texture.loadFile(image.options.path);
		texture.blendMode = Texture.BLEND_SRC;
		texture.choptex.params[0].param = GL.LINEAR;
		texture.choptex.params[1].param = GL.LINEAR;
		texture.choptex.updateParams();

		if(_opt.sizing != null) {

			switch(_opt.sizing) {
					//sets the uv to be the size on the longest edge
					//possibly leaving whitespace on the sides (pillarbox) or top (letterbox)
				case 'fit': {
					if(texture.data.width > texture.data.height) {
						ratio_w = control.w;
						ratio_h = texture.data.height / texture.data.width * control.w;
					} else {
						ratio_h = control.h;
						ratio_w = texture.data.width / texture.data.height * control.h;
					}
				} //fit

					// cover the viewport with the size (possible cropping)
				case 'cover': {
					//var _rx = 1.0;
					//var _ry = 1.0;
					//if(texture.data.width > texture.data.height) {
						//_rx = texture.data.height/texture.data.width;
					//} else {
						//_ry = texture.data.width/texture.data.height;
					//}
					//_opt.uv = Vec4.fromValues(0,0,texture.data.width*_rx,texture.data.height*_ry);
				}

			}
		}

		//visual = new luxe.Sprite({
			//name: control.name+'.visual',
			//batcher: render.options.batcher,
			//centered: false,
			//texture: texture,
			//pos: new Vector(control.x, control.y),
			//size: new Vector(control.w*ratio_w, control.h*ratio_h),
			//depth: render.options.depth + control.depth,
			//group: render.options.group,
			//visible: control.visible,
			//uv: _opt.uv
		//});
		visual = new QuadModel();
		visual.mat.useShading = false;
		visual.pos.x = Convert.coord(control.x);
		visual.pos.y = Convert.coordY(control.y);
		visual.setSize(Convert.coord(ratio_w), Convert.coord(ratio_h));
		visual.pos.z = Convert.coordZ(render.options.depth + control.depth);
		visual.visible = control.visible;
		visual.cams = [_opt.cam];
		_opt.group.add(visual);
		
		visual.loadTex(texture);
		// TODO: UV coords

    } //new

    override function onbounds() {

        if(visual != null) {
            visual.pos.x = Convert.coord(control.x);
			visual.pos.y = Convert.coordY(control.y);
			visual.setSize(Convert.coord(ratio_w), Convert.coord(ratio_h));
        }

    } //onbounds

    override function ondestroy() {

        if(visual != null) {
            visual.destroy();
            visual = null;
        }

    } //ondestroy

    override function onvisible( _visible:Bool ) {

        if(visual != null) {
            visual.visible = _visible;
        }

    } //onvisible

    override function ondepth( _depth:Float ) {

        if(visual != null) {
            visual.pos.z = Convert.coordZ(render.options.depth + _depth);
        }

    } //ondepth

} //Image
