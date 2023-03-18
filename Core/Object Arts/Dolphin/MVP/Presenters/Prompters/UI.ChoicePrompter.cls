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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog 918022 #{Graphics.Point} 501 701 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 1376774 #{UI.ProportionalLayout} 138 #{Core.Dictionary} 34 1 1049094 #{Core.Association} 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 720 nil nil nil 7 nil nil nil 720 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 498 15 549 498 459 71 720 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 8 #() 498 193 193 nil 27 1 true 170 192 34 2 410 #{UI.ComboBox} 34 17 nil 416 34 2 8 1144063489 1025 1056 787270 2 #{UI.ListModel} 138 144 992 nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 7 nil nil nil 1056 nil 8 1814646992 786950 #{Core.Message} #displayString 8 #() 8 #() 401 818 34 1 866 #createAt:extent: 34 2 498 15 15 498 459 535 1056 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 1008 nil 27 8 'choices' 1180166 #{Graphics.Rectangle} 498 15 15 498 17 15 nil nil nil nil 56277 nil nil nil 498 501 311 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 818 34 2 866 #createAt:extent: 34 2 498 12287 21 498 521 711 416 866 #text: 34 1 8 'Choose one of:' 416 946 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 3 25 0 0 109 1 0 0] 34 2 1056 720 1008 nil 27)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog 918022 #{Graphics.Point} 501 701 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 498 15 549 498 459 71 656 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 8 #() 498 193 193 nil 27 nil nil 410 #{UI.ListBox} 34 17 nil 416 34 2 8 1144062209 1025 960 787270 2 #{UI.ListModel} 138 144 928 nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 7 nil nil nil 960 nil 8 1814640640 786950 #{Core.Message} #displayString 8 #() 8 #() nil 754 34 2 802 #createAt:extent: 34 2 498 15 15 498 459 535 960 802 #horizontalExtent: 8 #(0) 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 944 nil 27 170 192 34 2 960 8 'choices' 1180166 #{Graphics.Rectangle} 498 15 15 498 17 15 nil nil nil nil 63721 nil nil nil 498 501 311 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 754 34 2 802 #createAt:extent: 34 2 498 12287 21 498 521 711 416 802 #text: 34 1 8 'Choose one of:' 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 3 25 0 0 109 1 0 0] 34 2 960 656 944 nil 27)!

resource_Extensible_choice_prompter
	"Answer the literal data from which the 'Extensible choice prompter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Extensible_choice_prompter)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog 918022 #{Graphics.Point} 501 701 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 1048838 #{UI.FramingLayout} 170 176 34 6 410 #{UI.PushButton} 34 20 nil 656 34 2 8 1140924416 1 784 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 784 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #newChoice 8 '&New…' 1 1 nil nil false nil nil nil 1310982 #{Core.MessageSequence} 34 3 1049350 #{Core.MessageSend} #createAt:extent: 34 2 498 11 21 498 141 51 784 994 #isEnabled: 8 #(false) 784 994 #text: 34 1 8 '&New…' 784 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 75 0 0 0 35 0 0 0] 8 #() 498 193 193 nil 29 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 11 1266 #fixedViewLeft 141 1266 #fixedViewBottom -49 1266 #fixedParentBottom 1 410 #{UI.PushButton} 34 20 nil 656 34 2 8 1140924416 1 1344 nil 864 nil 7 nil nil nil 1344 nil 8 1815097472 898 #ok 8 'OK' 1 1 nil nil true nil nil nil 946 34 3 994 #createAt:extent: 34 2 498 169 21 498 141 51 1344 994 #isEnabled: 8 #(false) 1344 994 #text: 34 1 8 'OK' 1344 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 84 0 0 0 10 0 0 0 154 0 0 0 35 0 0 0] 8 #() 1216 nil 29 1234 1266 #fixedViewRight -139 1266 #fixedParentRight -149 1312 -49 1328 1 410 #{UI.PushButton} 34 20 nil 656 34 2 8 1140924416 1 1728 nil 864 nil 7 nil nil nil 1728 nil 8 1815097472 898 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 946 34 2 994 #createAt:extent: 34 2 498 319 21 498 141 51 1728 994 #text: 34 1 8 'Cancel' 1728 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 159 0 0 0 10 0 0 0 229 0 0 0 35 0 0 0] 8 #() 1216 nil 29 1234 1696 -139 1712 1 1312 -49 1328 1 170 192 8 #() 1180166 #{Graphics.Rectangle} 498 1 1 498 1 1 946 34 1 994 #createAt:extent: 34 2 498 15 549 498 459 71 656 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 34 3 784 1344 1728 1216 nil 27 nil nil 410 #{UI.ListView} 34 45 nil 416 34 2 8 1140969549 1025 2288 787270 2 #{UI.ListModel} 138 144 2064 nil 1769478 #{Kernel.IdentitySearchPolicy} 864 nil 7 nil nil nil 2288 nil 8 1815049392 786950 #{Core.Message} #displayString 8 #() nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 '' 451 #left nil 2450 #<= 8 #() nil nil 2288 nil 3 nil nil #report 8 #() nil 133121 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 946 34 1 994 #createAt:extent: 34 2 498 15 15 498 459 535 2288 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 1216 nil 35 170 192 34 2 2288 8 'choices' 2082 498 15 15 498 17 15 nil nil nil nil 69781 nil nil nil 498 501 311 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 946 34 2 994 #createAt:extent: 34 2 498 12287 21 498 521 711 416 994 #text: 34 1 8 'Choose one of:' 416 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 3 25 0 0 109 1 0 0] 34 2 2288 656 1216 nil 27)!

