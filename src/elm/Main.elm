module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Kakoune exposing ( draw, DrawParams, keydown )
import Keyboard
import Char

-- component import example
import Components.Hello exposing ( hello )


-- APP
main : Program Never Model Msg
main = Html.program {
    init = ( model, Cmd.none ),
    view = view,
    update = update,
    subscriptions = subscriptions
  }


-- MODEL
type alias Model = {
  draws : List DrawParams,
  presses : List Char
}

model : Model
model = {
    draws = [],
    presses = []
  }


-- UPDATE
type Msg = Draw DrawParams | KeyPress Keyboard.KeyCode

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Draw params -> (
      { model | draws = model.draws ++ [ params ] },
      Cmd.none
    )
    KeyPress code -> (
      { model | presses = model.presses ++ [ Char.fromCode code ] },
      Cmd.none
    )


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model = text <| toString <| model

-- CSS STYLES
styles : { img : List ( String, String ) }
styles =
  {
    img =
      [ ( "width", "33%" )
      , ( "border", "4px solid #337AB7")
      ]
  }


subscriptions init = Sub.batch [
    draw Draw,
    Keyboard.downs KeyPress
  ]
