"Filed out from Dolphin Smalltalk"!

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
			choicePresenter view addSelections: {new}]!

newPrompt
	"Answer the value of the receiver's 'newPrompt' instance variable."

	^newPrompt!

newPrompt: anObject
	"Set the value of the receiver's 'newPrompt' instance variable to the argument, anObject."

	newPrompt := anObject!

nilChoice: anObject
	"Sets the choice that can be used to represent a nil value in the model"

	choicePresenter nilChoice: anObject! !
!ChoicePrompter categoriesForMethods!
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
nilChoice:!accessing!public! !
!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog 328198 ##(Smalltalk.Point) 501 701 165 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 720 nil nil nil 7 nil nil nil 720 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 15 549 498 459 71 720 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 8 #() 498 193 193 nil 27 1 true 170 192 34 2 410 ##(Smalltalk.ComboBox) 34 17 nil 416 34 2 8 1144063489 1025 1072 590662 2 ##(Smalltalk.ListModel) 138 144 1008 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 1072 nil 8 1903738896 459270 ##(Smalltalk.Message) #displayString 8 #() 1008 401 818 138 144 34 1 882 #createAt:extent: 34 2 498 15 15 498 459 535 1072 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 1024 nil 27 8 'choices' 590342 ##(Smalltalk.Rectangle) 498 15 15 498 17 15 nil nil nil nil 12201 nil nil nil 498 501 311 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 1998684880 818 138 144 34 3 882 #createAt:extent: 34 2 498 3839 21 498 521 711 416 882 #text: 34 1 8 'Choose one of:' 416 882 #updateMenuBar 1008 416 962 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 131 8 0 0 109 1 0 0] 34 2 1072 720 1024 nil 27 )!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog 328198 ##(Smalltalk.Point) 501 701 165 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 15 549 498 459 71 656 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 8 #() 498 193 193 nil 27 nil nil 410 ##(Smalltalk.ListBox) 34 17 nil 416 34 2 8 1144062209 1025 976 590662 2 ##(Smalltalk.ListModel) 138 144 944 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 976 nil 8 1903732064 459270 ##(Smalltalk.Message) #displayString 8 #() 944 nil 754 138 144 34 2 818 #createAt:extent: 34 2 498 15 15 498 459 535 976 818 #horizontalExtent: 8 #(0) 976 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 960 nil 27 170 192 34 2 976 8 'choices' 590342 ##(Smalltalk.Rectangle) 498 15 15 498 17 15 nil nil nil nil 11893 nil nil nil 498 501 311 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 1998684880 754 138 144 34 3 818 #createAt:extent: 34 2 498 3839 21 498 521 711 416 818 #text: 34 1 8 'Choose one of:' 416 818 #updateMenuBar 944 416 898 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 131 8 0 0 109 1 0 0] 34 2 976 656 960 nil 27 )!

resource_Extensible_choice_prompter
	"Answer the literal data from which the 'Extensible choice prompter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Extensible_choice_prompter)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog 328198 ##(Smalltalk.Point) 501 701 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.PushButton) 34 20 nil 656 34 2 8 1140924416 1 784 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 784 nil 8 1883832576 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 319 21 498 141 51 784 1010 #text: 34 1 8 'Cancel' 784 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 159 0 0 0 10 0 0 0 229 0 0 0 35 0 0 0] 8 #() 498 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedViewRight -139 1250 #fixedParentRight 1 1250 #fixedViewBottom -49 1250 #fixedParentBottom 1 410 ##(Smalltalk.PushButton) 34 20 nil 656 34 2 8 1140924416 1 1328 nil 864 nil 7 nil nil nil 1328 nil 8 1883832576 898 #newChoice 8 '&New...' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 498 11 21 498 141 51 1328 1010 #isEnabled: 8 #(false) 1328 1010 #text: 34 1 8 '&New...' 1328 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 75 0 0 0 35 0 0 0] 8 #() 1200 nil 29 1218 1250 #fixedParentLeft 11 1250 #fixedViewLeft 141 1296 -49 1312 1 410 ##(Smalltalk.PushButton) 34 20 nil 656 34 2 8 1140924416 1 1728 nil 864 nil 7 nil nil nil 1728 nil 8 1883832576 898 #ok 8 'OK' 1 1 nil nil true nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 498 169 21 498 141 51 1728 1010 #isEnabled: 8 #(false) 1728 1010 #text: 34 1 8 'OK' 1728 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 84 0 0 0 10 0 0 0 154 0 0 0 35 0 0 0] 8 #() 1200 nil 29 1218 1264 -139 1280 -149 1296 -49 1312 1 170 192 8 #() 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 946 138 144 34 1 1010 #createAt:extent: 34 2 498 15 549 498 459 71 656 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 34 3 1328 1728 784 1200 nil 27 nil nil 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140969549 1025 2352 590662 2 ##(Smalltalk.ListModel) 138 144 2112 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 864 nil 7 nil nil nil 2352 nil 8 1883852064 459270 ##(Smalltalk.Message) #displayString 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 451 #left nil 2514 #<= 8 #() nil nil 2352 nil 3 nil nil #report 2112 nil 133121 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 946 138 144 34 1 1010 #createAt:extent: 34 2 498 15 15 498 459 535 2352 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 1200 nil 35 170 192 34 2 2352 8 'choices' 2130 498 15 15 498 17 15 nil nil nil nil 34895 nil nil nil 498 501 311 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010284960 946 138 144 34 3 1010 #createAt:extent: 34 2 498 7039 21 498 521 711 416 1010 #text: 34 1 8 'Choose one of:' 416 1010 #updateMenuBar 2112 416 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 195 14 0 0 109 1 0 0] 34 2 2352 656 1200 nil 27 )!

