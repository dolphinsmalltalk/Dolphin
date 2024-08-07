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
	validater := aMonadicValuable! !

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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog 518 #{Graphics.Point} 501 701 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 1 518 #{Core.Association} 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 352 nil nil nil 5 nil nil nil 352 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 193 384 8 '' 352 3 8 #() 130 193 193 nil 27 1 true 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 18 #{UI.ComboBox} 50 17 nil 32 50 2 8 1144063489 1025 720 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 720 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 401 450 50 1 498 #createWindow: 50 1 546 578 8 #[7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 193 752 8 '' 720 3 8 #() 130 193 193 nil 27 8 'choices' 518 #{Graphics.Rectangle} 130 15 15 130 17 15 nil nil nil nil 1 nil nil nil 130 501 311 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 450 50 2 498 #createWindow: 50 1 518 #{UI.CreateDialog} 1154 130 7679 21 130 8199 731 193 32 498 #setWindowText: 50 1 8 'Choose one of:' 32 1 50 2 720 352 130 193 193 nil 29)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog 518 #{Graphics.Point} 501 701 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 193 304 8 '' 272 3 8 #() 130 193 193 nil 27 nil nil 18 #{UI.ListBox} 50 17 nil 32 50 2 8 1144062209 1025 592 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 592 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() nil 370 50 1 418 #createWindow: 50 1 466 498 8 #[7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 193 624 8 '' 592 3 8 #() 130 193 193 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 592 8 'choices' 518 #{Graphics.Rectangle} 130 15 15 130 17 15 nil nil nil nil 1 nil nil nil 130 501 311 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 370 50 2 418 #createWindow: 50 1 518 #{UI.CreateDialog} 1074 130 7679 21 130 8199 731 193 32 418 #setWindowText: 50 1 8 'Choose one of:' 32 1 50 2 592 272 130 193 193 nil 29)!

resource_Extensible_choice_prompter
	"Answer the literal data from which the 'Extensible choice prompter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Extensible_choice_prompter)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog 518 #{Graphics.Point} 501 701 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 6 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 416 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 416 nil nil 1350 4 #{UI.CommandDescription} #newChoice 8 '&New…' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[5 0 0 0 10 0 0 0 75 0 0 0 35 0 0 0] 193 448 8 '&New…' 416 610 #isEnabled: 8 #(false) 416 3 8 #() 130 193 193 nil 29 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 11 850 #fixedViewLeft 141 850 #fixedViewBottom -49 850 #fixedParentBottom 1 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 928 nil 496 nil 5 nil nil nil 928 nil nil 514 #ok 8 'OK' 1 1 nil nil true nil nil nil 562 50 2 610 #createWindow: 50 1 658 690 8 #[84 0 0 0 10 0 0 0 154 0 0 0 35 0 0 0] 193 960 8 'OK' 928 610 #isEnabled: 8 #(false) 928 3 8 #() 130 193 193 nil 29 818 850 #fixedViewRight -139 850 #fixedParentRight -149 896 -49 912 1 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 1264 nil 496 nil 5 nil nil nil 1264 nil nil 514 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 562 50 1 610 #createWindow: 50 1 658 690 8 #[159 0 0 0 10 0 0 0 229 0 0 0 35 0 0 0] 193 1296 8 'Cancel' 1264 3 8 #() 130 193 193 nil 29 818 1232 -139 1248 1 896 -49 912 1 550 #{Core.IdentityDictionary} 0 nil 562 50 1 610 #createWindow: 50 1 658 690 8 #[7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 193 304 8 '' 272 3 50 3 416 928 1264 130 193 193 nil 27 nil nil 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140969549 1025 1728 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 496 nil 5 nil nil nil 1728 nil nil 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 1826 1 3142 5 #{UI.ListViewColumn} 8 '' 451 #left nil 1890 #<= 8 #() nil nil 1728 nil 3 nil nil #report 8 #() nil 133121 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 1728 nil nil nil nil nil nil nil nil nil 562 50 1 610 #createWindow: 50 1 658 690 8 #[7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 193 1760 8 '' 1728 3 8 #() 130 193 193 nil 35 370 1536 50 2 1728 8 'choices' 518 #{Graphics.Rectangle} 130 15 15 130 17 15 nil nil nil nil 1 nil nil nil 130 501 311 nil nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 562 50 2 610 #createWindow: 50 1 518 #{UI.CreateDialog} 2322 130 7679 21 130 8199 731 193 32 610 #setWindowText: 50 1 8 'Choose one of:' 32 1 50 2 1728 272 130 193 193 nil 29)!

