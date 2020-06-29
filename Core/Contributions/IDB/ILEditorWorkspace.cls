"Filed out from Dolphin Smalltalk 7"!

View subclass: #ILEditorWorkspace
	instanceVariableNames: 'zoom location zone zoneBrushes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ILEditorWorkspace guid: (GUID fromString: '{367ecf4d-c63b-44a0-a054-07d7fcc14c7b}')!
ILEditorWorkspace comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ILEditorWorkspace categoriesForClass!IDB Goodies! !
!ILEditorWorkspace methodsFor!

clearZone
	"Invalidate the user interface to ensure the toolbar is updated"

	self hideZone.
	zone := nil.
	self presenter trigger: #zoneDescriptionChanged!

connectModel
	"Register for events triggered by the model"

	self model ifNotNil: 
			[:arg | 
			arg 
				when: #imageChanged:
				send: #onImageChanged:
				to: self]!

continueTrackingAt: aPoint from: aPreviousPoint
	"Part of the zone definition protocol called while the mouse is being tracked. Only
	update the zone if it's extent has changed to avoid excessive repainting"

	| pixel |
	pixel := self imagePixelFor: aPoint.
	(pixel notNil and: [pixel ~= zone corner]) 
		ifTrue: 
			[self hideZone.
			zone corner: pixel.
			self showZone.
			self presenter trigger: #zoneDescriptionChanged.
			location := pixel.
			self presenter trigger: #locationDescriptionChanged].
	^aPoint!

cursor
	^Cursor fromFile: (File composePath: SessionManager current idbResourcesFolder
				subPath: 'ImageEditor.cur')!

drawImageOn: aCanvas in: aRectangle
	"Draw the complete image, pixel by pixel. This looks like it should be iimplemented in
	LImage but we need to calculate the screen rect for each pixel so this is the best place"

	| imageRectangle |
	aCanvas pen: Pen red.
	imageRectangle := self imageRectangleFor: (aRectangle expandedBy: zoom).
	imageRectangle left to: imageRectangle right
		do: 
			[:across | 
			imageRectangle top to: imageRectangle bottom
				do: 
					[:down | 
					self model 
						draw: across @ down
						on: aCanvas
						in: (self viewRectangleForPoint: across @ down)]]!

drawZoneOn: aCanvas show: aBoolean
	"aBoolean indicates if the zone or the underlying image should be displayed. 
	true = show the zone, false = show the underlying image"

	self isZoomed & self hasZone ifFalse: [^self].
	aCanvas
		pen: Pen red;
		backgroundMode: (aBoolean ifTrue: [TRANSPARENT] ifFalse: [OPAQUE]).
	self zonePerimeterPixels do: 
			[:each | 
			| rectangle |
			rectangle := self viewRectangleForPoint: each.
			aBoolean 
				ifFalse: 
					[self model 
						draw: each
						on: aCanvas
						in: rectangle]
				ifTrue: 
					[aCanvas
						brush: (self zoneBrushes at: each x odd == each y odd);
						rectangle: rectangle]]!

endTrackingAt: aPoint
	"Part of the zone definition protocol called while the mouse tracking has ended. The zone
	has been redrawn while it was being tracked (see #continueTrackinAt:from:) so all
	we need to do here is check for a 0 extent zone - which means that no zone is wanted"

	self hasZone 
		ifTrue: 
			[zone := zone normalize.
			zone extent = Point zero ifTrue: [^self clearZone]].
	self model trigger: #zoneDescriptionChanged!

hasZone
	^zone notNil!

hideZone
	self drawZoneOn: self canvas show: false!

imagePixelFor: aPoint
	"aPoint represents a location in the view. This method answers the pixel in
	the image that is being displayed at that point or nil if it is outside"

	| pixel |
	pixel := (aPoint - self margin) // (zoom - 1) + 1.
	^(self model rectangle containsPointInclusive: pixel) ifTrue: [pixel]!

imageRectangleFor: aRectangle
	"aRectangle represents an area of the view. This method answers the smallest
	rectangle, in the models image co-ordinates, that will enclose the views rectangle
	but ignoring anything outside the perimiters of the image"

	| origin corner |
	origin := self imagePixelFor: aRectangle origin.
	origin isNil ifTrue: [origin := self model rectangle origin].
	corner := self imagePixelFor: aRectangle corner.
	corner isNil ifTrue: [corner := self model rectangle corner].
	^(origin corner: corner) intersect: self model rectangle!

initialize
	super initialize.
	self usePreferredExtent: true!

isZoomed
	^zoom notNil and: [zoom > 1]!

locationDescription
	"Answers a String describing the location for the editor status"

	^(String writeStream)
		nextPutAll: ' Loc: ';
		display: location;
		contents!

margin
	"Answer the size of the margin added to the outsides of the image display"

	^8!

onImageChanged: aRectangleOrNil
	"The model has changed one or more of the pixels contained within aRectangle.
	Refresh the screen but only within the bit that corresponds to the changed rectangle"

	self invalidateRect: (self viewRectangleForRectangle: aRectangleOrNil) erase: false!

onLeftButtonPressed: aMouseEvent
	"Trigger a left button event passing the appropriate arguments
	mouse only - draw a pixel in the current colour
	mouse + control - pick up the colur and make it current
	mouse + shift + control - set the hotSpot for a cursor"

	| pixel |
	self isZoomed ifFalse: [^self].
	(pixel := self imagePixelFor: aMouseEvent position) isNil ifTrue: [^self].
	aMouseEvent isCtrlDown 
		ifTrue: 
			[aMouseEvent isShiftDown 
				ifTrue: [self model hotSpot: pixel]
				ifFalse: [^self onMiddleButtonPressed: aMouseEvent]]
		ifFalse: [self presenter trigger: #plot: with: pixel]!

onMiddleButtonPressed: aMouseEvent
	| pixel |
	(pixel := self imagePixelFor: aMouseEvent position) isNil ifTrue: [^self].
	self presenter trigger: #selectRGB: with: (self model getRGBAt: pixel)!

onMouseMoved: aMouseEvent
	"If the mouse has moved onto another pixel, ot moved out of the edit
	area, then simulate a button up/button down sequence"

	| pixel |
	self isZoomed ifFalse: [^self].
	pixel := self imagePixelFor: aMouseEvent position.
	pixel = location 
		ifFalse: 
			[location := pixel.
			self presenter trigger: #locationDescriptionChanged.
			aMouseEvent isLButtonDown ifTrue: [self onLeftButtonPressed: aMouseEvent]]!

onMouseWheel: aMouseEvent
	self parentView parentView scroll: aMouseEvent wheelDirection
		toNextIn: ((1 to: self model height) collect: [:each | each * (zoom - 1) + self margin])!

onPaintRequired: aPaintEvent
	"Redraw the receiver using the current model. If the image is not zoomed then 
	we just draw the bitmap that the model maintains, otherwise we have to paint 
	each pixel within in the specified screen rectangle, individually (with a border)"

	| canvas |
	self model isNil ifTrue: [^self].
	canvas := aPaintEvent canvas.
	self isZoomed 
		ifTrue: 
			[self drawImageOn: canvas in: aPaintEvent paintStruct rcPaint asRectangle.
			self drawZoneOn: canvas show: true]
		ifFalse: [self model drawBitmapOn: canvas at: self margin asPoint]!

onRightButtonPressed: aMouseEvent
	"Start tracking the mouse to define the zone"

	self isZoomed ifFalse: [^self].
	self clearZone.

	"Right click outside to only clear the zone"
	(self imagePixelFor: aMouseEvent position) isNil ifTrue: [^self].
	(MouseTracker forPresenter: self presenter startingAt: aMouseEvent screenPosition)
		origin: aMouseEvent position;
		hysteresis: 0;
		dragButton: #right;
		startTracking: self!

preferredExtent
	"Answer the extent of the receiver allowing for the extent of the image, the zoom
	factor and the margin allowed around all four edges. If this answers the correct
	size the the parent view, a ScrollingDecorator can set it's scroll bars correctly"

	self model isNil ifTrue: [^10 @ 10].
	^self model extent * (zoom - 1) + (self margin * 2)!

showZone
	self drawZoneOn: self canvas show: true!

startTrackingAt: aPoint
	"Part of the zone definition protocol called while the mouse starts being tracked"

	zone := (self imagePixelFor: aPoint) extent: 0.
	self showZone.
	self presenter trigger: #zoneDescriptionChanged.
	^aPoint!

viewRectangleForPoint: aPoint
	"aPoint represents a pixel in the model (an ILImage). This method answers the
	rectangle in the view that defines the equivalent area"

	^(aPoint - 1) * (zoom - 1) + self margin asPoint extent: zoom!

viewRectangleForRectangle: aRectangle
	"aPoint represents a rectangle in the model (an ILImage). This method answers the
	rectangle in the view that defines the equivalent area"

	^(self viewRectangleForPoint: aRectangle origin) 
		merge: (self viewRectangleForPoint: aRectangle corner)!

zoneBrushes
	"When painting the zone we use two alternating brush designs. Define and cache
	them here to avoid a bit of GDI Churn"

	zoneBrushes isNil 
		ifTrue: 
			[zoneBrushes := (LookupTable new: 2)
						at: true
							put: (Brush 
									withStyle: BS_HATCHED
									color: Color red
									hatch: HS_DIAGCROSS);
						at: false
							put: (Brush 
									withStyle: BS_HATCHED
									color: Color black
									hatch: HS_DIAGCROSS);
						yourself].
	^zoneBrushes!

zoneDescription
	"Answers a String describing the location for the editor status bar"

	^(String writeStream)
		nextPutAll: ' Zone: ';
		display: (zone isNil ifTrue: [String new] ifFalse: [zone normalize extent abs + 1]);
		contents!

zonePerimeterPixels
	"Answer the collection of pixels (in ILImage coordinates) that comprise the zone perimeter"

	| pixels rectangle |
	pixels := OrderedCollection new.
	rectangle := zone normalize.
	rectangle left to: rectangle right
		do: 
			[:across | 
			pixels
				add: across @ zone top;
				add: across @ zone bottom].
	rectangle top + 1 to: rectangle bottom - 1
		do: 
			[:down | 
			pixels
				add: zone left @ down;
				add: zone right @ down].
	^pixels!

zoneRectangle
	^zone!

zoom: anInteger
	"Set the zoom factor - The number of pixels used for each side of an ILImage pixel.
	As this redraws everything we might as well check first to make sure it is actually changing.
	We need to force a full redraw and relayout as the scrollers might need to be updated"

	zoom = anInteger ifTrue: [^self].
	zoom := anInteger.
	(self parentView)
		invalidateLayout;
		invalidate.
	self presenter trigger: #zoomDescriptionChanged!

zoomBy: anInteger
	"Increase the zoom by anInteger. zoom just defines the number of screen pixels
	to be used for each size of an ILImage pixel"

	(zoom + anInteger between: 1 and: 40) ifFalse: [^self].
	self zoom: zoom + anInteger!

zoomDescription
	"Answers a String describing the amount of zoom"

	^(String writeStream)
		nextPutAll: ' Zoom: ';
		display: zoom;
		contents! !
!ILEditorWorkspace categoriesFor: #clearZone!event handling!public! !
!ILEditorWorkspace categoriesFor: #connectModel!models!public! !
!ILEditorWorkspace categoriesFor: #continueTrackingAt:from:!event handling!public! !
!ILEditorWorkspace categoriesFor: #cursor!constants!public! !
!ILEditorWorkspace categoriesFor: #drawImageOn:in:!drawing!public! !
!ILEditorWorkspace categoriesFor: #drawZoneOn:show:!event handling!public! !
!ILEditorWorkspace categoriesFor: #endTrackingAt:!event handling!public! !
!ILEditorWorkspace categoriesFor: #hasZone!public!testing! !
!ILEditorWorkspace categoriesFor: #hideZone!event handling!public! !
!ILEditorWorkspace categoriesFor: #imagePixelFor:!calculations!public! !
!ILEditorWorkspace categoriesFor: #imageRectangleFor:!calculations!public! !
!ILEditorWorkspace categoriesFor: #initialize!initializing!public! !
!ILEditorWorkspace categoriesFor: #isZoomed!public!testing! !
!ILEditorWorkspace categoriesFor: #locationDescription!displaying!public! !
!ILEditorWorkspace categoriesFor: #margin!constants!public! !
!ILEditorWorkspace categoriesFor: #onImageChanged:!event handling!public! !
!ILEditorWorkspace categoriesFor: #onLeftButtonPressed:!event handling!public! !
!ILEditorWorkspace categoriesFor: #onMiddleButtonPressed:!event handling!public! !
!ILEditorWorkspace categoriesFor: #onMouseMoved:!event handling!public! !
!ILEditorWorkspace categoriesFor: #onMouseWheel:!event handling!public! !
!ILEditorWorkspace categoriesFor: #onPaintRequired:!event handling!public! !
!ILEditorWorkspace categoriesFor: #onRightButtonPressed:!event handling!public! !
!ILEditorWorkspace categoriesFor: #preferredExtent!geometry!public! !
!ILEditorWorkspace categoriesFor: #showZone!event handling!public! !
!ILEditorWorkspace categoriesFor: #startTrackingAt:!event handling!public! !
!ILEditorWorkspace categoriesFor: #viewRectangleForPoint:!calculations!public! !
!ILEditorWorkspace categoriesFor: #viewRectangleForRectangle:!calculations!public! !
!ILEditorWorkspace categoriesFor: #zoneBrushes!event handling!public! !
!ILEditorWorkspace categoriesFor: #zoneDescription!displaying!public! !
!ILEditorWorkspace categoriesFor: #zonePerimeterPixels!event handling!public! !
!ILEditorWorkspace categoriesFor: #zoneRectangle!accessing!public! !
!ILEditorWorkspace categoriesFor: #zoom:!accessing!public! !
!ILEditorWorkspace categoriesFor: #zoomBy:!accessing!public! !
!ILEditorWorkspace categoriesFor: #zoomDescription!displaying!public! !

!ILEditorWorkspace class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (LiteralResourceIdentifier class: self name name: 'Default view')
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ILEditorWorkspace)  98 16 0 0 98 2 8 1140850688 1 416 0 721158 ##(SystemColor)  31 0 519 0 0 0 416 0 0 0 0 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 658 225 201 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 117 0 0 0 105 0 0 0] 98 0 658 193 193 0 27 )! !
!ILEditorWorkspace class categoriesFor: #resource_Default_view!public!resources-views! !

