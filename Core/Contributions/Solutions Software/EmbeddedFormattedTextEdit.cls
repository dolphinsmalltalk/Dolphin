"Filed out from Dolphin Smalltalk 7"!

FormattedTextEdit subclass: #EmbeddedFormattedTextEdit
	instanceVariableNames: 'offset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
EmbeddedFormattedTextEdit guid: (GUID fromString: '{4ef6adf7-0642-4bac-970d-10e4a69ec7f0}')!
EmbeddedFormattedTextEdit comment: ''!
!EmbeddedFormattedTextEdit categoriesForClass!Unclassified! !
!EmbeddedFormattedTextEdit methodsFor!

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
		font: aView font;
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

display: anObject in: aRectangle on: aCanvas forecolor: fColor backcolor: bColor editable: aBoolean hot: hBoolean

	| text color displayOffset cornerOffset |

	text := self typeconverter convertFromLeftToRight: anObject.
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

	^(aRectangle topLeft + self actualOffset) extent: (aRectangle extent - (self actualOffset + (0@1)))!

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

	^self isTextValid
		ifTrue: [true]
		ifFalse: [self errorTextInvalid. false]!

preTranslateKeyboardInput: aMSG

	^self embeddedPreTranslateKeyboardInput: aMSG!

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
!EmbeddedFormattedTextEdit categoriesFor: #column!accessing!public! !
!EmbeddedFormattedTextEdit categoriesFor: #createEmbeddedIn:!initialize/release!public! !
!EmbeddedFormattedTextEdit categoriesFor: #cueBanner!accessing!public! !
!EmbeddedFormattedTextEdit categoriesFor: #cueBanner:!accessing!public! !
!EmbeddedFormattedTextEdit categoriesFor: #defaultOffset!accessing!public! !
!EmbeddedFormattedTextEdit categoriesFor: #defaultWindowExStyle!constants!private! !
!EmbeddedFormattedTextEdit categoriesFor: #defaultWindowStyle!constants!private! !
!EmbeddedFormattedTextEdit categoriesFor: #display:in:on:forecolor:backcolor:editable:hot:!drawing!public! !
!EmbeddedFormattedTextEdit categoriesFor: #displayOnFormats!binary filing!public! !
!EmbeddedFormattedTextEdit categoriesFor: #editRectFor:!accessing!private! !
!EmbeddedFormattedTextEdit categoriesFor: #expectsText!public!testing! !
!EmbeddedFormattedTextEdit categoriesFor: #hasCueBanner!public!testing! !
!EmbeddedFormattedTextEdit categoriesFor: #hasEmbeddedHotTracking!public!testing! !
!EmbeddedFormattedTextEdit categoriesFor: #isDisplayOwnerDrawn!public!testing! !
!EmbeddedFormattedTextEdit categoriesFor: #offset!accessing!public! !
!EmbeddedFormattedTextEdit categoriesFor: #offset:!accessing!public! !
!EmbeddedFormattedTextEdit categoriesFor: #onCursoredLeft!event handling!public! !
!EmbeddedFormattedTextEdit categoriesFor: #onKillFocus!event handling!public! !
!EmbeddedFormattedTextEdit categoriesFor: #onRequestDeactivate!event handling!public! !
!EmbeddedFormattedTextEdit categoriesFor: #preTranslateKeyboardInput:!event handling!public! !
!EmbeddedFormattedTextEdit categoriesFor: #show!operations!public! !
!EmbeddedFormattedTextEdit categoriesFor: #showIn:!operations!public! !
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

