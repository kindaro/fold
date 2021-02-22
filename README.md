# Is lazy left fold a misnomer?

I am not sure what a left fold is. I know what it does, overall, but I am not sure what the essential difference from the right fold is.

For reference, here is an uncontroversial definition of the right fold.

    foldr ∷ (α → β → β) → β → [α] → β
    foldr f z (x: xs) = x `f` foldr f z xs
    foldr _ z [ ] = z

Why exactly is it acceptable? There are many moving parts — maybe this is not really a definition of the right fold?

* * *

## Examples from `Prelude`.

Some examples from `Prelude`. Try to make sense of these.

### Base line — `head`.

First, a base line: `head`. It is very lazy.

    λ head [1, undefined]
    1
    λ head (1: undefined)
    1
    λ head ([1] ++ undefined)
    1

### Right folds.

Now, `foldr const undefined`. You would think it should emulate `head`. And it does.

    λ foldr const undefined [1, undefined]
    1
    λ foldr const undefined (1: undefined)
    1
    λ foldr const undefined ([1] ++ undefined)
    1

But how about `foldr1 const`?

    λ foldr1 const [1, undefined]
    1
    λ foldr1 const (1: undefined)
    *** Exception: Prelude.undefined
    CallStack (from HasCallStack):
      error, called at libraries/base/GHC/Err.hs:79:14 in base:GHC.Err
      undefined, called at <interactive>:33:18 in interactive:Ghci15
    λ foldr1 const ([1] ++ undefined)
    *** Exception: Prelude.undefined
    CallStack (from HasCallStack):
      error, called at libraries/base/GHC/Err.hs:79:14 in base:GHC.Err
      undefined, called at <interactive>:34:22 in interactive:Ghci15

An observable difference between `[1, undefined]` and `(1: undefined)` for you. And they say it is syntactic sugar.

For a longer list, everything works smoothly, so `foldr` is still mostly lazy.

    λ foldr1 const [1, 2, undefined]
    1
    λ foldr1 const (1: 2: undefined)
    1
    λ foldr1 const ([1, 2] ++ undefined)
    1

### Left folds.

A left fold is very strict. It is tail recursive and processes its input from the end, so it has to force all the length of the spine before returning anything. But it does not force the values.

    λ foldl (flip const) undefined [undefined, 2]
    2

Even though it is so strict, we can tease the initial accumulator out.

    λ foldl const 0 undefined
    *** Exception: Prelude.undefined
    CallStack (from HasCallStack):
      error, called at libraries/base/GHC/Err.hs:79:14 in base:GHC.Err
      undefined, called at <interactive>:61:15 in interactive:Ghci28
    λ foldl const 0 [undefined]
    0

This is about all the leeway. An `undefined` in any other place will explode.

The strict left fold from `Data.List` is not having any of this.

    λ foldl' (flip const) undefined [1, 2]
    *** Exception: Prelude.undefined
    CallStack (from HasCallStack):
      error, called at libraries/base/GHC/Err.hs:79:14 in base:GHC.Err
      undefined, called at <interactive>:58:21 in interactive:Ghci27
    λ foldl' (flip const) 0 [undefined, 2]
    *** Exception: Prelude.undefined
    CallStack (from HasCallStack):
      error, called at libraries/base/GHC/Err.hs:79:14 in base:GHC.Err
      undefined, called at <interactive>:59:24 in interactive:Ghci27

Somehow, we still can get the accumulator out — in this case it forces the spine, but not the values. So, the strictness in this regars is the same as of the lazy left fold.

    λ foldl' const 0 undefined
    *** Exception: Prelude.undefined
    CallStack (from HasCallStack):
      error, called at libraries/base/GHC/Err.hs:79:14 in base:GHC.Err
      undefined, called at <interactive>:67:16 in interactive:Ghci31
    λ foldl' const 0 [undefined]
    0
    
### Conclusion.

Is there a method to this madness?

My conclusion is that strictness is underspecified.
