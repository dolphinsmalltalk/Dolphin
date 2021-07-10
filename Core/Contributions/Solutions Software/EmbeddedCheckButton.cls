"Filed out from Dolphin Smalltalk"!

CheckButton subclass: #EmbeddedCheckButton
	instanceVariableNames: 'textExtent text isAlwaysDrawnEnabled buttonExtent'
	classVariableNames: ''
	poolDictionaries: 'ThemeConstants'
	classInstanceVariableNames: ''!
EmbeddedCheckButton guid: (GUID fromString: '{577c445c-7f28-41c6-be9f-021847c53e4e}')!
EmbeddedCheckButton comment: ''!
!EmbeddedCheckButton categoriesForClass!MVP-Views! !
!EmbeddedCheckButton methodsFor!

_buttonExtent

	| size | 

	self isThemed ifFalse: [^(UserLibrary default getSystemMetrics: SM_CXMENUCHECK)@(UserLibrary default getSystemMetrics: SM_CYMENUCHECK)].

	size := SIZE new.
	ThemeLibrary default getThemePartSize: self theme hdc: self canvas asParameter iPartId: self iPartId iStateId: self defaultIStateId prc: nil eSize: TS_DRAW psz: size.
	^size asObject!

buttonExtent

	^buttonExtent ifNil: [buttonExtent := self _buttonExtent]!

createEmbeddedIn: aView

	interactor := presenter := self.
	flags := 0.

	self 
		isManaged: true;
		initializeModel;
		parentView: aView;
		backcolor: Color none;
		isTransparent: true;
		create;
		font: aView font!

defaultIStateId

	^self subclassResponsibility!

