module Main exposing (..)
import Html exposing (..)
import Kakoune exposing ( drawBuffer, drawStatus, DrawParams, keydown )
import Keyboard
import View exposing ( view )
import Msg exposing ( Msg(..) )
import Model exposing ( Model, model )
import Keys exposing ( .. )
import Debug exposing ( log )


-- APP
main : Program Never Model Msg
main = Html.program {
    init = ( model, Cmd.none ),
    view = view,
    update = update,
    subscriptions = subscriptions
  }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    noop = ( model, Cmd.none )
  in
    case msg of
      DrawStatus params -> (
        { model | status = params },
        Cmd.none
      )
      DrawBuffer params -> (
        { model | buffer = params },
        Cmd.none
      )
      KeyPress code ->
        case mapKey code of
          Nothing -> noop
          Just key -> case key of
            Normal str -> ( model, keydown str )
            Mod modifier -> ( setMod True model modifier, Cmd.none )
      KeyRelease code ->
        case mapKey code of
          Nothing -> noop
          Just key -> case key of
            Normal str -> noop
            Mod modifier -> ( setMod False model modifier, Cmd.none )

setMod active model modifier =
  let
    mods = model.modifiers
  in
    case modifier of
      Shift -> { model | modifiers = { mods | shift = active } }
      Ctrl -> { model | modifiers = { mods | ctrl = active } }

subscriptions : a -> Sub Msg
subscriptions init = Sub.batch [
    drawBuffer DrawBuffer,
    drawStatus DrawStatus,
    Keyboard.downs KeyPress,
    Keyboard.ups KeyRelease
  ]
