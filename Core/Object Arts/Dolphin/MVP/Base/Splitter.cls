﻿"Filed out from Dolphin Smalltalk 7"!

View subclass: #Splitter
	instanceVariableNames: ''
	classVariableNames: 'FlatMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Splitter guid: (GUID fromString: '{87b4c716-026e-11d3-9fd7-00a0cc3e4a32}')!
Splitter addClassConstant: 'FlatMask' value: 16r100000!
Splitter comment: 'Splitter is a <view> used for implementing "splitter bars" for resizing adjacent views within a <compositeView>. Normally, a Splitter requires that the parent view in which it is placed is under the control of a ProprtionalLayout manager.'!
!Splitter categoriesForClass!MVP-Resources-Splitters!MVP-Views! !
!Splitter methodsFor!

calculateExtent: aLayoutContext 
	"Private - Answer the calculated extent of the receiver that should be used by a
	layout manager during it's layout process."

	^self calcExtentFromClientExtent: self defaultExtent!

cancelTrackingAt: aPoint 
	| position |
	position := self constrainPosition: aPoint.
	self eraseTrackingAt: position!

constrainPosition: aPoint
	"Private - An attempt may be made to change the position of the receiver to aPoint.
	Answers the actual position that may be achieved."

	| position |
	position := aPoint max: 0 @ 0.
	self isVertical
		ifTrue: [position x: self x]
		ifFalse: [position y: self y].
	^position!

continueTrackingAt: aPoint from: aPreviousPoint
	"Private - Continue position tracking for the associated view at aPoint when
	the previous tracking position was at aPreviousPoint. Part of the <MouseTracker>
	target protocol. Answers the actual position achieved"

	| position |
	position := self constrainPosition: aPoint.
	self eraseTrackingAt: aPreviousPoint.
	self drawTrackingAt: position.
	^position!

cursor
	"Answer the cursor to be used in conjunction with instances of the receiver."

	^self isVertical
		ifTrue: [Cursor splitHorizontal]
		ifFalse: [Cursor splitVertical]
!

defaultBackcolor
	"Private - Answers the default colour to be used for the receiver."

	^self hasFlatAppearance
		ifTrue: [Color face3d]
		ifFalse: 
			["This is the shadow colour in the XP luna theme - this has to be fairly
			 dark or the gradient is not visible.."
			Color
				r: 172
				g: 168
				b: 153]!

defaultExtent
	"Private - Answer the default size of the receiver to be used when it is created."

	"Implementation Note: Splitters used to be one pixel larger than the standard Windows sizing frame,
	however, the default sizing frame seems to have grown larger over the years so now we hard code a reasonable value."

	"^SystemMetrics current sizingFrameExtent+1"

	^5 asPoint!

defaultProportion
	"Private - Answer the default proportion to be assumed by the receiver when associated with
	a container with a <ProportionalLayout>."

	^0!

drawTrackingAt: aPoint
	"Private - Draw a position tracking rectangle for the associated view at aPoint"

	| rectangle |
	rectangle := self rectangle position: aPoint.
	self parentView drawFocusRect: rectangle.	
!

endTrackingAt: aPoint 
	"Private - End position tracking for the new position of the receiver.
	Part of the <MouseTracker> target protocol."

	| position |
	position := self constrainPosition: aPoint.
	self eraseTrackingAt: position.
	self parentView layoutManager 
		ifNotNil: [:layoutManager | layoutManager reposition: self to: position].
	self parentView layout!

eraseTrackingAt: aPoint
	"Private - Erase a position tracking rectangle for the associated view at aPoint. 
	Default tracking is Xored onto the parent canvas so we can just redraw it to
	erase it"

	self drawTrackingAt: aPoint
!

forecolor
	"Answers the foreground colour of the receiver."

	^self hasFlatAppearance
		ifTrue: [self actualBackcolor intensity: 0.9]
		ifFalse: 
			["This is the light colour in the gradient fill, being the light3d colour in
			 the XP luna schema."
			Color
				r: 241
				g: 239
				b: 226]!

hasFlatAppearance
	"Answer whether the receiver should be draw with flat (i.e. ungraded) look. This is now the default."

	^flags noMask: FlatMask!

hasFlatAppearance: aBoolean
	flags := flags mask: FlatMask set: aBoolean not!

isHot
	^false!

isVertical
	"Private - Answer whether the layoutManager which is controlling our
	destiny has oriented us vertically."

	| layoutManager |
	layoutManager := self parentView layoutManager.
	(layoutManager isKindOf: ProportionalLayout) ifFalse: [^false].
	^layoutManager isVertical!

onEraseRequired: aColorEvent
	"Handler for erase background. A splitter fills its area entirely when painted,
	so we don't need to erase the background."

	^true!

