"Filed out from Dolphin Smalltalk 7"!

MultilineTextEdit subclass: #EmbeddedMultilineTextEdit
	instanceVariableNames: 'column'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmbeddedMultilineTextEdit guid: (GUID fromString: '{F464E637-7C1A-4A4A-A066-653A45DA17FD}')!
EmbeddedMultilineTextEdit comment: ''!
!EmbeddedMultilineTextEdit categoriesForClass!Unclassified! !
!EmbeddedMultilineTextEdit methodsFor!

column
	^column!

column: anObject
	column := anObject!

createEmbeddedIn: aView

	self
		initialize;
		parentView: aView;
		column: (aView allColumns detect: [ :each | each editor == self]);
		create;
		font: self view font;
		yourself!

defaultWindowExStyle
	"Private - Answer the default extended window creation style.
	Use the client edge style for the standard Win95 look."

	^super defaultWindowExStyle bitXor: WS_EX_CLIENTEDGE!

defaultWindowStyle
	"Private - Answer a default style to use when creating an EmbeddedMultilineTextEdit."

	^super defaultWindowStyle | WS_VSCROLL | ES_AUTOVSCROLL
!

display: aString in: aRectangle on: aCanvas forecolor: fColor backcolor: bColor editable: aBoolean hot: hBoolean

	| myRect formatRect text displayRect |

	text := aString ifNil: [''].

	"Get the actual dimensions of the text as formatted in aRectangle"
	myRect := aRectangle insetBy: self horzDisplayOffset@0.
	formatRect := myRect asParameter.
	UserLibrary default 
		drawTextEx: aCanvas asParameter
		lpchText: text
		cchText: text size
		lprc: formatRect
		dwDTFormat: (DT_WORDBREAK | DT_LEFT | DT_CALCRECT)
		lpDTParams: nil.
	formatRect := formatRect asRectangle.

	"Show the text centered"
	formatRect height < myRect height
		ifTrue: [displayRect := myRect translatedBy: 0@((aRectangle height - formatRect height) // 2)]
		ifFalse: [displayRect := myRect insetBy: 0@(self parentView defaultOffsetForEditor: self) y].

	aCanvas 
		forecolor: fColor;
		formatText: text in: displayRect!

displayOnFormats

	^#(#class)!

hasEmbeddedHotTracking

	^false!

horzDisplayOffset

	^3!

isDisplayOwnerDrawn

	^true!

onCursoredLeft

	"The receiver has been entered by a cursor left action"

	self caretPosition: (self plainText size + 1)!

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
		(key = VK_RIGHT and: [self caretPosition > self plainText size]) ifTrue: [action := MessageSend receiver: self parentView selector: #fieldExitNextTabbed: arguments: #(false)].

		key = VK_LEFT ifTrue:
			[(self selectionRange isEmpty and: [self caretPosition = 1]) ifTrue: 
				[action := MessageSend receiver: self parentView selector: #fieldExitPrevTabbed: arguments: #(false)].
			(Keyboard default isShiftDown not and: [self basicSelectionRange = (0 to: self textLength)]) ifTrue: 
				[action := MessageSend receiver: self selector: #caretPosition: arguments: #(1)]].

		(key = VK_UP and: [self currentLine = 1]) ifTrue: [action := MessageSend receiver: self parentView selector: #fieldExitUp].
		(key = VK_DOWN and: [self currentLine = self lineCount]) ifTrue: [action := MessageSend receiver: self parentView selector: #fieldExitDown].
		key = VK_ESCAPE ifTrue: [action := [self undo; selectAll]].
		action notNil ifTrue:
			[SessionManager inputState queueDeferredAction: action.
			^true]].

	^super preTranslateKeyboardInput: aMSG!

show

	self caretPosition: 1.
	^super show!

showIn: aRectangle

	self
		position: aRectangle topLeft;
		height: (aRectangle height - 1);
		width: (aRectangle width - 1);
		show!

stbSaveOn: anSTBOutFiler

	"If the receiver is unrealized (i.e. just exists in the spec of a column in the view composer),
	save as a plain object"

	handle isNil 
		ifTrue: [anSTBOutFiler saveObject: self]
		ifFalse: [super stbSaveOn: anSTBOutFiler]! !
!EmbeddedMultilineTextEdit categoriesFor: #column!accessing!private! !
!EmbeddedMultilineTextEdit categoriesFor: #column:!accessing!private! !
!EmbeddedMultilineTextEdit categoriesFor: #createEmbeddedIn:!initialize/release!public! !
!EmbeddedMultilineTextEdit categoriesFor: #defaultWindowExStyle!constants!private! !
!EmbeddedMultilineTextEdit categoriesFor: #defaultWindowStyle!constants!private! !
!EmbeddedMultilineTextEdit categoriesFor: #display:in:on:forecolor:backcolor:editable:hot:!displaying!public! !
!EmbeddedMultilineTextEdit categoriesFor: #displayOnFormats!binary filing!public! !
!EmbeddedMultilineTextEdit categoriesFor: #hasEmbeddedHotTracking!public!testing! !
!EmbeddedMultilineTextEdit categoriesFor: #horzDisplayOffset!accessing!public! !
!EmbeddedMultilineTextEdit categoriesFor: #isDisplayOwnerDrawn!public!testing! !
!EmbeddedMultilineTextEdit categoriesFor: #onCursoredLeft!event handling!public! !
!EmbeddedMultilineTextEdit categoriesFor: #onKillFocus!event handling!public! !
!EmbeddedMultilineTextEdit categoriesFor: #onRequestDeactivate!event handling!public! !
!EmbeddedMultilineTextEdit categoriesFor: #preTranslateKeyboardInput:!event handling!public! !
!EmbeddedMultilineTextEdit categoriesFor: #show!displaying!public! !
!EmbeddedMultilineTextEdit categoriesFor: #showIn:!displaying!public! !
!EmbeddedMultilineTextEdit categoriesFor: #stbSaveOn:!binary filing!public! !

