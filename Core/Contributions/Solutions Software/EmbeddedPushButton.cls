"Filed out from Dolphin Smalltalk 7"!

EmulatedPushButton subclass: #EmbeddedPushButton
	instanceVariableNames: 'isDisplayingEmbedded embeddedRectangle embeddedDisplayState embeddedText text'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmbeddedPushButton guid: (GUID fromString: '{B1D223A1-89B7-41CD-9057-4B9D84F774C7}')!
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

	(aView hasFullRowSelect and: [aView showsSelAlways]) ifTrue: [self backcolor: Color face3d].

	"Arrange pass-thru for tooltip requests so we show the same when active as when passive"
	self addToolTipWithHandle: aView lvmGetToolTips!

display: aValue in: aRectangle on: aCanvas forecolor: fcolor backcolor: bcolor editable: aBoolean hot: hBoolean

	| wasDisplayingEmbedded |

	wasDisplayingEmbedded := self isDisplayingEmbedded.

	[self embeddedRectangle: (self displayRectangleWithin: aRectangle).
	self embeddedText: aValue.
	self embeddedDisplayState:
		(aBoolean
			ifTrue: [hBoolean ifTrue: [#hot] ifFalse: [#normal]]
			ifFalse: [#disabled]).
	self isDisplayingEmbedded: true.
	self drawOn: aCanvas] ensure:  [self isDisplayingEmbedded: wasDisplayingEmbedded]!

displayInset

	^##(2@1 corner: 1@2)!

displayOnFormats

	^#(#class)!

displayRectangleWithin: aRectangle

	| rectangle maxWidth maxHeight |

	rectangle := aRectangle insetBy: self displayInset.
	self preferredExtent isNil ifTrue: [^rectangle].

	maxWidth := self preferredExtent x.
	maxHeight := self preferredExtent y.

	rectangle width > maxWidth ifTrue: [rectangle := rectangle insetBy: (((rectangle width - maxWidth) // 2)@0)].
	rectangle height > maxHeight ifTrue: [rectangle := rectangle insetBy: (0@((rectangle height - maxHeight) // 2))].

	^rectangle!

displayState

	^self isDisplayingEmbedded
		ifTrue: [self embeddedDisplayState]
		ifFalse: [super displayState]!

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

extent

	^self isDisplayingEmbedded
		ifTrue: [self embeddedRectangle extent]
		ifFalse: [super extent]!

hasEmbeddedHotTracking

	^true!

hasFocus

	^self isDisplayingEmbedded not and: [super hasFocus]!

imagePosOn: aCanvas

	^self isDisplayingEmbedded
		ifTrue: [(super imagePosOn: aCanvas) + self embeddedRectangle origin]
		ifFalse: [super imagePosOn: aCanvas]!

isDefault

	"If the receiver is active in its ELV, it is by definition the default button (at least, that's how we want to display it)"

	^self isDisplayingEmbedded not!

isDisplayingEmbedded
	^isDisplayingEmbedded ifNil: [false]!

isDisplayingEmbedded: anObject
	isDisplayingEmbedded := anObject!

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

textPosOn: aCanvas

	^self isDisplayingEmbedded
		ifTrue: [(super textPosOn: aCanvas) + self embeddedRectangle origin]
		ifFalse: [super textPosOn: aCanvas]!

ttnGetDispInfo: anNMTTDISPINFO 
	"Pull in the tip text defined by my column, if any"

	(self parentView activeColumn infoTipFromRow: self parentView activeEditorModel withPrefix: '') ifNotNil: [ :tipText | self tipText: tipText].
	
	^super ttnGetDispInfo: anNMTTDISPINFO!

validateUserInterface
	"Set the enabled state of the receiver"

	"do nothing here"!

wmSetFocus: message wParam: wParam lParam: lParam

	"Check for the receiver getting the focus whilst clicked on (assume user clicked on the 'button' in the ELV) - display in the pressed state"
	((self clientRectangle containsPoint: self cursorPosition) and: [Keyboard default isKeyDown: VK_LBUTTON]) ifTrue: [^self displayState: #pressed].

	^super wmSetFocus: message wParam: wParam lParam: lParam! !
!EmbeddedPushButton categoriesFor: #clientRectangle!accessing!public! !
!EmbeddedPushButton categoriesFor: #createEmbeddedIn:!initialize/release!public! !
!EmbeddedPushButton categoriesFor: #display:in:on:forecolor:backcolor:editable:hot:!displaying!public! !
!EmbeddedPushButton categoriesFor: #displayInset!operations!public! !
!EmbeddedPushButton categoriesFor: #displayOnFormats!accessing!public! !
!EmbeddedPushButton categoriesFor: #displayRectangleWithin:!calculating!private! !
!EmbeddedPushButton categoriesFor: #displayState!accessing!public! !
!EmbeddedPushButton categoriesFor: #embeddedDisplayState!accessing!private! !
!EmbeddedPushButton categoriesFor: #embeddedDisplayState:!accessing!private! !
!EmbeddedPushButton categoriesFor: #embeddedRectangle!accessing!private! !
!EmbeddedPushButton categoriesFor: #embeddedRectangle:!accessing!private! !
!EmbeddedPushButton categoriesFor: #embeddedText!accessing!private! !
!EmbeddedPushButton categoriesFor: #embeddedText:!accessing!private! !
!EmbeddedPushButton categoriesFor: #embeddedValue:!accessing!public! !
!EmbeddedPushButton categoriesFor: #extent!accessing!public! !
!EmbeddedPushButton categoriesFor: #hasEmbeddedHotTracking!public!testing! !
!EmbeddedPushButton categoriesFor: #hasFocus!public!testing! !
!EmbeddedPushButton categoriesFor: #imagePosOn:!calculating!private! !
!EmbeddedPushButton categoriesFor: #isDefault!public!testing! !
!EmbeddedPushButton categoriesFor: #isDisplayingEmbedded!accessing!private! !
!EmbeddedPushButton categoriesFor: #isDisplayingEmbedded:!accessing!private! !
!EmbeddedPushButton categoriesFor: #isDisplayOwnerDrawn!public!testing! !
!EmbeddedPushButton categoriesFor: #onCursoredLeft!event handling!public! !
!EmbeddedPushButton categoriesFor: #onKillFocus!event handling!public! !
!EmbeddedPushButton categoriesFor: #onRequestDeactivate!event handling!public! !
!EmbeddedPushButton categoriesFor: #preferredExtent:!accessing!public! !
!EmbeddedPushButton categoriesFor: #preTranslateKeyboardInput:!event handling!public! !
!EmbeddedPushButton categoriesFor: #showIn:!operations!public! !
!EmbeddedPushButton categoriesFor: #stbSaveOn:!binary filing!public! !
!EmbeddedPushButton categoriesFor: #text!accessing!public! !
!EmbeddedPushButton categoriesFor: #text:!accessing!public! !
!EmbeddedPushButton categoriesFor: #textPosOn:!calculating!private! !
!EmbeddedPushButton categoriesFor: #ttnGetDispInfo:!event handling!public! !
!EmbeddedPushButton categoriesFor: #validateUserInterface!operations!public! !
!EmbeddedPushButton categoriesFor: #wmSetFocus:wParam:lParam:!public! !

