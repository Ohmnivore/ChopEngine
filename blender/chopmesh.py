import bpy, bmesh, pprint, zlib, os
import xml.etree.ElementTree as ET
from xml.dom import minidom

# TODO
# Global tag ID to avoid collisions

use_log = True

class MyMaterial:
    def __init__(self):
        self.name = None
        self.ID = None
        self.use_shading = None
        self.shadows_cast = None
        self.shadows_receive = None
        self.diffuse_color = None
        self.diffuse_intensity = None
        self.specular_color = None
        self.specular_intensity = None
        self.ambient_intensity = None
        self.emit = None
        self.transparency = None

    def interpret(self, mat):
        self.name = mat.name
        self.use_shading = not mat.use_shadeless
        self.shadows_cast = mat.use_cast_shadows
        self.shadows_receive = mat.use_shadows
        self.diffuse_color = self.convert_color(mat.diffuse_color)
        self.diffuse_intensity = self.convert_float(mat.diffuse_intensity)
        self.specular_color = self.convert_color(mat.specular_color)
        self.specular_intensity = self.convert_float(mat.specular_intensity)
        self.ambient_intensity = self.convert_float(mat.ambient)
        self.emit = self.convert_float(mat.emit)
        self.transparency = self.convert_float(mat.alpha)
    def convert_float(self, f, mult=100):
        return int(f * mult)
    def convert_color(self, arr, mult=100):
        return (self.convert_float(arr[0], mult),
                self.convert_float(arr[1], mult),
                self.convert_float(arr[2], mult))

    def to_xml(self, xml):
        xml.set('name', str(self.name))
        xml.set('ID', str(self.ID))
        xml.set('use_shading', str(self.use_shading))
        xml.set('shadows_cast', str(self.shadows_cast))
        xml.set('shadows_receive', str(self.shadows_receive))
        xml.set('diffuse_intensity', str(self.diffuse_intensity))
        xml.set('specular_intensity', str(self.specular_intensity))
        xml.set('ambient_intensity', str(self.ambient_intensity))
        xml.set('emit', str(self.emit))
        xml.set('transparency', str(self.transparency))
        # colors
        xml.set('diffuse_r', str(self.diffuse_color[0]))
        xml.set('diffuse_g', str(self.diffuse_color[1]))
        xml.set('diffuse_b', str(self.diffuse_color[2]))
        xml.set('specular_r', str(self.specular_color[0]))
        xml.set('specular_g', str(self.specular_color[1]))
        xml.set('specular_b', str(self.specular_color[2]))

class MyFace:
    def __init__(self):
        self.material_id = None
        self.vertex1_id = None
        self.vertex2_id = None
        self.vertex3_id = None
        self.normal = None

    def interpret(self, face, vert_offset, mat_id):
        self.material_id = mat_id
        self.vertex1_id = face.vertices[0] + vert_offset
        self.vertex2_id = face.vertices[1] + vert_offset
        self.vertex3_id = face.vertices[2] + vert_offset

    def to_xml(self, xml):
        xml.set('material_id', str(self.material_id))
        xml.set('vertex1_id', str(self.vertex1_id))
        xml.set('vertex2_id', str(self.vertex2_id))
        xml.set('vertex3_id', str(self.vertex3_id))

class MyTag:
    def __init__(self):
        self.name = None
        self.ID = None

    def interpret(self, group):
        self.name = group.name
        self.ID = group.index

    def to_xml(self, xml):
        xml.set('name', str(self.name))
        xml.set('ID', str(self.ID))

class MyAnimation:
    def __init__(self):
        self.name = None
        self.length_ms = None
        self.frames = None

    def interpret(self, animation, fps):
        self.name = animation.name
        self.length_ms = animation.frame_range[1] - animation.frame_range[0]
        self.length_ms = int(self.length_ms * (1000.0 / fps))
        self.frames = []

    def interpret_none(self):
        self.name = 'static'
        self.length_ms = 0
        self.frames = []

    def to_xml(self, xml):
        xml.set('name', str(self.name))
        xml.set('length_ms', str(self.length_ms))
        for frame in self.frames:
            xframe = ET.SubElement(xml, 'frame')
            frame.to_xml(xframe)

class MyFrame:
    def __init__(self):
        self.index = None
        self.time_ms = None
        self.vertices = None

    def interpret(self, frame, animation, index, fps):
        self.index = index
        self.time_ms = frame.co[0] - animation.frame_range[0]
        self.time_ms = int(self.time_ms * (1000.0 / fps))
        self.vertices = []

    def interpret_none(self):
        self.index = 0
        self.time_ms = 0
        self.vertices = []

    def to_xml(self, xml):
        xml.set('index', str(self.index))
        xml.set('time_ms', str(self.time_ms))
        for vert in self.vertices:
            xvert = ET.SubElement(xml, 'vert')
            vert.to_xml(xvert)

