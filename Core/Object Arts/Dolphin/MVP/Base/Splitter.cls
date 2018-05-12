"Filed out from Dolphin Smalltalk 7"!

View subclass: #Splitter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Splitter guid: (GUID fromString: '{87b4c716-026e-11d3-9fd7-00a0cc3e4a32}')!
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
	"Private - Answers the default colour to be used for the receiver. 
	This has to be fairly dark or the gradient is not visible."

	"This is the shadow colour in the XP luna theme."

	^Color 
		red: 172
		green: 168
		blue: 153!

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
	"Answers the foreground colour of the receiver. This is the light colour in the gradient fill."

	"This is the light3d colour in the XP luna schema."

	^Color 
		red: 241
		green: 239
		blue: 226!

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

onLeftButtonPressed: aMouseEvent 
	"Start tracking the mouse with the ultimate aim of resizing the views
	surrounding the receiver."

	self setFocus.
	(MouseTracker forPresenter: self presenter
		startingAt: aMouseEvent screenPosition)
		origin: aMouseEvent position + self position;
		startTracking: self.
	^false!

onPaintRequired: aPaintEvent 
	aPaintEvent canvas 
		fillRectangle: self clientRectangle
		startColor: self forecolor
		endColor: self actualBackcolor
		verticalGradient: self isVertical!

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
!Splitter categoriesFor: #isVertical!public!testing! !
!Splitter categoriesFor: #onEraseRequired:!event handling!public! !
!Splitter categoriesFor: #onGetCursor:!event handling!public! !
!Splitter categoriesFor: #onInputMaskRequired:!event handling!public! !
!Splitter categoriesFor: #onLeftButtonPressed:!event handling!public! !
!Splitter categoriesFor: #onPaintRequired:!event handling!private! !
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

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(Splitter)  98 12 0 0 98 2 8 1140850688 1 416 0 524550 ##(ColorRef)  8 4278190080 0 519 0 0 0 416 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 674 361 11 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 185 0 0 0 10 0 0 0] 98 0 674 193 193 0 27 )!

stbConvertFromVersion12: anArray 
	"Private - Perform an STB conversion from a version 12 <View> to version 13. 13 adds
	inheritable background colours if the backcolor is nil (similar to the way fonts are
	inherited). The special colour 'default' can be used to specify the control's default
	background colour."

	| backcolor |
	backcolor := anArray at: 6.
	(backcolor = ##(RGB 
				red: 225
				green: 225
				blue: 225) 
		or: [backcolor = ##(Color face3d)]) ifTrue: [anArray at: 6 put: Color default].
	^super stbConvertFromVersion12: anArray! !
!Splitter class categoriesFor: #icon!constants!public! !
!Splitter class categoriesFor: #resource_Horizontalvertical_splitter!public!resources-views! !
!Splitter class categoriesFor: #stbConvertFromVersion12:!binary filing!private! !

