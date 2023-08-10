"Filed out from Dolphin Smalltalk"!

UI.ValueDialog
	subclass: #'UI.ChoicePrompter'
	instanceVariableNames: 'choicePresenter newBlock newCaption newPrompt validater newPrompterBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ChoicePrompter guid: (Core.GUID fromString: '{87b4c6a7-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ChoicePrompter comment: 'ChoicePrompter is a <valueDialogPresenter> that allows a value to be chosen from a list of alternatives. 

You can instantiate a single selection ChoicePrompter dialog using the class methods #choices:caption: or #on:choices:caption:. It is also possible to allow multiple selections by using the methods #multipleChoices:caption: and #on:multipleChoices:caption:. Each of these methods answers the model value if Ok (or nil if Cancel) is pressed. When a ChoicePrompter is being used to select multiple choices, the <valueModel> will be used to contain an Array of the selected items.

Since a ChoicePrompter is really just a dialog wrapper around a <ChoicePresenter> it presents most of the functionality of the latter in an easy to use dialog form. The initial selection of choices in the dialog will match the initial value of the model. The selections made in the choices list will not be transferred to the <valueModel> unless Ok is used to confirm the dialog. If Cancel is pressed the model will be left untouched. 

It is also possible to configure a ChoicePrompter such that new entries may be added dynamically to the list of choices. This can be done by specifying a <monadicValuable> using #newBlock:. When a #newChoice or #newMultipleChoice command is received from the view, a standard <Prompter> will be displayed and the resultant text from this will be run through the newBlock to determine the choice or choices to be added to the list. In order to enable this functionality it is necessary to explicitly specify the view as "Extensible choice prompter" or "Extensible multi-selection choice prompter", as appropriate.

Examples:

"Single Selection"
ChoicePrompter choices: #[0 1 2 3] caption: ''Please choose''. "Display it"

model := 2 asValue.
ChoicePrompter on: model choices: #[0 1 2 3] caption: ''Please choose''.
model value"Display it"

"Multiple Selection"
ChoicePrompter multipleChoices: #[0 1 2 3] caption: ''Please choose''. "Display it"

model := (Array with: 2) asValue.
ChoicePrompter on: model multipleChoices: #[0 1 2 3] caption: ''Please choose''.
model value "Display it"

Instance Variables:
	choicesPresenter	<ChoicePresenter> used to make a selection from range of choices.
	newBlock		<monadicValuable> which is evaluated with a string argument to create a new choice.
	newCaption	<readableString> holding the caption to use when prompting for a new choice.
	newPrompt	<readableString> holding the prompt text to use when prompting for a new choice.




'!
!UI.ChoicePrompter categoriesForClass!MVP-Presenters! !
!UI.ChoicePrompter methodsFor!

choices: aSequenceableCollection
	"Private - Sets the choices to be aSequenceableCollection"

	choicePresenter choices: aSequenceableCollection.!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	choicePresenter := self add: ChoicePresenter new name: 'choices'!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring.
	choicePresenter when: #actionPerformed send: #ok to: self.!

getImageBlock: monad
	"Set the <monadicValuable> used to extract an image from the choices in
	the receiver for display in the choice list."

	choicePresenter view getImageBlock: monad!

getTextBlock: monad
	"Set the <monadicValuable> used to extract text from the choices in
	the receiver for display in the choice list to the argument.
	The default 'block' sends #displayString to the objects, which is satisfactory 
	for many uses, but this message allows the same prompter view 
	to be used in a wider range of circumstances. "

	choicePresenter view getTextBlock: monad!

imageManager: anImageManager
	"Set the <ImageManager> to be used to manage any images displayed in the
	receiver."

	choicePresenter view imageManager: anImageManager!

initialize
	"Private - Initialize the receiver"

	super initialize.
	newBlock := [:each | each yourself].
	newPrompt := 'New name:'.
	newCaption := 'New…'.
	newPrompterBlock := [:newModel | Prompter
				createOn: newModel asValue
				prompt: self newPrompt
				caption: self newCaption].!

model: aSubjectModel
	"Connect the receiver to aSubjectModel. The choice presenter shares this
	same model since it is responsible for editing its value"

	super model: aSubjectModel.	
	choicePresenter model: self model.!

newBlock: monadicValuable
	"Set the <monadicValuable> to be evaluated against the string
	entered by the user to create a new choice to the argument."

	newBlock := monadicValuable!

newCaption
	"Answer the value of the receiver's 'newCaption' instance variable."

	^newCaption!

newCaption: anObject
	"Set the value of the receiver's 'newCaption' instance variable to the argument, anObject."

	newCaption := anObject!

newChoice
	"New command has been issued. Create a new choice by prompting the user for
	its name."

	(self promptForNewNamed: choicePresenter value)
		ifNotNil: 
			[:new |
			(choicePresenter viewModel includes: new) ifFalse: [choicePresenter viewModel add: new].
			self value: new]!

newMultipleChoice
	"New command has been issued for a multi-selection prompter. 
	Create a new choice by prompting the user for its name."

	| default |
	default := choicePresenter value.
	(self promptForNewNamed: (default isEmpty ifFalse: [default first]))
		ifNotNil: 
			[:new |
			(choicePresenter viewModel includes: new) ifFalse: [choicePresenter viewModel add: new].
			choicePresenter view addSelections: {new}]!

newPrompt
	"Answer the value of the receiver's 'newPrompt' instance variable."

	^newPrompt!

newPrompt: aString
	newPrompt := aString!

newPrompterBlock: aMonadicValuable
	newPrompterBlock := aMonadicValuable!

nilChoice: anObject
	"Sets the choice that can be used to represent a nil value in the model"

	choicePresenter nilChoice: anObject!

promptForNewNamed: anObject
	| newPrompter |
	newPrompter := newPrompterBlock value: anObject.
	self validater ifNotNil: [:v | newPrompter validater: v].
	^newPrompter showModal ifNotNil: [:chosenName | newBlock value: chosenName]!

validater
	^validater!

validater: aMonadicValuable
	validater := aMonadicValuable!

validationBlock: aMonadicValuable
	self validater: [:response | ValidationResult value: (aMonadicValuable value: response)]! !
!UI.ChoicePrompter categoriesForMethods!
choices:!accessing!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
getImageBlock:!accessing!public! !
getTextBlock:!accessing!public! !
imageManager:!accessing!public! !
initialize!initializing!private! !
model:!accessing!public! !
newBlock:!accessing!public! !
newCaption!accessing!public! !
newCaption:!accessing!public! !
newChoice!commands!public! !
newMultipleChoice!commands!public! !
newPrompt!accessing!public! !
newPrompt:!accessing!public! !
newPrompterBlock:!accessing!public! !
nilChoice:!accessing!public! !
promptForNewNamed:!helpers!private! !
validater!accessing!public! !
validater:!accessing!public! !
validationBlock:!accessing!public! !
!

!UI.ChoicePrompter class methodsFor!

choices: aSequenceableCollection
	"Shows a dialog to allow the user to choose from aSequenceableCollection.
	The dialog is given a default caption.

	Answer the choice made or nil if the dialog is cancelled"

	^self choices: aSequenceableCollection caption: nil.
!

choices: aSequenceableCollection caption: aStringCaptionOrNil
	"Shows a dialog to allow the user to choose from aSequenceableCollection.
	The dialog is given a caption according to aStringCaptionOrNil. If nil then
	the default caption is used.

	Answer the choice made or nil if the dialog is cancelled"

	| select |
	select := aSequenceableCollection notEmpty ifTrue: [aSequenceableCollection first].
	^self on: select asValue choices: aSequenceableCollection caption: aStringCaptionOrNil
!

create: viewName on: aValueModel choices: aSequenceableCollection caption: aStringCaptionOrNil
	"Answer a dialog capable of allowing the user to choose from aSequenceableCollection.
	The initial list selection is determined by the value of aValueModel and the
	list choice made is sent back as this model's value. The dialog is given a caption
	according to aStringCaptionOrNil. If nil the default caption is used."

	| prompter |
	(prompter := self create: viewName)
		choices: aSequenceableCollection;
		model: aValueModel.
	aStringCaptionOrNil notNil ifTrue: [
		prompter caption: aStringCaptionOrNil ].
	^prompter!

create: viewName on: aValueModel multipleChoices: aSequenceableCollection caption: aStringCaptionOrNil
	"Answer a new instance of a dialog that allows the user to choose multiple items from 
	aSequenceableCollection when shown. The initial list selection is determined by the value 
	of aValueModel and the list choice made is sent back as this model's value. The dialog is 
	given a caption according to aStringCaptionOrNil. If nil then the default caption is used."

	| prompter |
	(prompter := self create: viewName)
		choices: aSequenceableCollection;
		model: aValueModel.
	aStringCaptionOrNil notNil ifTrue: [
		prompter caption: aStringCaptionOrNil ].
	^prompter!

createOn: aValueModel choices: aSequenceableCollection caption: aStringCaptionOrNil
	"Answer a new instance of the receiver that when shown allows the user to 
	make a single choice from aSequenceableCollection."

	^self 
		create: self defaultView
		on: aValueModel
		choices: aSequenceableCollection 
		caption: aStringCaptionOrNil!

createOn: aValueModel multipleChoices: aSequenceableCollection caption: aStringCaptionOrNil 
	"Answer a new instance of a dialog that allows the user to choose multiple items from 
	aSequenceableCollection when shown. The initial list selection is determined by the value 
	of aValueModel and the list choice made is sent back as this model's value. The dialog is 
	given a caption according to aStringCaptionOrNil. If nil then the default caption is used.
	The default multiple choice view is used."

	^self 
		create: self defaultMultipleChoiceView
		on: aValueModel
		multipleChoices: aSequenceableCollection
		caption: aStringCaptionOrNil!

defaultAdditionalAccelerators
	^#(#(#selectAll 'Ctrl+A'))!

defaultMultipleChoiceView
	^'Multiselection choice prompter'.!

defaultView
	^'List view'!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon fromId: '!!APPLICATION'

!

multipleChoices: aSequenceableCollection
	"Shows a dialog to allow the user to choose multiple items from aSequenceableCollection.
	The dialog is given a default caption.

	Answer the choice(s) made or nil if the dialog is cancelled"

	^self multipleChoices: aSequenceableCollection caption: nil
!

multipleChoices: aSequenceableCollection caption: aStringCaptionOrNil
	"Shows a dialog to allow the user to choose multiple items from aSequenceableCollection.
	The dialog is given a caption according to aStringCaptionOrNil. If nil then
	the default caption is used.

	Answer the choice(s) made or nil if the dialog is cancelled"

	^self 
		on: OrderedCollection new asValue 
		multipleChoices: aSequenceableCollection 
		caption: aStringCaptionOrNil!

on: aValueModel choices: aSequenceableCollection caption: aStringCaptionOrNil
	"Shows a dialog to allow the user to choose from aSequenceableCollection.
	See #create:on:choices:caption: for configuration details. Answer the choice made 
	or nil if the dialog is cancelled"

	^(self 
		createOn: aValueModel
		choices: aSequenceableCollection 
		caption: aStringCaptionOrNil) showModal!

on: aValueModel multipleChoices: aSequenceableCollection caption: aStringCaptionOrNil
	"Shows a dialog to allow the user to choose multiple items from aSequenceableCollection.
	See #create:on:multipleChoices:caption: for further configuration details. Answer the choices made 
	or nil if the dialog is cancelled."

	^(self
		createOn: aValueModel 
		multipleChoices: aSequenceableCollection 
		caption: aStringCaptionOrNil) showModal!

resource_Combo_choice_prompter
	"Answer the literal data from which the 'Combo choice prompter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Combo_choice_prompter)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog 518 #{Graphics.Point} 501 701 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 130 193 193 nil 32 518 #{UI.ProportionalLayout} 294 #{Core.Dictionary} 1 518 #{Core.Association} 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 352 nil nil nil 7 nil nil nil 352 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 130 15 549 130 459 71 352 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 8 #() 130 193 193 nil 27 1 true 550 #{Core.IdentityDictionary} 1 18 #{UI.ComboBox} 50 17 nil 32 50 2 8 1144063489 1025 688 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 7 nil nil nil 688 nil 8 1852792128 518 #{Core.Message} #displayString 8 #() 8 #() 401 450 50 1 498 #createAt:extent: 50 2 130 15 15 130 459 535 688 578 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 640 nil 27 8 'choices' 518 #{Graphics.Rectangle} 130 15 15 130 17 15 nil nil nil nil 13949 nil nil nil 130 501 311 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 450 50 2 498 #createAt:extent: 50 2 130 6143 21 130 521 711 32 498 #text: 50 1 8 'Choose one of:' 32 578 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 3 13 0 0 109 1 0 0] 50 2 688 352 640 nil 27)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog 518 #{Graphics.Point} 501 701 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 130 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 288 nil nil nil 7 nil nil nil 288 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 130 15 549 130 459 71 288 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 8 #() 130 193 193 nil 27 nil nil 18 #{UI.ListBox} 50 17 nil 32 50 2 8 1144062209 1025 592 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 7 nil nil nil 592 nil 8 1853043568 518 #{Core.Message} #displayString 8 #() 8 #() nil 386 50 2 434 #createAt:extent: 50 2 130 15 15 130 459 535 592 434 #horizontalExtent: 8 #(0) 592 514 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 576 nil 27 550 #{Core.IdentityDictionary} 1 592 8 'choices' 518 #{Graphics.Rectangle} 130 15 15 130 17 15 nil nil nil nil 13917 nil nil nil 130 501 311 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 386 50 2 434 #createAt:extent: 50 2 130 6143 21 130 521 711 32 434 #text: 50 1 8 'Choose one of:' 32 514 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 3 13 0 0 109 1 0 0] 50 2 592 288 576 nil 27)!

resource_Extensible_choice_prompter
	"Answer the literal data from which the 'Extensible choice prompter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Extensible_choice_prompter)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog 518 #{Graphics.Point} 501 701 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 130 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 288 nil nil nil 7 nil nil nil 288 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 3 18 #{UI.PushButton} 50 20 nil 288 50 2 8 1140924416 1 416 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 416 nil 8 1853182784 1350 4 #{UI.CommandDescription} #newChoice 8 '&New…' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 3 774 #{Core.MessageSend} #createAt:extent: 50 2 130 11 21 130 141 51 416 626 #isEnabled: 8 #(false) 416 626 #text: 50 1 8 '&New…' 416 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 75 0 0 0 35 0 0 0] 8 #() 130 193 193 nil 29 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 11 898 #fixedViewLeft 141 898 #fixedViewBottom -49 898 #fixedParentBottom 1 18 #{UI.PushButton} 50 20 nil 288 50 2 8 1140924416 1 976 nil 496 nil 7 nil nil nil 976 nil 8 1853182784 530 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 578 50 2 626 #createAt:extent: 50 2 130 319 21 130 141 51 976 626 #text: 50 1 8 'Cancel' 976 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 159 0 0 0 10 0 0 0 229 0 0 0 35 0 0 0] 8 #() 848 nil 29 866 898 #fixedViewRight -139 898 #fixedParentRight 1 944 -49 960 1 18 #{UI.PushButton} 50 20 nil 288 50 2 8 1140924416 1 1328 nil 496 nil 7 nil nil nil 1328 nil 8 1853182784 530 #ok 8 'OK' 1 1 nil nil true nil nil nil 578 50 3 626 #createAt:extent: 50 2 130 169 21 130 141 51 1328 626 #isEnabled: 8 #(false) 1328 626 #text: 50 1 8 'OK' 1328 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 84 0 0 0 10 0 0 0 154 0 0 0 35 0 0 0] 8 #() 848 nil 29 866 1296 -139 1312 -149 944 -49 960 1 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 130 1 1 130 1 1 578 50 1 626 #createAt:extent: 50 2 130 15 549 130 459 71 288 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 50 3 416 1328 976 848 nil 27 nil nil 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140969549 1025 1920 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 496 nil 7 nil nil nil 1920 nil 8 1853243664 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 2018 1 3142 5 #{UI.ListViewColumn} 8 '' 451 #left nil 2098 #<= 8 #() nil nil 1920 nil 3 nil nil #report 8 #() nil 133121 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 578 50 1 626 #createAt:extent: 50 2 130 15 15 130 459 535 1920 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 848 nil 35 1682 1 1920 8 'choices' 1714 130 15 15 130 17 15 nil nil nil nil 13925 nil nil nil 130 501 311 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 578 50 2 626 #createAt:extent: 50 2 130 6143 21 130 521 711 32 626 #text: 50 1 8 'Choose one of:' 32 786 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 3 13 0 0 109 1 0 0] 50 2 1920 288 848 nil 27)!

resource_Extensible_multiselection_choice_prompter
	"Answer the literal data from which the 'Extensible multiselection choice prompter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Extensible_multiselection_choice_prompter)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog 518 #{Graphics.Point} 501 701 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 130 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 288 nil nil nil 7 nil nil nil 288 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 3 18 #{UI.PushButton} 50 20 nil 288 50 2 8 1140924416 1 416 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 416 nil 8 1853182784 1350 4 #{UI.CommandDescription} #ok 8 'OK' 1 1 nil nil true nil nil nil 262 #{Core.MessageSequence} 50 3 774 #{Core.MessageSend} #createAt:extent: 50 2 130 169 21 130 141 51 416 626 #isEnabled: 8 #(false) 416 626 #text: 50 1 8 'OK' 416 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 84 0 0 0 10 0 0 0 154 0 0 0 35 0 0 0] 8 #() 130 193 193 nil 29 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedViewRight -139 898 #fixedParentRight -149 898 #fixedViewBottom -49 898 #fixedParentBottom 1 18 #{UI.PushButton} 50 20 nil 288 50 2 8 1140924416 1 976 nil 496 nil 7 nil nil nil 976 nil 8 1853182784 530 #newMultipleChoice 8 '&New…' 1 1 nil nil false nil nil nil 578 50 3 626 #createAt:extent: 50 2 130 11 21 130 141 51 976 626 #isEnabled: 8 #(false) 976 626 #text: 50 1 8 '&New…' 976 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 75 0 0 0 35 0 0 0] 8 #() 848 nil 29 866 898 #fixedParentLeft 11 898 #fixedViewLeft 141 944 -49 960 1 18 #{UI.PushButton} 50 20 nil 288 50 2 8 1140924416 1 1360 nil 496 nil 7 nil nil nil 1360 nil 8 1853182784 530 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 578 50 2 626 #createAt:extent: 50 2 130 319 21 130 141 51 1360 626 #text: 50 1 8 'Cancel' 1360 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 159 0 0 0 10 0 0 0 229 0 0 0 35 0 0 0] 8 #() 848 nil 29 866 912 -139 928 1 944 -49 960 1 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 130 1 1 130 1 1 578 50 1 626 #createAt:extent: 50 2 130 15 549 130 459 71 288 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 50 3 976 416 1360 848 nil 27 nil nil 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140969801 1025 1920 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 496 nil 7 nil nil nil 1920 nil 8 1853243664 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 2018 1 3142 5 #{UI.ListViewColumn} 8 '' 451 #left nil 2098 #<= 8 #() nil nil 1920 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 578 50 1 626 #createAt:extent: 50 2 130 15 15 130 459 535 1920 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 848 nil 35 1682 1 1920 8 'choices' 1714 130 15 15 130 17 15 nil nil nil nil 13933 nil nil nil 130 501 311 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 578 50 2 626 #createAt:extent: 50 2 130 6143 21 130 521 711 32 626 #text: 50 1 8 'Choose one or more of:' 32 786 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 3 13 0 0 109 1 0 0] 50 2 1920 288 848 nil 27)!

resource_List_view
	"Answer the literal data from which the 'List view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_List_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog 518 #{Graphics.Point} 501 701 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 130 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 288 nil nil nil 7 nil nil nil 288 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 130 15 549 130 459 71 288 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 8 #() 130 193 193 nil 27 nil nil 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140969549 1025 592 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 7 nil nil nil 592 nil 8 1853243664 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 690 1 3142 5 #{UI.ListViewColumn} 8 '' 451 #left nil 802 #<= 8 #() nil nil 592 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 386 50 1 434 #createAt:extent: 50 2 130 15 15 130 459 535 592 514 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 576 nil 35 550 #{Core.IdentityDictionary} 1 592 8 'choices' 518 #{Graphics.Rectangle} 130 15 15 130 17 15 nil nil nil nil 13941 nil nil nil 130 501 311 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 386 50 2 434 #createAt:extent: 50 2 130 6143 21 130 521 711 32 434 #text: 50 1 8 'Choose one of:' 32 514 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 3 13 0 0 109 1 0 0] 50 2 592 288 576 nil 27)!

resource_Multiselection_choice_prompter
	"Answer the literal data from which the 'Multiselection choice prompter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Multiselection_choice_prompter)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog 518 #{Graphics.Point} 501 701 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 130 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 288 nil nil nil 7 nil nil nil 288 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 130 15 549 130 459 71 288 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 8 #() 130 193 193 nil 27 nil nil 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140969801 1025 592 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default 130 485 577 7 nil nil nil 592 nil 8 1853243664 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 690 1 3142 5 #{UI.ListViewColumn} 8 '' 451 #left nil 818 #<= 8 #() nil nil 592 nil 3 nil nil #report 8 #() nil 133121 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 386 50 1 434 #createAt:extent: 50 2 130 15 15 130 459 535 592 514 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 576 nil 35 550 #{Core.IdentityDictionary} 1 592 8 'choices' 518 #{Graphics.Rectangle} 130 15 15 130 17 15 nil nil nil nil 13909 nil nil nil 130 501 311 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 386 50 2 434 #createAt:extent: 50 2 130 6143 21 130 521 711 32 434 #text: 50 1 8 'Choose one or more of:' 32 514 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 3 13 0 0 109 1 0 0] 50 2 592 288 576 nil 27)! !
!UI.ChoicePrompter class categoriesForMethods!
choices:!instance creation!public! !
choices:caption:!instance creation!public! !
create:on:choices:caption:!instance creation!public! !
create:on:multipleChoices:caption:!instance creation!public! !
createOn:choices:caption:!instance creation!public! !
createOn:multipleChoices:caption:!instance creation!public! !
defaultAdditionalAccelerators!constants!private! !
defaultMultipleChoiceView!constants!private! !
defaultView!constants!private! !
icon!constants!public! !
multipleChoices:!instance creation!public! !
multipleChoices:caption:!instance creation!public! !
on:choices:caption:!instance creation!public! !
on:multipleChoices:caption:!instance creation!public! !
resource_Combo_choice_prompter!public!resources-views! !
resource_Default_view!public!resources-views! !
resource_Extensible_choice_prompter!public!resources-views! !
resource_Extensible_multiselection_choice_prompter!public!resources-views! !
resource_List_view!public!resources-views! !
resource_Multiselection_choice_prompter!public!resources-views! !
!

