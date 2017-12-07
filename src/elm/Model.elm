module Model exposing ( Model, model )
import Kakoune exposing ( DrawParams )


-- MODEL
type alias Model = {
  buffer : List DrawParams,
  status : DrawParams,
  presses : List Char,
  modifiers : {
      shift : Bool,
      ctrl : Bool
  }
}

model : Model
model = {
    buffer = [],
    status = [],
    presses = [],
    modifiers = {
        shift = False
      , ctrl = False
    }
  }

