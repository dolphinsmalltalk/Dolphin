"Filed out from Dolphin Smalltalk 7"!

FormattedTextEdit subclass: #EmbeddedFormattedTextEdit
	instanceVariableNames: 'offset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmbeddedFormattedTextEdit guid: (GUID fromString: '{4ef6adf7-0642-4bac-970d-10e4a69ec7f0}')!
EmbeddedFormattedTextEdit comment: ''!
!EmbeddedFormattedTextEdit categoriesForClass!Unclassified! !
!EmbeddedFormattedTextEdit methodsFor!

actualOffset

	^self offset ifNil: [self defaultOffset]!

cellRect

	"Private - Return the cell rectangle equivalent to the receiver's edit rectangle"

	^(self rectangle topLeft - self actualOffset) extent: (self extent + (self actualOffset + (0@1)))!

column

	^self parentView allColumns detect: [ :each | each editor == self]!

createEmbeddedIn: aView

	interactor := presenter := self.
	flags := 0.

	self 
		isManaged: true;
		initializeModel;
		parentView: aView;
		create;
		font: aView font;
		yourself!

defaultOffset

	^self parentView defaultOffsetForEditor: self!

defaultWindowExStyle
	"Private - Answer the default extended window creation style.
	Use the client edge style for the standard Win95 look."

	^super defaultWindowExStyle bitXor: WS_EX_CLIENTEDGE!

defaultWindowStyle
	"Private - Answer a default style to use when creating an EmbeddedTextEdit."

	^(super defaultWindowStyle) | ES_AUTOHSCROLL!

display: anObject in: aRectangle on: aCanvas forecolor: fColor backcolor: bColor editable: aBoolean hot: hBoolean

	| text actualOffset |

	text := self typeconverter convertFromLeftToRight: anObject.
	actualOffset := self actualOffset + (3@0).
	
	aCanvas 
		forecolor: fColor;
		formatText: text in: ((aRectangle origin + actualOffset) extent: (aRectangle extent - actualOffset))!

displayOnFormats

	^#(#class)!

editRectFor: aRectangle

	"Private - Return the rectangle to use for the editor within the grid cell aRectangle"

	^(aRectangle topLeft + self actualOffset) extent: (aRectangle extent - (self actualOffset + (0@1)))!

hasEmbeddedHotTracking

	^false!

isDisplayOwnerDrawn

	^false!

offset

	^offset
!

offset: aPoint

	offset := aPoint

!

onCursoredLeft

	"The receiver has been entered by a cursor left action"

	self caretPosition: (self plainText size + 1)!

onKillFocus

	self parentView hideActiveEditor.

	^super onKillFocus!

onRequestDeactivate

	"Return if OK"

	^self isTextValid
		ifTrue: [true]
		ifFalse: [self errorTextInvalid. false]!

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

		key = VK_UP ifTrue: [action := MessageSend receiver: self parentView selector: #fieldExitUp].
		key = VK_DOWN ifTrue: [action := MessageSend receiver: self parentView selector: #fieldExitDown].
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
		rectangle: (self editRectFor: aRectangle);
		show!

stbSaveOn: anSTBOutFiler

	"If the receiver is unrealized (i.e. just exists in the spec of a column in the view composer),
	save as a plain object"

	handle isNil 
		ifTrue: [anSTBOutFiler saveObject: self]
		ifFalse: [super stbSaveOn: anSTBOutFiler]! !
!EmbeddedFormattedTextEdit categoriesFor: #actualOffset!accessing!public! !
!EmbeddedFormattedTextEdit categoriesFor: #cellRect!displaying!private! !
!EmbeddedFormattedTextEdit categoriesFor: #column!accessing!public! !
!EmbeddedFormattedTextEdit categoriesFor: #createEmbeddedIn:!initialize/release!public! !
!EmbeddedFormattedTextEdit categoriesFor: #defaultOffset!accessing!public! !
!EmbeddedFormattedTextEdit categoriesFor: #defaultWindowExStyle!constants!private! !
!EmbeddedFormattedTextEdit categoriesFor: #defaultWindowStyle!constants!private! !
!EmbeddedFormattedTextEdit categoriesFor: #display:in:on:forecolor:backcolor:editable:hot:!displaying!public! !
!EmbeddedFormattedTextEdit categoriesFor: #displayOnFormats!binary filing!public! !
!EmbeddedFormattedTextEdit categoriesFor: #editRectFor:!displaying!private! !
!EmbeddedFormattedTextEdit categoriesFor: #hasEmbeddedHotTracking!public!testing! !
!EmbeddedFormattedTextEdit categoriesFor: #isDisplayOwnerDrawn!public!testing! !
!EmbeddedFormattedTextEdit categoriesFor: #offset!accessing!public! !
!EmbeddedFormattedTextEdit categoriesFor: #offset:!accessing!public! !
!EmbeddedFormattedTextEdit categoriesFor: #onCursoredLeft!event handling!public! !
!EmbeddedFormattedTextEdit categoriesFor: #onKillFocus!event handling!public! !
!EmbeddedFormattedTextEdit categoriesFor: #onRequestDeactivate!event handling!public! !
!EmbeddedFormattedTextEdit categoriesFor: #preTranslateKeyboardInput:!event handling!public! !
!EmbeddedFormattedTextEdit categoriesFor: #show!displaying!public! !
!EmbeddedFormattedTextEdit categoriesFor: #showIn:!displaying!public! !
!EmbeddedFormattedTextEdit categoriesFor: #stbSaveOn:!binary filing!public! !

!EmbeddedFormattedTextEdit class methodsFor!

newForDate

	^super new 
		initialize;
		separatorChars: '/';
		placeholderChar: $_;
		format: '__/__/____';
		typeconverter: DateToText new;
		yourself! !
!EmbeddedFormattedTextEdit class categoriesFor: #newForDate!constants!development!public! !

