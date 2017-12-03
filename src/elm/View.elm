module View exposing ( view )
import Kakoune exposing ( Atom )
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Msg exposing ( Msg(..) )
import Model exposing ( Model, model )
import Dict exposing ( Dict )


getBg name =
    let
    colors = Dict.fromList [
        ("default", "transparent")
      ]
  in
    Maybe.withDefault name ( Dict.get name colors )

getFg name =
  let
    colors = Dict.fromList [
        ("default", "grey")
      ]
  in
    Maybe.withDefault name ( Dict.get name colors )



-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model = body [ style [("background", "#111"), ("height", "100vh")] ] [
    div [ monospace ] (List.map renderAtom model.atoms)
  ]

monospace : Attribute msg
monospace = style [("font-family", "monospace")]

renderAtom : Atom -> Html Msg
renderAtom atom = span [ atomStyle atom ] [ text atom.contents ]

atomStyle : Atom -> Attribute Msg
atomStyle atom =
  let
    colors = atom.face
  in
    style [ ("color", getFg colors.fg), ("background-color", getBg colors.bg) ]
