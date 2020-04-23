# priority-queue[![Build Status](https://travis-ci.org/fifth-postulate/priority-queue.svg?branch=master)](https://travis-ci.org/fifth-postulate/priority-queue)
A priority queue for Elm.

A [*priority queue*][priority-queue] is an

> abstract data type which is like a regular [queue][] or [stack][] data structure, but where additionally each element has a "priority" associated with it. In a priority queue, an element with high priority is served before an element with low priority.

The implementation we provide here is based on Okasaki's *leftist heaps*. See [Purely Functional Data Structures][pfds] for more information.

## Installation
Install `fifth-postulate/priority-queue` with the following command

```sh
elm install fifth-postulate/priority-queue
```

## Usage
The documentation for the `priority-queue` package can be found [online][documentation]. Below you can read how a `PriorityQueue` can be used.

Let's say that for an artistic painting application you are maintaining a queue of rectangles to paint. The rectangles come in over a port and you want to paint larger, i.e. rectangles with a larger **area**, first. A priority queue helps in this scenario.

To create a queue you could use the `PriorityQueue.empty` function. It accepts a `Priority`, i.e. a function that assigns priority to elements. Note that lower values corresponds to higher priority. Think of the priority as the time you would be willing to wait before you would like to process the element.

We assume that there is a type alias `Rectangle` and a corresponding `area` function that returns the (integer) area of a rectangle.

```elm
queue: PriorityQueue Rectangle
queue =
    let
        priority =
            area >> negate
    in
    empty priority
```

Here area is composed with negate to ensure that larger areas have a higher priority.

Inserting a rectangle into a queue is done with the `insert` function. Given a `rectangle` and a `queue` the following code creates a new queue which contains the provided rectangle.

```elm
nextQueue = insert rectangle queue
```

Notice that it is not necessary to repeat the `Priority`. The queue already knows how to tell the priority for a rectangle.


When it is time to draw a rectangle `head` could provide you with one.

```elm
case head queue of
    Nothing ->
        Cmd.none
    
    Just rectangle ->
        draw rectangle 
```

The `tail` function returns a priority queue of the remaining elements.

[priority-queue]: https://en.wikipedia.org/wiki/Priority_queue
[queue]: https://en.wikipedia.org/wiki/Queue_(abstract_data_type)
[stack]: https://en.wikipedia.org/wiki/Stack_(abstract_data_type)
[pfds]: https://www.cs.cmu.edu/~rwh/theses/okasaki.pdf
[documentation]: https://package.elm-lang.org/packages/fifth-postulate/priority-queue/latest/
