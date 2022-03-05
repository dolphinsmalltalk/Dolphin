"Filed out from Dolphin Smalltalk"!

EmulatedPushButton subclass: #EmbeddedPushButton
	instanceVariableNames: 'isDisplayingEmbedded embeddedRectangle embeddedDisplayState embeddedText text'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmbeddedPushButton guid: (GUID fromString: '{b1d223a1-89b7-41cd-9057-4b9d84f774c7}')!
EmbeddedPushButton comment: ''!
!EmbeddedPushButton categoriesForClass!Unclassified! !
!EmbeddedPushButton methodsFor!

clientRectangle

	^self isDisplayingEmbedded
		ifTrue: [self embeddedRectangle]
		ifFalse: [super clientRectangle]!

createEmbeddedIn: aView

	interactor := presenter := self.
	flags := 0.

	self 
		isManaged: true;
		initializeModel;
		parentView: aView;
		create;
		font: aView font.

	"Arrange pass-thru for tooltip requests so we show the same when active as when passive"
	self addToolTipWithHandle: aView lvmGetToolTips!

display: aValue in: aRectangle on: aCanvas forecolor: fcolor backcolor: bcolor editable: aBoolean hot: hBoolean

	| wasDisplayingEmbedded |

	wasDisplayingEmbedded := self isDisplayingEmbedded.

	[self embeddedRectangle: (self displayRectangleWithin: aRectangle).
	self embeddedText: aValue.
	self embeddedDisplayState:
		(aBoolean == true
			ifTrue: [hBoolean ifTrue: [#hot] ifFalse: [#normal]]
			ifFalse: [#disabled]).
	self isDisplayingEmbedded: true.
	self drawOn: aCanvas] ensure:  [self isDisplayingEmbedded: wasDisplayingEmbedded]!

displayInset

	^##(2@1 corner: 1@2)!

displayOnFormats

	^#(#class)!

displayRectangleWithin: aRectangle

	| rectangle |

	rectangle := aRectangle insetBy: self displayInset.
	self preferredExtent isNil ifTrue: [^rectangle].

	self preferredExtent x ifNotNil: [ :maxWidth | rectangle width > maxWidth ifTrue: [rectangle := rectangle insetBy: (((rectangle width - maxWidth) // 2)@0)]].
	self preferredExtent y ifNotNil: [ :maxHeight | rectangle height > maxHeight ifTrue: [rectangle := rectangle insetBy: (0@((rectangle height - maxHeight) // 2))]].

	^rectangle!

displayState

	| state |

	self isDisplayingEmbedded ifTrue: [^self embeddedDisplayState].

	"For extra emphasis we display as default when active"
	^((state := super displayState) = #normal and: [self hasFocus])
		ifTrue: [#default]
		ifFalse: [state]!

drawBackgroundOn: aCanvas

	self isTransparent
		ifTrue: [self isDisplayingEmbedded ifFalse: [aCanvas erase: self clientRectangle color: self backcolor]]
		ifFalse: [super drawBackgroundOn: aCanvas]!

dropDownOffset

	^(-12 - self imageGap)@-10!

durationOfTransition: aSymbol

	^(self transitionDurations at: aSymbol ifAbsent: [nil]) ifNil: [0]!

embeddedDisplayState
	^embeddedDisplayState!

embeddedDisplayState: anObject
	embeddedDisplayState := anObject!

embeddedRectangle
	^embeddedRectangle!

embeddedRectangle: anObject
	embeddedRectangle := anObject!

embeddedText
	^embeddedText!

embeddedText: anObject
	embeddedText := anObject!

embeddedValue: aStringOrNil

	aStringOrNil ifNotNil: [ :string | self text: string]!

expectsText

	^true!

extent

	^self isDisplayingEmbedded
		ifTrue: [self embeddedRectangle extent]
		ifFalse: [super extent]!

hasEmbeddedHotTracking

	^true!

hasFocus

	^self isDisplayingEmbedded not and: [super hasFocus]!

isDisplayingEmbedded
	^isDisplayingEmbedded ifNil: [false]!

isDisplayingEmbedded: anObject
	isDisplayingEmbedded := anObject!

isDisplayOwnerDrawn

	^true!

isEnabled

	^(self isDisplayingEmbedded and: [self embeddedDisplayState = #disabled])
		ifTrue: [false]
		ifFalse: [super isEnabled]!

onCursoredLeft

	"The receiver has been entered by a cursor left action"

	^self!

onKillFocus

	self parentView onEditorLostFocus: self.

	^super onKillFocus!

onRequestDeactivate

	"Return if OK"

	^true!

preferredExtent: aPointOrNil 
	"Set the preferred size of the receiver to aPointOrNil. If nil is specified then this implies that
	the receiver has no preferred extent"

	preferredExtent = aPointOrNil ifTrue: [^self].
	preferredExtent := aPointOrNil.

	"Reimplemented since parentView may not be set"
	self parentView ifNotNil: [ :pv | pv invalidateLayout]!

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

	self
		rectangle: (self displayRectangleWithin: aRectangle);
		show!

stbSaveOn: anSTBOutFiler

	"If the receiver is unrealized (i.e. just exists in the spec of a column in the view composer),
	save as a plain object"

	handle isNil 
		ifTrue: [anSTBOutFiler saveObject: self]
		ifFalse: [super stbSaveOn: anSTBOutFiler]!

text
	^(self isDisplayingEmbedded 
		ifTrue: [self embeddedText ifNil: [text]]
		ifFalse: [text]) ifNil: ['']!

text: aString
	text := aString.
	self handle notNull ifTrue: [super text: aString]!

ttnGetDispInfo: anNMTTDISPINFOW
	"Pull in the tip text defined by my column, if any"

	(self parentView activeColumn infoTipFromRow: self parentView activeEditorModel withPrefix: '')
		ifNotNil: [:tipText | self tipText: tipText].
	^super ttnGetDispInfo: anNMTTDISPINFOW!

validateUserInterface
	"Set the enabled state of the receiver"

	"do nothing here"!

wmSetFocus: message wParam: wParam lParam: lParam

	"Check for the receiver getting the focus whilst clicked on (assume user clicked on the 'button' in the ELV) - display in the pressed state"
	((self clientRectangle containsPoint: self cursorPosition) and: [Keyboard default isKeyDown: VK_LBUTTON]) ifTrue: [^self displayState: #pressed].

	^super wmSetFocus: message wParam: wParam lParam: lParam! !
!EmbeddedPushButton categoriesForMethods!
clientRectangle!accessing!public! !
createEmbeddedIn:!initialize/release!public! !
display:in:on:forecolor:backcolor:editable:hot:!drawing!public! !
displayInset!operations!public! !
displayOnFormats!accessing!public! !
displayRectangleWithin:!calculating!private! !
displayState!accessing!public! !
drawBackgroundOn:!drawing!public! !
dropDownOffset!accessing!public! !
durationOfTransition:!accessing!public! !
embeddedDisplayState!accessing!private! !
embeddedDisplayState:!accessing!private! !
embeddedRectangle!accessing!private! !
embeddedRectangle:!accessing!private! !
embeddedText!accessing!private! !
embeddedText:!accessing!private! !
embeddedValue:!accessing!public! !
expectsText!public!testing! !
extent!accessing!public! !
hasEmbeddedHotTracking!public!testing! !
hasFocus!public!testing! !
isDisplayingEmbedded!accessing!private! !
isDisplayingEmbedded:!accessing!private! !
isDisplayOwnerDrawn!public!testing! !
isEnabled!public!testing! !
onCursoredLeft!event handling!public! !
onKillFocus!event handling!public! !
onRequestDeactivate!event handling!public! !
preferredExtent:!accessing!public! !
preTranslateKeyboardInput:!event handling!public! !
showIn:!operations!public! !
stbSaveOn:!binary filing!public! !
text!accessing!public! !
text:!accessing!public! !
ttnGetDispInfo:!event handling!public! !
validateUserInterface!operations!public! !
wmSetFocus:wParam:lParam:!event handling-win32!public! !
!

!EmbeddedPushButton class methodsFor!

stbConvertFrom: anSTBClassFormat

	anSTBClassFormat version = 9 ifTrue:
		[^[:data || newInstance |
		newInstance := self basicNew.
		1 to: 12 do: [:i | newInstance instVarAt: i put: (data at: i)].
		newInstance instVarAt: 15 put: (data at: 16). "commandDescription"
		newInstance instVarAt: 16 put: (data at: 18). "image"
		newInstance instVarAt: 35 put: (data at: 17). "text"
		newInstance]].

	^super stbConvertFrom: anSTBClassFormat!

stbVersion
	^20! !
!EmbeddedPushButton class categoriesForMethods!
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
!

