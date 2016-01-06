"Filed out from Dolphin Smalltalk X6.1"!

View subclass: #EmulatedCheckBox
	instanceVariableNames: 'isTransition isChecked hasCursor isThemed'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmulatedCheckBox guid: (GUID fromString: '{0C2F590C-7A32-472F-8BDA-78BEC35B9903}')!
EmulatedCheckBox comment: ''!
!EmulatedCheckBox categoriesForClass!Unclassified! !
!EmulatedCheckBox methodsFor!

defaultWindowStyle

	"Private - Answer a default style to use when creating an instance of the receiver.
	All controls have the WS_TABSTOP style by default."

	^super defaultWindowStyle bitOr: WS_TABSTOP
!

draw: aValue transition: aBoolean 
	in: aRectangle on: aCanvas 
	forecolor: fcolor backcolor: bcolor 
	focus: focusBool highlight: highlightBool

	^self isThemed
	ifTrue: 
		[self 
			drawXP: aValue 
			transition: aBoolean 
			in: aRectangle 
			on: aCanvas 
			forecolor: fcolor
			backcolor: bcolor
			focus: focusBool
			highlight: highlightBool]
	ifFalse: 
		[self 
			drawNonXP: aValue 
			transition: aBoolean 
			in: aRectangle 
			on: aCanvas 
			forecolor: fcolor
			backcolor: bcolor
			focus: focusBool
			highlight: highlightBool]!

