"Filed out from Dolphin Smalltalk"!

ControlView subclass: #StaticRectangle
	instanceVariableNames: ''
	classVariableNames: 'StyleMap'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StaticRectangle guid: (GUID fromString: '{aad4f3a9-dc68-42b2-bedc-0a4fc49880f2}')!

StaticRectangle comment: '`StaticRectangle` is a simple `ControlView` class which wraps the Windows STATIC control for simple rectangles and frames.

The rectangle styles paint a solid block of colour filling the client area. The frame styles draw a border/frame around the edge of the client area of the control allowing the background colour to show through.

Apart from its uses for background rectangles and frames, StaticRectangle can also be used for horizontal and vertical lines by setting the width or height appropriately. When using in conjunction with a `ProportionalLayout` to add some kind of divider, set the arrangement to 0 to maintain the specified width/height.

## Class Variables:
  `StyleMap`		`LookupTable` of `Symbol` rectangle/frame style names Windows styles.'!

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

	self setStyle: (StyleMap at: rectangleStyleName)!

windowTitle
	"Answer the window title that is set/restored through WindowCreationParameters. Generally this is the window text."

	"The Static control ignores the text passed as the window title for the CreateWindowEx call, and we don't need it in this case anyway, so don't store the text in the WindowCreationState"

	^nil! !

!StaticRectangle categoriesForMethods!
setStyle:!accessing!private! !
style!accessing!public! !
style:!accessing!public! !
windowTitle!accessing!public! !
!

!StaticRectangle class methodsFor!

initialize
	"Private - Initialise the receiver's class variables:

			self initialize
	"

	self addClassConstant: 'StyleMap'
		value: (IdentityDictionary new
				at: #blackFrame put: SS_BLACKFRAME;
				at: #blackRectangle put: SS_BLACKRECT;
				at: #grayFrame put: SS_GRAYFRAME;
				at: #grayRectangle put: SS_GRAYRECT;
				at: #whiteFrame put: SS_WHITEFRAME;
				at: #whiteRectangle put: SS_WHITERECT;
				at: #etchedFrame put: SS_ETCHEDFRAME;
				at: #etchedHorizontal put: SS_ETCHEDHORZ;
				at: #etchedVertical put: SS_ETCHEDVERT;
				shrink;
				isImmutable: true;
				yourself)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.StaticRectangle) 34 14 nil nil 34 2 8 1140850951 1 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 1759212608 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[127 7 0 0 10 0 0 0 232 7 0 0 35 0 0 0] 193 448 nil 416 594 #isEnabled: 8 #(false) 416 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 )!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'STATIC'
! !

!StaticRectangle class categoriesForMethods!
initialize!development!initializing!private! !
resource_Default_view!public!resources-views! !
winClassName!constants!private! !
!

