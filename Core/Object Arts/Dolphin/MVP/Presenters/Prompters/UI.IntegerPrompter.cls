"Filed out from Dolphin Smalltalk"!

UI.Prompter
	subclass: #'UI.IntegerPrompter'
	instanceVariableNames: 'intervalPresenter interval'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.IntegerPrompter guid: (Core.GUID fromString: '{f0928363-bf5c-4f5e-98e2-714351f9e977}')!
UI.IntegerPrompter comment: 'IntegerPrompter is a <Prompter> specialised to accept only integer input within a defined interval. The validation block is set so that the OK button is only enabled if the value in the reply field is a member of the interval. If the view has a SpinButton, then this is set to step between the elements of the interval.

Example Usage:
	IntegerPrompter 
		on: (Debugger aspectValue: #animatePause)
		prompt: ''Millisecond delay between debug animation steps:''
		caption: nil
		interval: (50 to: 5000 by: 50)

Instance Variables:
	intervalPresenter	<NumberPresenter>. SpinButton, if available
	interval		<Interval>. Defines acceptable input. Must be integral, but may have step other than one, e.g. (0 to: 48 by: 6)

'!
!UI.IntegerPrompter categoriesForClass!MVP-Presenters! !
!UI.IntegerPrompter methodsFor!

bufferedModelFor: aValueHolder
	| buffer |
	buffer := super bufferedModelFor: aValueHolder.
	buffer validater: self getValidater.
	^buffer!

createComponents
	"Create the presenters contained by the receiver."

	"Implementation Note: We don't supersend because we want to connect the reply field to a 
	NumberPresenter, not a TextPresenter."

	promptPresenter := self add: TextPresenter new name: 'prompt'.
	replyPresenter := self add: NumberPresenter new name: 'reply'.
	intervalPresenter := self add: NumberPresenter new name: 'spinner'!

getValidater
	^
	[:value |
	| result |
	result := ValidationResult new.
	(result value: (interval includes: value))
		ifFalse: 
			[result errorMessage: '<1d> is outside the expected range <2d>..<3d>'
						<< {value. interval first. interval last}].
	result]!

hasEmptyValue
	^self value isNil!

initialize
	"Private - Initialize the receiver"

	super initialize.
	interval := 1 to: 100.
	self showHintWhenEmpty: false!

interval
	^interval!

interval: anInterval 
	interval := anInterval.
	self isOpen ifTrue: [self setSpinnerRange]!

onViewOpened
	"Received when the receiver's view has been connected. "

	super onViewOpened.
	self setSpinnerRange.
	"We have to delay setting the model until now (rather than in an override of #model:) because 
	 the value may not be in the range of the view's default interval."
	intervalPresenter model: self model!

setSpinnerRange
	"Note that if the spinner view is not present, then the interval presenter view will be a DeafObject, which will silently not understand #range:.
	If you are using an IntegerPrompter in an application and see that #range: among the unimplemented messges, and it is sent from here, then you will need to add a the 'Dolphin SpinButton Control' package as a manual pre-requisite."

	intervalPresenter view range: self interval! !
!UI.IntegerPrompter categoriesForMethods!
bufferedModelFor:!helpers!private! !
createComponents!initializing!public! !
getValidater!helpers!private! !
hasEmptyValue!private!testing! !
initialize!initializing!private! !
interval!accessing!public! !
interval:!accessing!public! !
onViewOpened!event handling!public! !
setSpinnerRange!helpers!private! !
!

!UI.IntegerPrompter class methodsFor!

defaultModel
	^1 asValue!

on: aValueModel prompt: aStringPrompt caption: aStringCaptionOrNil
	^self
		on: aValueModel
		prompt: aStringPrompt
		caption: aStringCaptionOrNil
		interval: (1 to: SmallInteger maximum)!

on: aValueModel prompt: aStringPrompt caption: aStringCaptionOrNil interval: anInterval 
	"Creates an instance of the receiver on aValueModel and an aStringPrompt. 
	The prompter is given a caption according to aStringCaptionOrNil; if nil
	a default caption is used. The prompter is displayed modally, prompting 
	for a String reply. The initial value of the reply field is the original
	value of aSubjectModel.

	Answer the reply, or nil if the dialog is cancelled"

	| prompter |
	prompter := self on: aValueModel.
	prompter
		interval: anInterval;
		createView: self defaultView;
		prompt: aStringPrompt.
	aStringCaptionOrNil notNil ifTrue: [prompter caption: aStringCaptionOrNil].
	^prompter showModal!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13107200 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 1048838 #{UI.FramingLayout} 170 176 34 6 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 25 125 578 429 61 672 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 62 0 0 0 226 0 0 0 92 0 0 0] 8 #() 578 193 193 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 5 1010 #fixedParentRight 5 1010 #fixedViewBottom -59 1010 #fixedParentBottom 3 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 1088 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} 8 '' nil nil 7 nil nil nil 1088 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil true 770 34 2 818 #createAt:extent: 34 2 578 41 33 578 231 81 1088 818 #text: 34 1 8 'Enter number:' 1088 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 16 0 0 0 135 0 0 0 56 0 0 0] 8 #() 960 nil 27 978 1024 21 1010 #fixedViewLeft 231 1010 #fixedParentTop 3 1010 #fixedViewTop 81 410 #{UI.TextEdit} 34 16 nil 416 34 2 8 1140924544 1025 1536 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 1536 nil 8 1815092992 1049670 1 #{UI.IntegerToText} nil 8 '' 721222 1 #{Core.Locale} #userDefault nil 5 770 34 2 818 #createAt:extent: 34 2 578 291 31 578 149 45 1536 818 #setMarginWidths: 34 1 8 #(3 3) 1536 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 15 0 0 0 219 0 0 0 37 0 0 0] 8 #() 960 nil 27 978 1010 #fixedPreviousRight 21 1488 149 1504 1 1520 45 170 192 34 4 1088 8 'prompt' 1536 8 'reply' 1180166 #{Graphics.Rectangle} 578 21 31 578 21 21 nil nil nil nil 62991 nil nil nil nil 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 770 34 2 818 #createAt:extent: 34 2 578 12287 21 578 501 281 416 818 #text: 34 1 8 'Please respond:' 416 898 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 249 24 0 0 150 0 0 0] 34 3 1088 1536 672 960 nil 27)! !
!UI.IntegerPrompter class categoriesForMethods!
defaultModel!models!public! !
on:prompt:caption:!instance creation!public! !
on:prompt:caption:interval:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

