"Filed out from Dolphin Smalltalk X6.1"!

ValueDialog subclass: #Prompter
	instanceVariableNames: 'promptPresenter replyPresenter validationBlock'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Prompter guid: (GUID fromString: '{87B4C6AC-026E-11D3-9FD7-00A0CC3E4A32}')!
Prompter comment: 'Prompter is a <valueDialogPresenter> that can be used to prompt a user to enter a <readableString> response to a question. The <valueModel> initially holds the default response and, if the dialog is confirmed, will hold the actual response from the user.

Instance Variables:
	promptPresenter	<TextPresenter> holding the prompt text.
	replyPresenter		<TextPresenter> holding the reply text.
	validationBlock		<monadicValuable> evaluated against the current user input (the reply text) to distinguish valid from invalid input.

'!
!Prompter categoriesForClass!MVP-Presenters! !
!Prompter methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	promptPresenter := self add: TextPresenter new name: 'prompt'.
	replyPresenter := self add: TextPresenter new name: 'reply'.

!

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
!Prompter categoriesFor: #createComponents!initializing!public! !
!Prompter categoriesFor: #initialize!initializing!private! !
!Prompter categoriesFor: #isInputValid!public!testing! !
!Prompter categoriesFor: #model:!accessing!public! !
!Prompter categoriesFor: #prompt:!accessing!public! !
!Prompter categoriesFor: #queryCommand:!commands!private! !
!Prompter categoriesFor: #validationBlock!accessing!public! !
!Prompter categoriesFor: #validationBlock:!accessing!public! !

!Prompter class methodsFor!

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 116 114 97 32 66 111 108 100 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 788230 ##(Smalltalk.BorderLayout)  1 21 0 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 672 0 0 0 7 0 0 0 672 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 610 31 177 610 539 71 672 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 88 0 0 0 28 1 0 0 123 0 0 0] 98 0 610 193 193 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 1056 0 0 0 7 0 0 0 1056 642 1 1 0 410 8 ##(Smalltalk.TextEdit)  98 16 0 1056 98 2 8 1140916352 1025 1152 0 482 8 4278190080 0 7 0 0 0 1152 0 8 4294903807 852486 ##(Smalltalk.NullConverter)  0 0 5 818 202 208 98 3 882 912 98 2 610 1 77 610 539 41 1152 882 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 1152 882 8 #isTextModified: 98 1 32 1152 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 38 0 0 0 13 1 0 0 58 0 0 0] 98 0 1040 0 27 0 0 410 8 ##(Smalltalk.StaticText)  98 16 0 1056 98 2 8 1140850944 1 1600 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  8 '' 0 0 7 0 0 0 1600 0 8 4294903625 1282 0 0 16 818 202 208 98 1 882 912 98 2 610 1 1 610 539 77 1600 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 13 1 0 0 38 0 0 0] 98 0 1040 0 27 234 256 98 4 1600 8 'prompt' 1152 8 'reply' 0 818 202 208 98 1 882 912 98 2 610 31 41 610 539 117 1056 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 20 0 0 0 28 1 0 0 78 0 0 0] 98 2 1600 1152 1040 0 27 234 256 1024 590342 ##(Smalltalk.Rectangle)  610 31 41 610 31 21 0 0 0 0 30475 0 0 0 0 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 818 202 208 98 3 882 912 98 2 610 2799 21 610 611 331 416 882 8 #text: 98 1 8 'Please respond:' 416 882 8 #updateMenuBar 1024 416 978 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 168 6 0 0 175 0 0 0] 98 2 1056 672 1040 0 27 )!

resource_Inplace_edit_view
	"Answer the literal data from which the 'Inplace edit view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Inplace_edit_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 16777217 268566529 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 328198 ##(Smalltalk.Point)  131 45 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 0 0 0 410 8 ##(Smalltalk.TextEdit)  98 16 0 416 98 2 8 1140916608 1 592 0 482 512 0 519 0 0 0 592 0 8 4294903569 852486 ##(Smalltalk.NullConverter)  0 0 65 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 530 1 1 530 245 69 592 802 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 592 802 8 #isTextModified: 98 1 32 592 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 122 0 0 0 34 0 0 0] 98 0 530 193 193 0 27 234 256 98 2 592 8 'reply' 0 0 0 0 0 9575 0 0 0 0 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 1995974453 738 202 208 98 2 802 832 98 2 530 3359 21 530 249 73 416 802 8 #updateMenuBar 98 0 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 11 7 0 0 46 0 0 0] 98 2 592 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 1408 0 0 0 7 0 0 0 1408 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 738 202 208 98 1 802 832 98 2 530 21 21 530 201 201 1408 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 110 0 0 0 110 0 0 0] 1344 1088 0 27 1088 0 27 )!

resource_Mini_view
	"Answer the literal data from which the 'Mini view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Mini_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(DialogView)  98 30 0 0 98 2 1048577 393217 416 0 196934 1 ##(RGB)  23199743 0 133 0 0 0 416 788230 ##(BorderLayout)  1 1 0 0 0 0 410 8 ##(TextEdit)  98 16 0 416 98 2 8 1140916352 1 544 0 482 23199743 0 5 0 0 0 544 0 8 4294906635 852486 ##(NullConverter)  0 0 1 983302 ##(MessageSequence)  202 208 98 3 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 818 117 37 544 754 8 #selectionRange: 98 1 525062 ##(Interval)  3 1 3 544 754 8 #isTextModified: 98 1 32 544 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 63 0 0 0 23 0 0 0] 98 0 818 193 193 0 27 234 256 98 2 544 8 'reply' 590342 ##(Rectangle)  818 11 11 818 1 1 0 0 0 0 13887 0 0 0 0 1 0 0 590598 ##(Semaphore)  0 0 1 0 8 2010572111 690 202 208 98 2 754 784 98 2 818 1535 1175 818 131 51 416 754 8 #menuBar: 98 1 0 416 994 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 75 2 0 0 64 3 0 0 100 2 0 0] 98 2 544 410 8 ##(ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 1440 0 0 0 5 0 0 0 1440 1180166 ##(ResourceIdentifier)  8 ##(Presenter)  8 #resource_OK_Cancel_button_block 0 690 202 208 98 1 754 784 98 2 818 21 21 818 201 201 1440 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 110 0 0 0 110 0 0 0] 98 0 1056 0 27 1056 0 27 )! !
!Prompter class categoriesFor: #create:on:prompt:caption:!instance creation!public! !
!Prompter class categoriesFor: #createOn:prompt:caption:!instance creation!public! !
!Prompter class categoriesFor: #defaultModel!models!public! !
!Prompter class categoriesFor: #icon!constants!public! !
!Prompter class categoriesFor: #on:prompt:caption:!instance creation!public! !
!Prompter class categoriesFor: #prompt:!instance creation!public! !
!Prompter class categoriesFor: #prompt:caption:!instance creation!public! !
!Prompter class categoriesFor: #resource_Default_view!public!resources-views! !
!Prompter class categoriesFor: #resource_Inplace_edit_view!public!resources-views! !
!Prompter class categoriesFor: #resource_Mini_view!public!resources-views! !

