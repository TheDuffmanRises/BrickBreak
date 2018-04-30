module BrickBreak exposing (..)

import Color
import Html exposing (..)
import AnimationFrame

--

import Game.TwoD.Camera as Camera exposing (Camera)
import Game.TwoD.Render as Render exposing (Renderable, rectangle, circle)
import Game.TwoD as Game

-- MAIN
main : Program Never Model Msg
main =
    program
        { view = view
        , update = update
        , init = init
        , subscriptions = subs
        }


-- MODEL
type alias Model =
  { position : ( Float, Float )
  , velocity : ( Float, Float )
  }


type Msg
  = Tick Float


-- INIT
init : ( Model, Cmd Msg )
init =
  { position = ( 0, 4 )
  , velocity = ( 0, 6 )
  }
      ! []


-- SUBSCRIPTIONS
subs m =
    AnimationFrame.diffs Tick

-- UPDATE
update msg model =
    case msg of
        Tick dt ->
            tick (dt / 1000) model ! []


tick dt { position, velocity } =
    let
        ( ( x, y ), ( vx, vy ) ) =
            ( position, velocity )

        vy_ =
            vy - 9.81 * dt

        ( newP, newV ) =
            if y <= 0 then
                ( ( x, 0.00001 ), ( 0, -vy_ * 0.9 ) )
            else
                ( ( x, y + vy_ * dt ), ( 0, vy_ ) )
    in
        Model newP newV


-- VIEW

view : Model -> Html Msg
view m =
    Game.renderCentered { time = 0, camera = Camera.fixedHeight 20 ( 0, 1.5 ), size = ( 800, 600 ) }
        [ Render.shape rectangle { color = Color.green, position = ( -1.5, -1 ), size = ( 3, 1 ) }
        , Render.shape circle { color = Color.blue, position = m.position, size = ( 0.5, 0.5 ) }
        ]