display: aValue in: aRectangle on: aCanvas forecolor: fColor backcolor: bColor editable: aBoolean hot: hBoolean

	| buttonOffset textRect |

	self hasText 
		ifTrue: [self textExtent: (aCanvas textExtent: self text)]
		ifFalse: [self textExtent: 0@0].

	buttonOffset := (((aRectangle width - self totalExtent x) @ (aRectangle height - self buttonExtent y) // 2) rounded) max: (self horzMargin@0).

	textRect := aRectangle copy.
	self hasText ifTrue: 
		[textRect 
			left: (textRect left + buttonOffset x + self buttonExtent x + self textOffset x);
			right: (textRect right - self horzMargin).
		textRect := self textRectIn: textRect on: aCanvas iStateId: (self iStateFor: aValue enabled: aBoolean hot: hBoolean)].

	self isThemed
		ifTrue: [self drawThemed: aValue in: aRectangle on: aCanvas buttonOffset: buttonOffset textRect: textRect enabled: aBoolean hot: hBoolean]
		ifFalse: [self drawNonThemed: aValue in: aRectangle on: aCanvas buttonOffset: buttonOffset textRect: textRect enabled: aBoolean hot: hBoolean]!

displayOnFormats

	^#(#class)!

drawNonThemed: aValue in: aRectangle on: aCanvas buttonOffset: buttonOffset textRect: textRectangle enabled: aBoolean hot: hBoolean

	UserLibrary default 
		drawFrameControl: aCanvas handle
		lprc: ((aRectangle origin + buttonOffset) extent: (self buttonExtent min: aRectangle extent)) asParameter 
		uType: DFC_BUTTON 
		uState: (self uStateFor: aValue enabled: aBoolean).

	self hasText ifTrue:
		[aBoolean ifFalse: [aCanvas forecolor: Color grayText].
		"We need to use DT_NOCLIP to get the correct layout so we must clip the canvas to compensate"
		aCanvas clipTo: aRectangle during: 
			[aCanvas formatText: self text in: textRectangle flags: ##(DT_WORDBREAK | DT_LEFT | DT_EDITCONTROL | DT_NOCLIP)]]!

drawThemed: aValue in: aRectangle on: aCanvas buttonOffset: buttonOffset textRect: textRectangle enabled: aBoolean hot: hBoolean

	| iStateId |

	iStateId := self iStateFor: aValue enabled: aBoolean hot: hBoolean.

	ThemeLibrary default 
		drawThemeBackground: self theme 
		hdc: aCanvas asParameter 
		iPartId: self iPartId
		iStateId: iStateId
		pRect: ((aRectangle origin + buttonOffset) extent: self buttonExtent) asParameter 
		pClipRect: aRectangle asParameter.

	self hasText ifTrue: 
		["We need to use DT_NOCLIP to get the correct layout so we also need to clip the canvas to compensate"
		aCanvas clipTo: aRectangle during: 
			[ThemeLibrary default 
				drawThemeText: self theme 
				hdc: aCanvas asParameter 
				iPartId: self iPartId
				iStateId: iStateId
				pszText: self text asUtf16String 
				iCharCount: -1 
				dwTextFlags: ##(DT_WORDBREAK | DT_LEFT | DT_EDITCONTROL | DT_NOCLIP)
				dwTextFlags2: 0 
				pRect: textRectangle asParameter]]!

expectsText

	^false!

freeTheme

	buttonExtent := nil.

	super freeTheme!

hasEmbeddedHotTracking

	^true!

hasText

	^(self text ifNil: ['']) isEmpty not!

horzMargin

	^3!

initialize

	self isAlwaysDrawnEnabled: false.
	super initialize!

iPartId

	^self subclassResponsibility!

isAlwaysDrawnEnabled
	^isAlwaysDrawnEnabled ifNil: ["Backwards compatibility" true]!

isAlwaysDrawnEnabled: anObject
	isAlwaysDrawnEnabled := anObject!

isDisplayOwnerDrawn

	^true!

iStateFor: aValue enabled: aBoolean hot: hBoolean

	^self subclassResponsibility!

onCursoredLeft

	"The receiver has been entered by a cursor left action"

	^self!

onKillFocus

	self parentView onEditorLostFocus: self.

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

setWindowText

	self handle notNull ifTrue: [super text: self text]!

showIn: aRectangle

	| offsetX |

	offsetX := ((aRectangle width - self totalExtent x) // 2) rounded max: self horzMargin.

	self
		setWindowText;
		rectangle: (aRectangle insetBy: offsetX@0);
		show!

stbSaveOn: anSTBOutFiler

	"If the receiver is unrealized (i.e. just exists in the spec of a column in the view composer),
	save as a plain object"

	handle isNil 
		ifTrue: [anSTBOutFiler saveObject: self]
		ifFalse: [super stbSaveOn: anSTBOutFiler]!

text
	^text ifNil: ['']!

text: aString
	text := aString.
	self setWindowText!

textExtent

	^textExtent ifNil: [0@0]!

textExtent: aPoint

	textExtent := aPoint!

textOffset

	^self hasText
		ifTrue: [3@0]
		ifFalse: [0@0]!

textRectIn: aRectangle on: aCanvas iStateId: iStateId

	| formatRect |

	"Get the actual dimensions of the text as formatted in aRectangle"
	formatRect := aRectangle asParameter.

	self isThemed
	ifTrue: 
		[ThemeLibrary default 
			getThemeTextExtent: self theme hdc: aCanvas asParameter 
			iPartId: self iPartId iStateId: iStateId 
			pszText: self text asUtf16String iCharCount: -1 
			dwTextFlags: ##(DT_WORDBREAK |  DT_EDITCONTROL | DT_LEFT | DT_CALCRECT) 
			pBoundingRect: formatRect pExtentRect: formatRect]
	ifFalse: 
		[aCanvas 
			formatText: self text in: formatRect 
			flags: ##(DT_WORDBREAK |  DT_EDITCONTROL | DT_LEFT | DT_CALCRECT)].

	formatRect := formatRect asRectangle.

	^aRectangle insetBy: 0@((aRectangle height - formatRect height) // 2)!

totalExtent

	^(self buttonExtent x + self textOffset x + self textExtent x)@(self buttonExtent y max: self textExtent y).
!

uStateFor: aValue enabled: aBoolean

	^self subclassResponsibility! !
!EmbeddedCheckButton categoriesForMethods!
_buttonExtent!accessing!private! !
buttonExtent!accessing!public! !
createEmbeddedIn:!initialize/release!public! !
defaultIStateId!constants!public! !
display:in:on:forecolor:backcolor:editable:hot:!drawing!public! !
displayOnFormats!accessing!public! !
drawNonThemed:in:on:buttonOffset:textRect:enabled:hot:!drawing!private! !
drawThemed:in:on:buttonOffset:textRect:enabled:hot:!drawing!private! !
expectsText!public!testing! !
freeTheme!initialize/release!private! !
hasEmbeddedHotTracking!public!testing! !
hasText!public!testing! !
horzMargin!accessing!public! !
initialize!initialize/release!public! !
iPartId!constants!public! !
isAlwaysDrawnEnabled!accessing!private! !
isAlwaysDrawnEnabled:!accessing!private! !
isDisplayOwnerDrawn!public!testing! !
iStateFor:enabled:hot:!drawing!private! !
onCursoredLeft!event handling!public! !
onKillFocus!event handling!public! !
onRequestDeactivate!event handling!public! !
preTranslateKeyboardInput:!event handling!public! !
setWindowText!operations!private! !
showIn:!operations!public! !
stbSaveOn:!binary filing!public! !
text!accessing!public! !
text:!accessing!public! !
textExtent!accessing!public! !
textExtent:!accessing!public! !
textOffset!accessing!public! !
textRectIn:on:iStateId:!drawing!private! !
totalExtent!accessing!public! !
uStateFor:enabled:!drawing!private! !
!

!EmbeddedCheckButton class methodsFor!

stbConvertFrom: anSTBClassFormat

	anSTBClassFormat version <= 21 ifTrue:
		[^[:data || newInstance |
		newInstance := self basicNew.
		1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
		newInstance]].

	^super stbConvertFrom: anSTBClassFormat!

stbVersion
	^22! !
!EmbeddedCheckButton class categoriesForMethods!
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
!

