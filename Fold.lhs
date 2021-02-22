> module Fold where
>
> import qualified Prelude
> import Prelude (($), flip, (+), Num)
> import Prelude.Unicode ((∘))
> import Data.Function (fix)

A definition of the right fold, for reference:

> foldr ∷ (α → β → β) → β → [α] → β
> foldr f z (x: xs) = x `f` foldr f z xs
> foldr _ z [ ] = z
>
> id ∷ [α] → [α]
> id = foldr (:) [ ]
>
> map ∷ (α → β) → [α] → [β]
> map f = foldr ((:) ∘ f) [ ]
>
> sum ∷ Num α ⇒ [α] → α
> sum = foldr (+) 0


So what is a left fold? There are two ways to define it.

> foldlViaFix ∷ (β → α → β) → β → [α] → β
> foldlViaFix f = fix \ k z xs → case xs of
>   [ ] → z
>   (x: xs) → k (z `f` x) xs
>
> foldlViaFoldr ∷ (β → α → β) → β → [α] → β
> foldlViaFoldr f z = ($ z) ∘ flip foldr Prelude.id \ x g → g ∘ flip f x
