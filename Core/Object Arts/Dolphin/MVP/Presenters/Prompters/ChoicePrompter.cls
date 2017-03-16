"Filed out from Dolphin Smalltalk 7"!

ValueDialog subclass: #ChoicePrompter
	instanceVariableNames: 'choicePresenter newBlock newCaption newPrompt'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChoicePrompter guid: (GUID fromString: '{87b4c6a7-026e-11d3-9fd7-00a0cc3e4a32}')!
ChoicePrompter comment: 'ChoicePrompter is a <valueDialogPresenter> that allows a value to be chosen from a list of alternatives. 

You can instantiate a single selection ChoicePrompter dialog using the class methods #choices:caption: or #on:choices:caption:. It is also possible to allow multiples selections by using the methods #multipleChoices:caption: and #on:multipleChoices:caption:. Each of these methods answers the model value if Ok (or nil if Cancel) is pressed. When a ChoicePrompter is being used to select multiple choices, the < valueModel> will be used to contain an Array of the selected items.

Since a ChoicePrompter is really just a dialog wrapper around a <ChoicePresenter> it presents most of the functionality of the latter in an easy to use dialog form. The initial selection of choices in the dialog will match the initial value of the model. The selections made in the choices list will not be transferred to the <valueModel> unless Ok is used confirm the dialog. If Cancel is pressed the model will be left untouched. 

It is also possible to configure a ChoicePrompter such that new entries may be added dynmaically to the list of choices. This can be done by specifying a <monadicValuable> using #newBlock:. When a #newChoice or #newMultipleChoice command is received from the view, a standard <Prompter> will be displayed and the resultant text from this will be run through the newBlock to determine the choice or choices to be added to the list. In order to enable this functionality it is necessary to explicitly specify the view as "Extensible choice prompter" or "Extensible multi-selection choice prompter", as appropriate.

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
!ChoicePrompter categoriesForClass!MVP-Presenters! !
!ChoicePrompter methodsFor!

choices: aSequenceableCollection
	"Private - Sets the choices to be aSequenceableCollection"

	choicePresenter choices: aSequenceableCollection.!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	choicePresenter := self add: ChoicePresenter new name: 'choices'.!

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
	for a many uses, but this message allows the same prompter view 
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
	newCaption := 'New...'!

model: aSubjectModel
	"Connect the receiver to aSubjectModel. The choice presenter shares this
	same model since it is responsible for editing it's value"

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

	| default chosenName new |
	default := choicePresenter value.
	default := default notNil 
				ifTrue: [choicePresenter view getTextBlock value: default]
				ifFalse: [''].
	chosenName := Prompter 
				on: default
				prompt: self newPrompt
				caption: self newCaption.
	chosenName isNil ifTrue: [^self].
	new := newBlock value: chosenName.
	"newBlock answers nil if new 'name' is not valid"
	new notNil 
		ifTrue: 
			[(choicePresenter viewModel includes: new) ifFalse: [choicePresenter viewModel add: new].
			self value: new
			"self ok"]!

newMultipleChoice
	"New command has been issued for a multi-selection prompter. 
	Create a new choice by prompting the user for	its name."

	| default chosenName new |
	default := choicePresenter value.
	default := default notEmpty 
				ifTrue: [choicePresenter view getTextBlock value: default first]
				ifFalse: [''].
	chosenName := Prompter 
				on: default
				prompt: self newPrompt
				caption: self newCaption.
	chosenName isNil ifTrue: [^self].
	new := newBlock value: chosenName.
	"newBlock answers nil if new 'name' is not valid"
	new notNil 
		ifTrue: 
			[(choicePresenter viewModel includes: new) ifFalse: [choicePresenter viewModel add: new].
			choicePresenter view addSelections: (Array with: new)]!

newPrompt
	"Answer the value of the receiver's 'newPrompt' instance variable."

	^newPrompt!

newPrompt: anObject
	"Set the value of the receiver's 'newPrompt' instance variable to the argument, anObject."

	newPrompt := anObject!

nilChoice: anObject
	"Sets the choice that can be used to represent a nil value in the model"

	choicePresenter nilChoice: anObject! !
!ChoicePrompter categoriesFor: #choices:!accessing!private! !
!ChoicePrompter categoriesFor: #createComponents!initializing!public! !
!ChoicePrompter categoriesFor: #createSchematicWiring!initializing!public! !
!ChoicePrompter categoriesFor: #getImageBlock:!accessing!public! !
!ChoicePrompter categoriesFor: #getTextBlock:!accessing!public! !
!ChoicePrompter categoriesFor: #imageManager:!accessing!public! !
!ChoicePrompter categoriesFor: #initialize!initializing!private! !
!ChoicePrompter categoriesFor: #model:!accessing!public! !
!ChoicePrompter categoriesFor: #newBlock:!accessing!public! !
!ChoicePrompter categoriesFor: #newCaption!accessing!public! !
!ChoicePrompter categoriesFor: #newCaption:!accessing!public! !
!ChoicePrompter categoriesFor: #newChoice!commands!public! !
!ChoicePrompter categoriesFor: #newMultipleChoice!commands!public! !
!ChoicePrompter categoriesFor: #newPrompt!accessing!public! !
!ChoicePrompter categoriesFor: #newPrompt:!accessing!public! !
!ChoicePrompter categoriesFor: #nilChoice:!accessing!public! !

