module Graph exposing (Graph, Path, Vertex, empty, insertNeighbors, member, neighbors)

{-| This module exposes graph related abstractions.

The code below shows how to recreate the graph from [Dijkstra Algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm) wikipedia page.

            g =
                empty
                    |> insertNeighbors '1' [ ( '2', 7 ), ( '3', 9 ), ( '6', 14 ) ]
                    |> insertNeighbors '2' [ ( '1', 7 ), ( '3', 10 ), ( '4', 15 ) ]
                    |> insertNeighbors '3' [ ( '1', 9 ), ( '2', 10 ), ( '4', 11 ), ( '6', 2 ) ]
                    |> insertNeighbors '4' [ ( '2', 15 ), ( '3', 11 ), ( '5', 6 ) ]
                    |> insertNeighbors '5' [ ( '4', 6 ), ( '6', 9 ) ]
                    |> insertNeighbors '6' [ ( '1', 14 ), ( '3', 2 ), ( '5', 9 ) ]

-}

import Dict exposing (Dict)
import Set exposing (Set)


{-| A [`Graph`](https://en.wikipedia.org/wiki/Graph) is a

> structure amounting to a set of objects in which some pairs of the objects are in some sense "related". The objects correspond to mathematical abstractions called vertices (also called nodes or points) and each of the related pairs of vertices is called an edge (also called an arc or line).

Specifically our graph or directed, edge-weighted graphs.

-}
type Graph
    = Graph
        { vertices : Set Vertex
        , edges : Dict Vertex (Set ( Vertex, Int ))
        }


{-| The type over vertices in our graph.
-}
type alias Vertex =
    Char


{-| Returns an empty graph.
-}
empty : Graph
empty =
    Graph { vertices = Set.empty, edges = Dict.empty }


{-| Inserts all the neighbors with correspond distances into the graph.
-}
insertNeighbors : Vertex -> List ( Vertex, Int ) -> Graph -> Graph
insertNeighbors v vs (Graph graph) =
    let
        ns =
            Set.fromList vs

        edgeVertices =
            vs
                |> List.map (\( n, _ ) -> n)
                |> Set.fromList

        nextVertices =
            graph.vertices
                |> Set.insert v
                |> Set.union edgeVertices
    in
    Graph
        { edges = Dict.insert v ns graph.edges
        , vertices = nextVertices
        }


type alias Path =
    List Vertex


{-| Returns all neighbors and there distance form the vertex.
-}
neighbors : Vertex -> Graph -> Set ( Vertex, Int )
neighbors vertex (Graph { edges }) =
    Dict.get vertex edges
        |> Maybe.withDefault Set.empty


{-| Determines if vertex is a present in the graph.
-}
member : Vertex -> Graph -> Bool
member vertex (Graph { vertices }) =
    Set.member vertex vertices