class MyVertex:
    def __init__(self):
        self.x = None
        self.y = None
        self.z = None
        self.tag_id = None
        self.normal = None

    def interpret(self, vertex, x, y, z):
        self.x = x
        self.y = y
        self.z = z
        if len(vertex.groups) > 0:
            self.tag_id = vertex.groups[0].group
        else:
            self.tag_id = -1
        self.normal = vertex.normal

    def to_xml(self, xml):
        xml.set('x', "{:f}".format(self.x))
        xml.set('y', "{:f}".format(self.y))
        xml.set('z', "{:f}".format(self.z))
        xml.set('tag_id', str(self.tag_id))
        xml.set('normal_x', "{:f}".format(self.normal.x))
        xml.set('normal_y', "{:f}".format(self.normal.y))
        xml.set('normal_z', "{:f}".format(self.normal.z))

class XMLWriter:
    def __init__(self):
        self.filepath = None
        self.use_compression = None
        self.xml = None
        self.materials = None
        self.faces = None
        self.tags = None
        self.animations = None

    def set_data(self, materials, faces, tags, animations):
        self.materials = materials
        self.faces = faces
        self.tags = tags
        self.animations = animations

    def gen_xml(self):
        xroot = ET.Element('chopmesh')

        xmats = ET.SubElement(xroot, 'materials')
        for mat in self.materials:
            xmat = ET.SubElement(xmats, 'material')
            mat.to_xml(xmat)

        xfaces = ET.SubElement(xroot, 'faces')
        for face in self.faces:
            xface = ET.SubElement(xfaces, 'face')
            face.to_xml(xface)

        xtags = ET.SubElement(xroot, 'tags')
        for tag in self.tags:
            xtag = ET.SubElement(xtags, 'tag')
            tag.to_xml(xtag)

        xanimations = ET.SubElement(xroot, 'animations')
        for animation in self.animations:
            xanimation = ET.SubElement(xanimations, 'animation')
            animation.to_xml(xanimation)

        self.xml = ET.ElementTree(xroot)

    def write(self, filepath, use_compression=True):
        self.filepath = filepath
        output = minidom.parseString(
                ET.tostring(self.xml.getroot(), 'utf-8')
            ).toprettyxml(indent="    ")
        if use_compression:
            output = zlib.compress(output.encode('utf-8'))
            target = open(self.filepath, 'wb')
            target.write(output)
            target.close()
        else:
            target = open(self.filepath, 'wt')
            target.write(output)
            target.close()

def get_vertices(scene, global_matrix, filepath):
    if use_log:
        logfile = open(os.path.join(os.path.dirname(filepath), "chopmeshlog"), "r")
        before = logfile.read()
        logfile.close()
        logfile = open(os.path.join(os.path.dirname(filepath), "chopmeshlog"), "a")
        logfile.truncate(0)
    vertices = []
    for obj in bpy.data.objects:
        if obj.type == 'MESH':
            mesh = obj.to_mesh(scene=scene, apply_modifiers=True, settings='PREVIEW', calc_tessface=False)

            if mesh.is_editmode:
                operator.report({'ERROR'}, 'Can\'t export while in edit mode, switch over to object mode.')
                return {'CANCELLED'}
            the_bmesh = bmesh.new()
            the_bmesh.from_mesh(mesh)
            bmesh.ops.triangulate(the_bmesh, faces=the_bmesh.faces)
            the_bmesh.to_mesh(mesh)
            the_bmesh.free()
            del the_bmesh

            mesh.transform(global_matrix * obj.matrix_world)

            for v in mesh.vertices:
                vertices.append((v, v.co[0], v.co[1], v.co[2]))
                if use_log:
                    logfile.write("v {:f} {:f} {:f}\n".format(v.co[0], v.co[1], v.co[2]))
            bpy.data.meshes.remove(mesh)
    if use_log:
        logfile.write(before)
        logfile.close()
    return vertices

