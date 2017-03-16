"Filed out from Dolphin Smalltalk 7"!

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
	intervalPresenter view range: self interval! !
!IntegerPrompter categoriesFor: #createComponents!initializing!public! !
!IntegerPrompter categoriesFor: #initialize!initializing!private! !
!IntegerPrompter categoriesFor: #interval!accessing!public! !
!IntegerPrompter categoriesFor: #interval:!accessing!public! !
!IntegerPrompter categoriesFor: #onViewOpened!event handling!public! !
!IntegerPrompter categoriesFor: #setSpinnerRange!helpers!private! !

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 852230 ##(Smalltalk.FramingLayout)  234 240 98 6 410 8 ##(Smalltalk.TextEdit)  98 16 0 416 98 2 8 1140924544 1025 592 0 482 512 0 7 0 0 0 592 0 8 4294903807 852742 ##(Smalltalk.IntegerToText)  0 8 '' 0 1 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  291 31 882 149 41 592 818 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 592 818 8 #isTextModified: 98 1 32 592 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 145 0 0 0 15 0 0 0 219 0 0 0 35 0 0 0] 98 0 882 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedPreviousRight 21 1170 8 #fixedViewLeft 149 1170 8 #fixedParentTop 1 1170 8 #fixedViewTop 41 410 8 ##(Smalltalk.StaticText)  98 16 0 416 98 2 8 1140850944 1 1312 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  8 '' 0 0 7 0 0 0 1312 0 8 4294903625 852486 ##(Smalltalk.NullConverter)  0 0 16 754 202 208 98 2 818 848 98 2 882 41 33 882 231 81 1312 818 8 #text: 98 1 8 'Enter number:' 1312 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 16 0 0 0 135 0 0 0 56 0 0 0] 98 0 1120 0 27 1138 1170 8 #fixedParentLeft 21 1216 231 1248 3 1280 81 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 1792 0 0 0 7 0 0 0 1792 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 754 202 208 98 1 818 848 98 2 882 21 145 882 449 53 1792 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 72 0 0 0 234 0 0 0 98 0 0 0] 98 0 1120 0 27 1138 1760 1 1170 8 #fixedParentRight 1 1170 8 #fixedViewBottom -51 1170 8 #fixedParentBottom 1 234 256 98 4 1312 8 'prompt' 592 8 'reply' 590342 ##(Smalltalk.Rectangle)  882 21 31 882 21 21 0 0 0 0 32123 0 0 0 0 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 754 202 208 98 3 818 848 98 2 882 2799 21 882 501 281 416 818 1648 98 1 8 'Please respond:' 416 818 8 #updateMenuBar 2080 416 1058 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 113 6 0 0 150 0 0 0] 98 3 1312 592 1792 1120 0 27 )! !
!IntegerPrompter class categoriesFor: #defaultModel!models!public! !
!IntegerPrompter class categoriesFor: #on:prompt:caption:!instance creation!public! !
!IntegerPrompter class categoriesFor: #on:prompt:caption:interval:!instance creation!public! !
!IntegerPrompter class categoriesFor: #resource_Default_view!public!resources-views! !

