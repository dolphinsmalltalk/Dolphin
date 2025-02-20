"Filed out from Dolphin Smalltalk"!

ComboBox subclass: #EmbeddedComboBox
	instanceVariableNames: 'choiceModel allowNilSelection'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EmbeddedComboBox guid: (GUID fromString: '{37ad4011-9526-4f00-adbb-a2e73c6b5ebc}')!

EmbeddedComboBox comment: ''!

!EmbeddedComboBox categoriesForClass!Unclassified! !

!EmbeddedComboBox methodsFor!

allowNilSelection
	^allowNilSelection ifNil: [false]!

allowNilSelection: anObject
	allowNilSelection := anObject!

cbnSelChange

	self choiceModel value: self selectionOrNil.
	^super cbnSelChange!

choiceModel
	^choiceModel!

choiceModel: anObject
	choiceModel := anObject!

choices: aCollection

	self model list: aCollection!

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

defaultWindowExStyle
	"Private - Answer the default extended window creation style.
	Use the client edge style for the standard Win95 look."

	^super defaultWindowExStyle bitXor: WS_EX_CLIENTEDGE!

defaultWindowStyle
	"Private - Answer a default style to use when creating an EmbeddedTextEdit."

	^(super defaultWindowStyle) | TextEditConstants.ES_AUTOHSCROLL!

display: anObject in: aRectangle on: aCanvas forecolor: fColor backcolor: bColor editable: aBoolean hot: hBoolean

	| text color actualOffset |

	text := self displayStringFor: anObject.
	color := fColor ifNil: [Color windowText].
	(text isEmpty and: [self hasCueBanner]) ifTrue: 
		[text := self cueBanner.
		color := Color grayText].
	actualOffset := (self offsetX@self offsetY) + (4@2).
	
	aCanvas 
		forecolor: color;
		formatText: text in: ((aRectangle origin + actualOffset) extent: (aRectangle extent - actualOffset)) flags: ##(DT_LEFT | DT_END_ELLIPSIS)!

displayOnFormats

	^#(#class)!

editRectFor: aRectangle

	"Private - Return the rectangle to use for the editor within the grid cell aRectangle"

	^(aRectangle origin extent: (aRectangle width@(aRectangle height + self droppedHeight))) insetBy: ((self offsetX@self offsetY) corner: (0@self offsetY))!

embeddedValue

	^self choiceModel value!

embeddedValue: anObject

	self selectionOrNil: anObject.
	self choiceModel setValue: anObject.
	self editView text: (self getTextBlock value: anObject).
	lastSelIndices := #()!

expectsText

	^false!

hasCueBanner

	^(self cueBanner ifNil: ['']) isEmpty not!

hasEmbeddedHotTracking

	^false!

hide

	"Unlike other embedded widgets, combo box does not lose focus when hidden. Force by setting focus to the containing list"

	super hide.

	(self allowNilSelection and: [self editView text isEmpty]) ifTrue: [self choiceModel value: nil].

	self parentView setFocus!

isDisplayOwnerDrawn

	^self hasCueBanner!

listModel: aListModel

	super model: aListModel!

model: aValueHolder

	self choiceModel: aValueHolder!

offsetX

	^0!

offsetY

	^self parentView isMultiline
		ifTrue: [((self parentView rowPixelHeight - (self actualFont pixelSize + 12)) / 2) rounded]
		ifFalse: [0]!

onCursoredLeft

	"The receiver has been entered by a cursor left action"
!

onKillFocus

	self parentView onEditorLostFocus: self.

	^super onKillFocus!

onRequestDeactivate

	"Return if OK"

	^true!

onViewCreated

	super onViewCreated.

	self sendMessage: CB_SETEXTENDEDUI wParam: true asParameter
!

preTranslateKeyboardInput: aMSG

	aMSG message = WM_KEYDOWN ifTrue:
		[| key action editView |
		key := aMSG wParam.
		key = VK_TAB ifTrue:
			[Keyboard default isShiftDown
				ifTrue: [action := MessageSend receiver: self parentView selector: #fieldExitPrevTabbed: arguments: #(true)]
				ifFalse: [action := MessageSend receiver: self parentView selector: #fieldExitNextTabbed: arguments: #(true)]].

		(key = VK_LEFT or: [key = VK_RIGHT]) ifTrue: 
			[editView := self editView.
			key = VK_LEFT ifTrue: 
				[(editView selectionRange isEmpty and: [editView caretPosition = 1]) ifTrue: 
					[action := MessageSend receiver: self parentView selector: #fieldExitPrevTabbed: arguments: #(false)].
				(Keyboard default isShiftDown not and: [editView basicSelectionRange = (0 to: editView textLength)]) ifTrue: 
					[action := MessageSend receiver: editView selector: #caretPosition: arguments: #(1)]].
			(key = VK_RIGHT and: [editView caretPosition > editView plainText size]) ifTrue: 
				[action := MessageSend receiver: self parentView selector: #fieldExitNextTabbed: arguments: #(false)]].

		action notNil ifTrue:
			[SessionManager inputState queueDeferredAction: action.
			^true]].

	^super preTranslateKeyboardInput: aMSG!

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

!EmbeddedComboBox categoriesForMethods!
allowNilSelection!accessing!public! !
allowNilSelection:!accessing!public! !
cbnSelChange!event handling!public! !
choiceModel!accessing!private! !
choiceModel:!accessing!private! !
choices:!public!testing! !
column!accessing!public! !
createEmbeddedIn:!initialize/release!public! !
cueBanner!displaying!public! !
cueBanner:!displaying!public! !
defaultWindowExStyle!constants!private! !
defaultWindowStyle!constants!private! !
display:in:on:forecolor:backcolor:editable:hot:!displaying!public! !
displayOnFormats!binary filing!public! !
editRectFor:!accessing!private! !
embeddedValue!accessing!public! !
embeddedValue:!accessing!public! !
expectsText!public!testing! !
hasCueBanner!displaying!public! !
hasEmbeddedHotTracking!public!testing! !
hide!displaying!public! !
isDisplayOwnerDrawn!public!testing! !
listModel:!public!testing! !
model:!accessing!public! !
offsetX!accessing!public! !
offsetY!accessing!public! !
onCursoredLeft!event handling!public! !
onKillFocus!event handling!public! !
onRequestDeactivate!event handling!public! !
onViewCreated!event handling!public! !
preTranslateKeyboardInput:!event handling!public! !
showIn:!displaying!public! !
stbSaveOn:!binary filing!public! !
!

!EmbeddedComboBox class methodsFor!

stbConvertFrom: anSTBClassFormat

	anSTBClassFormat version <= 20 ifTrue:
		[^[:data || newInstance |
		newInstance := self basicNew.
		1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
		"#1030 lastSelIndices needs initializing"
		newInstance instVarAt: ##(self allInstanceVariableNames indexOf: 'lastSelIndices') put: #().
		newInstance]].

	^super stbConvertFrom: anSTBClassFormat!

stbVersion

	"21 - lastSelIndices already initialized to #() - see #1030"

	^21! !

!EmbeddedComboBox class categoriesForMethods!
stbConvertFrom:!public! !
stbVersion!binary filing!public! !
!

