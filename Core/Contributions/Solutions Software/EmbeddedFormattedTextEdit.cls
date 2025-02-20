"Filed out from Dolphin Smalltalk"!

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
	color := fColor ifNil: [Color windowText].
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

!EmbeddedFormattedTextEdit categoriesForMethods!
actualOffset!accessing!public! !
column!accessing!public! !
createEmbeddedIn:!initialize/release!public! !
cueBanner!accessing!public! !
cueBanner:!accessing!public! !
defaultOffset!accessing!public! !
defaultWindowExStyle!constants!private! !
defaultWindowStyle!constants!private! !
display:in:on:forecolor:backcolor:editable:hot:!drawing!public! !
displayOnFormats!binary filing!public! !
editRectFor:!accessing!private! !
expectsText!public!testing! !
hasCueBanner!public!testing! !
hasEmbeddedHotTracking!public!testing! !
isDisplayOwnerDrawn!public!testing! !
offset!accessing!public! !
offset:!accessing!public! !
onCursoredLeft!event handling!public! !
onKillFocus!event handling!public! !
onRequestDeactivate!event handling!public! !
preTranslateKeyboardInput:!event handling!public! !
show!operations!public! !
showIn:!operations!public! !
stbSaveOn:!binary filing!public! !
!

!EmbeddedFormattedTextEdit class methodsFor!

newForDate

	^super new 
		initialize;
		separatorChars: '/';
		placeholderChar: $_;
		format: '__/__/____';
		typeconverter: DateToText new;
		yourself! !

!EmbeddedFormattedTextEdit class categoriesForMethods!
newForDate!constants!development!public! !
!

