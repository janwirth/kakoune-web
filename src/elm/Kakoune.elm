port module Kakoune exposing ( draw, DrawParams )

port draw : (DrawParams -> msg) -> Sub msg
port menu_hide : (MenuHideParams -> msg) -> Sub msg
port info_hide : (InfoHideParams -> msg) -> Sub msg
port draw_status : (DrawStatusParams -> msg) -> Sub msg
port refresh : (RefreshParams -> msg) -> Sub msg

menuHide = menu_hide
infoHide = info_hide
drawStatus = draw_status

type alias DrawParams = List Atom
type alias MenuHideParams = ()
type alias InfoHideParams = ()
type alias DrawStatusParams = List Atom
type alias RefreshParams = ( Bool )

type alias Atom = {
    face: {
      fg : String,
      bg : String,
      attributes : List String
    },
    contents : String
  }
