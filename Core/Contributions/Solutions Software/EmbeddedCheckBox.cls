"Filed out from Dolphin Smalltalk X6.1"!

EmulatedCheckBox subclass: #EmbeddedCheckBox
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmbeddedCheckBox guid: (GUID fromString: '{99DEC189-99A2-4781-9681-FC04AE58678D}')!
EmbeddedCheckBox comment: ''!
!EmbeddedCheckBox categoriesForClass!Unclassified! !
!EmbeddedCheckBox methodsFor!

createEmbeddedIn: aView

	interactor := presenter := self.
	flags := 0.

	self 
		isManaged: true;
		initializeModel;
		parentView: aView;
		create;
		font: aView font.

	(aView hasFullRowSelect and: [aView showsSelAlways]) ifTrue: [self backcolor: Color face3d]!

display: aValue in: aRectangle on: aCanvas forecolor: fcolor backcolor: bcolor

	self 
		draw: aValue transition: false 
		in: aRectangle on: aCanvas 
		forecolor: fcolor backcolor: bcolor 
		focus: false highlight: false
!

displayOnFormats

	^#(#class)!

isDisplayOwnerDrawn

	^true!

isHighlighted

	"Override to always highlight when hasFocus"

	^self hasFocus or: [super isHighlighted]!

onCursoredLeft

	"The receiver has been entered by a cursor left action"

	^self!

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
		key = VK_RIGHT ifTrue: [action := MessageSend receiver: self parentView selector: #fieldExitNextTabbed: arguments: #(false)].
		key = VK_LEFT ifTrue: [action := MessageSend receiver: self parentView selector: #fieldExitPrevTabbed: arguments: #(false)].
		key = VK_UP ifTrue: [action := MessageSend receiver: self parentView selector: #fieldExitUp].
		key = VK_DOWN ifTrue: [action := MessageSend receiver: self parentView selector: #fieldExitDown].
		action notNil ifTrue:
			[SessionManager inputState queueDeferredAction: action.
			^true]].

	^super preTranslateKeyboardInput: aMSG!

showIn: aRectangle

	self
		position: (aRectangle topLeft+(1@1));
		height: (aRectangle height - 2);
		width: (aRectangle width - 2);
		show!

stbSaveOn: anSTBOutFiler

	"If the receiver is unrealized (i.e. just exists in the spec of a column in the view composer),
	save as a plain object"

	handle isNil 
		ifTrue: [anSTBOutFiler saveObject: self]
		ifFalse: [super stbSaveOn: anSTBOutFiler]! !
!EmbeddedCheckBox categoriesFor: #createEmbeddedIn:!initialize/release!public! !
!EmbeddedCheckBox categoriesFor: #display:in:on:forecolor:backcolor:!displaying!public! !
!EmbeddedCheckBox categoriesFor: #displayOnFormats!binary filing!public! !
!EmbeddedCheckBox categoriesFor: #isDisplayOwnerDrawn!public!testing! !
!EmbeddedCheckBox categoriesFor: #isHighlighted!displaying!public! !
!EmbeddedCheckBox categoriesFor: #onCursoredLeft!event handling!public! !
!EmbeddedCheckBox categoriesFor: #onKillFocus!event handling!public! !
!EmbeddedCheckBox categoriesFor: #onRequestDeactivate!event handling!public! !
!EmbeddedCheckBox categoriesFor: #preTranslateKeyboardInput:!event handling!public! !
!EmbeddedCheckBox categoriesFor: #showIn:!displaying!public! !
!EmbeddedCheckBox categoriesFor: #stbSaveOn:!binary filing!public! !

