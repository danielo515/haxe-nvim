
## Why Haxe to configure neovim?

I am a former javascript developer that felt in love with static typing, well, strong and good static typing.
I started my programming journey with typed languages (C, Pascal), but I soon felt in love with Javascript and how easy and fast you can prototype stuff on it.
Letting projects grow and professionally working with Javascript was not as fun tough. Can't remember how many times I had this conversation with myself:

> Current: Why is this (expected) string an array?
> Former: do you remember that change you made 3 months ago and that didn't broke anything because 90% of the functions were just passing down their arguments and the other 10% was just checking the string length (which happens to exist also array)? Do you remember that?
> Current: No, Id on't remember it 😕
> Former: 😛, yeah

Some developers love bug hunting, they are usually easy to fix and you can close several tickets in a day.
I don't, I just feel stupid to waste 1 hour because one variable was an array  instead of a string, or because a number was in milliseconds rather than in kilometers.

At the same time, some hate for typed languages started to grow on me, being Java the main culprit.
It is ultery verbose, the type system only gets on your way and, after all, the worst of all is that ti does not prevent the worst mistakes.
Every time I tried to do something of medium complexity in Java I had to play the guess game of how many of the 5k useless classes I have to extend, and which methods I don't care I have to override...
I hated Java so much that, as of today, if you ask my Alexa to destroy the world she will answer back

> Ok, loading the required Jar files...

That is how Evil I think Java is.

I gave Typescript a go (it was version 3.x) and I also hated it. The type system was not rich enough to express half of the things you were able to do in JS, and the worst of all is that, after all that typing pain you were left with runtime errors in the same way you had with JS, bah!

Things just got worse when I discovered with functional programming. 
You know that point-free nerds? Well, I was one of them, until I put some pipeline in production and I was not able to understand what the hell was going wrong because the lack of types and the size of the pipeline.
Of course Typescript was not up to the task of having proper types in functional programming either.

Thankfully, I discovered ReasonML and then felt in love with it and learnt to like Ocaml too.

Why all that matters? Well, it will be relevant for the last wall of text.
Almost since I started using Linux 15 years ago, I wanted to use Vim as my text-editor, but the experience was so subpar compared to any other IDE that I could just not get over it.
However, it became almost a tradition to waste a couple of days every 6 months trying to make it my main editor.
With every attempt I was getting further (1 week using it as my main editor, 3 weeks, 2 months!), but sooner or later I was reaching roadblocks, and I needed work to get done.
On top of all the problems you get to configure Vim, using VimScript was... not fun, and who wants to waste time in something that is not fun?
Then NeoVim announced they were going to add Lua as scripting language, and I thought:

> I couldn't care less.

But then people started to built all sort of plugins in Lua, and then I discovered LunarVim, and suddenly NeoVim was not only a capable IDE, it was an IDE that I could very easily script!. Open your `init.lua`, throw some lines of code, and boom, new functionality. Lua was simple enough and similar enough to JS to being able to use it without having to follow any tutorial or waste any time.
However, as you keep adding lines and lines of code, the same problems that JS has start to arise: dumb mistakes everywhere that are hard to debug but easy to forget.
As in JS, languages that try to "just add types on top of" Lua were just as poor as TS.
And because the real solution to my JS problems was reasonML I thought: 

> Maybe is it possible to transpile ReasonML to lua in addition to JS?

Well, after months of research, the answer is no. Asking in Ocaml/ReasonML/Rescript forums about transpiling to Lua someone suggested Haxe.
I took a look and, I didn't liked the OOP style at first, but after getting through that barrier I started to see its potential, and I decided to give it a try, after all I can just make all my class be just namespaces and all my methods Static, right?
As positive things, the language is designed to be mapped to other languages, so it will be easier to add more targets if you like it enough, which is not true for ReasonML, and the Macro system is a piece of cake compared to PPX that Ocaml has.
And here we are!
Hope this was not too boring!
