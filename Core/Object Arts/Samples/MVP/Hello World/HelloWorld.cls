"Filed out from Dolphin Smalltalk X6.2"!

ShellView subclass: #HelloWorld
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HelloWorld guid: (GUID fromString: '{87B4C720-026E-11D3-9FD7-00A0CC3E4A32}')!
HelloWorld comment: 'A sample illustrating just about the simplest of all applications;a window displaying the text "Hello from Dolphin" within an elliptical border. To demonstrate this evaluate the following:

HelloWorld show.

The walkback that results from clicking within the window''s client area is intentional and part of the Application Deployment Kit tutorial.'!
!HelloWorld categoriesForClass!MVP-Views!Samples! !
!HelloWorld methodsFor!

defaultExtent
	"Private - Answer the default size of the receiver. This is used only to
	set the size of a view when it is created. Thereafter preferredExtent is
	used when the desired size of a view is requested."

	^##(260 @ 180)!

minExtent
	"Answers the minimum extent for the receiver or nil if there is no constraint.
	This only applies for	views being resized directly by the UI. It is not considered
	during layout by a LayoutManager."

	^self defaultExtent // 2!

onLeftButtonPressed: aMouseEvent
	"Default handler for a left button down mouse event.
	Accept the default window processing."

	super onLeftButtonPressed: aMouseEvent.
	self thisIsADeliberateError
!

onPaintRequired: aPaintEvent 
	"A portion of the receiver window has been exposed and needs repainting.
	The supplied aPaintEvent holds details about the exposed area.
	Within #onPaintRequired: you MUST ask for a Canvas from aPaintEvent 
	(not the receiver window) to paint the contents on."

	| canvas rect |
	canvas := aPaintEvent canvas.
	rect := self clientRectangle.
	canvas
		pen: Pen red;
		brush: Color darkBlue brush;
		ellipse: rect;
		forecolor: Color white;
		backgroundMode: TRANSPARENT;
		text: 'Hello from Dolphin' at: rect center - (60 @ 10)!

onPositionChanged: aPositionEvent
	"Handle a window position change event (move or resize).
	Implementation Note:  We need to redraw the entire view when resized because
	of the ellipse. If we don't do this then increasing the size of the window will
	result in a bit of a mess!!"

	aPositionEvent isResize ifTrue: [self invalidate].
	^super onPositionChanged: aPositionEvent! !
!HelloWorld categoriesFor: #defaultExtent!constants!private! !
!HelloWorld categoriesFor: #minExtent!accessing!public! !
!HelloWorld categoriesFor: #onLeftButtonPressed:!event handling!public! !
!HelloWorld categoriesFor: #onPaintRequired:!event handling!public! !
!HelloWorld categoriesFor: #onPositionChanged:!event handling!public! !

!HelloWorld class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon window!

initialize
	"Private - Initialize the receiver. Install as a sample application into the
	system folder
		self initialize.
	"

	Smalltalk developmentSystem 
		addSamplesFolderIconFor: self description: self samplesFolderDescription helpId: 10739!

samplesFolderDescription
	"Private - Answer the description to be used for the receiver in the in the samples folder."

	^'Hello World'!

show
	"Creates and shows an instance of the receiver"

	self new show

	!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system.
	Un-register the system folder icon for the receiver.
	N.B. This must be in the 'must strip' category because it relies on the
	#samplesFolderIcon method, which must in turn be stripped.

	self uninitialize
	"

	Smalltalk developmentSystem 
		removeSystemFolderIconNamed: self samplesFolderDescription! !
!HelloWorld class categoriesFor: #icon!constants!public! !
!HelloWorld class categoriesFor: #initialize!development!initializing!private! !
!HelloWorld class categoriesFor: #samplesFolderDescription!accessing!private! !
!HelloWorld class categoriesFor: #show!instance creation!public! !
!HelloWorld class categoriesFor: #uninitialize!initializing!private! !

