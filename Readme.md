# Important information!!

## WIP

This is a work in progress. It is very usable, in fact I use it in my personal configs and in one Neovim plugin with great success, but the API may change.

## Not a plugin

**This is not a Neovim plugin** , it is a Haxe library to help you write neovim configurations and plugins using Haxe programming language

## How to contribute

I am just a newcomer to Haxe, so there are lots of places where I will appreciate contributions.
Here is a list of things that are very welcome
- [ ] A cool logo. If anything this project needs is a cool logo. 
- [x] Proper configurations to publish this to haxelib
- [ ] A better lua annotations parser. I don't want to depend on anything but Haxe. Currently this library uses a very dumb parser for the Lua annotations. If you want to help there and improve it or write a new one you are welcome
- [ ] Try this out. Yeah, just having this used by someone but me will probably be beneficial.
- [ ] Write more neovim externs! This library tries to generate most extenrs automatically, but some manual work is unavoidable (because how wild the Neovim api is in terms of types). If you want to contribute and add new and better definitions for NeoVim methods, this is also welcome

# Haxe Nvim

Write your next Neovim plugin or your personal neovim configuration in Haxe and enjoy a high level language which is type safe.

This library was initially intended to be named "Nvim haxelerator" (and I may rename it at some point) because it will allow you to write Neovim plugins faster and safer.
Take advantage of the powerful Haxe compiler and turn frustrating runtime errors your users (probably your future self) will face and that will take you hours to debug into nice compilation time errors that will take you seconds to fix!

## Philosophy

We have strong opinions about what this library should be and what should not be. Read about that below.

### Prefer enums over magic values

APIs must be for humans to instruct machines, not to talk between machines. Because of that the usage of magic values that have a special meaning is avoided as much as possible. Instead Enums are used in every place it is possible. Haxe has a great feature which is called `Abstracts`, which allows you to have proper compile-time-only abstractions without any runtime overhead.
An example of this is the `Buffer` type. All the neovim functions that expect a `BufferId` will not just accept any number, you must provide a proper `BufferId` (obtained from functions that return a `BufferId`) or `CurrentBuffer`. Thanks to the nature of abstract types this disappears after compilation and all what is left are plain numbers.

## Advantages over plain Lua

- Proper types! You don't know how good is having proper types that will you prevent from doing silly mistakes.
This library goes even further and not only prevents you from putting a `"string"` where a number is expected, it will  also prevent you from putting the wrong number!
- Compile time errors. Yes, rather than saving your plugin/config, reload neovim, test your feature and try to decipher the stack trace, you will get compile-time errors as you save your file, pointing out to the exact place where you did that stupid mistake because you are configuring your editor again at 2:00 am

## Limitations

- Currently the output size is a bit beefy compared to plain Lua. I ported kickstart.lua, which is about 350 lines of code and the generated Lua is about ~1k lines. It is just 3 times larger, which is not that bad if you consider all the extra language features you get.
- Duplicated STD. This library tries to use Neovim std as much as possible, but because the Haxe Lua output limitations there are always some Haxe STD helpers in the generated file. This paired with the inability of Haxe to output several files will make every plugin contain a copy of all the STD helper Haxe produces.

# Example usage

If you want an example or a bootstrap to start your own neovim plugin using haxe-nvim, take a look at the [template plugin](https://github.com/danielo515/haxe-nvim-example-plugin)
If you want an example of a personal configuration using it, here is [kickstart.hx](https://github.com/danielo515/kickstart.hx)

# Acknowledgments

I want to thank Rudy from the Haxe discord channel for his huge help with macros to reduce the overhead
of the Lua target.