resource_Extensible_multiselection_choice_prompter
	"Answer the literal data from which the 'Extensible multiselection choice prompter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Extensible_multiselection_choice_prompter)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog 918022 #{Graphics.Point} 501 701 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 1048838 #{UI.FramingLayout} 170 176 34 6 410 #{UI.PushButton} 34 20 nil 656 34 2 8 1140924416 1 784 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 784 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 498 319 21 498 141 51 784 994 #text: 34 1 8 'Cancel' 784 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 159 0 0 0 10 0 0 0 229 0 0 0 35 0 0 0] 8 #() 498 193 193 nil 29 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedViewRight -139 1234 #fixedParentRight 1 1234 #fixedViewBottom -49 1234 #fixedParentBottom 1 410 #{UI.PushButton} 34 20 nil 656 34 2 8 1140924416 1 1312 nil 864 nil 7 nil nil nil 1312 nil 8 1815097472 898 #newMultipleChoice 8 '&New…' 1 1 nil nil false nil nil nil 946 34 3 994 #createAt:extent: 34 2 498 11 21 498 141 51 1312 994 #isEnabled: 8 #(false) 1312 994 #text: 34 1 8 '&New…' 1312 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 75 0 0 0 35 0 0 0] 8 #() 1184 nil 29 1202 1234 #fixedParentLeft 11 1234 #fixedViewLeft 141 1280 -49 1296 1 410 #{UI.PushButton} 34 20 nil 656 34 2 8 1140924416 1 1696 nil 864 nil 7 nil nil nil 1696 nil 8 1815097472 898 #ok 8 'OK' 1 1 nil nil true nil nil nil 946 34 3 994 #createAt:extent: 34 2 498 169 21 498 141 51 1696 994 #isEnabled: 8 #(false) 1696 994 #text: 34 1 8 'OK' 1696 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 84 0 0 0 10 0 0 0 154 0 0 0 35 0 0 0] 8 #() 1184 nil 29 1202 1248 -139 1264 -149 1280 -49 1296 1 170 192 8 #() 1180166 #{Graphics.Rectangle} 498 1 1 498 1 1 946 34 1 994 #createAt:extent: 34 2 498 15 549 498 459 71 656 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 34 3 1312 1696 784 1184 nil 27 nil nil 410 #{UI.ListView} 34 45 nil 416 34 2 8 1140969801 1025 2288 787270 2 #{UI.ListModel} 138 144 2064 nil 1769478 #{Kernel.IdentitySearchPolicy} 864 nil 7 nil nil nil 2288 nil 8 1815049392 786950 #{Core.Message} #displayString 8 #() nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 '' 451 #left nil 2450 #<= 8 #() nil nil 2288 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 946 34 1 994 #createAt:extent: 34 2 498 15 15 498 459 535 2288 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 1184 nil 35 170 192 34 2 2288 8 'choices' 2082 498 15 15 498 17 15 nil nil nil nil 69913 nil nil nil 498 501 311 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 946 34 2 994 #createAt:extent: 34 2 498 12287 21 498 521 711 416 994 #text: 34 1 8 'Choose one or more of:' 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 3 25 0 0 109 1 0 0] 34 2 2288 656 1184 nil 27)!

resource_List_view
	"Answer the literal data from which the 'List view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_List_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog 918022 #{Graphics.Point} 501 701 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 498 15 549 498 459 71 656 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 8 #() 498 193 193 nil 27 nil nil 410 #{UI.ListView} 34 45 nil 416 34 2 8 1140969549 1025 960 787270 2 #{UI.ListModel} 138 144 928 nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 7 nil nil nil 960 nil 8 1815049392 786950 #{Core.Message} #displayString 8 #() nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 '' 451 #left nil 1154 #<= 8 #() nil nil 960 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 754 34 1 802 #createAt:extent: 34 2 498 15 15 498 459 535 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 944 nil 35 170 192 34 2 960 8 'choices' 1180166 #{Graphics.Rectangle} 498 15 15 498 17 15 nil nil nil nil 72183 nil nil nil 498 501 311 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 754 34 2 802 #createAt:extent: 34 2 498 12287 21 498 521 711 416 802 #text: 34 1 8 'Choose one of:' 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 3 25 0 0 109 1 0 0] 34 2 960 656 944 nil 27)!

resource_Multiselection_choice_prompter
	"Answer the literal data from which the 'Multiselection choice prompter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Multiselection_choice_prompter)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog 918022 #{Graphics.Point} 501 701 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 498 15 549 498 459 71 656 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 8 #() 498 193 193 nil 27 nil nil 410 #{UI.ListView} 34 45 nil 416 34 2 8 1140969801 1025 960 787270 2 #{UI.ListModel} 138 144 928 nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default 498 485 577 7 nil nil nil 960 nil 8 1815049392 786950 #{Core.Message} #displayString 8 #() nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 '' 451 #left nil 1170 #<= 8 #() nil nil 960 nil 3 nil nil #report 8 #() nil 133121 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 754 34 1 802 #createAt:extent: 34 2 498 15 15 498 459 535 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 944 nil 35 170 192 34 2 960 8 'choices' 1180166 #{Graphics.Rectangle} 498 15 15 498 17 15 nil nil nil nil 72841 nil nil nil 498 501 311 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 754 34 2 802 #createAt:extent: 34 2 498 12287 21 498 521 711 416 802 #text: 34 1 8 'Choose one or more of:' 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 3 25 0 0 109 1 0 0] 34 2 960 656 944 nil 27)! !
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

