"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'UI.KeyValuePrompter'
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
!UI.KeyValuePrompter categoriesForMethods!
createComponents!initializing!public! !
initialize!initializing!private! !
model:!accessing!public! !
prompt:!accessing!public! !
queryCommand:!commands!private! !
validationBlock!accessing!public! !
validationBlock:!accessing!public! !
!

!UI.KeyValuePrompter class methodsFor!

createOn: pairValueModel prompt: promptString caption: captionStringOrNil 
	"Creates an instance of the receiver on pairValueModel and promptString. The prompter is
	given a caption according to captionStringOrNil; if nil a default caption is used. The
	initial value of the reply field will be the original value of the model. The model must
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
	the reply field is the original value of the model. The model must expose #key and #value
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
	"Creates an instance of the receiver with the specified prompt string and caption. If the
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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13107200 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 21 251 578 539 63 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 125 0 0 0 23 1 0 0 156 0 0 0] 8 #() 578 193 193 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 944 nil nil nil 7 nil nil nil 944 1048838 #{UI.FramingLayout} 170 176 34 10 410 #{UI.StaticText} 34 16 nil 944 34 2 8 1140850944 1 1072 nil nil nil 7 nil nil nil 1072 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 25 163 578 77 41 1072 786 #text: 34 1 8 'Value:' 1072 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 81 0 0 0 50 0 0 0 101 0 0 0] 8 #() 928 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 25 1410 #fixedViewLeft 77 1410 #fixedPreviousBottom 37 1410 #fixedViewTop 41 410 #{UI.StaticText} 34 16 nil 944 34 2 8 1140850944 1 1488 nil nil nil 7 nil nil nil 1488 nil 8 1815137184 1154 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 21 91 578 91 41 1488 786 #text: 34 1 8 'Name:' 1488 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 45 0 0 0 55 0 0 0 65 0 0 0] 8 #() 928 nil 27 1378 1424 21 1440 91 1456 21 1472 41 410 #{UI.TextEdit} 34 16 nil 944 34 2 8 1140916352 1025 1792 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 1792 nil 8 1815092992 1154 nil nil 1 738 34 2 786 #createAt:extent: 34 2 578 131 83 578 409 45 1792 786 #setMarginWidths: 34 1 8 #(3 3) 1792 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 41 0 0 0 13 1 0 0 63 0 0 0] 8 #() 928 nil 27 1378 1410 #fixedPreviousRight 21 1410 #fixedParentRight 11 1410 #fixedPreviousTop -7 1472 45 410 #{UI.TextEdit} 34 16 nil 944 34 2 8 1140916352 1025 2176 nil 1872 nil 7 nil nil nil 2176 nil 8 1815092992 1154 nil nil 1 738 34 2 786 #createAt:extent: 34 2 578 131 155 578 409 45 2176 786 #setMarginWidths: 34 1 8 #(3 3) 2176 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 77 0 0 0 13 1 0 0 99 0 0 0] 8 #() 928 nil 27 1378 2128 31 2144 11 2160 -7 1472 45 410 #{UI.StaticText} 34 16 nil 944 34 2 8 1140850944 1 2480 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} 8 '' nil nil 7 nil nil nil 2480 nil 8 1815137184 1154 nil nil true 738 34 1 786 #createAt:extent: 34 2 578 21 21 578 509 51 2480 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 8 1 0 0 35 0 0 0] 8 #() 928 nil 27 1378 1424 21 2144 1 1410 #fixedParentTop 21 1472 51 170 192 34 6 1792 8 'key' 2480 8 'prompt' 2176 8 'value' 1180166 #{Graphics.Rectangle} 578 1 1 578 11 1 738 34 1 786 #createAt:extent: 34 2 578 21 21 578 539 231 944 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 23 1 0 0 125 0 0 0] 34 5 2480 1488 1792 1072 2176 928 nil 27 170 192 912 2914 578 21 21 578 21 21 nil nil nil nil 60891 nil nil nil nil 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 738 34 2 786 #createAt:extent: 34 2 578 12287 21 578 611 411 416 786 #text: 34 1 8 'Please respond:' 416 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 48 25 0 0 215 0 0 0] 34 2 944 640 928 nil 27)! !
!UI.KeyValuePrompter class categoriesForMethods!
createOn:prompt:caption:!instance creation!public! !
icon!constants!public! !
on:prompt:caption:!instance creation!public! !
prompt:!instance creation!public! !
prompt:caption:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

