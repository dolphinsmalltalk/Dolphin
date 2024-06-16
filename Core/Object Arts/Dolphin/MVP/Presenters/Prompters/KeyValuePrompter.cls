"Filed out from Dolphin Smalltalk"!

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

!KeyValuePrompter categoriesForMethods!
createComponents!initializing!public! !
initialize!initializing!private! !
model:!accessing!public! !
prompt:!accessing!public! !
queryCommand:!commands!private! !
validationBlock!accessing!public! !
validationBlock:!accessing!public! !
!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13107200 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[10 0 0 0 125 0 0 0 23 1 0 0 156 0 0 0] 193 640 8 '' 608 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 5 nil nil nil 960 852230 ##(Smalltalk.FramingLayout) 170 176 34 10 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850944 1 1088 nil nil nil 5 nil nil nil 1088 nil 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 45 0 0 0 55 0 0 0 65 0 0 0] 193 1120 nil 1088 770 #text: 34 1 8 'Name:' 1088 3 8 #() 930 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 21 1442 #fixedViewLeft 91 1442 #fixedPreviousBottom 21 1442 #fixedViewTop 41 410 ##(Smalltalk.TextEdit) 34 16 nil 960 34 2 8 1140916352 1025 1520 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 1520 nil 8 1759000288 1170 nil nil 1 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[65 0 0 0 77 0 0 0 13 1 0 0 99 0 0 0] 193 1552 nil 1520 770 #setMarginWidths: 34 1 8 #(3 3) 1520 3 8 #() 930 193 193 nil 27 1410 1442 #fixedPreviousRight 31 1442 #fixedParentRight 11 1442 #fixedPreviousTop -7 1504 45 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850944 1 1920 nil nil nil 5 nil nil nil 1920 nil 8 1759212608 1170 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[12 0 0 0 81 0 0 0 50 0 0 0 101 0 0 0] 193 1952 nil 1920 770 #text: 34 1 8 'Value:' 1920 3 8 #() 930 193 193 nil 27 1410 1456 25 1472 77 1488 37 1504 41 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850944 1 2240 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 8 '' nil nil 5 nil nil nil 2240 nil 8 1759212608 1170 nil nil true 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 10 0 0 0 8 1 0 0 35 0 0 0] 193 2272 nil 2240 770 #text: 34 1 8 '' 2240 3 8 #() 930 193 193 nil 27 1410 1456 21 1888 1 1442 #fixedParentTop 21 1504 51 410 ##(Smalltalk.TextEdit) 34 16 nil 960 34 2 8 1140916352 1025 2656 nil 1600 nil 5 nil nil nil 2656 nil 8 1759000288 1170 nil nil 1 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[65 0 0 0 41 0 0 0 13 1 0 0 63 0 0 0] 193 2688 nil 2656 770 #setMarginWidths: 34 1 8 #(3 3) 2656 3 8 #() 930 193 193 nil 27 1410 1872 21 1888 11 1904 -7 1504 45 170 192 34 6 1520 8 'value' 2656 8 'key' 2240 8 'prompt' 590342 ##(Smalltalk.Rectangle) 930 1 1 930 11 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 10 0 0 0 23 1 0 0 125 0 0 0] 193 992 8 '' 960 3 34 5 2240 1088 2656 1920 1520 930 193 193 nil 27 170 192 912 3058 930 21 21 930 21 21 nil nil nil nil 11649 nil nil nil nil 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 3058 930 1 1 930 611 411 193 416 770 #setWindowText: 34 1 8 'Please respond:' 416 1 34 2 960 608 930 193 193 nil 29 )! !

!KeyValuePrompter class categoriesForMethods!
createOn:prompt:caption:!instance creation!public! !
icon!constants!public! !
on:prompt:caption:!instance creation!public! !
prompt:!instance creation!public! !
prompt:caption:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

