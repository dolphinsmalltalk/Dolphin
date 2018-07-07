"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #KeyValuePrompter
	instanceVariableNames: 'promptPresenter keyPresenter valuePresenter validationBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
KeyValuePrompter guid: (GUID fromString: '{a84461c7-be36-46c1-be33-5752489de6e5}')!
KeyValuePrompter comment: 'KeyValuePrompter is a <dialogPresenter> that can be used to prompt a user to enter or edit key-value pair strings in response to a question.

Instance Variables:
	promptPresenter	<TextPresenter> holding the prompt text.
	keyPresenter		<TextPresenter> holding the key text.
	valuePresenter	<TextPresenter> holding the value text.
	validationBlock	<dyadicValuable> evaluated to validate the key-value pair
'!
!KeyValuePrompter categoriesForClass!MVP-Prompters! !
!KeyValuePrompter methodsFor!

createComponents
	"Create the presenters contained by the receiver."

	super createComponents.
	promptPresenter := self add: TextPresenter new name: 'prompt'.
	keyPresenter := self add: TextPresenter new name: 'key'.
	valuePresenter := self add: TextPresenter new name: 'value'!

initialize
	"Private - Initialize the receiver"

	super initialize.
	validationBlock := [:key :value | true]!

model: pairSubjectModel 
	| buf |
	super model: pairSubjectModel.
	buf := self model.
	keyPresenter model: (buf aspectValue: #key).
	valuePresenter model: (buf aspectValue: #value)!

prompt: aString
	"Set the text to use as the description in the dialog box."

	promptPresenter value: aString
!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>."

	aCommandQuery commandSymbol == #ok 
		ifTrue: 
			[aCommandQuery 
				isEnabled: (self validationBlock value: keyPresenter value value: valuePresenter value) == true.
			^true].
	^super queryCommand: aCommandQuery!

validationBlock
	^validationBlock!

validationBlock: aDyadicValuable 
	validationBlock := aDyadicValuable! !
!KeyValuePrompter categoriesFor: #createComponents!initializing!public! !
!KeyValuePrompter categoriesFor: #initialize!initializing!private! !
!KeyValuePrompter categoriesFor: #model:!accessing!public! !
!KeyValuePrompter categoriesFor: #prompt:!accessing!public! !
!KeyValuePrompter categoriesFor: #queryCommand:!commands!private! !
!KeyValuePrompter categoriesFor: #validationBlock!accessing!public! !
!KeyValuePrompter categoriesFor: #validationBlock:!accessing!public! !

!KeyValuePrompter class methodsFor!

createOn: pairValueModel prompt: promptString caption: captionStringOrNil 
	"Creates an instance of the receiver on pairValueModel and promptString. The prompter is
	given a caption according to captionStringOrNil; if nil a default caption is used.. The
	initial value of the reply field will be the original value of the model The model must
	expose #key and #value aspects, e.g. an Association. The dialog is not shown."

	| answer |
	answer := self createOn: pairValueModel.
	answer prompt: promptString.
	captionStringOrNil notNil ifTrue: [answer caption: captionStringOrNil].
	^answer!

icon
	"Answers an Icon that can be used to represent this class and which is displayed in the
	caption of the dialog box."

	^Icon fromId: '!!APPLICATION'!

on: pairValueModel prompt: promptString caption: captionStringOrNil 
	"Creates an instance of the receiver on pairValueModel and promptString. The prompter is
	given a caption according to captionStringOrNil; if nil a default caption is used. The
	prompter is displayed modally, prompting for a key-value pair reply. The initial value of
	the reply field is the original value of the model The model must expose #key and #value
	aspects, e.g. an Association.

	Answer the reply or nil if the dialog is cancelled."

	^(self 
		createOn: pairValueModel
		prompt: promptString
		caption: captionStringOrNil) showModal!

prompt: promptString 
	"Creates an instance of the receiver with the specified prompt string and a default caption.
	The prompter is displayed modally, prompting for a key-value pair reply.

	Answer the reply or nil if the dialog is cancelled"

	^self prompt: promptString caption: nil!

prompt: promptString caption: captionStringOrNil 
	"Creates an instance of the receiver with the specified prompt string and caption.. If the
	captionStringOrNil is nil then a default caption is used. The prompter is displayed modally,
	prompting for a key-value pair reply.

	Answer the reply or nil if the dialog is cancelled."

	^self 
		on: Association new
		prompt: promptString
		caption: captionStringOrNil!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 626 1 1 410 ##(Smalltalk.StaticRectangle) 34 14 nil 656 34 2 8 1140850960 1 736 nil nil nil 7 nil nil nil 736 nil 8 1906774720 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 594 1 1 594 539 5 736 882 #isEnabled: 8 #(false) 736 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 13 1 0 0 2 0 0 0] 8 #() 594 193 193 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 656 34 2 8 1140850688 131073 1072 nil nil nil 7 nil nil nil 1072 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 818 138 144 34 1 882 #createAt:extent: 34 2 594 1 -9 594 539 81 1072 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 251 255 255 255 13 1 0 0 35 0 0 0] 8 #() 1056 nil 27 nil nil nil 170 192 1312 590342 ##(Smalltalk.Rectangle) 594 1 1 594 1 1 818 138 144 34 1 882 #createAt:extent: 34 2 594 21 243 594 539 71 656 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 121 0 0 0 23 1 0 0 156 0 0 0] 34 2 736 1072 1056 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1568 nil nil nil 7 nil nil nil 1568 852230 ##(Smalltalk.FramingLayout) 170 176 34 10 410 ##(Smalltalk.TextEdit) 34 16 nil 1568 34 2 8 1140916352 1025 1696 nil 466 496 nil 7 nil nil nil 1696 nil 8 1906818384 852486 ##(Smalltalk.NullConverter) nil nil 1 818 138 144 34 2 882 #createAt:extent: 34 2 594 131 83 594 399 45 1696 882 #setMarginWidths: 34 1 8 #(3 3) 1696 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 41 0 0 0 8 1 0 0 63 0 0 0] 8 #() 1056 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 21 2066 #fixedParentRight 1 2066 #fixedPreviousTop -7 2066 #fixedViewTop 45 410 ##(Smalltalk.StaticText) 34 16 nil 1568 34 2 8 1140850944 1 2144 nil nil nil 7 nil nil nil 2144 nil 8 1906774720 1794 nil nil nil 818 138 144 34 2 882 #createAt:extent: 34 2 594 21 91 594 91 41 2144 882 #text: 34 1 8 'Name:' 2144 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 45 0 0 0 55 0 0 0 65 0 0 0] 8 #() 1056 nil 27 2034 2066 #fixedParentLeft 21 2066 #fixedViewLeft 91 2066 #fixedPreviousBottom 21 2128 41 410 ##(Smalltalk.StaticText) 34 16 nil 1568 34 2 8 1140850944 1 2512 nil nil nil 7 nil nil nil 2512 nil 8 1906774720 1794 nil nil nil 818 138 144 34 2 882 #createAt:extent: 34 2 594 25 163 594 77 41 2512 882 #text: 34 1 8 'Value:' 2512 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 81 0 0 0 50 0 0 0 101 0 0 0] 8 #() 1056 nil 27 2034 2464 25 2480 77 2496 37 2128 41 410 ##(Smalltalk.StaticText) 34 16 nil 1568 34 2 8 1140850944 1 2832 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 '' nil nil 7 nil nil nil 2832 nil 8 1906774720 1794 nil nil true 818 138 144 34 1 882 #createAt:extent: 34 2 594 21 21 594 509 51 2832 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 8 1 0 0 35 0 0 0] 8 #() 1056 nil 27 2034 2464 21 2096 1 2066 #fixedParentTop 21 2128 51 410 ##(Smalltalk.TextEdit) 34 16 nil 1568 34 2 8 1140916352 1025 3200 nil 466 496 nil 7 nil nil nil 3200 nil 8 1906818384 1794 nil nil 1 818 138 144 34 2 882 #createAt:extent: 34 2 594 131 155 594 401 45 3200 882 #setMarginWidths: 34 1 8 #(3 3) 3200 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 77 0 0 0 9 1 0 0 99 0 0 0] 8 #() 1056 nil 27 2034 2080 31 2096 3 2112 -7 2128 45 170 192 34 6 3200 8 'value' 2832 8 'prompt' 1696 8 'key' 1346 594 1 1 594 11 1 818 138 144 34 1 882 #createAt:extent: 34 2 594 21 21 594 539 223 1568 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 23 1 0 0 121 0 0 0] 34 5 2832 2144 1696 2512 3200 1056 nil 27 170 192 1312 1346 594 21 21 594 21 21 nil nil nil nil 17597 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010075552 818 138 144 34 3 882 #createAt:extent: 34 2 594 3839 21 594 611 411 416 882 #text: 34 1 8 'Please respond:' 416 882 #updateMenuBar 1312 416 994 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 176 8 0 0 215 0 0 0] 34 2 1568 656 1056 nil 27 )! !
!KeyValuePrompter class categoriesFor: #createOn:prompt:caption:!instance creation!public! !
!KeyValuePrompter class categoriesFor: #icon!constants!public! !
!KeyValuePrompter class categoriesFor: #on:prompt:caption:!instance creation!public! !
!KeyValuePrompter class categoriesFor: #prompt:!instance creation!public! !
!KeyValuePrompter class categoriesFor: #prompt:caption:!instance creation!public! !
!KeyValuePrompter class categoriesFor: #resource_Default_view!public!resources-views! !

