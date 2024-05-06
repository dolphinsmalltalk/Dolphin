"Filed out from Dolphin Smalltalk"!

Prompter subclass: #IntegerPrompter
	instanceVariableNames: 'intervalPresenter interval'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

IntegerPrompter guid: (GUID fromString: '{f0928363-bf5c-4f5e-98e2-714351f9e977}')!

IntegerPrompter comment: 'IntegerPrompter is a <Prompter> specialised to accept only integer input within a defined interval. The validation block is set so that the OK button is only enabled if the value in the reply field is a member of the interval. If the view has a SpinButton, then this is set to step between the elements of the interval.

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

!IntegerPrompter categoriesForClass!MVP-Presenters! !

!IntegerPrompter methodsFor!

createComponents
	"Create the presenters contained by the receiver."

	"Implementation Note: We don't supersend because we want to connect the reply field to a 
	NumberPresenter, not a TextPresenter."

	promptPresenter := self add: TextPresenter new name: 'prompt'.
	replyPresenter := self add: NumberPresenter new name: 'reply'.
	intervalPresenter := self add: NumberPresenter new name: 'spinner'!

initialize
	"Private - Initialize the receiver"

	super initialize.
	interval := 1 to: 100.
	validationBlock := [:reply | interval includes: reply]!

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

!IntegerPrompter categoriesForMethods!
createComponents!initializing!public! !
initialize!initializing!private! !
interval!accessing!public! !
interval:!accessing!public! !
onViewOpened!event handling!public! !
setSpinnerRange!helpers!private! !
!

!IntegerPrompter class methodsFor!

defaultModel
	^1 asValue!

on: aValueModel prompt: aStringPrompt caption: aStringCaptionOrNil 
	^self 
		on: aValueModel
		prompt: aStringPrompt
		caption: aStringCaptionOrNil
		interval: (1 to: SmallInteger maximum)!

on: aValueModel prompt: aStringPrompt caption: aStringCaptionOrNil interval: anInterval 
	"Creates an instance of the receiver on aValueModel with and aStringPrompt. 
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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 165 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140924544 1025 672 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 672 nil 8 1903872368 852742 ##(Smalltalk.IntegerToText) nil 8 '' nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 291 31 578 149 45 672 898 #setMarginWidths: 34 1 8 #(3 3) 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 15 0 0 0 219 0 0 0 37 0 0 0] 8 #() 578 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 21 1138 #fixedViewLeft 149 1138 #fixedParentTop 1 1138 #fixedViewTop 45 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 1216 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 '' nil nil 7 nil nil nil 1216 nil 8 1903849936 852486 ##(Smalltalk.NullConverter) nil nil true 834 138 144 34 2 898 #createAt:extent: 34 2 578 41 33 578 231 81 1216 898 #text: 34 1 8 'Enter number:' 1216 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 16 0 0 0 135 0 0 0 56 0 0 0] 8 #() 1088 nil 27 1106 1138 #fixedParentLeft 21 1168 231 1184 3 1200 81 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1648 nil nil nil 7 nil nil nil 1648 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 834 138 144 34 1 898 #createAt:extent: 34 2 578 25 125 578 429 61 1648 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 62 0 0 0 226 0 0 0 92 0 0 0] 8 #() 1088 nil 27 1106 1632 5 1138 #fixedParentRight 5 1138 #fixedViewBottom -59 1138 #fixedParentBottom 3 170 192 34 4 672 8 'reply' 1216 8 'prompt' 590342 ##(Smalltalk.Rectangle) 578 21 31 578 21 21 nil nil nil nil 12993 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 1998684880 834 138 144 34 3 898 #createAt:extent: 34 2 578 3839 21 578 501 281 416 898 #text: 34 1 8 'Please respond:' 416 898 #updateMenuBar 1888 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 121 8 0 0 150 0 0 0] 34 3 1216 672 1648 1088 nil 27 )! !

!IntegerPrompter class categoriesForMethods!
defaultModel!models!public! !
on:prompt:caption:!instance creation!public! !
on:prompt:caption:interval:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

