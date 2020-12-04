"Filed out from Dolphin Smalltalk 7"!

UI.ValueDialog subclass: #'UI.Prompter'
	instanceVariableNames: 'promptPresenter replyPresenter validationBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Prompter guid: (Core.GUID fromString: '{87b4c6ac-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.Prompter comment: 'Prompter is a <valueDialogPresenter> that can be used to prompt a user to enter a <readableString> response to a question. The <valueModel> initially holds the default response and, if the dialog is confirmed, will hold the actual response from the user.

Instance Variables:
	promptPresenter	<TextPresenter> holding the prompt text.
	replyPresenter		<TextPresenter> holding the reply text.
	validationBlock		<monadicValuable> evaluated against the current user input (the reply text) to distinguish valid from invalid input.

'!
!UI.Prompter categoriesForClass!MVP-Presenters! !
!UI.Prompter methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	promptPresenter := self add: TextPresenter new name: 'prompt'.
	replyPresenter := self add: TextPresenter new name: 'reply'!

initialize
	"Private - Initialize the receiver"

	super initialize.
	validationBlock := [:replyString | true]!

isInputValid
	^(self validationBlock value: replyPresenter value) == true!

model: aSubjectModel
	"Connect the receiver to aSubjectModel. The reply presenter shares this
	same model since it is responsible for editing it's value"

	super model: aSubjectModel.	
	replyPresenter model: self model.!

prompt: aString
	"Set the text to use as the description in the dialog box."

	promptPresenter value: aString
!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>."

	aCommandQuery commandSymbol == #ok 
		ifTrue: 
			[aCommandQuery isEnabled: self isInputValid.
			^true].
	^super queryCommand: aCommandQuery!

validationBlock
	^validationBlock!

validationBlock: aBlock 
	"Set the <monadicValuable> used to validate the user's reply. The valuable is passed the
	current reply text as its argument, and is expected to answer whether it is valid. The OK
	button is not enabled until the validationBlock answers true."

	validationBlock := aBlock! !
!UI.Prompter categoriesFor: #createComponents!initializing!public! !
!UI.Prompter categoriesFor: #initialize!initializing!private! !
!UI.Prompter categoriesFor: #isInputValid!public!testing! !
!UI.Prompter categoriesFor: #model:!accessing!public! !
!UI.Prompter categoriesFor: #prompt:!accessing!public! !
!UI.Prompter categoriesFor: #queryCommand:!commands!private! !
!UI.Prompter categoriesFor: #validationBlock!accessing!public! !
!UI.Prompter categoriesFor: #validationBlock:!accessing!public! !

!UI.Prompter class methodsFor!

create: aViewName on: aValueModel prompt: aStringPrompt caption: aStringCaptionOrNil 
	| prompter |
	(prompter := self create: aViewName on: aValueModel) prompt: aStringPrompt.
	aStringCaptionOrNil notNil ifTrue: [
		prompter caption: aStringCaptionOrNil ].
	^prompter!

createOn: aValueModel prompt: aStringPrompt caption: aStringCaptionOrNil 
	"Creates an instance of the receiver on aValueModel and aStringPrompt. The prompter is
	given a caption according to aStringCaptionOrNil; if nil a default caption is used. The
	prompter is displayed modally, prompting for a String reply. The initial value of the reply
	field is the original value of aValueModel. The dialog is not shown."

	| prompter |
	(prompter := self createOn: aValueModel) prompt: aStringPrompt.
	aStringCaptionOrNil notNil ifTrue: [prompter caption: aStringCaptionOrNil].
	^prompter!

defaultModel
	^String new!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon fromId: '!!APPLICATION'

!

on: aValueModel prompt: aStringPrompt caption: aStringCaptionOrNil 
	"Creates an instance of the receiver on aValueModel and aStringPrompt. The prompter is given
	a caption according to aStringCaptionOrNil; if nil a default caption is used. The prompter
	is displayed modally, prompting for a String reply. The initial value of the reply field is
	the original value of aValueModel.

	Answers the reply or nil if the dialog is cancelled"

	^(self 
		createOn: aValueModel
		prompt: aStringPrompt
		caption: aStringCaptionOrNil) showModal!

prompt: aStringPrompt
	"Creates an instance of the receiver with aStringPrompt and a default caption.
	The prompter is displayed modally, prompting for a String reply. 

	Answer the reply or nil if the dialog is cancelled"

	^self prompt: aStringPrompt caption: nil
!

prompt: aStringPrompt caption: aStringCaptionOrNil 
	"Creates an instance of the receiver with aStringPrompt.
	The prompter is given a caption according to aStringCaptionOrNil; if nil
	a default caption is used. The prompter is displayed modally, prompting 
	for a String reply. 

	Answer the reply or nil if the dialog is cancelled"

	^self on: self defaultModel prompt: aStringPrompt caption: aStringCaptionOrNil !

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 165 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 655878 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 17 nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 31 183 578 519 61 640 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 91 0 0 0 18 1 0 0 121 0 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 7 nil nil nil 960 610 1 1 410 ##(UI.StaticText) 34 16 nil 960 34 2 8 1140850944 1 1040 918598 2 ##(UI.ValueHolder) nil nil 1441798 ##(Kernel.NeverSearchPolicy) 8 '' nil nil 7 nil nil nil 1040 nil 8 1920531648 1049094 ##(UI.NullConverter) nil nil true 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 1 578 519 71 1040 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 3 1 0 0 35 0 0 0] 8 #() 944 nil 27 410 ##(UI.TextEdit) 34 16 nil 960 34 2 8 1140916352 1025 1392 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1392 nil 8 1920675248 1202 nil nil 5 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 83 578 519 45 1392 802 #setMarginWidths: 34 1 8 #(3 3) 1392 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 41 0 0 0 3 1 0 0 63 0 0 0] 8 #() 944 nil 27 nil nil nil 170 192 34 4 1040 8 'prompt' 1392 8 'reply' nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 31 41 578 519 127 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 20 0 0 0 18 1 0 0 83 0 0 0] 34 2 1040 1392 944 nil 27 170 192 928 1180166 ##(Graphics.Rectangle) 578 31 41 578 31 21 nil nil nil nil 31587 nil nil nil nil 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2005493520 738 138 144 34 2 802 #createAt:extent: 34 2 578 6143 21 578 611 341 416 802 #text: 34 1 8 'Please respond:' 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 48 13 0 0 180 0 0 0] 34 2 960 640 944 nil 27)!

resource_Inplace_edit_view
	"Answer the literal data from which the 'Inplace edit view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Inplace_edit_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(8388608 134283264) 416 nil 917510 ##(Graphics.Color) #default 655878 ##(Graphics.Point) 131 45 549 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 nil nil nil nil 410 ##(UI.TextEdit) 34 16 nil 416 34 2 8 1140916608 1 560 nil 480 nil 519 nil nil nil 560 nil 8 1920675248 1049094 ##(UI.NullConverter) nil nil 65 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 498 1 1 498 269 75 560 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 134 0 0 0 37 0 0 0] 8 #() 498 193 193 nil 27 170 192 34 2 560 8 'reply' nil nil nil nil nil 31727 nil nil nil nil 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2005493520 674 138 144 34 1 738 #createAt:extent: 34 2 498 6143 21 498 273 79 416 818 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 135 12 0 0 49 0 0 0] 34 2 560 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1152 nil nil nil 7 nil nil nil 1152 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 674 138 144 34 1 738 #createAt:extent: 34 2 498 21 99 498 201 201 1152 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 49 0 0 0 110 0 0 0 149 0 0 0] 8 #() 880 nil 27 880 nil 27)!

resource_Mini_view
	"Answer the literal data from which the 'Mini view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Mini_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(524288 196608) 416 nil 917510 ##(Graphics.Color) #lightYellow nil 165 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 nil nil nil nil 410 ##(UI.TextEdit) 34 16 nil 416 34 2 8 1140916352 1 528 nil nil nil 7 nil nil nil 528 nil 8 1920675248 1049094 ##(UI.NullConverter) nil nil 1 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 11 11 754 117 65 528 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 63 0 0 0 37 0 0 0] 8 #() 754 193 193 nil 27 170 192 34 2 528 8 'reply' 1180166 ##(Graphics.Rectangle) 754 11 11 754 1 1 nil nil nil nil 31867 nil nil nil nil 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2005493520 642 138 144 34 1 706 #createAt:extent: 34 2 754 6143 21 754 131 79 416 802 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 64 12 0 0 49 0 0 0] 34 2 528 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1200 nil nil nil 7 nil nil nil 1200 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 642 138 144 34 1 706 #createAt:extent: 34 2 754 161 71 754 201 201 1200 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 35 0 0 0 180 0 0 0 135 0 0 0] 8 #() 864 nil 27 864 nil 27)! !
!UI.Prompter class categoriesFor: #create:on:prompt:caption:!instance creation!public! !
!UI.Prompter class categoriesFor: #createOn:prompt:caption:!instance creation!public! !
!UI.Prompter class categoriesFor: #defaultModel!models!public! !
!UI.Prompter class categoriesFor: #icon!constants!public! !
!UI.Prompter class categoriesFor: #on:prompt:caption:!instance creation!public! !
!UI.Prompter class categoriesFor: #prompt:!instance creation!public! !
!UI.Prompter class categoriesFor: #prompt:caption:!instance creation!public! !
!UI.Prompter class categoriesFor: #resource_Default_view!public!resources-views! !
!UI.Prompter class categoriesFor: #resource_Inplace_edit_view!public!resources-views! !
!UI.Prompter class categoriesFor: #resource_Mini_view!public!resources-views! !

