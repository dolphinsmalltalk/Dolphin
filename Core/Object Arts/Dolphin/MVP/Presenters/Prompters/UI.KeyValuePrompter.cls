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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13107200 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 272 nil nil nil 7 nil nil nil 272 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 21 251 210 539 63 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 125 0 0 0 23 1 0 0 156 0 0 0] 8 #() 210 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 7 nil nil nil 576 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 5 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850944 1 704 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 8 '' nil nil 7 nil nil nil 704 nil 8 1853387904 518 #{UI.NullConverter} nil nil true 370 50 1 418 #createAt:extent: 50 2 210 21 21 210 509 51 704 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 8 1 0 0 35 0 0 0] 8 #() 560 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 21 1074 #fixedParentRight 1 1074 #fixedParentTop 21 1074 #fixedViewTop 51 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850944 1 1152 nil nil nil 7 nil nil nil 1152 nil 8 1853387904 866 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 21 91 210 91 41 1152 418 #text: 50 1 8 'Name:' 1152 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 45 0 0 0 55 0 0 0 65 0 0 0] 8 #() 560 nil 27 1042 1088 21 1074 #fixedViewLeft 91 1074 #fixedPreviousBottom 21 1136 41 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850944 1 1488 nil nil nil 7 nil nil nil 1488 nil 8 1853387904 866 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 25 163 210 77 41 1488 418 #text: 50 1 8 'Value:' 1488 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 81 0 0 0 50 0 0 0 101 0 0 0] 8 #() 560 nil 27 1042 1088 25 1456 77 1472 37 1136 41 18 #{UI.TextEdit} 50 20 nil 576 50 2 8 1140916352 1025 1792 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 1792 nil 8 1853175488 866 nil nil 1 #focusLost nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 131 155 210 409 45 1792 418 #setMarginWidths: 50 1 8 #(3 3) 1792 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 77 0 0 0 13 1 0 0 99 0 0 0] 8 #() 560 nil 45 1042 1074 #fixedPreviousRight 31 1104 11 1074 #fixedPreviousTop -7 1136 45 18 #{UI.TextEdit} 50 20 nil 576 50 2 8 1140916352 1025 2160 nil 1872 nil 7 nil nil nil 2160 nil 8 1853175488 866 nil nil 1 #focusLost nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 131 83 210 409 45 2160 418 #setMarginWidths: 50 1 8 #(3 3) 2160 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 41 0 0 0 13 1 0 0 63 0 0 0] 8 #() 560 nil 45 1042 2128 21 1104 11 2144 -7 1136 45 550 #{Core.IdentityDictionary} 3 704 8 'prompt' 1792 8 'value' 2160 8 'key' 518 #{Graphics.Rectangle} 210 1 1 210 11 1 370 50 1 418 #createAt:extent: 50 2 210 21 21 210 539 231 576 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 23 1 0 0 125 0 0 0] 50 5 704 1152 2160 1488 1792 560 nil 27 2466 0 2546 210 21 21 210 21 21 nil nil nil nil 13339 nil nil nil nil 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 370 50 2 418 #createAt:extent: 50 2 210 6143 21 210 611 411 32 418 #text: 50 1 8 'Please respond:' 32 498 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 48 13 0 0 215 0 0 0] 50 2 576 272 560 nil 27)! !
!UI.KeyValuePrompter class categoriesForMethods!
createOn:prompt:caption:!instance creation!public! !
icon!constants!public! !
on:prompt:caption:!instance creation!public! !
prompt:!instance creation!public! !
prompt:caption:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

