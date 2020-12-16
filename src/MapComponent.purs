module MapComponent where

import Prelude (Unit, Void, ($), bind, discard, negate, pure, unit)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Effect.Console (log)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

import OpenLayers.Layer.Tile as Tile
import OpenLayers.Map as Map
import OpenLayers.Proj as Proj
import OpenLayers.Source.OSM as OSM
import OpenLayers.View as View

-- type Slot = H.Slot Query Void
type Slot = H.Slot (Const Void) Void

-- | State for the component
type State =  {   map           ::Maybe Map.Map         -- | The Map on the page
              }

type ChildSlots = ()


data Action
  = Initialize
  | Finalize

-- | The component definition
component :: forall q i o m . MonadAff m
          => H.Component HH.HTML q i o m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction,
      initialize = Just Initialize,
      finalize = Just Finalize
     }
    }

  where


  initialState :: i -> State
  initialState ml =  {  map : Nothing  }

  render :: State -> H.ComponentHTML Action ChildSlots m
  render state =
    HH.div_
      [ renderMap state  ]

  renderMap :: State -> H.ComponentHTML Action ChildSlots m
  renderMap state =
    HH.div_
       [ HH.div
           [ HP.id_ "parent" ]
           [ HH.text "map will go here" ]
       , HH.div [HP.id_ "map" ][]
       ]

  handleAction ∷ Action -> H.HalogenM State Action ChildSlots o m Unit
  handleAction = case _ of
    Initialize -> do
      hamap <- createBasicMap
      H.modify_ (_ { map = Just hamap }
                )
    Finalize -> do
      pure unit

--
-- Creates a basic map
--
createBasicMap :: forall o m . MonadAff m
          => H.HalogenM State Action () o m Map.Map
createBasicMap = do

  state <- H.get
  hamap <- H.liftEffect $ do
    -- Use OpenStreetMap as a source
    osm <- OSM.create'
    tile <- Tile.create {source: osm}

    -- Create the view of Edinburgh
    view <- View.create { projection: Proj.epsg_3857
                        , center: Proj.fromLonLat edinburghLonLat (Just Proj.epsg_3857)
                        , zoom: defaultZoom
                        }

    log "creating map at div id map"
      
    -- Create the map and set up the controls, layers and view
    Map.create {
        target: Map.target.asId "map"
        , layers: Map.layers.asArray [ tile ]
        , view: view}

  -- Return with the map
  pure hamap

edinburghLonLat :: Array Number
edinburghLonLat = [-3.1883, 55.9533 ]

defaultZoom :: Number
defaultZoom = 13.0
