module PriorityQueue.Kernel exposing (PriorityQueue)

type PriorityQueue a =
    PriorityQueue { priority : a -> Int }
