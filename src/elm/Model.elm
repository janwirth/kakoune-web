module Model exposing ( Model, model )
import Kakoune exposing ( DrawParams )


-- MODEL
type alias Model = {
  atoms : DrawParams,
  presses : List Char
}

model : Model
model = {
    atoms = [],
    presses = []
  }