!ChoicePrompter class methodsFor!

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
	"Answer a new instance of the receiver that when shown allows the the user to 
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
	^'Multi-selection choice prompter'!

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
	See #create:on:choices:caption: for configuration details.Answer the choice made 
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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Combo_choice_prompter)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 328198 ##(Smalltalk.Point)  501 701 167 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  202 8 ##(Smalltalk.Dictionary)  98 1 721414 ##(Smalltalk.Association)  410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 656 0 0 0 7 0 0 0 656 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 514 15 553 514 475 77 656 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 20 1 0 0 244 0 0 0 58 1 0 0] 98 0 514 193 193 0 27 1 16 234 256 98 2 410 8 ##(Smalltalk.ComboBox)  98 17 0 416 98 2 8 1144063489 1025 1072 590662 2 ##(Smalltalk.ListModel)  202 208 1008 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 0 0 0 1072 0 8 4294903803 459270 ##(Smalltalk.Message)  8 #displayString 98 0 1008 401 802 202 208 98 1 866 896 98 2 514 15 15 514 475 539 1072 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 244 0 0 0 20 1 0 0] 98 0 1024 0 27 8 'choices' 590342 ##(Smalltalk.Rectangle)  514 15 15 514 17 15 0 0 0 0 43635 0 0 0 514 501 311 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 802 202 208 98 3 866 896 98 2 514 2799 21 514 521 711 416 866 8 #text: 98 1 8 'Choose one of:' 416 866 8 #updateMenuBar 1008 416 962 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 123 6 0 0 109 1 0 0] 98 2 1072 656 1024 0 27 )!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 328198 ##(Smalltalk.Point)  501 701 167 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 576 0 0 0 7 0 0 0 576 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 514 15 559 514 475 71 576 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 23 1 0 0 244 0 0 0 58 1 0 0] 98 0 514 193 193 0 27 0 0 410 8 ##(Smalltalk.ListBox)  98 17 0 416 98 2 8 1144062209 1025 960 590662 2 ##(Smalltalk.ListModel)  202 208 928 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 0 0 0 960 0 8 4294903955 459270 ##(Smalltalk.Message)  8 #displayString 98 0 928 0 722 202 208 98 2 786 816 98 2 514 15 15 514 475 545 960 786 8 #horizontalExtent: 98 1 1 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 244 0 0 0 23 1 0 0] 98 0 944 0 27 234 256 98 2 960 8 'choices' 590342 ##(Smalltalk.Rectangle)  514 15 15 514 17 15 0 0 0 0 43765 0 0 0 514 501 311 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 722 202 208 98 3 786 816 98 2 514 2799 21 514 521 711 416 786 8 #text: 98 1 8 'Choose one of:' 416 786 8 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 123 6 0 0 109 1 0 0] 98 2 960 576 944 0 27 )!

