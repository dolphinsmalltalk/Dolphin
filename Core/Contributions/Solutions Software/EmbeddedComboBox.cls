"Filed out from Dolphin Smalltalk 7"!

ComboBox subclass: #EmbeddedComboBox
	instanceVariableNames: 'choiceModel cellRect'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmbeddedComboBox guid: (GUID fromString: '{37AD4011-9526-4F00-ADBB-A2E73C6B5EBC}')!
EmbeddedComboBox comment: ''!
!EmbeddedComboBox categoriesForClass!Unclassified! !
!EmbeddedComboBox methodsFor!

cbnSelChange

	self choiceModel value: self selectionOrNil.
	^super cbnSelChange!

cellRect

	^cellRect!

cellRect: anObject
	cellRect := anObject!

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

defaultWindowExStyle
	"Private - Answer the default extended window creation style.
	Use the client edge style for the standard Win95 look."

	^super defaultWindowExStyle bitXor: WS_EX_CLIENTEDGE!

defaultWindowStyle
	"Private - Answer a default style to use when creating an EmbeddedTextEdit."

	^(super defaultWindowStyle) | 128 "ES_AUTOHSCROLL"!

display: anObject in: aRectangle on: aCanvas forecolor: fColor backcolor: bColor editable: aBoolean hot: hBoolean

	| text actualOffset |

	text := self displayStringFor: anObject.
	actualOffset := (self offsetX@self offsetY) + (4@2).
	
	aCanvas 
		forecolor: fColor;
		formatText: text in: ((aRectangle origin + actualOffset) extent: (aRectangle extent - actualOffset))!

displayOnFormats

	^#(#class)!

embeddedValue

	^self choiceModel value!

embeddedValue: anObject

	self selectionOrNil: anObject.
	self choiceModel setValue: anObject.
	lastSelIndices := #()!

hasEmbeddedHotTracking

	^false!

isDisplayOwnerDrawn

	^false!

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

onFullyCreated

	super onFullyCreated.

	"CB_SETEXTENDEDUI"
	self sendMessage: 16r0155 wParam: true asParameter
!

onKillFocus

	"Need to specify the editor to avoid killing the focus on any new editor(something to do with combo box vs its entry field?)" 
	self parentView hideActiveEditor: self.

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
		action notNil ifTrue:
			[SessionManager inputState queueDeferredAction: action.
			^true]].

	^super preTranslateKeyboardInput: aMSG!

showIn: aRectangle

	"need to cache the cellRect since the receiver's height isn't reliable"
	self cellRect: aRectangle.

	self
		rectangle: ((aRectangle origin extent: (aRectangle width@(aRectangle height + self droppedHeight))) 
					insetBy: ((self offsetX@self offsetY) corner: (0@self offsetY)));
		show!

stbSaveOn: anSTBOutFiler

	"If the receiver is unrealized (i.e. just exists in the spec of a column in the view composer),
	save as a plain object"

	handle isNil 
		ifTrue: [anSTBOutFiler saveObject: self]
		ifFalse: [super stbSaveOn: anSTBOutFiler]! !
!EmbeddedComboBox categoriesFor: #cbnSelChange!event handling!public! !
!EmbeddedComboBox categoriesFor: #cellRect!accessing!public! !
!EmbeddedComboBox categoriesFor: #cellRect:!accessing!private! !
!EmbeddedComboBox categoriesFor: #choiceModel!accessing!private! !
!EmbeddedComboBox categoriesFor: #choiceModel:!accessing!private! !
!EmbeddedComboBox categoriesFor: #choices:!public!testing! !
!EmbeddedComboBox categoriesFor: #column!accessing!public! !
!EmbeddedComboBox categoriesFor: #createEmbeddedIn:!initialize/release!public! !
!EmbeddedComboBox categoriesFor: #defaultWindowExStyle!constants!private! !
!EmbeddedComboBox categoriesFor: #defaultWindowStyle!constants!private! !
!EmbeddedComboBox categoriesFor: #display:in:on:forecolor:backcolor:editable:hot:!displaying!public! !
!EmbeddedComboBox categoriesFor: #displayOnFormats!binary filing!public! !
!EmbeddedComboBox categoriesFor: #embeddedValue!accessing!public! !
!EmbeddedComboBox categoriesFor: #embeddedValue:!accessing!public! !
!EmbeddedComboBox categoriesFor: #hasEmbeddedHotTracking!public!testing! !
!EmbeddedComboBox categoriesFor: #isDisplayOwnerDrawn!public!testing! !
!EmbeddedComboBox categoriesFor: #listModel:!public!testing! !
!EmbeddedComboBox categoriesFor: #model:!accessing!public! !
!EmbeddedComboBox categoriesFor: #offsetX!accessing!public! !
!EmbeddedComboBox categoriesFor: #offsetY!accessing!public! !
!EmbeddedComboBox categoriesFor: #onCursoredLeft!event handling!public! !
!EmbeddedComboBox categoriesFor: #onFullyCreated!event handling!public! !
!EmbeddedComboBox categoriesFor: #onKillFocus!event handling!public! !
!EmbeddedComboBox categoriesFor: #onRequestDeactivate!event handling!public! !
!EmbeddedComboBox categoriesFor: #preTranslateKeyboardInput:!event handling!public! !
!EmbeddedComboBox categoriesFor: #showIn:!displaying!public! !
!EmbeddedComboBox categoriesFor: #stbSaveOn:!binary filing!public! !

!EmbeddedComboBox class methodsFor!

stbConvertFrom: anSTBClassFormat 
	"Convert from version 9. Version 10 adds cellRect inst var"

	^[:data | 
	| newInstance |
	newInstance := self basicNew.
	1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
	newInstance cellRect: nil.
	newInstance]!

stbVersion

	^10! !
!EmbeddedComboBox class categoriesFor: #stbConvertFrom:!public! !
!EmbeddedComboBox class categoriesFor: #stbVersion!public! !

