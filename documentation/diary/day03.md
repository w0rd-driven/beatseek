# Friday, January 13

It's early like yesterday, now close to 2:30 am and I should probably try to sleep soon but I'm sadly really motivated and not all that tired.
After running the generator for `Artists` I can see how harsh I was for the authentication piece. It is still completely out of place to me.
I just can't unsee it. The generator leads to a nice polished experience with auth components just hanging out in the parent `live/` directory.
I think I just don't "get it" as there has to be some reason it's done this way that I just haven't picked up on by looking at other projects.

It took a minute to get both the Artist and relational Album records created. I was completely hung up on trying to rewrite the case statement
because I somehow had it in my head that you could translate just about every case statement to recursive functions.
I believe that's true and especially useful for list walking functions but there are **so many examples** of the case statement against `{;ok, _} {:error, _}` tuples that I can't unsee the pattern now.
