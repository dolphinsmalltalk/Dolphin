"Filed out from Dolphin Smalltalk"!

UI.ShellView
	subclass: #'UI.Examples.Playground'
	instanceVariableNames: 'shapes'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.Playground guid: (Core.GUID fromString: '{87b4c721-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.Examples.Playground comment: 'A Playground window is part of the Playground sample package learning aid for Smalltalk. A Playground is a <topView> window into which one or more geometric objects can be placed. These objects can then be manipulated by sending messages to them, usually from a workspace.

The objects to be placed in a Playground are normally of a class that is derived from the class <PlayShape>. Typical shapes might be <Triangle>, <Square>, <Circle> etc.The shapes can be added and removed from a <Playground> using the #add: and #remove: methods respectively. You can request a collection of all the shapes currently in the playground using #shapes. Once you have identified a particular shape you can send messages to communicate with it directly.

See the Playground package comment for a simple example of how to create and use a <Playground> window. 

Instance Variables:
	shapes		<OrderedCollection> of shapes within the playground.

'!
!UI.Examples.Playground categoriesForClass!MVP-Views!Samples! !
!UI.Examples.Playground methodsFor!

add: aPlayShape
	"Adds aPlayShape to the receiver and causes it to be drawn. 
	Answers aPlayShape"

	shapes add: aPlayShape.
	aPlayShape playground: self.
	self invalidate.

	^aPlayShape!

clear
	"Clear the receiver by removing all shapes from it"

	self initialize; invalidate!

initialize
	"Private - Initialize the receiver's instance variables"

	super initialize.
	shapes := OrderedCollection new.!

onPaintRequired: aPaintEvent
	"Handler for aPaintEvent. 
	This is called whenever the receiver window needs to be completely or partially redrawn."

	| canvas |
	canvas := aPaintEvent canvas.
	self shapes do: [:each | each drawOn: canvas].!

remove: aPlayShape
	"Removes aPlayShape from the receiver and causes it to be erased. 
	Answers aPlayShape"

	shapes remove: aPlayShape.
	aPlayShape playground: nil.
	self invalidate.

	^aPlayShape!

shapes
	"Answer the collection of shapes held by the receiver"

	^shapes! !
!UI.Examples.Playground categoriesForMethods!
add:!adding!public! !
clear!operations!public! !
initialize!initializing!private! !
onPaintRequired:!event handling!public! !
remove:!public!removing! !
shapes!accessing!public! !
!

!UI.Examples.Playground class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(TextTileIcon text: $\x1F388 fontName: 'Segoe UI Emoji' color: Color red)!

new
	"Create and show a new instance of the receiver. Answer the new instance"

	^super new show caption: 'A Playground'.! !
!UI.Examples.Playground class categoriesForMethods!
icon!constants!public! !
new!instance creation!public! !
!

