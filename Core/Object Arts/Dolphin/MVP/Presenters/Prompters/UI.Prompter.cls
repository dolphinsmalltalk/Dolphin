"Filed out from Dolphin Smalltalk"!

UI.ValueDialog subclass: #'UI.Prompter'
	instanceVariableNames: 'promptPresenter replyPresenter validationDwell hintDwell flags hintFont hintBubble'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'NoHintBubble' -> 16r1.
		'NoHintWhenEmpty' -> 16r2
	}!
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

closeBubble
	hintBubble
		ifNotNil: 
			[hintBubble close.
			hintBubble := nil]!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	promptPresenter := self add: TextPresenter new name: 'prompt'.
	replyPresenter := self add: TextPresenter new name: 'reply'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	replyPresenter
		when: #valueChanged
		send: #onReplyChanged
		to: self!

getHintCaption: aValidationResult
	^aValidationResult caption
		ifNil: [aValidationResult hint iconStyle == #error ifTrue: ['Invalid Input']]!

hasEmptyValue
	^self value isEmpty!

hintDwell
	"Answer the <Duration> for which a hint bubble should be shown before fading away."

	^hintDwell!

hintDwell: aDuration
	hintDwell := aDuration!

hintFont
	"Answer the `Font` to be used for the main text of any hint bubble. This does not affect the headline text, the font of which is not configurable."

	^hintFont ifNil: [Font name: 'Segoe UI' pointSize: 10]!

hintFont: aFont
	hintFont := aFont!

hintPosition
	"Private - Answer a <Point> representing the screen co-ordinate at which the hint bubble's arrow should point."

	^replyPresenter view screenRectangle centerRight!

initialize
	"Private - Initialize the receiver"

	super initialize.
	validationDwell := 1 seconds.
	hintDwell := 10 seconds.
	flags := 0!

model: aSubjectModel
	"Connect the receiver to aSubjectModel. The reply presenter shares this	same model since it is responsible for editing its value."

	super model: aSubjectModel.	
	replyPresenter model: self model.!

onPositionChanged: aPositionEvent
	self closeBubble.
	^super onPositionChanged: aPositionEvent!

onReplyChanged
	"Private - The response has been edited. Initiate delayed validation."

	self closeBubble.
	self view setTimer: ValidationTimerId interval: self validationDwell!

preTranslateKeyboardInput: aMSG
	"Answer whether the receiver would like to consume the argument aMSG, which is a keyboard message."

	"We want to show a validation hint if the user pressses the Enter key with the OK button the default, but disabled. In order to do this we have to intercept the key before it is dispatched to the dialog, or we will never see it."

	(aMSG isKeyPress: VK_RETURN) ifTrue: [self validate].
	^super preTranslateKeyboardInput: aMSG!

prompt: aString
	"Set the text to use as the description in the dialog box."

	promptPresenter value: aString
!

queryCommand: aCommandQuery
	"Private - Enters details about a potential command for the receiver into the <CommandQuery>."

	aCommandQuery commandSymbol == #ok
		ifTrue: 
			["Ensure the reply has been flushed from the view to the model - the standard views have update-per-char set on the text edit views so will already have done this, but a custom view might not."
			replyPresenter value.
			aCommandQuery validationResult: self validateModel.
			^true].
	^super queryCommand: aCommandQuery!

shouldShowValidationHint: aValidationResult
	^aValidationResult hint notNil
		and: [self showHintBubble and: [self hasEmptyValue not or: [self showHintWhenEmpty]]]!

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

showValidationResult: aValidationResult
	self closeBubble.
	(self shouldShowValidationHint: aValidationResult)
		ifTrue: 
			[hintBubble := MessageBubble new.
			hintBubble
				caption: (self getHintCaption: aValidationResult);
				font: self hintFont;
				timeout: self hintDwell;
				position: self hintPosition;
				exceptionDescription: aValidationResult hint;
				isSilent: true;
				open]!

validater
	^self model validater!

validater: aMonadicValuable
	"Set the <monadicValuable> used to validate the user's reply. The valuable is passed the current reply text as its argument first argument, and is expected to answer a <ValuationResult>, the value of which indicates whether the text is considered valid in context. The OK button is not enabled until the ValidationResult's value is true. The validator can also pass out a hint details to be displayed in a message bubble if desired (see ValidationResult for the options available). The hint is primarily intended as a means to explain to the user why the OK button is disabled, as this can otherwise be difficult to understand."

	self model validater: aMonadicValuable!

validationBlock: aBlock
	"Set the <monadicValuable> used to validate the user's reply. The valuable is passed the current reply text as its argument first argument and should answer true/false indicating whether the text is valid or not.
	This method is present mainly for backwards compatibility."

	"Although not deprecated because the old-style true/false result is adequate for many purposes, the alternative of providing a block that returns a full <ValidationResult> (see #validater:) is preferred."

	self validater: [:response | ValidationResult value: (aBlock value: response)]!

validationDwell
	"Answer the <Duration> to wait after the user has stopped typing before re-validating and possibly showing a hint bubble."

	^validationDwell!

validationDwell: aDuration
	validationDwell := aDuration! !
!UI.Prompter categoriesForMethods!
closeBubble!helpers!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
getHintCaption:!helpers!private! !
hasEmptyValue!private!testing! !
hintDwell!accessing!public! !
hintDwell:!accessing!public! !
hintFont!accessing!public! !
hintFont:!accessing!public! !
hintPosition!accessing!private! !
initialize!initializing!private! !
model:!accessing!public! !
onPositionChanged:!event handling!private! !
onReplyChanged!event handling!private! !
preTranslateKeyboardInput:!dispatching!public! !
prompt:!accessing!public! !
queryCommand:!commands!private! !
shouldShowValidationHint:!private!testing! !
showHintBubble!accessing!public! !
showHintBubble:!accessing!public! !
showHintWhenEmpty!accessing!public! !
showHintWhenEmpty:!accessing!public! !
showValidationResult:!helpers!private! !
validater!accessing!public! !
validater:!initializing!public! !
validationBlock:!initializing!public! !
validationDwell!accessing!public! !
validationDwell:!accessing!public! !
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 17 nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 31 183 578 519 61 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 91 0 0 0 18 1 0 0 121 0 0 0] 8 #() 578 193 193 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 944 nil nil nil 7 nil nil nil 944 610 1 1 410 #{UI.StaticText} 34 16 nil 944 34 2 8 1140850944 1 1024 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} 8 '' nil nil 7 nil nil nil 1024 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil true 738 34 1 786 #createAt:extent: 34 2 578 1 1 578 519 71 1024 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 3 1 0 0 35 0 0 0] 8 #() 928 nil 27 410 #{UI.TextEdit} 34 16 nil 944 34 2 8 1140916352 1025 1360 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 1360 nil 8 1815092992 1186 nil nil 5 738 34 2 786 #createAt:extent: 34 2 578 1 83 578 519 45 1360 786 #setMarginWidths: 34 1 8 #(3 3) 1360 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 41 0 0 0 3 1 0 0 63 0 0 0] 8 #() 928 nil 27 nil nil nil 170 192 34 4 1024 8 'prompt' 1360 8 'reply' nil 738 34 1 786 #createAt:extent: 34 2 578 31 41 578 519 127 944 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 20 0 0 0 18 1 0 0 83 0 0 0] 34 2 1024 1360 928 nil 27 170 192 912 1180166 #{Graphics.Rectangle} 578 31 41 578 31 21 nil nil nil nil 62857 nil nil nil 578 441 331 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 738 34 2 786 #createAt:extent: 34 2 578 12287 21 578 611 341 416 786 #text: 34 1 8 'Please respond:' 416 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 48 25 0 0 180 0 0 0] 34 2 944 640 928 nil 27)!

