
"This Workspace window contains some examples for you to try just to get started with Dolphin. 
When you've finished here continue with one of the following:

---- the Guided Tour from the Help/Guided Tour menu.
---- the Beginner's Guide to Dolphin Smalltalk from the Help/Education Centre menu. 

With the examples below:

---- To evaluate an expression, type Ctrl+E.
---- To evaluate and display the result of an expression, type Ctrl+D. The result is highlighted at the end of the line. Use DEL to clear it.
---- To evaluate and inspect the result of an expression, type Ctrl+I.
---- To bring up a Class Hierarchy Browser, type Ctrl+B.
---- To debug through an expression, type F11
---- If you mistakenly evaluate some code which hangs, try pressing Ctrl+Break to interrupt it.

There is no need to select single line expressions, just place the text cursor on the line and press the desired evaluation key sequence. If the expression consists of more than one line, select it in the normal way with the mouse or keyboard before attempting to evaluate it.

Here are some examples:"

"First evaluated by Smalltalk in October 1972, and by Dolphin in February 1995.
With a bit of luck the answer will be 7."
3 + 4.

"Our standard arithmetic benchmark (try this in C++ or Java)!"
1000 factorial.

"Time the execution of an expression."
Time millisecondsToRun: [1000 factorial].
Time microsecondsToRun: [1000 factorial].

"All the classes in the system (well over 1000) in ascending name order."
Class allClasses asSortedCollection.

"The number of objects in the system."
Object allSubinstances size.

"Create a simple digital clock on the desktop (select next 7 lines and evaluate it with Ctrl+E)"
digitalClockProcess := [[
	Processor sleep: 1000.
	(DesktopView current canvas)
		font: (Font name: 'Arial' pointSize: 36) beBold;
		text: Time now printString at: 10@10;
		free
] repeat] fork.

"Stop the clock and tidy up."
digitalClockProcess terminate. View desktop invalidate.

"Play a sound twice (you need to substitute the path of a .wav file or you'll just get the default sound)"
(Sound fromFile: 'xxxxx.wav') woofAndWait; woofAndWait.

"An array initialized with the integers 1..100"
(1 to: 100) collect: [:i | i].
"or"
(1 to: 100) asArray.

"Generate a winning lottery ticket."
(Random new next: 6) collect: [:n | (n * 49) rounded].

"Generate another winning lottery ticket when the Newsagent points out the duplicates in the above (display the result of evaluating next 4 lines with Ctrl+D)"
r := Random new.
s := Set new.
[s size = 6] whileFalse: [s add: (r next * 49) rounded].
s asSortedCollection asArray.

"Open a Scribble pad for mouse doodling. This is one of the sample applications discussed in the tutorial sessions. Evaluate the following with Ctrl+E"
scribble := Scribble show.

"Keeping the above window open, create an Etch-a-Sketch(tm) window that draws in parallel with the Scribble pad. Use the scroll bars as drawing controls. This is another tutorial example"
EtchASketch showOn: scribble model.

"Bring up a walkback (press 'Debug' to enter the debugger, then try stepping using the toolbar buttons). You can also debug an expression by using the Debug-It command, bound to F11"
self halt.

"Browse methods containing the text, 'Dolphin' (may take a few seconds to read several megabytes of source code). This can also be done from the Class Hierarchy Browser Method menu too."
SmalltalkSystem current browseContainingText: 'Dolphin'.

"And finally, tidy up any mess. This will close all views, including the System Folder. A new, System Folder will be opened after a short delay. This can be a useful 'panic' expression. Alternatively you can use the panic (Munch's Scream) button in the System Folder toolbar."
SmalltalkSystemShell default panic


