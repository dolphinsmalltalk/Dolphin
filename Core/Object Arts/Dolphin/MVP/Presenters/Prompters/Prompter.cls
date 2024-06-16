"Filed out from Dolphin Smalltalk"!

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

!Prompter categoriesForMethods!
createComponents!initializing!public! !
initialize!initializing!private! !
isInputValid!public!testing! !
model:!accessing!public! !
prompt:!accessing!public! !
queryCommand:!commands!private! !
validationBlock!accessing!public! !
validationBlock:!accessing!public! !
!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13107200 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 17 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[15 0 0 0 91 0 0 0 18 1 0 0 121 0 0 0] 193 640 8 '' 608 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 5 nil nil nil 960 578 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850944 1 1040 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 '' nil nil 5 nil nil nil 1040 nil 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil true 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 0 0 0 0 3 1 0 0 35 0 0 0] 193 1072 nil 1040 770 #text: 34 1 8 '' 1040 3 8 #() 930 193 193 nil 27 410 ##(Smalltalk.TextEdit) 34 16 nil 960 34 2 8 1140916352 1025 1440 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 1440 nil 8 1759000288 1202 nil nil 5 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 41 0 0 0 3 1 0 0 63 0 0 0] 193 1472 nil 1440 770 #setMarginWidths: 34 1 8 #(3 3) 1440 3 8 #() 930 193 193 nil 27 nil nil nil 170 192 34 4 1040 8 'prompt' 1440 8 'reply' nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[15 0 0 0 20 0 0 0 18 1 0 0 83 0 0 0] 193 992 8 '' 960 3 34 2 1040 1440 930 193 193 nil 27 170 192 912 590342 ##(Smalltalk.Rectangle) 930 31 41 930 31 21 nil nil nil nil 12503 nil nil nil nil 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 2034 930 1 1 930 611 341 193 416 770 #setWindowText: 34 1 8 'Please respond:' 416 1 34 2 960 608 930 193 193 nil 29 )!

resource_Inplace_edit_view
	"Answer the literal data from which the 'Inplace edit view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Inplace_edit_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(8388608 134283264) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 131 45 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916608 1 560 nil 480 nil 517 nil nil nil 560 nil 8 1759000288 852486 ##(Smalltalk.NullConverter) nil nil 65 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 134 0 0 0 37 0 0 0] 193 592 nil 560 3 8 #() 498 193 193 nil 27 170 192 34 2 560 8 'reply' nil nil nil nil nil 12511 nil nil nil nil 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 674 138 144 34 2 738 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 590342 ##(Smalltalk.Rectangle) 498 1 1 498 273 79 193 416 738 #setWindowText: 34 1 8 '' 416 1 34 2 560 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1232 nil nil nil 5 nil nil nil 1232 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 674 138 144 34 1 738 #createWindow: 34 1 786 818 8 #[10 0 0 0 49 0 0 0 110 0 0 0 149 0 0 0] 193 1264 8 '' 1232 3 8 #() 498 193 193 nil 27 498 193 193 nil 29 )!

resource_Mini_view
	"Answer the literal data from which the 'Mini view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Mini_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(524288 196608) 416 nil 327686 ##(Smalltalk.Color) #lightYellow nil 133 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916352 1 528 nil nil nil 5 nil nil nil 528 nil 8 1759000288 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[5 0 0 0 5 0 0 0 63 0 0 0 23 0 0 0] 193 560 nil 528 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 170 192 34 2 528 8 'reply' 590342 ##(Smalltalk.Rectangle) 850 11 11 850 1 1 nil nil nil nil 12519 nil nil nil nil 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 642 138 144 34 2 706 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 930 850 1 1 850 131 51 193 416 706 #setWindowText: 34 1 8 '' 416 1 34 2 528 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1264 nil nil nil 5 nil nil nil 1264 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 642 138 144 34 1 706 #createWindow: 34 1 754 786 8 #[80 0 0 0 35 0 0 0 180 0 0 0 135 0 0 0] 193 1296 8 '' 1264 3 8 #() 850 193 193 nil 27 850 193 193 nil 29 )! !

!Prompter class categoriesForMethods!
create:on:prompt:caption:!instance creation!public! !
createOn:prompt:caption:!instance creation!public! !
defaultModel!models!public! !
icon!constants!public! !
on:prompt:caption:!instance creation!public! !
prompt:!instance creation!public! !
prompt:caption:!instance creation!public! !
resource_Default_view!public!resources-views! !
resource_Inplace_edit_view!public!resources-views! !
resource_Mini_view!public!resources-views! !
!

