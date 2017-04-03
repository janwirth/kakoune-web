module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
-- import Html.Events exposing ( onClick )

bufferWidth : number
bufferWidth = 60

lineHeight : number
lineHeight = 60

-- APP
main : Program Never Model Msg
main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL
type alias Selection =
  {
      start : (Int, Int)
    , end : (Int, Int)
  }

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
  , selection = [
        ("z-index", "100")
      , ("position", "absolute")
    ]
  , selectionLine = [
        ("background-color", "#ccc")
      , ("height", toPixel lineHeight)
      , ("position", "relative")
      , ("color", "transparent")
    ]
  , text = style [
        ("z-index", "200")
      , ("position", "relative")
      -- , ("color", "transparent")
      -- , ("pointer-events", "none")
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
      , div [] <| List.map (renderSelection bufferLines) model.selections
    ]





renderSelection : List String -> Selection -> Html msg
renderSelection bufferLines selection =
  let
    selectionLines = calculateSelectionLines bufferLines selection
    top = lineHeight * ((Tuple.first selection.start) - 1)
    position = [("top", toPixel top)]
    layout = List.concat [styles.selection, position]
  in
    div [style layout] <| List.map renderSelectionLine selectionLines

-- Selection line consists of start & end of the highlight on a specific line
type alias SelectionLine = (Int, Int)

-- calculateSelectionLines
calculateSelectionLines : List String -> Selection -> List SelectionLine
calculateSelectionLines bufferLines selection =
  let
    selectionLineRange = List.range (Tuple.first selection.start) (Tuple.first selection.end)
    -- all lines except first start at 0, first one starts at first selection.start x coord
    lineStarts = List.repeat (List.length selectionLineRange) 0
      |> List.tail
      |> Maybe.withDefault []
      |> (::) (Tuple.second selection.start)
    lineEnds = bufferLines
      |> List.map String.length
      |> List.drop (Maybe.withDefault 0 (List.head selectionLineRange) + 1)
      |> List.take ((List.length selectionLineRange) - 1)
      |> List.reverse
      |> (::) (Tuple.second selection.end)
      |> List.reverse
  in
    -- determine if is single-line selection
    -- if single-line selection, calculate single selection line
    if List.length selectionLineRange == 1 then
      [((Tuple.second selection.start), (Tuple.second selection.end))]
    else
      -- else calculate array of lines
      List.map2 (\start end -> (start, end)) lineStarts lineEnds

renderSelectionLine : SelectionLine -> Html msg
renderSelectionLine selectionLine =
  let
    layout = [
        ("left", toCh (Tuple.first selectionLine))
      , ("width", toCh (((Tuple.second selectionLine) - (Tuple.first selectionLine))))
    ]
    colorAndLayout = List.concat [layout, styles.selectionLine]
  in
    div [style colorAndLayout] [text <| toString <| selectionLine]








-- CSS HELPER FUNCTIONS
toPixel number = toCssUnit "px" number

toCh number = toCssUnit "ch" number

toCssUnit : String -> Int -> String
toCssUnit unit content =
  (toString content) ++ unit
