"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'UI.RadioButtonSetPresenter'
	instanceVariableNames: 'ownedRadioButtons'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.RadioButtonSetPresenter guid: (Core.GUID fromString: '{40498d60-542d-11d3-998b-d5ca2c3c1d61}')!

UI.RadioButtonSetPresenter comment: 'RadioButtonSetPresenter is a <valuePresenter> that displays a <valueModel> onto a <Symbol>, where the symbol is the name of the selected <RadioButton> in the set. A RadioButtonSetPresenter expects to be connected to a container view, the child views of which are <RadioButton>s. 
Only a single <RadioButton> in the set can be selected at any time. When the radio button selection in the set changes (e.g. as a result of user selection), the associated <valueModel> is updated and hence generates a #valueChanged event.

RadioButtonSetPresenter is based on a contribution from Ian Bartholomew.'!

!UI.RadioButtonSetPresenter categoriesForClass!MVP-Presenters!MVP-Resources-Containers! !

!UI.RadioButtonSetPresenter methodsFor!

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

	^self radioButtons detect: [:each | each name = aSymbol] ifNone: nil!

radioButtons
	"Private - Answer a collection of the immediate sub views of the receiver that admit to
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

!UI.RadioButtonSetPresenter categoriesForMethods!
createSchematicWiring!initializing!public! !
disable:!public!states-changing! !
disableAll!public!states-changing! !
dragOver:!event handling!public! !
enable:!public!states-changing! !
enableAll!public!states-changing! !
onRadioButtonSelection:!event handling!private! !
onValueChanged!event handling!private! !
onViewOpened!public! !
radioButtonNamed:!enquiries!public! !
radioButtons!accessing!private! !
!

!UI.RadioButtonSetPresenter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 32 1030 #{UI.GridLayout} 1 3 1 1 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 6 18 #{UI.RadioButton} 50 16 nil 32 50 2 8 1141055497 1 224 1094 2 #{UI.ValueHolder} nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 354 #hash 8 #() false 128 nil 517 nil nil nil 224 nil nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[0 0 0 0 0 0 0 0 90 0 0 0 32 0 0 0] 193 256 8 'Option 1' 224 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 8 'option1' 18 #{UI.RadioButton} 50 16 nil 32 50 2 8 1140924425 1 720 290 nil nil 322 354 #= 8 #() 354 #hash 8 #() false 128 nil 517 nil nil nil 720 nil nil 434 nil nil nil 466 50 1 514 #createWindow: 50 1 562 594 8 #[0 0 0 0 32 0 0 0 90 0 0 0 63 0 0 0] 193 752 8 'Option 2' 720 3 8 #() 674 193 193 nil 27 8 'option2' 18 #{UI.RadioButton} 50 16 nil 32 50 2 8 1140924425 1 1072 290 nil nil 322 354 #= 8 #() 354 #hash 8 #() false 128 nil 517 nil nil nil 1072 nil nil 434 nil nil nil 466 50 1 514 #createWindow: 50 1 562 594 8 #[0 0 0 0 63 0 0 0 90 0 0 0 95 0 0 0] 193 1104 8 'Option 3' 1072 3 8 #() 674 193 193 nil 27 8 'option3' nil 466 50 1 514 #createWindow: 50 1 562 594 8 #[255 14 0 0 10 0 0 0 89 15 0 0 105 0 0 0] 193 80 8 '' 32 1 50 3 224 720 1072 674 193 193 nil 27)! !

!UI.RadioButtonSetPresenter class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

