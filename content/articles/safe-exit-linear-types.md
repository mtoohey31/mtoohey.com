---
title: A Safe Exit Function with Linear Types
description: An idea about how linear types could prevent exit from stopping the program without performing required cleanup.
published: 2024-08-08
tags: [linear types, vale]
---

<!-- cspell:ignore cleanup mktemp Finalizer atexit typeclass -->

While watching [this great video](https://www.youtube.com/watch?v=UavYVf0UEoc) by the "Developer Voices" YouTube channel with the creator of the Vale programming language, I had a thought about how linear types could resolve potential correctness issues that can be caused by the `exit` function. Here, `exit` refers to the function that invokes the operating system's exit syscall, terminating the execution of the program. This article assumes some level of familiarity with linear types and related concepts.

In most programming languages, nothing stops you from "dropping" resources on the ground. For example:

1. If you let the last pointer to something in memory go out of scope in C without freeing it, you've leaked the memory.
2. In Go, if you let a file go out of scope without closing it, it won't get cleaned up until the program exits.
3. If you create a temporary file in a Bash script with `mktemp`, nothing will prevent you from forgetting to remove it, filling up your temporary directory.
4. If you're working with an API that creates and destroys remote resources which should not outlive the lifetime of your program, most languages have no way of ensuring that the remote resources are actually cleaned up.

These are just a few examples (which will be referred to as "the cleanup examples" from here on). Programming languages attempt to address these issues in a variety of different ways:

- Garbage-collected and reference-counted languages address memory leaks by keeping track of when the memory resource is no longer needed within their runtime, and automatically cleaning it up for you. These approaches are limited to memory resources though, and can have a negative performance impact.
- JavaScript's [`FinalizationRegistry`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/FinalizationRegistry#notes_on_cleanup_callbacks), Go's [`runtime.SetFinalizer`](https://pkg.go.dev/runtime#SetFinalizer), and Python's [`__del__`](https://docs.python.org/3.12/reference/datamodel.html#object.__del__) features allow you to perform resource-specific cleanup once an object is garbage collected, but none provide any guarantees about when the finalizer will be called (or even if it will be called at all before the program exits), making them unsuitable for cleanup that must take place (such as 3. and 4. from the cleanup examples).
- Destructors in C++ and Rust are actually guaranteed to run immediately when objects go out of scope.

Many of these approaches suffer from a shared weakness though: the `exit` function. In most languages, the behaviour of the `exit` function is that it immediately terminates the application, without doing cleanup. Before continuing to the linear types solution, here are some caveats:

- `exit` doesn't always skip cleanup in some languages. Python has an [`atexit`](https://docs.python.org/3.12/library/atexit.html) module which allows you to do cleanup at exit (provided you exit using `sys.exit` and not `os._exit`).
- This isn't a problem for all types of resources. Memory and file descriptor resources (among others) are cleaned up by the operating system, meaning it's fine to exit without cleaning them up first (this case includes 1. and 2. from the cleanup examples).

With those caveats in mind, let's look at the signature of the exit function. We'll use Rust's [`std::process::exit`](https://doc.rust-lang.org/std/process/fn.exit.html), since it most precisely expresses what's happening:

```rust
pub fn exit(code: i32) -> !
```

It takes an `i32` exit code, and the `!` indicates that it never returns (the `!` is also known as the "never type", because it can never be constructed; it could be defined as a sum type without any variants, though it's a primitive type in Rust).

In my opinion, there are two decisions that the designers of Rust made, which lead to the possibility for missed cleanup:

1. You can call a function that never returns without having dropped all the values that are currently in scope.
2. You can call a function that never returns without declaring in your function signature that this may happen.

How does this problem relate to linear types, and what can we do about it? Like I mentioned at the start, I'll assume you have some understanding of linear types. As such, you may have already noticed why linear types are relevant here. If we think of Rust types whose drop implementations need to be called before exit to ensure correctness (such as cleanup examples 3. and 4.) as linear types, we can see that allowing the direct `exit` call, or any call of a function which may call `exit`, results in the values potentially not being used, leading to the missed cleanup.

What would we have to do to resolve the issue? One easy solution is to just disallow functions that return `!`, and only allow the programmer to exit by returning from main, but this is rather restrictive. Here is an alternative pair of decisions to ones made in Rust which were described above:

1. When calling a function that returns `!`, all linear type values in scope must either already have been used, or be passed to that function call.
2. If a function may call another that returns `!`, it must express this in its type signature somehow. One way to do this would be to convert the return type into a sum type which has two variants, one containing the original return type for the case where it doesn't call the `!` function, and the other containing a `!` for the case where it does. Furthermore, we must impose restrictions on calls to these functions, such that if they end up calling the `!` function, they can ensure all linear type values in the parent scope have been used. I'm not quite sure yet exactly how to do this. If you come up with any ideas, send me an email!

These certainly aren't without trade-offs. The second in particular introduces a ["coloured function"-like](https://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/) leaky abstraction which pollutes everything up the entire call chain, all the way up to main. This is why I describe the two points which lead to the potential for missed cleanup in Rust as "decisions", not as mistakes, because the only solution that comes to my mind comes with a significant cost. Maybe these solutions would be worth it for languages that already know how to work with linear types though?

There's one last thing I wanted to mention: what if we were to implement the alternative choices, and successfully prevent clean examples 3. and 4. from going wrong, but we still wanted to let the OS do cleanup of anything it could handle like examples 1. and 2. since it can probably do the cleanup faster than we can. Linear types also present a solution to this: we can modify `exit` so it will accept (and therefore "use") any linear type that the OS is capable of cleaning up. Consider the following Haskell signature:

```haskell
exit :: ExitCode -> [Pointers] -> [FileDescriptors] -> IO a
```

The implementation of `exit` would then require some special-casing in the compiler, or the use of a special unsafe function which tells the compiler to assume the resource parameters are used. An even more convenient (though more complex) extension to this approach would be to have a "marker trait" (to use Rust's terminology) for resources that can be automatically cleaned up by the OS. Then, the compiler could allow any variable whose type implements this trait to remain in scope when calling a function that returns `!`.
