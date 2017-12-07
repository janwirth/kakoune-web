module Msg exposing ( Msg(..) )
import Kakoune exposing ( DrawParams, keydown )
import Keyboard

-- UPDATE
type Msg = DrawBuffer (List DrawParams)
         | DrawStatus DrawParams
         | KeyPress Keyboard.KeyCode
         | KeyRelease Keyboard.KeyCode