def save(operator, context, filepath="",
        use_compression=True,
        global_matrix=None
        ):

    # materials = []
    # for i in range(len(bpy.data.materials)):
    #     mat = bpy.data.materials[i]
    #     my_mat = MyMaterial()
    #     my_mat.interpret(mat)
    #     my_mat.ID = i
    #     materials.append(my_mat)

    # if len(bpy.data.meshes) > 1:
    #     operator.report({'ERROR'}, 'There must be only one mesh. Try joining your mesh objects into a single mesh object.')
    #     return {'CANCELLED'}

    scene = context.scene
    materials = []
    material_map = {}
    faces = []
    tags = []
    vert_offset = 0
    for obj in bpy.data.objects:
        if obj.type == 'MESH':
            mesh = obj.to_mesh(scene=scene, apply_modifiers=True, settings='PREVIEW', calc_tessface=False)

            for i in range(len(mesh.materials)):
                mat = mesh.materials[i]
                if mat.name in material_map:
                    pass
                else:
                    my_mat = MyMaterial()
                    my_mat.interpret(mat)
                    my_mat.ID = len(materials)
                    materials.append(my_mat)
                    material_map[mat.name] = my_mat

            if mesh.is_editmode:
                operator.report({'ERROR'}, 'Can\'t export while in edit mode, switch over to object mode.')
                return {'CANCELLED'}
            the_bmesh = bmesh.new()
            the_bmesh.from_mesh(mesh)
            bmesh.ops.triangulate(the_bmesh, faces=the_bmesh.faces)
            the_bmesh.to_mesh(mesh)
            the_bmesh.free()
            del the_bmesh

            if use_log:
                logfile = open(os.path.join(os.path.dirname(filepath), "chopmeshlog"), "a")
                logfile.truncate(0)
            for i in range(len(mesh.polygons)):
                poly = mesh.polygons[i]
                my_face = MyFace()
                my_face.interpret(
                    poly,
                    vert_offset,
                    material_map[obj.material_slots[poly.material_index].material.name].ID
                    )
                faces.append(my_face)
                if use_log:
                    logfile.write("f {:d} {:d} {:d}\n".format(poly.vertices[0] + 1, poly.vertices[1] + 1, poly.vertices[2] + 1))
            vert_offset += len(mesh.vertices)
            if use_log:
                logfile.close()

            for j in range(len(obj.vertex_groups)):
                group = obj.vertex_groups[j]
                my_tag = MyTag()
                my_tag.interpret(group)
                tags.append(my_tag)

            bpy.data.meshes.remove(mesh)

    animations = []
    if len(bpy.data.actions) == 0:
        # Static mesh
        vertices = []
        for vert in get_vertices(scene, global_matrix, filepath):
            my_vert = MyVertex()
            my_vert.interpret(vert[0], vert[1], vert[2], vert[3])
            vertices.append(my_vert)
        frame = MyFrame()
        frame.interpret_none()
        frame.vertices = vertices
        animation = MyAnimation()
        animation.interpret_none()
        animation.frames = [frame]
        animations.append(animation)
    else:
        for animation in bpy.data.actions:
            my_animation = MyAnimation()
            my_animation.interpret(animation, float(scene.render.fps))
            for curve in animation.fcurves:
                for i in range(len(curve.keyframe_points)):
                    frame = curve.keyframe_points[i]
                    my_frame = MyFrame()
                    my_frame.interpret(frame, animation, i, float(scene.render.fps))
                    my_animation.frames.append(my_frame)
                    scene.frame_set(frame.co[0], 0.0)
                    for vert in get_vertices(scene, global_matrix, filepath):
                        my_vert = MyVertex()
                        my_vert.interpret(vert[0], vert[1], vert[2], vert[3])
                        my_frame.vertices.append(my_vert)
                break
            animations.append(my_animation)

    writer = XMLWriter()
    writer.set_data(materials, faces, tags, animations)
    writer.gen_xml()
    writer.write(filepath, use_compression)


    print('chopmesh exported!')
    return {'FINISHED'}





######################### The inline __init__.py code #########################

bl_info = {
    "name": ".chopmesh exporter ultimate",
    "author": "Ohmnivore",
    "version": (1, 0, 1),
    "blender": (2, 75, 0),
    "location": "File > Export",
    "description": "Export .chopmesh mesh. material, and animation data for this model",
    "category": "Import-Export"}


import bpy
from bpy.props import (
        BoolProperty,
        FloatProperty,
        StringProperty,
        EnumProperty,
        )
from bpy_extras.io_utils import (
        ImportHelper,
        ExportHelper,
        orientation_helper_factory,
        path_reference_mode,
        axis_conversion,
        )

IOOBJOrientationHelper = orientation_helper_factory("IOOBJOrientationHelper", axis_forward='-Z', axis_up='Y')

class ExportChopMesh(bpy.types.Operator, ExportHelper, IOOBJOrientationHelper):
    """Export CHOP files"""

    bl_idname = "unnamed.chopmesh"
    bl_label = 'Export to .chopmesh'
    bl_options = {'PRESET'}

    filename_ext = ".chopmesh"
    filter_glob = StringProperty(
            default="*.chopmesh",
            options={'HIDDEN'},
            )

    # context group
    use_compression = BoolProperty(
            name="Compression",
            description="Use zip compression to save space",
            default=True,
            )

    check_extension = True

    def execute(self, context):

        from mathutils import Matrix
        keywords = self.as_keywords(ignore=("axis_forward",
                                            "axis_up",
                                            "check_existing",
                                            "filter_glob",
                                            ))

        global_matrix = (Matrix.Scale(1, 4) *
                         axis_conversion(to_forward=self.axis_forward,
                                         to_up=self.axis_up,
                                         ).to_4x4())

        keywords["global_matrix"] = global_matrix
        return save(self, context, **keywords)


def menu_func_export(self, context):
    self.layout.operator(ExportChopMesh.bl_idname, text=".chopmesh")


def register():
    bpy.utils.register_module(__name__)
    bpy.types.INFO_MT_file_export.append(menu_func_export)


def unregister():
    bpy.utils.unregister_module(__name__)
    bpy.types.INFO_MT_file_export.remove(menu_func_export)


if __name__ == "__main__":
    register()
