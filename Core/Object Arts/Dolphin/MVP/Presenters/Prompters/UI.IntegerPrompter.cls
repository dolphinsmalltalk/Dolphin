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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13107200 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 6 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140924544 1025 320 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 320 nil nil 1094 1 #{UI.IntegerToText} nil 8 '' 326 1 #{Core.Locale} #userDefault nil 1 #perChar nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 291 31 210 149 45 320 546 #setMarginWidths: 50 1 8 #(3 3) 320 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 15 0 0 0 219 0 0 0 37 0 0 0] 8 #() 210 193 193 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 21 786 #fixedViewLeft 149 786 #fixedParentTop 1 786 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 864 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 8 '' nil nil 5 nil nil nil 864 nil nil 518 #{UI.NullConverter} nil nil true 498 50 2 546 #createAt:extent: 50 2 210 41 33 210 231 81 864 546 #text: 50 1 8 'Enter number:' 864 674 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 16 0 0 0 135 0 0 0 56 0 0 0] 8 #() 736 nil 27 754 786 #fixedParentLeft 21 816 231 832 3 848 81 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 1264 nil nil nil 5 nil nil nil 1264 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 498 50 1 546 #createAt:extent: 50 2 210 25 125 210 429 61 1264 674 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 62 0 0 0 226 0 0 0 92 0 0 0] 8 #() 736 nil 27 754 1248 5 786 #fixedParentRight 5 786 #fixedViewBottom -59 786 #fixedParentBottom 3 274 #{Core.IdentityDictionary} 50 4 864 8 'prompt' 320 8 'reply' 518 #{Graphics.Rectangle} 210 21 31 210 21 21 nil nil nil nil 1 nil nil nil nil 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 498 50 2 546 #createAt:extent: 50 2 210 6143 21 210 501 281 32 546 #text: 50 1 8 'Please respond:' 32 674 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 249 12 0 0 150 0 0 0] 50 3 864 320 1264 736 nil 27)! !
!UI.IntegerPrompter class categoriesForMethods!
defaultModel!models!public! !
on:prompt:caption:!instance creation!public! !
on:prompt:caption:interval:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

