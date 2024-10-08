﻿"Filed out from Dolphin Smalltalk"!

UI.ShellView
	subclass: #'UI.Examples.HelloWorld'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.HelloWorld guid: (Core.GUID fromString: '{87b4c720-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.Examples.HelloWorld comment: 'A sample illustrating just about the simplest of all applications; a window displaying hello (in Chinese) within an elliptical border. To demonstrate this evaluate the following:

HelloWorld show.'!

!UI.Examples.HelloWorld categoriesForClass!MVP-Views!Samples! !

!UI.Examples.HelloWorld methodsFor!

defaultExtent
	"Private - Answer the default size of the receiver. This is used only to
	set the size of a view when it is created. Thereafter preferredExtent is
	used when the desired size of a view is requested."

	^##(400 @ 400)!

helloWorldText
	"Answer the text to be displayed."

	^Utf8String
		with: $\x4F60
		with: $\x597D
		with: $\x20
		with: Character dolphin!

minExtent
	"Answers the minimum extent for the receiver at its current resolution, in this case 3/4 of the original creation size."

	^self defaultExtent * self dpi * 3 // ##(USER_DEFAULT_SCREEN_DPI * 4)!

onPaintRequired: aPaintEvent
	"A portion of the receiver window has been exposed and needs repainting.
	The supplied aPaintEvent holds details about the exposed area.
	Within #onPaintRequired: you MUST ask for a Canvas from aPaintEvent 
	(not the receiver window) to paint the contents on."

	| canvas rect textFont textToShow |
	canvas := aPaintEvent canvas.

	"We're going to draw an ellipse inside a rectangle that is inset
	10 pixels from the edge of the window."
	rect := self clientRectangle insetBy: 10.

	"Get a font and assign to the canvas. Then we can ask the canvas how big the
	text will be when displayed."
	textFont := Font name: 'Arial' pointSize: 32.
	canvas font: textFont.
	textToShow := self helloWorldText.

	"Draw the ellipse with a grey background and red border"
	canvas
		pen: (Pen red width: 4);
		brush: Color silver brush;
		ellipse: rect.

	"Now draw the text in white. We still have the correct font set from before
	but we must tell it where it's positioned in order to centre it."
	canvas
		forecolor: Color white;
		backgroundMode: TRANSPARENT;
		formatText: textToShow in: rect flags: ##(DT_CENTER | DT_VCENTER | DT_SINGLELINE)!

onPositionChanged: aPositionEvent
	"Handle a window position change event (move or resize).
	Implementation Note:  We need to redraw the entire view when resized because
	of the ellipse. If we don't do this then increasing the size of the window will
	result in a bit of a mess!!"

	aPositionEvent isResize ifTrue: [self invalidate].
	^super onPositionChanged: aPositionEvent! !

!UI.Examples.HelloWorld categoriesForMethods!
defaultExtent!constants!private! !
helloWorldText!constants!public! !
minExtent!accessing!public! !
onPaintRequired:!event handling!public! !
onPositionChanged:!event handling!public! !
!

!UI.Examples.HelloWorld class methodsFor!

icon
	"Answer an icon for the receiver and its instances."

	^Icon fromId: '!!APPLICATION'!

show
	"Creates and shows an instance of the receiver"

	self new show

	! !

!UI.Examples.HelloWorld class categoriesForMethods!
icon!constants!public! !
show!instance creation!public! !
!

