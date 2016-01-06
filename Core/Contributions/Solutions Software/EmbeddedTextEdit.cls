"Filed out from Dolphin Smalltalk X6.1"!

TextEdit subclass: #EmbeddedTextEdit
	instanceVariableNames: 'offset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmbeddedTextEdit guid: (GUID fromString: '{B24A4423-0072-4380-BD67-1E317410EBF8}')!
EmbeddedTextEdit comment: ''!
!EmbeddedTextEdit categoriesForClass!Unclassified! !
!EmbeddedTextEdit methodsFor!

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
		font: self view font;
		yourself!

defaultOffset

	"Works for several fonts (set an explicit offset if not)"

	| x y |

	(self parentView primaryColumn editor == self)
		ifTrue: [x := -1]
		ifFalse: [x := 3].

	y := (10 - (self actualFont pointSize)) max: 0.
	self parentView isMultiline ifTrue:
		[y := (((self actualFont pixelSize + 2) * (self parentView rowHeight - 1)) + 1) //2].

	^x@y!

defaultWindowExStyle
	"Private - Answer the default extended window creation style.
	Use the client edge style for the standard Win95 look."

	^super defaultWindowExStyle bitXor: WS_EX_CLIENTEDGE!

defaultWindowStyle
	"Private - Answer a default style to use when creating an EmbeddedTextEdit."

	^(super defaultWindowStyle) | ES_AUTOHSCROLL!

display: aString in: aRectangle on: aCanvas forecolor: fColor backcolor: bColor 

	| text |

	text := aString ifNil: [''].
	offset := self actualOffset.
	
	aCanvas 
		forecolor: fColor;
		formatText: text in: ((aRectangle origin + offset) extent: (aRectangle extent - offset))!

displayOnFormats

	^#(#class)!

editRectFor: aRectangle

	"Private - Return the rectangle to use for the editor within the grid cell aRectangle"

	^(aRectangle topLeft + self actualOffset) extent: (aRectangle extent - (self actualOffset + (0@1)))!

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
!EmbeddedTextEdit categoriesFor: #actualOffset!accessing!public! !
!EmbeddedTextEdit categoriesFor: #cellRect!displaying!private! !
!EmbeddedTextEdit categoriesFor: #column!accessing!public! !
!EmbeddedTextEdit categoriesFor: #createEmbeddedIn:!initializing!public! !
!EmbeddedTextEdit categoriesFor: #defaultOffset!accessing!public! !
!EmbeddedTextEdit categoriesFor: #defaultWindowExStyle!constants!private! !
!EmbeddedTextEdit categoriesFor: #defaultWindowStyle!constants!private! !
!EmbeddedTextEdit categoriesFor: #display:in:on:forecolor:backcolor:!displaying!public! !
!EmbeddedTextEdit categoriesFor: #displayOnFormats!binary filing!public! !
!EmbeddedTextEdit categoriesFor: #editRectFor:!displaying!private! !
!EmbeddedTextEdit categoriesFor: #isDisplayOwnerDrawn!public!testing! !
!EmbeddedTextEdit categoriesFor: #offset!accessing!public! !
!EmbeddedTextEdit categoriesFor: #offset:!accessing!public! !
!EmbeddedTextEdit categoriesFor: #onCursoredLeft!event handling!public! !
!EmbeddedTextEdit categoriesFor: #onKillFocus!event handling!public! !
!EmbeddedTextEdit categoriesFor: #onRequestDeactivate!event handling!public! !
!EmbeddedTextEdit categoriesFor: #preTranslateKeyboardInput:!event handling!public! !
!EmbeddedTextEdit categoriesFor: #show!displaying!public! !
!EmbeddedTextEdit categoriesFor: #showIn:!displaying!public! !
!EmbeddedTextEdit categoriesFor: #stbSaveOn:!binary filing!public! !

