module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Selection exposing (Selection)

lineHeight = 60

-- APP
main : Program Never Model Msg
main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

multiLineSelection =
  {
      start = (3, 5)
    , end = (6, 1)
  }

singleLineSelection =
  {
      start = (1, 2)
    , end = (1, 10)
  }

type alias Model =
  {
      selections : List Selection
    , content : String
  }


model : Model
model = 
  {
      selections = [ singleLineSelection, multiLineSelection ]
    , content = "Hello World\n You are pretty\nHello World\n You are pretty\nHello World\n You are pretty\nHello World\n You are pretty\n"
  }


-- UPDATE
type Msg = NoOp | Increment

update : Msg -> Model -> Model
update msg model =
  case msg of
    NoOp -> model
    Increment -> model


styles = {
    buffer = style [
        ("font-family", "monospace")
      , ("line-height", toPixel lineHeight )
    ]
  , text = style [
        ("z-index", "200")
      , ("position", "relative")
    ]
  }



view : Model -> Html Msg
view model =
  let
    bufferLines = model.content
      |> String.split "\n"
    content = bufferLines
      |> List.map (\line -> div [] [text line])
  in
    div [ styles.buffer ] [
        pre [styles.text] [text model.content]
        -- map each selection through the selection renderer
      , div [] <| List.map (Selection.render bufferLines) model.selections
    ]






-- CSS HELPER FUNCTIONS
toPixel number = toCssUnit "px" number

toCh number = toCssUnit "ch" number

toCssUnit : String -> Int -> String
toCssUnit unit content =
  (toString content) ++ unit
