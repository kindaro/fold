# Is lazy left fold a misnomer?

I am not sure what a left fold is. I know what it does, overall, but I am not sure what the essential difference from the right fold is.

For reference, here is an uncontroversial definition of the right fold.

    foldr ∷ (α → β → β) → β → [α] → β
    foldr f z (x: xs) = x `f` foldr f z xs
    foldr _ z [ ] = z

Why exactly is it acceptable? There are many moving parts — maybe this is not really a definition of the right fold?
