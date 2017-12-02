module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Kakoune exposing ( draw, DrawParams )

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
type alias Model = List DrawParams

model : Model
model = []


-- UPDATE
type Msg = Draw DrawParams

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Draw params -> (model ++ [ params ], Cmd.none)


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
    draw Draw
  ]
