#  Stuckery - a scriptable replacement for Stickies.

I was annoyed that Apple’s Stickies did not support dark mode, and that I couldn't use Applescript
to put stickies where I wanted them.

So here is a rewrite.

## To compile:

As is usual with my apps, you'll need to edit the bundle ID from 'com.example' to a domain you control
and set your development team. Both settings are in Xcode's Signing&Capabilities panel of the Stuckery target.

Or you can grab the signed executable .zip file from [Releases](https://github.com/DavidPhillipOster/Stickery/releases) on this github page and unzip it.

## Hints:

* I keep my account organized by putting all my Stuckery documents in the same folder. 

* You'll find Stuckery more satisfying to use if, in Apple's **System Settings** > **Desktop&Dock** > the checkbox **Close Windows when quitting an application** is set to **off** That way, when you start Stuckery you'll get the same set of documents each time.

## Todo:
- basically done.
- worth translating to Swift?
- help menu has no contents.

## Done:
* read .rtf
* write .rtf
* scriptable bounds.
* icon, dock icon
* color menu, persists, as a keyword.
* undo
* zoom and fullscreen turned off.
* if the document is dirty, on close, you are prompted to save.
* Print commands removed from menu bar.
* reopening a previously closed sticky restores the size (but not the position)
* window titlebar buttons inherit from NSButton.


## Learning:

Unobvious things I had to figure out how to do to write this.

* Getting NSTextView to respond to dark mode was tricky. Observe the appearance change in NSApp.
* Disable zoom by accessing the zoom button of the window.
* Disable fullscreen by accessing the window.collectionBehavior
* Improve dragging by delegating to the NSWindow’s method.

## Version History:

1.0 initial release

1.0.1 Improved window titlebar

1.0.2 Fix hang on quit with unsaved documents.

1.0.3 title bar with a proxy icon, command-click for file path menu

1.0.4 remove some dead code.

1.0.5 Remove background color of text pasted in.


## License

Apache 2 license
