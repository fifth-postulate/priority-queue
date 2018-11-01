module PriorityQueue exposing
    ( PriorityQueue, Priority
    , empty, insert, fromList
    , head, tail
    , toList
    )

{-| A priority queue for Elm.

A [_priority queue_](https://en.wikipedia.org/wiki/Priority_queue) is an

> abstract data type which is like a regular queue or stack data structure, but where additionally each element has a "priority" associated with it. In a priority queue, an element with high priority is served before an element with low priority.

The implementation we provide here is based on Okasaki's _leftist heaps_. See [Purely Functional Data Structures](https://www.cs.cmu.edu/~rwh/theses/okasaki.pdf) for more information.


# Priority

Throughout this package `priority` will mean a function that assigns a integer value to an element. Lower values indicate higher priority and vice versa.


# Types

@docs PriorityQueue, Priority


# Building

@docs empty, insert, fromList


# Query

@docs head, tail


# Conversion

@docs toList

-}

import PriorityQueue.Kernel as Kernel


{-| The abstract datatype of this package.
-}
type alias PriorityQueue a =
    Kernel.PriorityQueue a


{-| A function that assigns a priority to elements.

Higher values correspond to higher priority.

-}
type alias Priority a =
    Kernel.Priority a


{-| Create an empty `PriorityQueue`.
-}
empty : Priority a -> PriorityQueue a
empty priority =
    Kernel.empty priority


{-| Insert an element into the `PriorityQueue`
-}
insert : a -> PriorityQueue a -> PriorityQueue a
insert element queue =
    Kernel.insert element queue


{-| Creates a `PriorityQueue` from a given list of elements.

Must be given a `priority` function, i.e. a function that assigns the priority to elements.

-}
fromList : Priority a -> List a -> PriorityQueue a
fromList priority elements =
    let
        emptyQueue =
            Kernel.empty priority
    in
    List.foldl Kernel.insert emptyQueue elements


{-| Return the element of the `PriorityQueue` with the highest priority.

Returns `Nothing` when the queue is empty.

-}
head : PriorityQueue a -> Maybe a
head queue =
    Kernel.head queue


{-| Return the `PriorityQueue` that remains when the head is removed.
-}
tail : PriorityQueue a -> PriorityQueue a
tail queue =
    Kernel.tail queue


{-| Returns all the elements in a `PriorityQueue` as a `List`.

The order will be determined by the priority, higher priority elements before lower priority elements.

-}
toList : PriorityQueue a -> List a
toList queue =
    tailRecursiveToList [] queue


{-| [Tail-recursive][https://en.wikipedia.org/wiki/Tail_call] version of `toList`.
-}
tailRecursiveToList : List a -> PriorityQueue a -> List a
tailRecursiveToList accumulator queue =
    case Kernel.head queue of
        Nothing ->
            List.reverse accumulator

        Just element ->
            tailRecursiveToList (element :: accumulator) (Kernel.tail queue)
