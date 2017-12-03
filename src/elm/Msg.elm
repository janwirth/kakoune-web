module Msg exposing ( Msg(..) )
import Kakoune exposing ( draw, DrawParams, keydown )
import Keyboard

-- UPDATE
type Msg = Draw DrawParams | KeyPress Keyboard.KeyCode

