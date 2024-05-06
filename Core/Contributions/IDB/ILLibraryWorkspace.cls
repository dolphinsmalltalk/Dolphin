"Filed out from Dolphin Smalltalk"!

View subclass: #ILLibraryWorkspace
	instanceVariableNames: 'imageLayout imageLayoutRect lastSelection lastImage dum5'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ILLibraryWorkspace guid: (GUID fromString: '{1c1c2fa1-a653-4a42-a88e-d9da6c1d9276}')!

ILLibraryWorkspace comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ILLibraryWorkspace categoriesForClass!IDB Goodies! !

!ILLibraryWorkspace methodsFor!

connectModel
	self model ifNotNil: 
			[:arg | 
			arg 
				when: #libraryChanged:
				send: #onLibraryChanged:
				to: self]!

imageLayout
	imageLayout isNil 
		ifTrue: 
			[| lineRect |
			imageLayout := LookupTable new.
			imageLayoutRect := Rectangle new.
			lineRect := imageLayoutRect copy.
			self model images do: 
					[:each | 
					| imageRect |
					imageRect := lineRect topRight extent: each extent + (self margin * 2).
					imageRect right > (self parentView parentView width - 24) 
						ifTrue: 
							["allow for future scrollbar width"

							lineRect := imageLayoutRect bottomLeft extent: 0.
							imageRect := imageLayoutRect bottomLeft extent: each extent + (self margin * 2)].
					lineRect := lineRect merge: imageRect.
					imageLayoutRect := imageLayoutRect merge: lineRect.
					imageLayout at: each put: imageRect]].
	^imageLayout!

initialize
	super initialize.
	self usePreferredExtent: true!

margin
	^8!

onLeftButtonDoubleClicked: aMouseEvent
	self setCapture!

onLeftButtonPressed: aMouseEvent
	| rect image previousSelection |
	rect := self imageLayout detect: [:each | each containsPoint: aMouseEvent position]
				ifNone: [^self].
	self invalidateUserInterface.
	image := self imageLayout keyAtValue: rect.
	previousSelection := lastSelection.
	lastSelection := image.
	aMouseEvent isCtrlDown ifTrue: [^self model selectInvert: image].
	(aMouseEvent isShiftDown and: [previousSelection notNil]) 
		ifTrue: [^self model selectBetween: previousSelection and: image].
	self model selectOnly: image!

onLeftButtonReleased: aMouseEvent
	self hasCapture 
		ifTrue: 
			[self class releaseCapture.
			self presenter trigger: #editImage].
	^super onLeftButtonReleased: aMouseEvent!

onLibraryChanged: aCollectionOrNil
	"The arguent is either a Collection of images that have to be drawn or nil
	which indicates that the whole view (including it's scroll area) needs updating"

	| rect |
	aCollectionOrNil isNil 
		ifTrue: 
			[imageLayout := nil.
			"x2 because of the reference view!!"
			self parentView parentView layout]
		ifFalse: 
			[| images |
			images := aCollectionOrNil asOrderedCollection.
			rect := images inject: (self imageLayout at: images first)
						into: [:bigRect :each | bigRect merge: (self imageLayout at: each)]].
	self invalidateRect: rect!

onMouseMoved: aMouseEvent
	| rect image |
	rect := self imageLayout detect: [:each | each containsPoint: aMouseEvent position]
				ifNone: [].
	image := self imageLayout keyAtValue: rect.
	image == lastImage ifTrue: [^self].
	lastImage := image.
	self presenter trigger: #mouseOver: with: image!

onMouseWheel: aMouseEvent
	self parentView parentView scroll: aMouseEvent wheelDirection
		toNextIn: (self imageLayout collect: [:each | each top]) asSet asSortedCollection 
				asOrderedCollection!

onPaintRequired: aPaintEvent
	| canvas paintRect |
	self model isNil ifTrue: [^self].
	canvas := aPaintEvent canvas.
	paintRect := aPaintEvent paintStruct rcPaint asRectangle.
	self model images do: 
			[:each | 
			| imageRect |
			imageRect := self imageLayout at: each.
			(imageRect intersects: paintRect) 
				ifTrue: 
					[(self model isSelected: each) 
						ifTrue: 
							[canvas
								pen: Pen red;
								brush: Brush transparent;
								rectangle: (imageRect insetBy: 4)].
					each drawBitmapOn: canvas at: imageRect origin + self margin]]!

onPositionChanged: aPositionEvent
	aPositionEvent isResize 
		ifTrue: 
			[imageLayout := nil.
			self invalidate].
	^super onPositionChanged: aPositionEvent!

preferredExtent
	self model isNil ifTrue: [^10 @ 10].
	self imageLayout.
	^imageLayoutRect corner max: Point one! !

!ILLibraryWorkspace categoriesForMethods!
connectModel!models!public! !
imageLayout!geometry!public! !
initialize!initializing!public! !
margin!constants!public! !
onLeftButtonDoubleClicked:!event handling!public! !
onLeftButtonPressed:!event handling!public! !
onLeftButtonReleased:!event handling!public! !
onLibraryChanged:!event handling!public! !
onMouseMoved:!event handling!public! !
onMouseWheel:!event handling!public! !
onPaintRequired:!event handling!public! !
onPositionChanged:!event handling!public! !
preferredExtent!geometry!public! !
!

!ILLibraryWorkspace class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (LiteralResourceIdentifier class: self name name: 'Default view')
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ILLibraryWorkspace)  98 17 0 0 98 2 8 1140850688 1 416 0 524550 ##(ColorRef)  8 4278190080 0 519 0 0 0 416 0 0 0 0 0 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 674 225 201 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 117 0 0 0 105 0 0 0] 98 0 674 193 193 0 27 )! !

!ILLibraryWorkspace class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

