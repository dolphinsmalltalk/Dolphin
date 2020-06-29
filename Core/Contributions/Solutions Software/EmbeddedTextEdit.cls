"Filed out from Dolphin Smalltalk 7"!

TextEdit subclass: #EmbeddedTextEdit
	instanceVariableNames: 'offset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
EmbeddedTextEdit guid: (GUID fromString: '{b24a4423-0072-4380-bd67-1e317410ebf8}')!
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
		inheritContextMenu: false;
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

	color := fColor ifNil: [Color black].
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
!EmbeddedTextEdit categoriesFor: #cueBanner!accessing!public! !
!EmbeddedTextEdit categoriesFor: #cueBanner:!accessing!public! !
!EmbeddedTextEdit categoriesFor: #defaultOffset!accessing!public! !
!EmbeddedTextEdit categoriesFor: #defaultWindowExStyle!constants!private! !
!EmbeddedTextEdit categoriesFor: #defaultWindowStyle!constants!private! !
!EmbeddedTextEdit categoriesFor: #display:in:on:forecolor:backcolor:editable:hot:!drawing!public! !
!EmbeddedTextEdit categoriesFor: #displayOnFormats!binary filing!public! !
!EmbeddedTextEdit categoriesFor: #editRectFor:!accessing!private! !
!EmbeddedTextEdit categoriesFor: #expectsText!public!testing! !
!EmbeddedTextEdit categoriesFor: #hasCueBanner!public!testing! !
!EmbeddedTextEdit categoriesFor: #hasEmbeddedHotTracking!public!testing! !
!EmbeddedTextEdit categoriesFor: #isDisplayOwnerDrawn!public!testing! !
!EmbeddedTextEdit categoriesFor: #offset!accessing!public! !
!EmbeddedTextEdit categoriesFor: #offset:!accessing!public! !
!EmbeddedTextEdit categoriesFor: #onCursoredLeft!event handling!public! !
!EmbeddedTextEdit categoriesFor: #onKillFocus!event handling!public! !
!EmbeddedTextEdit categoriesFor: #onRequestDeactivate!event handling!public! !
!EmbeddedTextEdit categoriesFor: #preTranslateKeyboardInput:!event handling!public! !
!EmbeddedTextEdit categoriesFor: #show!operations!public! !
!EmbeddedTextEdit categoriesFor: #showIn:!operations!public! !
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