resource_Extensible_choice_prompter
	"Answer the literal data from which the 'Extensible choice prompter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Extensible_choice_prompter)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 328198 ##(Smalltalk.Point)  501 701 167 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 576 0 482 31 0 7 0 0 0 576 852230 ##(Smalltalk.FramingLayout)  234 240 98 6 410 8 ##(Smalltalk.PushButton)  98 17 0 576 98 2 8 1140924416 1 736 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 0 0 0 736 0 8 4294903631 1180998 4 ##(Smalltalk.CommandDescription)  8 #ok 8 'OK' 1 1 0 0 16 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 514 185 21 514 141 51 736 1010 8 #isEnabled: 98 1 32 736 1010 8 #text: 98 1 8 'OK' 736 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 92 0 0 0 10 0 0 0 162 0 0 0 35 0 0 0] 98 0 514 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedViewRight -139 1330 8 #fixedParentRight -149 1330 8 #fixedViewBottom -49 1330 8 #fixedParentBottom 1 410 752 98 17 0 576 98 2 8 1140924416 1 1472 0 818 848 0 7 0 0 0 1472 0 8 4294903631 882 8 #cancel 8 'Cancel' 1 1 0 0 32 946 202 208 98 2 1010 1040 98 2 514 335 21 514 141 51 1472 1010 1168 98 1 8 'Cancel' 1472 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 167 0 0 0 10 0 0 0 237 0 0 0 35 0 0 0] 98 0 1280 0 27 1298 1344 -139 1376 1 1408 -49 1440 1 410 752 98 17 0 576 98 2 8 1140924416 1 1840 0 818 848 0 7 0 0 0 1840 0 8 4294903631 882 8 #newChoice 8 '&New...' 1 1 0 0 32 946 202 208 98 3 1010 1040 98 2 514 11 21 514 141 51 1840 1010 1120 98 1 32 1840 1010 1168 98 1 8 '&New...' 1840 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 75 0 0 0 35 0 0 0] 98 0 1280 0 27 1298 1330 8 #fixedParentLeft 11 1330 8 #fixedViewLeft 141 1408 -49 1440 1 234 256 98 0 590342 ##(Smalltalk.Rectangle)  514 1 1 514 1 1 946 202 208 98 1 1010 1040 98 2 514 15 559 514 475 71 576 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 23 1 0 0 244 0 0 0 58 1 0 0] 98 3 1840 736 1472 1280 0 27 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140969549 1025 2560 590662 2 ##(Smalltalk.ListModel)  202 208 2320 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  818 848 0 7 0 0 0 2560 0 8 4294903801 459270 ##(Smalltalk.Message)  8 #displayString 98 0 0 1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 '' 467 8 #left 0 8 ##(Smalltalk.SortedCollection)  0 0 2560 0 3 0 0 8 #report 2320 0 133121 0 0 946 202 208 98 1 1010 1040 98 2 514 15 15 514 475 545 2560 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 244 0 0 0 23 1 0 0] 98 0 1280 0 27 234 256 98 2 2560 8 'choices' 2338 514 15 15 514 17 15 0 0 0 0 43895 0 0 0 514 501 311 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 946 202 208 98 3 1010 1040 98 2 514 2799 21 514 521 711 416 1010 1168 98 1 8 'Choose one of:' 416 1010 8 #updateMenuBar 2320 416 1218 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 123 6 0 0 109 1 0 0] 98 2 2560 576 1280 0 27 )!

resource_List_view
	"Answer the literal data from which the 'List view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_List_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 328198 ##(Smalltalk.Point)  501 701 167 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 576 0 0 0 7 0 0 0 576 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 514 15 559 514 475 71 576 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 23 1 0 0 244 0 0 0 58 1 0 0] 98 0 514 193 193 0 27 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140969549 1025 960 590662 2 ##(Smalltalk.ListModel)  202 208 928 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 0 0 0 960 0 8 4294903801 459270 ##(Smalltalk.Message)  8 #displayString 98 0 0 1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 '' 467 8 #left 0 8 ##(Smalltalk.SortedCollection)  0 0 960 0 3 0 0 8 #report 928 0 133185 0 0 722 202 208 98 1 786 816 98 2 514 15 15 514 475 545 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 244 0 0 0 23 1 0 0] 98 0 944 0 27 234 256 98 2 960 8 'choices' 590342 ##(Smalltalk.Rectangle)  514 15 15 514 17 15 0 0 0 0 44025 0 0 0 514 501 311 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 722 202 208 98 3 786 816 98 2 514 2799 21 514 521 711 416 786 8 #text: 98 1 8 'Choose one of:' 416 786 8 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 123 6 0 0 109 1 0 0] 98 2 960 576 944 0 27 )! !
!ChoicePrompter class categoriesFor: #choices:!instance creation!public! !
!ChoicePrompter class categoriesFor: #choices:caption:!instance creation!public! !
!ChoicePrompter class categoriesFor: #create:on:choices:caption:!instance creation!public! !
!ChoicePrompter class categoriesFor: #create:on:multipleChoices:caption:!instance creation!public! !
!ChoicePrompter class categoriesFor: #createOn:choices:caption:!instance creation!public! !
!ChoicePrompter class categoriesFor: #createOn:multipleChoices:caption:!instance creation!public! !
!ChoicePrompter class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!ChoicePrompter class categoriesFor: #defaultMultipleChoiceView!constants!private! !
!ChoicePrompter class categoriesFor: #defaultView!constants!private! !
!ChoicePrompter class categoriesFor: #icon!constants!public! !
!ChoicePrompter class categoriesFor: #multipleChoices:!instance creation!public! !
!ChoicePrompter class categoriesFor: #multipleChoices:caption:!instance creation!public! !
!ChoicePrompter class categoriesFor: #on:choices:caption:!instance creation!public! !
!ChoicePrompter class categoriesFor: #on:multipleChoices:caption:!instance creation!public! !
!ChoicePrompter class categoriesFor: #resource_Combo_choice_prompter!public!resources-views! !
!ChoicePrompter class categoriesFor: #resource_Default_view!public!resources-views! !
!ChoicePrompter class categoriesFor: #resource_Extensible_choice_prompter!public!resources-views! !
!ChoicePrompter class categoriesFor: #resource_List_view!public!resources-views! !

