"Filed out from Dolphin Smalltalk 7"!

ValueDialog subclass: #Prompter
	instanceVariableNames: 'promptPresenter replyPresenter validationBlock'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Prompter guid: (GUID fromString: '{87b4c6ac-026e-11d3-9fd7-00a0cc3e4a32}')!
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 17 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 594 31 183 594 519 61 656 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 91 0 0 0 18 1 0 0 121 0 0 0] 8 #() 594 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 976 nil nil nil 7 nil nil nil 976 626 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 976 34 2 8 1140850944 1 1056 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 '' nil nil 7 nil nil nil 1056 nil 8 1906774720 852486 ##(Smalltalk.NullConverter) nil nil true 754 138 144 34 1 818 #createAt:extent: 34 2 594 1 1 594 519 71 1056 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 3 1 0 0 35 0 0 0] 8 #() 960 nil 27 410 ##(Smalltalk.TextEdit) 34 16 nil 976 34 2 8 1140916352 1025 1408 nil 466 8 4278190080 nil 7 nil nil nil 1408 nil 8 1906818384 1218 nil nil 5 754 138 144 34 2 818 #createAt:extent: 34 2 594 1 83 594 519 45 1408 818 #setMarginWidths: 34 1 8 #(3 3) 1408 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 41 0 0 0 3 1 0 0 63 0 0 0] 8 #() 960 nil 27 nil nil nil 170 192 34 4 1056 8 'prompt' 1408 8 'reply' nil 754 138 144 34 1 818 #createAt:extent: 34 2 594 31 41 594 519 127 976 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 20 0 0 0 18 1 0 0 83 0 0 0] 34 2 1056 1408 960 nil 27 170 192 944 590342 ##(Smalltalk.Rectangle) 594 31 41 594 31 21 nil nil nil nil 23351 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010075552 754 138 144 34 3 818 #createAt:extent: 34 2 594 3839 21 594 611 341 416 818 #text: 34 1 8 'Please respond:' 416 818 #updateMenuBar 944 416 898 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 176 8 0 0 180 0 0 0] 34 2 976 656 960 nil 27 )!

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

