---
title: Control Flow Monad
description: An example of an interesting application of monads for an interpreter in OCaml.
published: 2024-03-15
modified: 2024-03-18
tags: [monad, OCaml]
---

<!-- cspell:ignore ocaml -->

This article is going to assume you already have some understanding of what a monad is. If you haven't heard of monads before, you may want to do some research before reading. That said, you don't have to understand them perfectly: you might find this example useful if you're still trying to wrap your head around them.

Recently, while I was working on an interpreter written in OCaml, I came across an interesting application of monads. (I am likely not the first person to use monads in this way, but found it cool so I thought it was worth a small article.) The interpreter is for a procedural language which allows you to break or continue within a loop, and return within a function body. Originally, I dealt with this by defining something like the following simple data type:

```ocaml
type 'a control =
  | Break
  | Continue
  | Return of value option
  | None of 'a
```

Evaluating an expression would produce a value wrapped in this type, which could then be matched on to handle any potential control flow. However, I found myself often writing lots of nested code to handle cases where one of the aforementioned control flow constructs could cause evaluation to end immediately. I also realized that the handling was almost always the same:

```ocaml
match control with
| Break -> Break
| Continue -> Continue
| Return value -> Return value
| None a -> (* Do something with a here... and eventually return `None b` *)
```

(All the cases that just seem to return the same thing were often necessary when converting from a control of one type to a control of another, for example going from a `int control` to a `string control`.)

Then I realized that this looked kinda like a monad. Here's bind, which looks pretty similar to the structure above, and return:

```ocaml
let ( >>= ) control f =
  match control with
  | Break -> Break
  | Continue -> Continue
  | Return value -> Return value
  | None a -> f a

let return a = None a

let ( let* ) = ( >>= )
```

The final definition uses OCaml's [let extensions](https://v2.ocaml.org/manual/bindingops.html) feature which makes bind very convenient to use. Here's an example of using this to evaluate a function call expression, which I would've done before using three levels of nested matching:

```ocaml
let* callee = exec_expr callee scopes in
match callee with
| Procedure f ->
    let* args = exec_prod args scopes in
    return (f args)
| invalid -> raise InvalidCallee
```

Hope you found this interesting, thanks for reading!
