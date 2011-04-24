type obj = Irr_base.obj

exception Rendering_failed_exn

let () = Callback.register_exception "Rendering_failed_exn" Rendering_failed_exn

(******************************************************************************)

(* Binding for class ITexture *)

(******************************************************************************)

external texture_get_original_size : obj -> int Irr_core.dimension_2d =
  "ml_ITexture_getOriginalSize"

class texture obj = object(self)
  inherit Irr_base.reference_counted obj
  method original_size = texture_get_original_size self#obj
end

(******************************************************************************)

(* Binding of class SMaterialLayer *)

(******************************************************************************)

module Material_layer = struct
  type t = {
    mutable aniosotropic_filter : int;
    mutable bilinear_filter : bool;
    mutable lod_bias : int;
    mutable texture : obj option;
    mutable texture_warp_u : Irr_enums.texture_clamp;
    mutable texture_warp_v : Irr_enums.texture_clamp;
    mutable trilinear_filter : bool;
    mutable matrix : Irr_core.matrix4;
  }
  let default = {aniosotropic_filter = 0; bilinear_filter = true;
    lod_bias = 0; texture = None; texture_warp_u = `repeat;
    texture_warp_v = `repeat; trilinear_filter = false;
    matrix = Irr_core.matrix_identity ()}
end

external material_layer_set_bilinear_filter : obj -> bool -> unit =
  "ml_SMaterialLayer_set_BilinearFilter"

class material_layer (obj : obj) = object(self)
  val obj = obj
  method obj = obj
  method set_bilinear_filter b = material_layer_set_bilinear_filter self#obj b
end

(******************************************************************************)

(* Binding of class SMaterial *)

(******************************************************************************)

module Material = struct
  type t = {
    mutable ambiant_color : Irr_core.color;
    mutable anti_aliasing : Irr_enums.anti_aliasing_mode;
    mutable backface_culling : bool;
    mutable color_mask : Irr_enums.color_plane;
    mutable color_material : Irr_enums.colormaterial;
    mutable diffuse_color : Irr_core.color;
    mutable emissive_color : Irr_core.color;
    mutable fog_enable : bool;
    mutable fontface_culling : bool;
    mutable shading : bool;
    mutable lighting : bool;
    mutable material_type : Irr_enums.material_type;
    mutable material_type_param : float;
    mutable material_type_param2 : float;
    mutable normalize_normals : bool;
    mutable point_cloud : bool;
    mutable shininess : float;
    mutable specular_color : Irr_core.color;
    mutable texture_layer : Material_layer.t array;
    mutable thickness : float;
    mutable wireframe : bool;
    mutable z_buffer : Irr_enums.comparison_func;
    mutable z_write_enable : bool;
  }
end

external material_texture_layer : obj -> int -> obj =
  "ml_SMaterial_TextureLayer"

external material_set_anti_aliasing :
  obj -> Irr_enums.anti_aliasing_mode -> unit =
    "ml_SMaterial_set_AntiAliasing"

external material_get_wireframe : obj -> bool = "ml_SMaterial_get_Wireframe"

external material_get_point_cloud : obj -> bool =
  "ml_SMaterial_get_PointCloud"

external material_get_material_type : obj -> Irr_enums.material_type =
  "ml_SMaterial_get_MaterialType"

external material_set_texture : obj -> int -> obj -> unit =
  "ml_SMaterial_setTexture"

external material_set_lighting : obj -> bool -> unit =
  "ml_SMaterial_set_Lighting"

external material_set_normalize_normals : obj -> bool -> unit =
  "ml_SMaterial_set_NormalizeNormals"

class material (obj : obj) = object(self)
  val obj = obj
  method obj = obj
  method layer i =
    let obj = material_texture_layer self#obj i in
    object
      val mat = self
      inherit material_layer obj
    end
  method wireframe = material_get_wireframe self#obj
  method point_cloud = material_get_point_cloud self#obj
  method material_type = material_get_material_type self#obj
  method set_anti_aliasing m = material_set_anti_aliasing self#obj m
  method set_texture i (t : texture) =
    material_set_texture self#obj i t#obj
  method set_lighting flag = material_set_lighting self#obj flag
  method set_normalize_normals flag =
    material_set_normalize_normals self#obj flag
end

(******************************************************************************)

(* Binding of class IVideoDriver *)

(******************************************************************************)

