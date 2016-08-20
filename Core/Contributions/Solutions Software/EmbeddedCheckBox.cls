"Filed out from Dolphin Smalltalk 7"!

CheckBox subclass: #EmbeddedCheckBox
	instanceVariableNames: 'textExtent text'
	classVariableNames: ''
	poolDictionaries: 'ThemeConstants'
	classInstanceVariableNames: ''!
EmbeddedCheckBox guid: (GUID fromString: '{611F80AE-2E05-4E6F-B0C8-A0ADBD00FF31}')!
EmbeddedCheckBox comment: ''!
!EmbeddedCheckBox categoriesForClass!MVP-Views! !
!EmbeddedCheckBox methodsFor!

buttonExtent

	| size | 

	self isThemed ifFalse: [^(UserLibrary default getSystemMetrics: SM_CXMENUCHECK)@(UserLibrary default getSystemMetrics: SM_CYMENUCHECK)].

	size := SIZE new.
	ThemeLibrary default getThemePartSize: self theme hdc: self canvas asParameter iPartId: BP_CHECKBOX iStateId: CBS_UNCHECKEDNORMAL prc: nil eSize: TS_DRAW psz: size.
	^size asObject!

createEmbeddedIn: aView

	interactor := presenter := self.
	flags := 0.

	self 
		isManaged: true;
		initializeModel;
		parentView: aView;
		create;
		font: aView font.

	(aView hasFullRowSelect and: [aView showsSelAlways]) ifTrue: [self backcolor: Color face3d]!

