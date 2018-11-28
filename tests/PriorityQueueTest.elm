module PriorityQueueTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import PriorityQueue
import Test exposing (..)


suite : Test
suite =
    describe "PriorityQueue"
        [ describe "invariant"
            [ test "highest priority first" <|
                \_ ->
                    let
                        queue =
                            PriorityQueue.empty negate
                                |> PriorityQueue.insert 1
                                |> PriorityQueue.insert 2
                                |> PriorityQueue.insert 3
                    in
                    Expect.equal (Just 3) (PriorityQueue.head queue)
            , test "take" <|
                \_ ->
                    let
                        queue =
                            PriorityQueue.empty negate
                                |> PriorityQueue.insert 1
                                |> PriorityQueue.insert 2
                                |> PriorityQueue.insert 3

                        actual =
                            PriorityQueue.take 2 queue

                        expected =
                            [ 3, 2 ]
                    in
                    Expect.equal actual expected
            , test "drop" <|
                \_ ->
                    let
                        queue =
                            PriorityQueue.empty negate
                                |> PriorityQueue.insert 1
                                |> PriorityQueue.insert 2
                                |> PriorityQueue.insert 3

                        actual =
                            queue
                                |> PriorityQueue.drop 2
                                |> PriorityQueue.toList

                        expected =
                            [ 1 ]
                    in
                    Expect.all
                        [ \_ -> Expect.false "should not be empty" <| PriorityQueue.isEmpty queue
                        , \_ -> Expect.equal actual expected
                        ]
                        ()
            , fuzz (list int) "high priority elements before low priority" <|
                \aList ->
                    let
                        queue =
                            PriorityQueue.fromList negate aList

                        actual =
                            PriorityQueue.toList queue

                        expected =
                            aList
                                |> List.sort
                                |> List.reverse
                    in
                    Expect.equal actual expected
            ]
        ]