resource_Extensible_multiselection_choice_prompter
	"Answer the literal data from which the 'Extensible multiselection choice prompter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Extensible_multiselection_choice_prompter)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog 518 #{Graphics.Point} 501 701 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 6 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 416 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 416 nil nil 1350 4 #{UI.CommandDescription} #newMultipleChoice 8 '&New…' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[5 0 0 0 10 0 0 0 75 0 0 0 35 0 0 0] 193 448 8 '&New…' 416 610 #isEnabled: 8 #(false) 416 3 8 #() 130 193 193 nil 29 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 11 850 #fixedViewLeft 141 850 #fixedViewBottom -49 850 #fixedParentBottom 1 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 928 nil 496 nil 5 nil nil nil 928 nil nil 514 #ok 8 'OK' 1 1 nil nil false nil nil nil 562 50 2 610 #createWindow: 50 1 658 690 8 #[84 0 0 0 10 0 0 0 154 0 0 0 35 0 0 0] 193 960 8 'OK' 928 610 #isEnabled: 8 #(false) 928 3 8 #() 130 193 193 nil 29 818 850 #fixedViewRight -139 850 #fixedParentRight -149 896 -49 912 1 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 1264 nil 496 nil 5 nil nil nil 1264 nil nil 514 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 562 50 1 610 #createWindow: 50 1 658 690 8 #[159 0 0 0 10 0 0 0 229 0 0 0 35 0 0 0] 193 1296 8 'Cancel' 1264 3 8 #() 130 193 193 nil 29 818 1232 -139 1248 1 896 -49 912 1 550 #{Core.IdentityDictionary} 0 nil 562 50 1 610 #createWindow: 50 1 658 690 8 #[7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 193 304 8 '' 272 3 50 3 416 928 1264 130 193 193 nil 27 nil nil 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140969801 1025 1728 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 496 nil 5 nil nil nil 1728 nil nil 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 1826 1 3142 5 #{UI.ListViewColumn} 8 '' 451 #left nil 1890 #<= 8 #() nil nil 1728 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 1728 nil nil nil nil nil nil nil nil nil 562 50 1 610 #createWindow: 50 1 658 690 8 #[7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 193 1760 8 '' 1728 3 8 #() 130 193 193 nil 35 370 1536 50 2 1728 8 'choices' 518 #{Graphics.Rectangle} 130 15 15 130 17 15 nil nil nil nil 1 nil nil nil 130 501 311 nil nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 562 50 2 610 #createWindow: 50 1 518 #{UI.CreateDialog} 2322 130 7679 21 130 8199 731 193 32 610 #setWindowText: 50 1 8 'Choose one or more of:' 32 1 50 2 1728 272 130 193 193 nil 29)!

resource_List_view
	"Answer the literal data from which the 'List view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_List_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog 518 #{Graphics.Point} 501 701 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 193 304 8 '' 272 3 8 #() 130 193 193 nil 27 nil nil 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140969549 1025 592 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 592 nil nil 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 690 1 3142 5 #{UI.ListViewColumn} 8 '' 451 #left nil 786 #<= 8 #() nil nil 592 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 592 nil nil nil nil nil nil nil nil nil 370 50 1 418 #createWindow: 50 1 466 498 8 #[7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 193 624 8 '' 592 3 8 #() 130 193 193 nil 35 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 592 8 'choices' 518 #{Graphics.Rectangle} 130 15 15 130 17 15 nil nil nil nil 1 nil nil nil 130 501 311 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 370 50 2 418 #createWindow: 50 1 518 #{UI.CreateDialog} 1234 130 7679 21 130 8199 731 193 32 418 #setWindowText: 50 1 8 'Choose one of:' 32 1 50 2 592 272 130 193 193 nil 29)!

resource_Multiselection_choice_prompter
	"Answer the literal data from which the 'Multiselection choice prompter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Multiselection_choice_prompter)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog 518 #{Graphics.Point} 501 701 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 193 304 8 '' 272 3 8 #() 130 193 193 nil 27 nil nil 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140969801 1025 592 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default 130 485 577 5 nil nil nil 592 nil nil 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 690 1 3142 5 #{UI.ListViewColumn} 8 '' 451 #left nil 802 #<= 8 #() nil nil 592 nil 3 nil nil #report 8 #() nil 133121 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 592 nil nil nil nil nil nil nil nil nil 370 50 1 418 #createWindow: 50 1 466 498 8 #[7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 193 624 8 '' 592 3 8 #() 130 193 193 nil 35 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 592 8 'choices' 518 #{Graphics.Rectangle} 130 15 15 130 17 15 nil nil nil nil 1 nil nil nil 130 501 311 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 370 50 2 418 #createWindow: 50 1 518 #{UI.CreateDialog} 1250 130 7679 21 130 8199 731 193 32 418 #setWindowText: 50 1 8 'Choose one or more of:' 32 1 50 2 592 272 130 193 193 nil 29)! !

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

