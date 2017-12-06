port module Kakoune exposing ( drawBuffer, drawStatus, DrawParams, keydown, Atom )

port draw : (List DrawParams -> msg) -> Sub msg
port menu_hide : (MenuHideParams -> msg) -> Sub msg
port info_hide : (InfoHideParams -> msg) -> Sub msg
port draw_status : (DrawParams -> msg) -> Sub msg
port refresh : (RefreshParams -> msg) -> Sub msg

port keydown : String -> Cmd msg

menuHide = menu_hide
infoHide = info_hide
drawBuffer = draw
drawStatus = draw_status

type alias DrawParams = List Atom
type alias MenuHideParams = ()
type alias InfoHideParams = ()
type alias RefreshParams = ( Bool )

type alias Atom = {
    face: {
      fg : String,
      bg : String,
      attributes : List String
    },
    contents : String
  }