display: aValue in: aRectangle on: aCanvas forecolor: fColor backcolor: bColor editable: aBoolean hot: hBoolean

	| buttonOffset textOffset |

	self hasText 
		ifTrue: [self textExtent: (aCanvas textExtent: self text)]
		ifFalse: [self textExtent: 0@0].

	buttonOffset := (self displayOffset + (((aRectangle width - self totalExtent x) @ (aRectangle height - self buttonExtent y)) // 2) rounded) max: 0@0.
	textOffset := self textOffset + ((buttonOffset x + self buttonExtent x) @ ((aRectangle height - self textExtent y) // 2)) rounded.

	self isThemed
		ifTrue: [self drawThemed: aValue in: aRectangle on: aCanvas buttonOffset: buttonOffset textOffset: textOffset]
		ifFalse: [self drawNonThemed: aValue in: aRectangle on: aCanvas buttonOffset: buttonOffset textOffset: textOffset]!

displayOffset

	^0@0!

displayOnFormats

	^#(#class)!

drawNonThemed: aValue in: aRectangle on: aCanvas buttonOffset: buttonOffset textOffset: textOffset

	| uState textPos |

	uState := DFCS_BUTTONCHECK.

	self isEnabled
		ifTrue: 
			[aValue isNil
				ifTrue: [uState := uState | DFCS_BUTTON3STATE | DFCS_CHECKED | DFCS_INACTIVE]
				ifFalse: [aValue ifTrue: [uState := uState | DFCS_CHECKED]]]
		ifFalse: [uState := uState | DFCS_INACTIVE].

	UserLibrary default 
		drawFrameControl: aCanvas handle
		lprc: ((aRectangle origin + buttonOffset) extent: (self buttonExtent min: aRectangle extent)) asParameter 
		uType: DFC_BUTTON 
		uState: uState.

	(self text ifNil: ['']) isEmpty ifFalse:
		[textPos := aRectangle origin + textOffset.
		self isEnabled
			ifTrue: [aCanvas prefixTextTransparent: self text at: textPos]
			ifFalse: [aCanvas prefixTextDisabled: self text at: textPos]]!

drawThemed: aValue in: aRectangle on: aCanvas buttonOffset: buttonOffset textOffset: textOffset

	| iState textRect |
	iState := aValue isNil
				ifTrue: [CBS_MIXEDNORMAL]
				ifFalse: [aValue ifTrue: [CBS_CHECKEDNORMAL] ifFalse: [CBS_UNCHECKEDNORMAL]].

	ThemeLibrary default 
		drawThemeBackground: self theme 
		hdc: aCanvas asParameter 
		iPartId: BP_CHECKBOX
		iStateId: iState
		pRect: ((aRectangle origin + buttonOffset) extent: self buttonExtent) asParameter 
		pClipRect: aRectangle asParameter.

	self hasText ifTrue: 
		[textRect := (aRectangle origin + textOffset) extent: self textExtent.
		textRect right: (textRect right min: aRectangle right).
		ThemeLibrary default 
			drawThemeText: self theme 
			hdc: aCanvas asParameter 
			iPartId: BP_CHECKBOX
			iStateId: iState
			pszText: self text asUnicodeString 
			iCharCount: -1 dwTextFlags: 0 dwTextFlags2: 0 
			pRect: textRect asParameter]!

hasEmbeddedHotTracking

	^false!

hasText

	^(self text ifNil: ['']) isEmpty not!

isDisplayOwnerDrawn

	^true!

onCursoredLeft

	"The receiver has been entered by a cursor left action"

	^self!

onKillFocus

	self parentView hideActiveEditor.

	^super onKillFocus!

onRequestDeactivate

	"Return if OK"

	^true!

preTranslateKeyboardInput: aMSG

	aMSG message = WM_KEYDOWN ifTrue:
		[| key action |
		key := aMSG wParam.
		key = VK_TAB ifTrue:
			[Keyboard default isShiftDown
				ifTrue: [action := MessageSend receiver: self parentView selector: #fieldExitPrevTabbed: arguments: #(true)]
				ifFalse: [action := MessageSend receiver: self parentView selector: #fieldExitNextTabbed: arguments: #(true)]].
		key = VK_RIGHT ifTrue: [action := MessageSend receiver: self parentView selector: #fieldExitNextTabbed: arguments: #(false)].
		key = VK_LEFT ifTrue: [action := MessageSend receiver: self parentView selector: #fieldExitPrevTabbed: arguments: #(false)].
		key = VK_UP ifTrue: [action := MessageSend receiver: self parentView selector: #fieldExitUp].
		key = VK_DOWN ifTrue: [action := MessageSend receiver: self parentView selector: #fieldExitDown].
		action notNil ifTrue:
			[SessionManager inputState queueDeferredAction: action.
			^true]].

	^super preTranslateKeyboardInput: aMSG!

showIn: aRectangle

	| offset |

	offset := (aRectangle extent - self totalExtent) // 2.

	self
		rectangle: (aRectangle insetBy: offset);
		show!

stbSaveOn: anSTBOutFiler

	"If the receiver is unrealized (i.e. just exists in the spec of a column in the view composer),
	save as a plain object"

	handle isNil 
		ifTrue: [anSTBOutFiler saveObject: self]
		ifFalse: [super stbSaveOn: anSTBOutFiler]!

text
	^text!

text: aString
	text := aString.
	self handle notNull ifTrue: [super text: aString]!

textExtent

	^textExtent ifNil: [0@0]!

textExtent: aPoint

	textExtent := aPoint!

textOffset

	^self textExtent > 0
		ifTrue: [3@0]
		ifFalse: [0@0]!

themePartName

	^#BUTTON!

totalExtent

	^(self buttonExtent x + self textOffset x + self textExtent x)@(self buttonExtent y max: self textExtent y).
! !
!EmbeddedCheckBox categoriesFor: #buttonExtent!accessing!public! !
!EmbeddedCheckBox categoriesFor: #createEmbeddedIn:!initialize/release!public! !
!EmbeddedCheckBox categoriesFor: #display:in:on:forecolor:backcolor:editable:hot:!displaying!public! !
!EmbeddedCheckBox categoriesFor: #displayOffset!accessing!public! !
!EmbeddedCheckBox categoriesFor: #displayOnFormats!accessing!public! !
!EmbeddedCheckBox categoriesFor: #drawNonThemed:in:on:buttonOffset:textOffset:!displaying!private! !
!EmbeddedCheckBox categoriesFor: #drawThemed:in:on:buttonOffset:textOffset:!displaying!private! !
!EmbeddedCheckBox categoriesFor: #hasEmbeddedHotTracking!public!testing! !
!EmbeddedCheckBox categoriesFor: #hasText!public!testing! !
!EmbeddedCheckBox categoriesFor: #isDisplayOwnerDrawn!public!testing! !
!EmbeddedCheckBox categoriesFor: #onCursoredLeft!event handling!public! !
!EmbeddedCheckBox categoriesFor: #onKillFocus!event handling!public! !
!EmbeddedCheckBox categoriesFor: #onRequestDeactivate!event handling!public! !
!EmbeddedCheckBox categoriesFor: #preTranslateKeyboardInput:!event handling!public! !
!EmbeddedCheckBox categoriesFor: #showIn:!operations!public! !
!EmbeddedCheckBox categoriesFor: #stbSaveOn:!binary filing!public! !
!EmbeddedCheckBox categoriesFor: #text!accessing!public! !
!EmbeddedCheckBox categoriesFor: #text:!accessing!public! !
!EmbeddedCheckBox categoriesFor: #textExtent!accessing!public! !
!EmbeddedCheckBox categoriesFor: #textExtent:!accessing!public! !
!EmbeddedCheckBox categoriesFor: #textOffset!accessing!public! !
!EmbeddedCheckBox categoriesFor: #themePartName!accessing!public! !
!EmbeddedCheckBox categoriesFor: #totalExtent!accessing!public! !

!EmbeddedCheckBox class methodsFor!

stbConvertFrom: anSTBClassFormat

	^[:data || newInstance |
	newInstance := self basicNew.
	1 to: 12 do: [:i | newInstance instVarAt: i put: (data at: i)].
	newInstance baseStyle: newInstance defaultStyle first; extendedStyle: newInstance defaultStyle last.
	newInstance]!

stbVersion

	"Reimplemented in ControlView hierarchy"

	^20! !
!EmbeddedCheckBox class categoriesFor: #stbConvertFrom:!binary filing!public! !
!EmbeddedCheckBox class categoriesFor: #stbVersion!binary filing!public! !

