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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 672 0 0 0 7 0 0 0 672 642 1 1 410 8 ##(Smalltalk.StaticRectangle)  98 14 0 672 98 2 8 1140850960 1 768 0 0 0 7 0 0 0 768 0 8 4294903625 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 610 1 1 610 559 5 768 930 8 #isEnabled: 98 1 32 768 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 23 1 0 0 2 0 0 0] 98 0 610 193 193 0 27 410 8 ##(Smalltalk.ReferenceView)  98 14 0 672 98 2 8 1140850688 131073 1152 0 0 0 7 0 0 0 1152 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 866 202 208 98 1 930 960 98 2 610 1 -9 610 559 81 1152 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 251 255 255 255 23 1 0 0 35 0 0 0] 98 0 1136 0 27 0 0 0 234 256 1440 590342 ##(Smalltalk.Rectangle)  610 1 1 610 1 1 866 202 208 98 1 930 960 98 2 610 21 257 610 559 71 672 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 128 0 0 0 33 1 0 0 163 0 0 0] 98 2 768 1152 1136 0 27 0 0 410 688 98 15 0 416 98 2 8 1140850688 131073 1696 0 0 0 7 0 0 0 1696 852230 ##(Smalltalk.FramingLayout)  234 240 98 10 410 8 ##(Smalltalk.TextEdit)  98 16 0 1696 98 2 8 1140916352 1025 1824 0 482 512 0 7 0 0 0 1824 0 8 4294903807 852486 ##(Smalltalk.NullConverter)  0 0 1 866 202 208 98 3 930 960 98 2 610 131 153 610 421 41 1824 930 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 1824 930 8 #isTextModified: 98 1 32 1824 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 76 0 0 0 19 1 0 0 96 0 0 0] 98 0 1136 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedPreviousRight 31 2290 8 #fixedParentRight 3 2290 8 #fixedPreviousTop -7 2290 8 #fixedViewTop 41 410 8 ##(Smalltalk.StaticText)  98 16 0 1696 98 2 8 1140850944 1 2432 0 0 0 7 0 0 0 2432 0 8 4294903625 1938 0 0 0 866 202 208 98 2 930 960 98 2 610 25 161 610 77 27 2432 930 8 #text: 98 1 8 'Value:' 2432 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 80 0 0 0 50 0 0 0 93 0 0 0] 98 0 1136 0 27 2258 2290 8 #fixedParentLeft 25 2290 8 #fixedViewLeft 77 2290 8 #fixedPreviousBottom 37 2400 27 410 1840 98 16 0 1696 98 2 8 1140916352 1025 2880 0 482 512 0 7 0 0 0 2880 0 8 4294903807 1938 0 0 1 866 202 208 98 3 930 960 98 2 610 131 83 610 419 43 2880 930 2096 98 1 2130 3 1 3 2880 930 2176 98 1 32 2880 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 41 0 0 0 18 1 0 0 62 0 0 0] 98 0 1136 0 27 2258 2304 21 2336 1 2368 -7 2400 43 410 2448 98 16 0 1696 98 2 8 1140850944 1 3248 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  8 '' 0 0 7 0 0 0 3248 0 8 4294903625 1938 0 0 16 866 202 208 98 1 930 960 98 2 610 21 21 610 529 51 3248 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 18 1 0 0 35 0 0 0] 98 0 1136 0 27 2258 2784 21 2336 1 2290 8 #fixedParentTop 21 2400 51 410 2448 98 16 0 1696 98 2 8 1140850944 1 3632 0 0 0 7 0 0 0 3632 0 8 4294903625 1938 0 0 0 866 202 208 98 2 930 960 98 2 610 21 91 610 91 27 3632 930 2672 98 1 8 'Name:' 3632 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 45 0 0 0 55 0 0 0 58 0 0 0] 98 0 1136 0 27 2258 2784 21 2816 91 2848 21 2400 27 234 256 98 6 2880 8 'key' 3248 8 'prompt' 1824 8 'value' 1474 610 1 1 610 11 1 866 202 208 98 1 930 960 98 2 610 21 21 610 559 237 1696 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 33 1 0 0 128 0 0 0] 98 5 3248 3632 2880 2432 1824 1136 0 27 234 256 1440 1474 610 21 21 610 21 21 0 0 0 0 31853 0 0 0 0 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 866 202 208 98 3 930 960 98 2 610 2799 21 610 611 411 416 930 2672 98 1 8 'Please respond:' 416 930 8 #updateMenuBar 1440 416 1074 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 168 6 0 0 215 0 0 0] 98 2 1696 672 1136 0 27 )! !
!KeyValuePrompter class categoriesFor: #createOn:prompt:caption:!instance creation!public! !
!KeyValuePrompter class categoriesFor: #icon!constants!public! !
!KeyValuePrompter class categoriesFor: #on:prompt:caption:!instance creation!public! !
!KeyValuePrompter class categoriesFor: #prompt:!instance creation!public! !
!KeyValuePrompter class categoriesFor: #prompt:caption:!instance creation!public! !
!KeyValuePrompter class categoriesFor: #resource_Default_view!public!resources-views! !