drawNonXP: aValue transition: aBoolean 
	in: aRectangle on: aCanvas 
	forecolor: fcolor backcolor: bcolor 
	focus: isFocus highlight: isHighlighted

	| size origin box uState | 

	size := 15.
	origin := ((aRectangle width - size) //2)@((aRectangle height - size) //2).
	box := (aRectangle origin + origin) extent: (size@size).
	
	aValue
		ifTrue: [uState := 16r0400 "DFCS_CHECKED"]
		ifFalse: [uState := 0].
	aBoolean ifTrue: [uState := uState | 16r0200 "DFCS_PUSHED"].

	UserLibrary default 
		drawFrameControl: aCanvas handle
		lprc: (RECT fromRectangle: box) 
		uType: 4 "DFC_BUTTON" 
		uState: uState.

	isFocus ifTrue: [self drawFocusRect: (box insetBy: 2)]
!

drawOn: aCanvas

	self 
		draw: self isChecked 
		transition: self isTransition 
		in: (0@0 extent: self extent) 
		on: aCanvas
		forecolor: self forecolor
		backcolor: self backcolor
		focus: self hasFocus
		highlight: self isHighlighted!

drawXP: aValue transition: aBoolean 
	in: aRectangle on: aHdc 
	forecolor: fcolor backcolor: bcolor 
	focus: isFocus highlight: isHighlighted

	| size origin box canvas htheme iState |

	size := 15.

	origin := ((aRectangle width - size) //2)@((aRectangle height - size) //2).

	box := (aRectangle origin + origin) extent: (size@size).

	canvas := Canvas withNonOwnedDC: aHdc.

	htheme := ThemeLibrary default openThemeData: self handle pszClassList: 'BUTTON' asUnicodeString.

	aValue
		ifTrue: [iState := 5 "CBS_CHECKEDNORMAL"]
		ifFalse: [iState := 1 "CBS_UNCHECKEDNORMAL"].
	aBoolean 
		ifTrue: [iState := iState + 2 "CBS_xxxxPRESSED"]
		ifFalse: [isHighlighted ifTrue: [iState := iState + 1]].

	ThemeLibrary default 
		drawThemeBackground: htheme 
		hdc: canvas asParameter 
		iPartId: 3 "BP_CHECKBOX"
		iStateId: iState 
		pRect: box asParameter 
		pClipRect: nil.

	ThemeLibrary default closeThemeData: htheme.

	canvas free
!

hasCursor
	^hasCursor ifNil: [false]!

hasCursor: anObject
	hasCursor := anObject!

isChecked
	^isChecked ifNil: [isChecked := false"self model value"]!

isChecked: anObject
	isChecked := anObject!

isHighlighted

	^self hasCursor!

isThemed

	^isThemed ifNil:
		[isThemed := 
			OSVERSIONINFO current isWinXP 
			and: [ThemeLibrary default isThemeActive 
			and: [ThemeLibrary default isAppThemed]]]
!

isTransition
	^isTransition ifNil: [isTransition := false]!

isTransition: anObject
	isTransition := anObject!

onKeyPressed: aKeyEvent

	aKeyEvent code = Character space codePoint ifTrue:
		[self isTransition: true.
		self invalidate].

	^super onKeyPressed: aKeyEvent!

onKeyReleased: aKeyEvent

	(self isTransition and: [aKeyEvent code = Character space codePoint]) ifTrue:
		[self isChecked: self isChecked not.
		self updateModel].

	self isTransition: false.
	self invalidate.

	^super onKeyReleased: aKeyEvent!

onKillFocus

	self isTransition: false.

	self invalidate.

	^super onKillFocus!

onLeftButtonDoubleClicked: aMouseEvent
	"The event source received a mouse left button double-click event
	Treat as a single click"

	^self onLeftButtonPressed: aMouseEvent!

onLeftButtonPressed: aMouseEvent

	self hasFocus ifFalse: [self setFocus].
	self isTransition: true.
	self invalidate.

	^super onLeftButtonPressed: aMouseEvent!

onLeftButtonReleased: aMouseEvent

	self isTransition ifTrue:
		[self isChecked: self isChecked not.
		self updateModel].

	self isTransition: false.
	self invalidate.

	^super onLeftButtonReleased: aMouseEvent!

onMouseMoved: aMouseEvent

	| wasTransition hadCursor point |

	(aMouseEvent isLButtonDown and: [self isTransition not]) ifTrue: [self isTransition: true].

	hadCursor := self hasCursor ifNil: [false].
	wasTransition := self isTransition.
	point := aMouseEvent position.

	self hasCursor: (self clientRectangle containsPoint: point). 
	self isTransition: (wasTransition and: [self hasCursor]). 

	(self hasCursor = hadCursor and: [self isTransition = wasTransition]) ifFalse: 
		[self invalidate.
		(self hasCursor and: [hadCursor not]) ifTrue: [self trackMouseLeave]]!

onPaintRequired: aPaintEvent

	self drawOn: aPaintEvent canvas
!

onSetFocus

	self invalidate.

	^super onSetFocus!

refreshContents

	self isChecked: self model value.
	self invalidate!

updateModel

	self model value: self isChecked!

wmMouseLeave: message wParam: wParam lParam: lParam

	self hasCursor: false.
	self isTransition: false.
	self invalidate! !
!EmulatedCheckBox categoriesFor: #defaultWindowStyle!constants!private! !
!EmulatedCheckBox categoriesFor: #draw:transition:in:on:forecolor:backcolor:focus:highlight:!displaying!public! !
!EmulatedCheckBox categoriesFor: #drawNonXP:transition:in:on:forecolor:backcolor:focus:highlight:!displaying!private! !
!EmulatedCheckBox categoriesFor: #drawOn:!displaying!public! !
!EmulatedCheckBox categoriesFor: #drawXP:transition:in:on:forecolor:backcolor:focus:highlight:!displaying!private! !
!EmulatedCheckBox categoriesFor: #hasCursor!accessing!private! !
!EmulatedCheckBox categoriesFor: #hasCursor:!accessing!private! !
!EmulatedCheckBox categoriesFor: #isChecked!accessing!private! !
!EmulatedCheckBox categoriesFor: #isChecked:!accessing!private! !
!EmulatedCheckBox categoriesFor: #isHighlighted!displaying!public! !
!EmulatedCheckBox categoriesFor: #isThemed!accessing!private! !
!EmulatedCheckBox categoriesFor: #isTransition!accessing!private! !
!EmulatedCheckBox categoriesFor: #isTransition:!accessing!private! !
!EmulatedCheckBox categoriesFor: #onKeyPressed:!event handling!public! !
!EmulatedCheckBox categoriesFor: #onKeyReleased:!event handling!public! !
!EmulatedCheckBox categoriesFor: #onKillFocus!event handling!public! !
!EmulatedCheckBox categoriesFor: #onLeftButtonDoubleClicked:!event handling!public! !
!EmulatedCheckBox categoriesFor: #onLeftButtonPressed:!event handling!public! !
!EmulatedCheckBox categoriesFor: #onLeftButtonReleased:!event handling!public! !
!EmulatedCheckBox categoriesFor: #onMouseMoved:!event handling!public! !
!EmulatedCheckBox categoriesFor: #onPaintRequired:!event handling!public! !
!EmulatedCheckBox categoriesFor: #onSetFocus!event handling!public! !
!EmulatedCheckBox categoriesFor: #refreshContents!public!updating! !
!EmulatedCheckBox categoriesFor: #updateModel!public!updating! !
!EmulatedCheckBox categoriesFor: #wmMouseLeave:wParam:lParam:!event handling!public! !

!EmulatedCheckBox class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^false asValue!

initialize

	"self initialize"

	MessageMap 
		isImmutable: false;
		at: (16r02A3 + 1) put: #wmMouseLeave:wParam:lParam:;
		isImmutable: true!

uninitialize

	"self uninitialize"

	MessageMap
		at: (16r02A3 + 1) put: nil! !
!EmulatedCheckBox class categoriesFor: #defaultModel!models!public! !
!EmulatedCheckBox class categoriesFor: #initialize!models!public! !
!EmulatedCheckBox class categoriesFor: #uninitialize!models!public! !

