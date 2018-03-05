"Filed out from Dolphin Smalltalk 7"!

ControlView subclass: #StaticRectangle
	instanceVariableNames: ''
	classVariableNames: 'StyleMap'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StaticRectangle guid: (GUID fromString: '{aad4f3a9-dc68-42b2-bedc-0a4fc49880f2}')!
StaticRectangle comment: 'StaticRectangle is a simple <ControlView> class which wraps Windows STATIC control for simple rectangles and frames.

The rectangle styles () paint a solid block of colour filling the client area. The frame styles draw a border/frame around the edge of the client area of the control allowing the background colour to show through.

Apart from its uses for background rectangles and frames, StaticRectangle can also be used for horizontal and vertical lines by setting the width or height appropriately.

Class Variables:
	StyleMap		<LookupTable> of <Symbol> rectangle/frame style names Windows styles.'!
!StaticRectangle categoriesForClass!MVP-Views! !
!StaticRectangle methodsFor!

setStyle: rectangleStyleBits
	"Private - Sets the rectangle style of this static control."

	self baseStyle: rectangleStyleBits maskedBy: SS_TYPEMASK recreateIfChanged: true!

style
	"Answer the style of rectangle currently adopted by the receiver."

	| styleFlags |
	styleFlags := self baseStyle bitAnd: SS_TYPEMASK.
	^StyleMap keyAtValue: styleFlags ifAbsent: [#blackFrame]!

style: rectangleStyleName
	"Set the style of rectangle required of the receiver to that identifier by the symbolic
	name, rectangleStyleName."

	self setStyle: (StyleMap at: rectangleStyleName)! !
!StaticRectangle categoriesFor: #setStyle:!accessing!private! !
!StaticRectangle categoriesFor: #style!accessing!public! !
!StaticRectangle categoriesFor: #style:!accessing!public! !

!StaticRectangle class methodsFor!

initialize
	"Private - Initialise the receiver's class variables:

			self initialize
	"

	StyleMap := IdentityDictionary new
				at: #blackFrame put: SS_BLACKFRAME;
				at: #blackRectangle put: SS_BLACKRECT;
				at: #grayFrame put: SS_GRAYFRAME;
				at: #grayRectangle put: SS_GRAYRECT;
				at: #whiteFrame put: SS_WHITEFRAME;
				at: #whiteRectangle put: SS_WHITERECT;
				at: #etchedFrame put: SS_ETCHEDFRAME;
				at: #etchedHorizontal put: SS_ETCHEDHORZ;
				at: #etchedVertical put: SS_ETCHEDVERT;
				shrink
!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(StaticRectangle)  98 14 0 0 98 2 8 1140850951 1 416 0 524550 ##(ColorRef)  8 4278190080 0 7 0 0 0 416 0 8 4294906439 983302 ##(MessageSequence)  202 208 98 2 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 690 211 51 416 626 8 #isEnabled: 98 1 32 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 110 0 0 0 30 0 0 0] 98 0 690 193 193 0 27 )!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'STATIC'
! !
!StaticRectangle class categoriesFor: #initialize!development!initializing!private! !
!StaticRectangle class categoriesFor: #resource_Default_view!public!resources-views! !
!StaticRectangle class categoriesFor: #winClassName!constants!private! !