external driver_begin_scene : obj -> bool -> bool -> Irr_core.color -> unit =
  "ml_IVideoDriver_beginScene"

external driver_end_scene : obj -> unit = "ml_IVideoDriver_endScene"

external driver_draw_2d_image :
  obj -> obj -> int Irr_core.dimension_2d -> int Irr_core.rect ->
    (int Irr_core.rect) option -> Irr_core.color -> bool -> unit =
      "ml_IVideoDriver_draw2DImage_bytecode"
      "ml_IVideoDriver_draw2DImage_native"

external driver_draw_2d_image_scale :
  obj -> obj -> int Irr_core.rect -> int Irr_core.rect ->
  (int Irr_core.rect) option ->
  (Irr_core.color * Irr_core.color * Irr_core.color * Irr_core.color) option ->
  bool -> unit =
    "ml_IVideoDriver_draw2DImage_scale_bytecode"
    "ml_IVideoDriver_draw2DImage_scale_native"

external driver_draw_2d_rectangle :
  obj -> Irr_core.color -> int Irr_core.rect -> (int Irr_core.rect) option ->
    unit =
      "ml_IVideoDriver_draw2DRectangle"

external driver_get_texture : obj -> string -> obj =
  "ml_IVideoDriver_getTexture"

external driver_get_fps : obj -> int = "ml_IVideoDriver_getFPS"

external driver_get_name : obj -> string = "ml_IVideoDriver_getName"

external driver_get_material_2d : obj -> obj =
  "ml_IVideoDriver_getMaterial2D"

external driver_make_color_key_from_px :
  obj -> obj -> int Irr_core.pos_2d -> bool -> unit =
    "ml_IVideoDriver_makeColorKeyTexture1"

external driver_enable_material_2d : obj -> bool -> unit =
  "ml_IVideoDriver_enableMaterial2D"

external driver_set_texture_creation_flag :
  obj -> Irr_enums.texture_creation_flag -> bool -> unit =
    "ml_IVideoDriver_setTextureCreationFlag"

external driver_set_transform :
  obj -> Irr_enums.transformation_state -> Irr_core.matrix4 -> unit =
    "ml_IVideoDriver_setTransform"

external driver_draw_3d_triangle :
  obj -> Irr_core.triangle3df -> Irr_core.color -> unit =
    "ml_IVideoDriver_draw3DTriangle"

external driver_set_material : obj -> obj -> unit =
  "ml_IVideoDriver_setMaterial"

class driver obj = object(self)
  inherit Irr_base.reference_counted obj
  method begin_scene ?(backbuffer = true) ?(zbuffer = true)
    ?(color = Irr_core.color_ARGB 255 0 0 0) () =
    driver_begin_scene self#obj backbuffer zbuffer color
  method end_scene = driver_end_scene self#obj
  method draw_2d_image (tex : texture)
  ?(src = let w, h = tex#original_size in (0, 0, w, h)) ?clip
    ?(color = Irr_core.color_ARGB 255 255 255 255) ?(alpha = false) dst =
    driver_draw_2d_image self#obj tex#obj dst src clip color alpha
  method draw_2d_rect color ?clip pos =
    driver_draw_2d_rectangle self#obj color pos clip
  method draw_2d_image_scale (tex: texture)
    ?(src = let w, h = tex#original_size in (0, 0, w, h)) ?clip ?colors
    ?(alpha = false) dst =
    driver_draw_2d_image_scale self#obj tex#obj dst src clip colors alpha
  method get_texture filename =
    let obj = driver_get_texture self#obj filename in
    object
      val driver = self
      inherit texture obj
    end
  method material_2d =
    let obj = driver_get_material_2d self#obj in
    object
      val driver = self
      inherit material obj
    end
  method enable_material_2d = driver_enable_material_2d self#obj true
  method disable_material_2d = driver_enable_material_2d self#obj false
  method make_color_key_from_px (tex : texture) ?(zero_texels = false) pos =
    driver_make_color_key_from_px self#obj tex#obj pos zero_texels
  method fps = driver_get_fps self#obj
  method name =
    String.copy (driver_get_name self#obj)
  method set_texture_creation_flag flag b =
    driver_set_texture_creation_flag self#obj flag b
  method set_transform state mat = driver_set_transform self#obj state mat
  method draw_3d_triangle t c = driver_draw_3d_triangle self#obj t c
  method set_material (m : material) = driver_set_material self#obj m#obj
end
