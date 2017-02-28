"Filed out from Dolphin Smalltalk 7"!

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

cueBanner

	^self propertyAt: #cueBanner ifAbsent: [self propertyAt: #cueBanner put: super cueBanner]!

cueBanner: aString

	super cueBanner: aString.
	self removePropertyAt: #cueBanner ifAbsent: []!

defaultOffset

	^self parentView defaultOffsetForEditor: self!

defaultWindowExStyle
	"Private - Answer the default extended window creation style.
	Use the client edge style for the standard Win95 look."

	^super defaultWindowExStyle bitXor: WS_EX_CLIENTEDGE!

defaultWindowStyle
	"Private - Answer a default style to use when creating an EmbeddedTextEdit."

	^(super defaultWindowStyle) | ES_AUTOHSCROLL!

display: aValue in: aRectangle on: aCanvas forecolor: fColor backcolor: bColor editable: aBoolean hot: hBoolean

	| text color displayOffset cornerOffset |

	text := self typeconverter convertFromLeftToRight: aValue.

	color := fColor.
	(text isEmpty and: [self hasCueBanner]) ifTrue: 
		[text := self cueBanner.
		color := Color grayText].
	displayOffset := self actualOffset + (3@0).
	self alignment = #right 
		ifTrue: [cornerOffset := displayOffset + (8@0)]
		ifFalse: [cornerOffset := displayOffset].
	
	aCanvas 
		forecolor: color;
		formatText: text in: ((aRectangle origin + displayOffset) extent: (aRectangle extent - cornerOffset)) flags: ((AlignmentMap at: self column alignment ifAbsent: [DT_LEFT]) | DT_END_ELLIPSIS)!

displayOnFormats

	^#(#class)!

editRectFor: aRectangle

	"Private - Return the rectangle to use for the editor within the grid cell aRectangle"

	^(aRectangle topLeft + self actualOffset) extent: (aRectangle extent - (self actualOffset + ((self alignment = #right ifTrue: [5] ifFalse: [0])@1)))!

expectsText

	^self typeconverter isNullConverter!

hasCueBanner

	^(self cueBanner ifNil: ['']) isEmpty not!

hasEmbeddedHotTracking

	^false!

isDisplayOwnerDrawn

	^self hasCueBanner!

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
		alignment: self column alignment;
		rectangle: (self editRectFor: aRectangle);
		show!

stbSaveOn: anSTBOutFiler

	"If the receiver is unrealized (i.e. just exists in the spec of a column in the view composer),
	save as a plain object"

	handle isNil 
		ifTrue: [anSTBOutFiler saveObject: self]
		ifFalse: [super stbSaveOn: anSTBOutFiler]! !
!EmbeddedTextEdit categoriesFor: #actualOffset!accessing!public! !
!EmbeddedTextEdit categoriesFor: #column!accessing!public! !
!EmbeddedTextEdit categoriesFor: #createEmbeddedIn:!initializing!public! !
!EmbeddedTextEdit categoriesFor: #cueBanner!displaying!public! !
!EmbeddedTextEdit categoriesFor: #cueBanner:!displaying!public! !
!EmbeddedTextEdit categoriesFor: #defaultOffset!accessing!public! !
!EmbeddedTextEdit categoriesFor: #defaultWindowExStyle!constants!private! !
!EmbeddedTextEdit categoriesFor: #defaultWindowStyle!constants!private! !
!EmbeddedTextEdit categoriesFor: #display:in:on:forecolor:backcolor:editable:hot:!displaying!public! !
!EmbeddedTextEdit categoriesFor: #displayOnFormats!binary filing!public! !
!EmbeddedTextEdit categoriesFor: #editRectFor:!displaying!private! !
!EmbeddedTextEdit categoriesFor: #expectsText!public!testing! !
!EmbeddedTextEdit categoriesFor: #hasCueBanner!displaying!public! !
!EmbeddedTextEdit categoriesFor: #hasEmbeddedHotTracking!public!testing! !
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

!EmbeddedTextEdit class methodsFor!

stbConvertFrom: anSTBClassFormat

	(anSTBClassFormat version = 9 or: [anSTBClassFormat version = 13]) ifTrue:
		[^[:data || newInstance |
		newInstance := self basicNew.
		1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
		newInstance]].

	^super stbConvertFrom: anSTBClassFormat!

stbVersion
	^20! !
!EmbeddedTextEdit class categoriesFor: #stbConvertFrom:!binary filing!public! !
!EmbeddedTextEdit class categoriesFor: #stbVersion!binary filing!public! !