resource_Extensible_multiselection_choice_prompter
	"Answer the literal data from which the 'Extensible multiselection choice prompter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Extensible_multiselection_choice_prompter)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog 328198 ##(Smalltalk.Point) 501 701 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.PushButton) 34 20 nil 656 34 2 8 1140924416 1 784 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 784 nil 8 1883832576 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 319 21 498 141 51 784 1010 #text: 34 1 8 'Cancel' 784 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 159 0 0 0 10 0 0 0 229 0 0 0 35 0 0 0] 8 #() 498 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedViewRight -139 1250 #fixedParentRight 1 1250 #fixedViewBottom -49 1250 #fixedParentBottom 1 410 ##(Smalltalk.PushButton) 34 20 nil 656 34 2 8 1140924416 1 1328 nil 864 nil 7 nil nil nil 1328 nil 8 1883832576 898 #ok 8 'OK' 1 1 nil nil true nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 498 169 21 498 141 51 1328 1010 #isEnabled: 8 #(false) 1328 1010 #text: 34 1 8 'OK' 1328 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 84 0 0 0 10 0 0 0 154 0 0 0 35 0 0 0] 8 #() 1200 nil 29 1218 1264 -139 1280 -149 1296 -49 1312 1 410 ##(Smalltalk.PushButton) 34 20 nil 656 34 2 8 1140924416 1 1696 nil 864 nil 7 nil nil nil 1696 nil 8 1883832576 898 #newMultipleChoice 8 '&New...' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 498 11 21 498 141 51 1696 1010 #isEnabled: 8 #(false) 1696 1010 #text: 34 1 8 '&New...' 1696 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 75 0 0 0 35 0 0 0] 8 #() 1200 nil 29 1218 1250 #fixedParentLeft 11 1250 #fixedViewLeft 141 1296 -49 1312 1 170 192 8 #() 590342 ##(Smalltalk.Rectangle) 498 1 1 498 1 1 946 138 144 34 1 1010 #createAt:extent: 34 2 498 15 549 498 459 71 656 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 34 3 1696 1328 784 1200 nil 27 nil nil 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140969801 1025 2352 590662 2 ##(Smalltalk.ListModel) 138 144 2112 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 864 nil 7 nil nil nil 2352 nil 8 1883852064 459270 ##(Smalltalk.Message) #displayString 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 451 #left nil 2514 #<= 8 #() nil nil 2352 nil 3 nil nil #report 2112 nil 133185 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 946 138 144 34 1 1010 #createAt:extent: 34 2 498 15 15 498 459 535 2352 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 1200 nil 35 170 192 34 2 2352 8 'choices' 2130 498 15 15 498 17 15 nil nil nil nil 34903 nil nil nil 498 501 311 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010284960 946 138 144 34 3 1010 #createAt:extent: 34 2 498 7039 21 498 521 711 416 1010 #text: 34 1 8 'Choose one or more of:' 416 1010 #updateMenuBar 2112 416 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 195 14 0 0 109 1 0 0] 34 2 2352 656 1200 nil 27 )!

resource_List_view
	"Answer the literal data from which the 'List view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_List_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog 328198 ##(Smalltalk.Point) 501 701 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 15 549 498 459 71 656 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 8 #() 498 193 193 nil 27 nil nil 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140969549 1025 976 590662 2 ##(Smalltalk.ListModel) 138 144 944 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 976 nil 8 1883852064 459270 ##(Smalltalk.Message) #displayString 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 451 #left nil 1170 #<= 8 #() nil nil 976 nil 3 nil nil #report 944 nil 133185 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 754 138 144 34 1 818 #createAt:extent: 34 2 498 15 15 498 459 535 976 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 960 nil 35 170 192 34 2 976 8 'choices' 590342 ##(Smalltalk.Rectangle) 498 15 15 498 17 15 nil nil nil nil 34911 nil nil nil 498 501 311 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010284960 754 138 144 34 3 818 #createAt:extent: 34 2 498 7039 21 498 521 711 416 818 #text: 34 1 8 'Choose one of:' 416 818 #updateMenuBar 944 416 898 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 195 14 0 0 109 1 0 0] 34 2 976 656 960 nil 27 )!

resource_Multiselection_choice_prompter
	"Answer the literal data from which the 'Multiselection choice prompter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Multiselection_choice_prompter)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog 328198 ##(Smalltalk.Point) 501 701 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 15 549 498 459 71 656 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 18 1 0 0 236 0 0 0 53 1 0 0] 8 #() 498 193 193 nil 27 nil nil 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140969801 1025 976 590662 2 ##(Smalltalk.ListModel) 138 144 944 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default 498 485 577 7 nil nil nil 976 nil 8 1883852064 459270 ##(Smalltalk.Message) #displayString 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 451 #left nil 1186 #<= 8 #() nil nil 976 nil 3 nil nil #report 944 nil 133121 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 754 138 144 34 1 818 #createAt:extent: 34 2 498 15 15 498 459 535 976 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 7 0 0 0 236 0 0 0 18 1 0 0] 8 #() 960 nil 35 170 192 34 2 976 8 'choices' 590342 ##(Smalltalk.Rectangle) 498 15 15 498 17 15 nil nil nil nil 34919 nil nil nil 498 501 311 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010284960 754 138 144 34 3 818 #createAt:extent: 34 2 498 7039 21 498 521 711 416 818 #text: 34 1 8 'Choose one or more of:' 416 818 #updateMenuBar 944 416 898 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 195 14 0 0 109 1 0 0] 34 2 976 656 960 nil 27 )! !
!ChoicePrompter class categoriesForMethods!
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

