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

	^self parentView allColumns detect: [ :each | each editor == self]!

column: anObject
	column := anObject!

createEmbeddedIn: aView

	self
		initialize;
		parentView: aView;
		create;
		font: self view font;
		yourself!

cueBanner

	^self propertyAt: #cueBanner ifAbsent: [nil]!

cueBanner: aString

	self propertyAt: #cueBanner put: aString!

defaultWindowExStyle
	"Private - Answer the default extended window creation style.
	Use the client edge style for the standard Win95 look."

	^super defaultWindowExStyle bitXor: WS_EX_CLIENTEDGE!

defaultWindowStyle
	"Private - Answer a default style to use when creating an EmbeddedMultilineTextEdit."

	^super defaultWindowStyle | WS_VSCROLL | ES_AUTOVSCROLL
!

display: aValue in: aRectangle on: aCanvas forecolor: fColor backcolor: bColor editable: aBoolean hot: hBoolean

	| color myRect formatRect text displayRect commonFlags horzAlignmentFlag |

	text := self typeconverter convertFromLeftToRight: aValue.
	color := fColor.
	(text isEmpty and: [self hasCueBanner]) ifTrue: 
		[text := self cueBanner.
		color := Color grayText].

	"Get the actual dimensions of the text as formatted in aRectangle"
	commonFlags := ##(DT_WORDBREAK | DT_END_ELLIPSIS | DT_LEFT| DT_NOPREFIX | DT_EDITCONTROL | 64 "DT_EXPANDTABS").
	horzAlignmentFlag := AlignmentMap at: self column alignment ifAbsent: [DT_LEFT].
	myRect := aRectangle insetBy: self horzDisplayOffset@0.
	formatRect := myRect asParameter.
	aCanvas formatText: text in: formatRect flags: (horzAlignmentFlag | commonFlags | DT_CALCRECT).
	formatRect := formatRect asRectangle.

	"Show the text centered unless its too big"
	(self verticalAlignment = #top or: [formatRect height >= myRect height])
		ifTrue: [displayRect := myRect]
		ifFalse: [displayRect := myRect translatedBy: 0@((aRectangle height - formatRect height) // 2)].

	aCanvas 
		forecolor: color;
		formatText: text in: displayRect flags: (horzAlignmentFlag | commonFlags)!

displayOnFormats

	^#(#class)!

expectsText

	^self typeconverter isNullConverter!

hasCueBanner

	^(self cueBanner ifNil: ['']) isEmpty not!

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
		alignment: self column alignment;
		position: aRectangle topLeft;
		height: (aRectangle height - 1);
		width: (aRectangle width - 1);
		show!

stbSaveOn: anSTBOutFiler

	"If the receiver is unrealized (i.e. just exists in the spec of a column in the view composer),
	save as a plain object"

	handle isNil 
		ifTrue: [anSTBOutFiler saveObject: self]
		ifFalse: [super stbSaveOn: anSTBOutFiler]!

verticalAlignment

	^column ifNil: [#center]!

verticalAlignment: aSymbol

	column := aSymbol! !
!EmbeddedMultilineTextEdit categoriesFor: #column!accessing!private! !
!EmbeddedMultilineTextEdit categoriesFor: #column:!accessing!private! !
!EmbeddedMultilineTextEdit categoriesFor: #createEmbeddedIn:!initialize/release!public! !
!EmbeddedMultilineTextEdit categoriesFor: #cueBanner!displaying!public! !
!EmbeddedMultilineTextEdit categoriesFor: #cueBanner:!displaying!public! !
!EmbeddedMultilineTextEdit categoriesFor: #defaultWindowExStyle!constants!private! !
!EmbeddedMultilineTextEdit categoriesFor: #defaultWindowStyle!constants!private! !
!EmbeddedMultilineTextEdit categoriesFor: #display:in:on:forecolor:backcolor:editable:hot:!displaying!public! !
!EmbeddedMultilineTextEdit categoriesFor: #displayOnFormats!binary filing!public! !
!EmbeddedMultilineTextEdit categoriesFor: #expectsText!public!testing! !
!EmbeddedMultilineTextEdit categoriesFor: #hasCueBanner!displaying!public! !
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
!EmbeddedMultilineTextEdit categoriesFor: #verticalAlignment!accessing!public! !
!EmbeddedMultilineTextEdit categoriesFor: #verticalAlignment:!accessing!public! !

!EmbeddedMultilineTextEdit class methodsFor!

stbConvertFrom: anSTBClassFormat

	(anSTBClassFormat version = 9 or: [anSTBClassFormat version = 13]) ifTrue:
		[^[:data || newInstance |
		newInstance := self basicNew.
		1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
		newInstance]].

	^super stbConvertFrom: anSTBClassFormat!

stbVersion
	^20! !
!EmbeddedMultilineTextEdit class categoriesFor: #stbConvertFrom:!binary filing!public! !
!EmbeddedMultilineTextEdit class categoriesFor: #stbVersion!binary filing!public! !

