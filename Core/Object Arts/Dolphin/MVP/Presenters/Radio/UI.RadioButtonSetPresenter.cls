"Filed out from Dolphin Smalltalk 7"!

ValuePresenter subclass: #RadioButtonSetPresenter
	instanceVariableNames: 'ownedRadioButtons'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RadioButtonSetPresenter guid: (GUID fromString: '{40498d60-542d-11d3-998b-d5ca2c3c1d61}')!
RadioButtonSetPresenter comment: 'RadioButtonSetPresenter is a <valuePresenter> that displays a <valueModel> onto a <Symbol>, where the symbol is the name of the selected <RadioButton> in the set. A RadioButtonSetPresenter expects to be connected to a container view, the child views of which are <RadioButton>s. 
Only a single <RadioButton> in the set can be selected at any time. When the radio button selection in the set changes (e.g. as a result of user selection), the associated <valueModel> is updated and hence generates a #valueChanged event.

RadioButtonSetPresenter is based on a contribution from Ian Bartholomew.'!
!RadioButtonSetPresenter categoriesForClass!MVP-Presenters!MVP-Resources-Containers! !
!RadioButtonSetPresenter methodsFor!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self radioButtons do: 
			[:each | 
			each 
				when: #actionPerformed
				send: #onRadioButtonSelection:
				to: self
				with: each]!

disable: aSymbol 
	(self radioButtonNamed: aSymbol) ifNotNil: [:arg | arg disable]!

disableAll
	self radioButtons do: [:each | each disable]!

dragOver: session 
	"The drag operation described by the <DragDropSession>. session,
	has moved to a new position over the receiver's window.
	Implementation Note: Override in order to provide drop target highlighting
	and to suggest a reasonable drop target for most cases (the item under the
	cursor)."

	| item |
	item := self view subViewFromPoint: (session dragPointInView: self view).
	session suggestedTarget: (item isNil ifFalse: [item name asSymbol]).
	super dragOver: session!

enable: aSymbol 
	"Set the state of the RadioButton named aString to enabled"

	(self radioButtonNamed: aSymbol) ifNotNil: [:arg | arg enable]!

enableAll
	self radioButtons do: [:each | each enable]!

onRadioButtonSelection: aRadioButton 
	aRadioButton value ifTrue: [self value: aRadioButton name asSymbol]!

onValueChanged
	"Private - The receiver's value has changed. Update all the radio buttons own boolean values
	to match. The receiver's own #valueChanged event will be triggered by the superclass."

	| selected |
	selected := self value ifNotNil: [:value | value asString].
	self radioButtons do: [:each | each value: each name = selected].
	super onValueChanged!

onViewOpened
	super onViewOpened.
	self onValueChanged!

radioButtonNamed: aSymbol 
	"Answer the RadioButton that is so named, or nil if none."

	^self radioButtons detect: [:each | each name = aSymbol] ifNone: []!

radioButtons
	"Private - Answer a collection of the immediate sub views of the reciever that admit to
	being RadioButtons. As only the immediate sub views are checked this allows nesting of
	RadioButtonGroups. Cache the buttons for a bit of a performance gain as they are assumed not
	to change (i.e. if you are dynamically adding and removing radio buttons, then you will need
	to subclass this presenter)."

	ownedRadioButtons 
		ifNil: 
			[self isOpen ifFalse: [^#()].
			ownedRadioButtons := self view subViews select: [:each | each isKindOf: RadioButton].
			"Because of an issue in the Windows IsDialogMessage() API, we must ensure
			that the WS_GROUP style is set on only one of the radio-buttons, otherwise
			it can go into an infinite loop."
			ownedRadioButtons keysAndValuesDo: [:i :each | each isGroupStop: i == 1]].
	^ownedRadioButtons! !
!RadioButtonSetPresenter categoriesFor: #createSchematicWiring!initializing!public! !
!RadioButtonSetPresenter categoriesFor: #disable:!public!states-changing! !
!RadioButtonSetPresenter categoriesFor: #disableAll!public!states-changing! !
!RadioButtonSetPresenter categoriesFor: #dragOver:!event handling!public! !
!RadioButtonSetPresenter categoriesFor: #enable:!public!states-changing! !
!RadioButtonSetPresenter categoriesFor: #enableAll!public!states-changing! !
!RadioButtonSetPresenter categoriesFor: #onRadioButtonSelection:!event handling!private! !
!RadioButtonSetPresenter categoriesFor: #onValueChanged!event handling!private! !
!RadioButtonSetPresenter categoriesFor: #onViewOpened!public! !
!RadioButtonSetPresenter categoriesFor: #radioButtonNamed:!enquiries!public! !
!RadioButtonSetPresenter categoriesFor: #radioButtons!accessing!private! !

!RadioButtonSetPresenter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 656390 ##(Smalltalk.GridLayout) 1 3 1 1 170 192 34 6 410 ##(Smalltalk.RadioButton) 34 16 nil 416 34 2 8 1140924425 1 576 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 706 #hash 8 #() false 496 nil 5 nil nil nil 576 nil 8 1903885040 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 127 946 181 65 576 898 #text: 34 1 8 'Option 3' 576 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 63 0 0 0 90 0 0 0 95 0 0 0] 8 #() 946 193 193 nil 27 8 'option3' 410 ##(Smalltalk.RadioButton) 34 16 nil 416 34 2 8 1141055497 1 1136 642 nil nil 674 706 #= 8 #() 706 #hash 8 #() false 496 nil 5 nil nil nil 1136 nil 8 1903885040 802 nil nil nil 834 138 144 34 2 898 #createAt:extent: 34 2 946 1 1 946 181 65 1136 898 #text: 34 1 8 'Option 1' 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 90 0 0 0 32 0 0 0] 8 #() 1104 nil 27 8 'option1' 410 ##(Smalltalk.RadioButton) 34 16 nil 416 34 2 8 1140924425 1 1552 642 nil nil 674 706 #= 8 #() 706 #hash 8 #() false 496 nil 5 nil nil nil 1552 nil 8 1903885040 802 nil nil nil 834 138 144 34 2 898 #createAt:extent: 34 2 946 1 65 946 181 63 1552 898 #text: 34 1 8 'Option 2' 1552 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 0 0 0 90 0 0 0 63 0 0 0] 8 #() 1104 nil 27 8 'option2' nil 834 138 144 34 1 898 #createAt:extent: 34 2 946 3839 21 946 181 191 416 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 217 7 0 0 105 0 0 0] 34 3 1136 1552 576 1104 nil 27 )! !
!RadioButtonSetPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

