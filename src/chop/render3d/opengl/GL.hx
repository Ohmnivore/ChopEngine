package chop.render3d.opengl;

#if snow
    typedef GL                  = snow.modules.opengl.GL;
    typedef GLActiveInfo        = snow.modules.opengl.GL.GLActiveInfo;
    typedef GLBuffer            = snow.modules.opengl.GL.GLBuffer;
    typedef GLContextAttributes = snow.modules.opengl.GL.GLContextAttributes;
    typedef GLFramebuffer       = snow.modules.opengl.GL.GLFramebuffer;
    typedef GLProgram           = snow.modules.opengl.GL.GLProgram;
    typedef GLRenderbuffer      = snow.modules.opengl.GL.GLRenderbuffer;
    typedef GLShader            = snow.modules.opengl.GL.GLShader;
    typedef GLTexture           = snow.modules.opengl.GL.GLTexture;
    typedef GLUniformLocation   = snow.modules.opengl.GL.GLUniformLocation;
    typedef ArrayBufferView     = snow.api.buffers.ArrayBufferView;
	typedef Float32Array        = snow.api.buffers.Float32Array;
	typedef Uint8Array          = snow.api.buffers.Uint8Array;
	
	//#if snow_render_gl_native
        //typedef GLLink              = snow.modules.opengl.native.GL_Native.GLLink;
    //#end
#else
	typedef GL                  = lime.graphics.opengl.GL;
    typedef GLActiveInfo        = lime.graphics.opengl.GLActiveInfo;
    typedef GLBuffer            = lime.graphics.opengl.GLBuffer;
    typedef GLContextAttributes = lime.graphics.opengl.GLContextAttributes;
    typedef GLFramebuffer       = lime.graphics.opengl.GLFramebuffer;
    typedef GLProgram           = lime.graphics.opengl.GLProgram;
    typedef GLRenderbuffer      = lime.graphics.opengl.GLRenderbuffer;
    typedef GLShader            = lime.graphics.opengl.GLShader;
    typedef GLTexture           = lime.graphics.opengl.GLTexture;
    typedef GLUniformLocation   = lime.graphics.opengl.GLUniformLocation;
	typedef Float32Array        = lime.utils.Float32Array;
#end