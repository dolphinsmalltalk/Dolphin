"Filed out from Dolphin Smalltalk"!

UI.ValueDialog
	subclass: #'UI.Prompter'
	instanceVariableNames: 'promptPresenter replyPresenter validationDwell flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'NoHintBubble' -> 16r1. 'NoHintWhenEmpty' -> 16r2 }!
UI.Prompter guid: (Core.GUID fromString: '{87b4c6ac-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.Prompter comment: '`Prompter` is a `<valueDialogPresenter>` that can be used to prompt a user to enter a `<readableString>` response to a question. The `<valueModel>` initially holds the default response and, if the dialog is confirmed, will hold the actual response from the user.

The user input to a `Prompter` can be validated by supplying a validater block. This is passed the current input text as edited, and can follow the original simple pattern of answering true/false for valid/invalid (set through #validationBlock:), or for more flexibility can answer a `ValidationResult`. The returned result includes a valid/invalid boolean value, but also a validation hint represented as an `Exception` subinstance, which need not be an `Error`, but but could also be a `Warning` or even `Notification`. When a hint is provided, the 

## Instance Variables:
  `promptPresenter`		`<textPresenter>` holding the prompt text.
  `replyPresenter`		`<textPresenter>` holding the reply text.
  `validater`			`<monadicValuable>` evaluated against the current user input (the reply text) to distinguish valid from invalid input. Expected to answer a `ValidationResult`
  `validationResult`		`ValidationResult` provided by the last evaluation of the `validater`
  `hintBubble`			`MessageBubble` shown for a validation hint
  `validationDwell`		`Duration` to wait after typing stops before displaying a validation hint (defaults to 1 second)
  `hintDwell`			`Duration` for which the hint bubble should be shown (defaults to 10 seconds)
  `flags`				`<integer>` holding various boolean flags
  `hintFont`			`Font` to be used for the hint bubble text (not caption)
'!
!UI.Prompter categoriesForClass!MVP-Presenters! !
!UI.Prompter methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	"We don't want to show an error bubble if the user hasn't entered any text yet."
	validationResultPresenter
		filterBlock: [:result | self showHintBubble and: [self hasEmptyValue not or: [self showHintWhenEmpty]]].
	promptPresenter := self add: TextPresenter new name: 'prompt'.
	replyPresenter := self add: TextPresenter new name: 'reply'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	replyPresenter
		when: #valueChanged
		send: #onReplyChanged
		to: self!

hasEmptyValue
	^self value isEmpty!

initialize
	"Private - Initialize the receiver"

	super initialize.
	validationDwell := 1 seconds.
	flags := 0!

model: aSubjectModel
	"Connect the receiver to aSubjectModel. The reply presenter shares this	same model since it is responsible for editing its value."

	super model: aSubjectModel.	
	replyPresenter model: self model.!

onReplyChanged
	"Private - The response has been edited. Initiate delayed validation."

	self deferredValidate!

prompt: aString
	"Set the text to use as the description in the dialog box."

	promptPresenter value: aString
!

showHintBubble
	"Answer whether any hint provided by the validater should be shown using a <MessageBubble>. The validation hint is intended to help the user understand why the Ok button is disabled, as not knowing why the input is invalid can be very frustrating. By default the bubble will be shown if a validater is set that sets a hint on the <ValidationResult> it returns."

	^flags noMask: NoHintBubble!

showHintBubble: aBoolean
	"Set whether any hint provided by the validater should be shown using a <MessageBubble>. By default the bubble will be shown, but this setting is to allow it to be disabled."

	flags := flags mask: NoHintBubble set: aBoolean not!

showHintWhenEmpty
	"Answer whether any hint provided by the validater should be shown when the reply is empty. If the hint bubble is entirely disabled, then this setting has no effect either way."

	^flags noMask: NoHintWhenEmpty!

showHintWhenEmpty: aBoolean
	"Set whether any hint provided by the validater is shown even if the reply is empty. Sometimes it can be a bit annoying to show a hint when the reply is emptied by deleting all the text, so this setting allows the validation hint bubble to be suppressed if the reply is emptied. By default the hint bubble will be shown even when the reply is empty, although not when the prompter is first opened."

	flags := flags mask: NoHintWhenEmpty set: aBoolean not!

validater: aMonadicValuable
	"Set the <monadicValuable> used to validate the user's reply. The valuable is passed the current reply text as its argument first argument, and is expected to answer a <ValuationResult>, the value of which indicates whether the text is considered valid in context. The OK button is not enabled until the ValidationResult's value is true. The validator can also pass out a hint details to be displayed in a message bubble if desired (see ValidationResult for the options available). The hint is primarily intended as a means to explain to the user why the OK button is disabled, as this can otherwise be difficult to understand."

	self model validater: 
			[:methodName |
			(aMonadicValuable value: methodName)
				presenter: replyPresenter;
				yourself]!

validationDwell
	"Answer the <Duration> to wait after the user has stopped typing before re-validating and possibly showing a hint bubble."

	^validationDwell!

validationDwell: aDuration
	validationDwell := aDuration!

validationResultPresenterClass
	^ValidationHintPresenter! !
!UI.Prompter categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
hasEmptyValue!private!testing! !
initialize!initializing!private! !
model:!accessing!public! !
onReplyChanged!event handling!private! !
prompt:!accessing!public! !
showHintBubble!accessing!public! !
showHintBubble:!accessing!public! !
showHintWhenEmpty!accessing!public! !
showHintWhenEmpty:!accessing!public! !
validater:!initializing!public! !
validationDwell!accessing!public! !
validationDwell:!accessing!public! !
validationResultPresenterClass!constants!public! !
!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 17 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 31 183 210 519 61 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 91 0 0 0 18 1 0 0 121 0 0 0] 8 #() 210 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 242 1 1 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850944 1 656 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 8 '' nil nil 5 nil nil nil 656 nil nil 518 #{UI.NullConverter} nil nil true 370 50 1 418 #createAt:extent: 50 2 210 1 1 210 519 71 656 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 3 1 0 0 35 0 0 0] 8 #() 560 nil 27 18 #{UI.TextEdit} 50 20 nil 576 50 2 8 1140916352 1025 976 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 976 nil nil 802 nil nil 1 #perChar nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 83 210 519 45 976 418 #setMarginWidths: 50 1 8 #(3 3) 976 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 41 0 0 0 3 1 0 0 63 0 0 0] 8 #() 560 nil 45 nil nil nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 656 8 'prompt' 976 8 'reply' nil 370 50 1 418 #createAt:extent: 50 2 210 31 41 210 519 127 576 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 20 0 0 0 18 1 0 0 83 0 0 0] 50 2 656 976 560 nil 27 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 210 31 41 210 31 21 nil nil nil nil 1 nil nil nil 210 441 331 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 370 50 2 418 #createAt:extent: 50 2 210 6143 21 210 611 341 32 418 #text: 50 1 8 'Please respond:' 32 498 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 48 13 0 0 180 0 0 0] 50 2 576 272 560 nil 27)!

resource_Inplace_edit_view
	"Answer the literal data from which the 'Inplace edit view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Inplace_edit_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(8388608 134283264) 32 nil 6 #{Graphics.Color} #default 518 #{Graphics.Point} 131 45 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140916608 1 192 nil 112 nil 517 nil nil nil 192 nil nil 518 #{UI.NullConverter} nil nil 65 #focusLost nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 130 1 1 130 269 75 192 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 134 0 0 0 37 0 0 0] 8 #() 130 193 193 nil 45 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 192 8 'reply' nil nil nil nil nil 1 nil nil nil nil 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 290 50 1 338 #createAt:extent: 50 2 130 6143 21 130 273 79 32 418 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 135 12 0 0 49 0 0 0] 50 2 192 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 736 nil nil nil 5 nil nil nil 736 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 290 50 1 338 #createAt:extent: 50 2 130 21 99 130 201 201 736 418 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 49 0 0 0 110 0 0 0 149 0 0 0] 8 #() 480 nil 27 480 nil 27)!

resource_Mini_view
	"Answer the literal data from which the 'Mini view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Mini_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(524288 196608) 32 nil 6 #{Graphics.Color} #lightYellow nil 133 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140916352 1 160 nil nil nil 5 nil nil nil 160 nil nil 518 #{UI.NullConverter} nil nil 1 #focusLost nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 11 11 354 117 65 160 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 63 0 0 0 37 0 0 0] 8 #() 354 193 193 nil 45 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 160 8 'reply' 518 #{Graphics.Rectangle} 354 11 11 354 1 1 nil nil nil nil 1 nil nil nil nil 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 258 50 1 306 #createAt:extent: 50 2 354 6143 21 354 131 79 32 402 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 64 12 0 0 49 0 0 0] 50 2 160 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 784 nil nil nil 5 nil nil nil 784 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 258 50 1 306 #createAt:extent: 50 2 354 161 71 354 201 201 784 402 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 35 0 0 0 180 0 0 0 135 0 0 0] 8 #() 464 nil 27 464 nil 27)! !
!UI.Prompter class categoriesForMethods!
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

