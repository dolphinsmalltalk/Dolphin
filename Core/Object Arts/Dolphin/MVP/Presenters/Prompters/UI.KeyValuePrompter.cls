"Filed out from Dolphin Smalltalk 7"!

UI.Dialog subclass: #'UI.KeyValuePrompter'
	instanceVariableNames: 'promptPresenter keyPresenter valuePresenter validationBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.KeyValuePrompter guid: (Core.GUID fromString: '{a84461c7-be36-46c1-be33-5752489de6e5}')!
UI.KeyValuePrompter comment: 'KeyValuePrompter is a <dialogPresenter> that can be used to prompt a user to enter or edit key-value pair strings in response to a question.

Instance Variables:
	promptPresenter	<TextPresenter> holding the prompt text.
	keyPresenter		<TextPresenter> holding the key text.
	valuePresenter	<TextPresenter> holding the value text.
	validationBlock	<dyadicValuable> evaluated to validate the key-value pair
'!
!UI.KeyValuePrompter categoriesForClass!MVP-Prompters! !
!UI.KeyValuePrompter methodsFor!

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
!UI.KeyValuePrompter categoriesFor: #createComponents!initializing!public! !
!UI.KeyValuePrompter categoriesFor: #initialize!initializing!private! !
!UI.KeyValuePrompter categoriesFor: #model:!accessing!public! !
!UI.KeyValuePrompter categoriesFor: #prompt:!accessing!public! !
!UI.KeyValuePrompter categoriesFor: #queryCommand:!commands!private! !
!UI.KeyValuePrompter categoriesFor: #validationBlock!accessing!public! !
!UI.KeyValuePrompter categoriesFor: #validationBlock:!accessing!public! !

!UI.KeyValuePrompter class methodsFor!

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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 165 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 655878 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 21 251 578 539 63 640 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 125 0 0 0 23 1 0 0 156 0 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 7 nil nil nil 960 1048838 ##(UI.FramingLayout) 170 176 34 10 410 ##(UI.StaticText) 34 16 nil 960 34 2 8 1140850944 1 1088 918598 2 ##(UI.ValueHolder) nil nil 1441798 ##(Kernel.NeverSearchPolicy) 8 '' nil nil 7 nil nil nil 1088 nil 8 1920531648 1049094 ##(UI.NullConverter) nil nil true 738 138 144 34 1 802 #createAt:extent: 34 2 578 21 21 578 509 51 1088 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 8 1 0 0 35 0 0 0] 8 #() 944 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 21 1474 #fixedParentRight 1 1474 #fixedParentTop 21 1474 #fixedViewTop 51 410 ##(UI.TextEdit) 34 16 nil 960 34 2 8 1140916352 1025 1552 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1552 nil 8 1920675248 1250 nil nil 1 738 138 144 34 2 802 #createAt:extent: 34 2 578 131 83 578 409 45 1552 802 #setMarginWidths: 34 1 8 #(3 3) 1552 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 41 0 0 0 13 1 0 0 63 0 0 0] 8 #() 944 nil 27 1442 1474 #fixedPreviousRight 21 1504 11 1474 #fixedPreviousTop -7 1536 45 410 ##(UI.StaticText) 34 16 nil 960 34 2 8 1140850944 1 1936 nil nil nil 7 nil nil nil 1936 nil 8 1920531648 1250 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 21 91 578 91 41 1936 802 #text: 34 1 8 'Name:' 1936 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 45 0 0 0 55 0 0 0 65 0 0 0] 8 #() 944 nil 27 1442 1488 21 1474 #fixedViewLeft 91 1474 #fixedPreviousBottom 21 1536 41 410 ##(UI.StaticText) 34 16 nil 960 34 2 8 1140850944 1 2288 nil nil nil 7 nil nil nil 2288 nil 8 1920531648 1250 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 25 163 578 77 41 2288 802 #text: 34 1 8 'Value:' 2288 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 81 0 0 0 50 0 0 0 101 0 0 0] 8 #() 944 nil 27 1442 1488 25 2256 77 2272 37 1536 41 410 ##(UI.TextEdit) 34 16 nil 960 34 2 8 1140916352 1025 2608 nil 1632 nil 7 nil nil nil 2608 nil 8 1920675248 1250 nil nil 1 738 138 144 34 2 802 #createAt:extent: 34 2 578 131 155 578 409 45 2608 802 #setMarginWidths: 34 1 8 #(3 3) 2608 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 77 0 0 0 13 1 0 0 99 0 0 0] 8 #() 944 nil 27 1442 1904 31 1504 11 1920 -7 1536 45 170 192 34 6 2608 8 'value' 1088 8 'prompt' 1552 8 'key' 1180166 ##(Graphics.Rectangle) 578 1 1 578 11 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 21 21 578 539 231 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 23 1 0 0 125 0 0 0] 34 5 1088 1936 1552 2288 2608 944 nil 27 170 192 928 3010 578 21 21 578 21 21 nil nil nil nil 26365 nil nil nil nil 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2005493520 738 138 144 34 2 802 #createAt:extent: 34 2 578 6143 21 578 611 411 416 802 #text: 34 1 8 'Please respond:' 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 48 13 0 0 215 0 0 0] 34 2 960 640 944 nil 27)! !
!UI.KeyValuePrompter class categoriesFor: #createOn:prompt:caption:!instance creation!public! !
!UI.KeyValuePrompter class categoriesFor: #icon!constants!public! !
!UI.KeyValuePrompter class categoriesFor: #on:prompt:caption:!instance creation!public! !
!UI.KeyValuePrompter class categoriesFor: #prompt:!instance creation!public! !
!UI.KeyValuePrompter class categoriesFor: #prompt:caption:!instance creation!public! !
!UI.KeyValuePrompter class categoriesFor: #resource_Default_view!public!resources-views! !