resource_Inplace_edit_view
	"Answer the literal data from which the 'Inplace edit view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Inplace_edit_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(8388608 134283264) 416 nil 917510 #{Graphics.Color} #default 918022 #{Graphics.Point} 131 45 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 nil nil nil nil 410 #{UI.TextEdit} 34 16 nil 416 34 2 8 1140916608 1 560 nil 480 nil 519 nil nil nil 560 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 65 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 498 1 1 498 269 75 560 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 134 0 0 0 37 0 0 0] 8 #() 498 193 193 nil 27 170 192 34 2 560 8 'reply' nil nil nil nil nil 71407 nil nil nil nil 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 674 34 1 722 #createAt:extent: 34 2 498 12287 21 498 273 79 416 802 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 135 24 0 0 49 0 0 0] 34 2 560 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 1120 nil nil nil 7 nil nil nil 1120 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 674 34 1 722 #createAt:extent: 34 2 498 21 99 498 201 201 1120 802 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 49 0 0 0 110 0 0 0 149 0 0 0] 8 #() 864 nil 27 864 nil 27)!

resource_Mini_view
	"Answer the literal data from which the 'Mini view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Mini_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(524288 196608) 416 nil 917510 #{Graphics.Color} #lightYellow nil 167 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 nil nil nil nil 410 #{UI.TextEdit} 34 16 nil 416 34 2 8 1140916352 1 528 nil nil nil 7 nil nil nil 528 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 1 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 11 11 738 117 65 528 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 63 0 0 0 37 0 0 0] 8 #() 738 193 193 nil 27 170 192 34 2 528 8 'reply' 1180166 #{Graphics.Rectangle} 738 11 11 738 1 1 nil nil nil nil 72315 nil nil nil nil 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 642 34 1 690 #createAt:extent: 34 2 738 12287 21 738 131 79 416 786 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 64 24 0 0 49 0 0 0] 34 2 528 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 1168 nil nil nil 7 nil nil nil 1168 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 642 34 1 690 #createAt:extent: 34 2 738 161 71 738 201 201 1168 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 35 0 0 0 180 0 0 0 135 0 0 0] 8 #() 848 nil 27 848 nil 27)! !
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

