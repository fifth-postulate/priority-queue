module Main exposing (main)

import Browser
import Graph exposing (Graph, Path, Vertex, empty, insertNeighbors)
import Html exposing (Html)
import Html.Attributes as Attribute
import Html.Events as Event
import PriorityQueue exposing (Priority, PriorityQueue)
import Set exposing (Set)


main =
    let
        graph =
            empty
                |> insertNeighbors '1' [ ( '2', 7 ), ( '3', 9 ), ( '6', 14 ) ]
                |> insertNeighbors '2' [ ( '1', 7 ), ( '3', 10 ), ( '4', 15 ) ]
                |> insertNeighbors '3' [ ( '1', 9 ), ( '2', 10 ), ( '4', 11 ), ( '6', 2 ) ]
                |> insertNeighbors '4' [ ( '2', 15 ), ( '3', 11 ), ( '5', 6 ) ]
                |> insertNeighbors '5' [ ( '4', 6 ), ( '6', 9 ) ]
                |> insertNeighbors '6' [ ( '1', 14 ), ( '3', 2 ), ( '5', 9 ) ]

        from =
            '1'

        to =
            '5'
    in
    Browser.sandbox
        { init = modelFrom graph from to
        , update = update
        , view = view
        }


type alias Model =
    { dijkstra : Maybe Dijkstra
    }


type alias Dijkstra =
    { graph : Graph
    , from : Vertex
    , to : Vertex
    , visited : Set Vertex
    , toVisit : PriorityQueue ( Vertex, Int, Path )
    }


modelFrom : Graph -> Vertex -> Vertex -> Model
modelFrom graph from to =
    dijkstra graph from to
        |> Model


dijkstra : Graph -> Vertex -> Vertex -> Maybe Dijkstra
dijkstra graph from to =
    if Graph.member from graph && Graph.member to graph then
        let
            priority : ( Vertex, Int, Path ) -> Int
            priority ( _, d, _ ) =
                d
        in
        Just
            { graph = graph
            , from = from
            , to = to
            , visited = Set.empty
            , toVisit =
                PriorityQueue.empty priority
                    |> PriorityQueue.insert ( from, 0, [ from ] )
            }

    else
        Nothing


type Message
    = Step


update : Message -> Model -> Model
update message model =
    case message of
        Step ->
            model.dijkstra
                |> Maybe.map step
                |> Model


step : Dijkstra -> Dijkstra
step ({ graph, to, visited, toVisit } as ds) =
    let
        nextVisited =
            PriorityQueue.head toVisit
                |> Maybe.map (\( vertex, _, _ ) -> Set.insert vertex visited)
                |> Maybe.withDefault visited

        nextToVisit =
            PriorityQueue.head toVisit
                |> Maybe.map
                    (\( vertex, d, path ) ->
                        if vertex == to then
                            PriorityQueue.tail toVisit

                        else
                            let
                                ns : Set ( Vertex, Int )
                                ns =
                                    Graph.neighbors vertex graph

                                candidates =
                                    ns
                                        |> Set.map (\( b, s ) -> ( b, d + s, b :: path ))
                            in
                            candidates
                                |> Set.foldl PriorityQueue.insert (PriorityQueue.tail toVisit)
                    )
                |> Maybe.withDefault (PriorityQueue.tail toVisit)
    in
    { ds | visited = nextVisited, toVisit = nextToVisit }


view : Model -> Html Message
view model =
    case model.dijkstra of
        Just ds ->
            Html.div []
                [ Html.img [ Attribute.src "https://upload.wikimedia.org/wikipedia/commons/5/57/Dijkstra_Animation.gif" ] []
                , Html.div
                    []
                    [ Html.button [ Event.onClick Step ] [ Html.text "step" ]
                    , Html.span []
                        [ Html.text <| Debug.toString ds
                        ]
                    ]
                ]

        Nothing ->
            Html.div []
                [ Html.span []
                    [ Html.text "Create a correct Dijkstra model"
                    ]
                ]
