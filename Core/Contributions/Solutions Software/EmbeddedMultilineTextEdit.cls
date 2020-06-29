"Filed out from Dolphin Smalltalk 7"!

MultilineTextEdit subclass: #EmbeddedMultilineTextEdit
	instanceVariableNames: 'column'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
EmbeddedMultilineTextEdit guid: (GUID fromString: '{f464e637-7c1a-4a4a-a066-653a45da17fd}')!
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
		inheritContextMenu: false;
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
	color := fColor ifNil: [Color black].
	(text isEmpty and: [self hasCueBanner]) ifTrue: 
		[text := self cueBanner.
		color := Color grayText].

	"Get the actual dimensions of the text as formatted in aRectangle"
	commonFlags := ##(DT_WORDBREAK | DT_END_ELLIPSIS | DT_LEFT| DT_NOPREFIX | DT_EDITCONTROL | DT_EXPANDTABS).
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

	self parentView onEditorLostFocus: self.

	^super onKillFocus!

onRequestDeactivate

	"Return if OK"

	^true!

preTranslateKeyboardInput: aMSG

	^self embeddedPreTranslateKeyboardInput: aMSG!

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
!EmbeddedMultilineTextEdit categoriesFor: #cueBanner!accessing!public! !
!EmbeddedMultilineTextEdit categoriesFor: #cueBanner:!accessing!public! !
!EmbeddedMultilineTextEdit categoriesFor: #defaultWindowExStyle!constants!private! !
!EmbeddedMultilineTextEdit categoriesFor: #defaultWindowStyle!constants!private! !
!EmbeddedMultilineTextEdit categoriesFor: #display:in:on:forecolor:backcolor:editable:hot:!drawing!public! !
!EmbeddedMultilineTextEdit categoriesFor: #displayOnFormats!binary filing!public! !
!EmbeddedMultilineTextEdit categoriesFor: #expectsText!public!testing! !
!EmbeddedMultilineTextEdit categoriesFor: #hasCueBanner!public!testing! !
!EmbeddedMultilineTextEdit categoriesFor: #hasEmbeddedHotTracking!public!testing! !
!EmbeddedMultilineTextEdit categoriesFor: #horzDisplayOffset!accessing!public! !
!EmbeddedMultilineTextEdit categoriesFor: #isDisplayOwnerDrawn!public!testing! !
!EmbeddedMultilineTextEdit categoriesFor: #onCursoredLeft!event handling!public! !
!EmbeddedMultilineTextEdit categoriesFor: #onKillFocus!event handling!public! !
!EmbeddedMultilineTextEdit categoriesFor: #onRequestDeactivate!event handling!public! !
!EmbeddedMultilineTextEdit categoriesFor: #preTranslateKeyboardInput:!event handling!public! !
!EmbeddedMultilineTextEdit categoriesFor: #show!operations!public! !
!EmbeddedMultilineTextEdit categoriesFor: #showIn:!operations!public! !
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