onGetCursor: aSymbol
	"The named area of the window associated with the receiver has been hit.
	Answer the appropriate mouse cursor, or nil to accept the default."

	^self cursor!

onInputMaskRequired: anEvent
	"Handler for a WM_GETDLGCODE request from Windows.
	Splitters do not require any keyboard input, so answer 0 to
	let it all be gobbled up for navigation."
	
	^0!

onPaintRequired: aPaintEvent
	| rect canvas back |
	rect := self clientRectangle.
	canvas := aPaintEvent canvas.
	back := self actualBackcolor.
	self hasFlatAppearance
		ifTrue: 
			[| brush |
			brush := back brush.
			self interactor isHot
				ifTrue: 
					["When hot draw with a subtle edge so the splitter can be seen. Normally it blends into the background."
					canvas
						brush: brush;
						pen: self forecolor pen;
						rectangle: rect]
				ifFalse: [canvas fillRectangle: rect brush: brush].
			brush free]
		ifFalse: 
			[canvas
				fillRectangle: rect
				startColor: self forecolor
				endColor: back
				verticalGradient: self isVertical]!

onViewCreated
	interactor := DraggableViewInteractor forPresenter: self!

startTrackingAt: aPoint
	"Private - Start position tracking for the associated view at aPoint. Part of the 
	<MouseTracker> target protocol. Answers the actual position achieved."

	| position |
	position := self constrainPosition: aPoint.
	self drawTrackingAt: position.
	^position! !
!Splitter categoriesFor: #calculateExtent:!operations!private! !
!Splitter categoriesFor: #cancelTrackingAt:!private!tracking! !
!Splitter categoriesFor: #constrainPosition:!operations!private! !
!Splitter categoriesFor: #continueTrackingAt:from:!private!tracking! !
!Splitter categoriesFor: #cursor!constants!public! !
!Splitter categoriesFor: #defaultBackcolor!constants!private! !
!Splitter categoriesFor: #defaultExtent!constants!private! !
!Splitter categoriesFor: #defaultProportion!constants!private! !
!Splitter categoriesFor: #drawTrackingAt:!private!tracking! !
!Splitter categoriesFor: #endTrackingAt:!public!tracking! !
!Splitter categoriesFor: #eraseTrackingAt:!private!tracking! !
!Splitter categoriesFor: #forecolor!accessing!public! !
!Splitter categoriesFor: #hasFlatAppearance!accessing-styles!public! !
!Splitter categoriesFor: #hasFlatAppearance:!accessing-styles!public! !
!Splitter categoriesFor: #isHot!public!testing! !
!Splitter categoriesFor: #isVertical!public!testing! !
!Splitter categoriesFor: #onEraseRequired:!event handling!public! !
!Splitter categoriesFor: #onGetCursor:!event handling!public! !
!Splitter categoriesFor: #onInputMaskRequired:!event handling!public! !
!Splitter categoriesFor: #onPaintRequired:!event handling!private! !
!Splitter categoriesFor: #onViewCreated!event handling!public! !
!Splitter categoriesFor: #startTrackingAt:!private!tracking! !

Splitter methodProtocol: #mouseTrackerTarget attributes: #(#readOnly) selectors: #(#cancelTrackingAt: #continueTrackingAt:from: #endTrackingAt: #startTrackingAt:)!

!Splitter class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Horizontalvertical_splitter
	"Answer the literal data from which the 'Horizontalvertical splitter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Horizontalvertical_splitter)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.Splitter) 34 12 nil nil 34 2 8 1140850688 1 416 nil 327686 ##(Smalltalk.Color) #default nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 416 nil 1 #left nil nil nil 328198 ##(Smalltalk.Point) 1 1 546 9 9 nil 560 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 546 3839 21 546 951 11 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 90 9 0 0 15 0 0 0] 8 #() 546 193 193 nil 27 )!

stbConvertFromVersion12: anArray
	"Private - Perform an STB conversion from a version 12 <View> to version 13. 13 adds
	inheritable background colours if the backcolor is nil (similar to the way fonts are
	inherited). The special colour 'default' can be used to specify the control's default
	background colour."

	| backcolor |
	backcolor := anArray at: 6.
	(backcolor = ##(Color brightness: 225 / 255) or: [backcolor = Color face3d])
		ifTrue: [anArray at: 6 put: Color default].
	^super stbConvertFromVersion12: anArray! !
!Splitter class categoriesFor: #icon!constants!public! !
!Splitter class categoriesFor: #resource_Horizontalvertical_splitter!public!resources-views! !
!Splitter class categoriesFor: #stbConvertFromVersion12:!binary filing!private! !

