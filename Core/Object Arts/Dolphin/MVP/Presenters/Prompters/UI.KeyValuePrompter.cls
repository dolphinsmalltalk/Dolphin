"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'UI.KeyValuePrompter'
	instanceVariableNames: 'promptPresenter keyPresenter valuePresenter keyLabelPresenter valueLabelPresenter'
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
	keyLabelPresenter := self add: TextPresenter new name: 'keyLabel'.
	keyPresenter := self add: TextPresenter new name: 'key'.
	valueLabelPresenter := self add: TextPresenter new name: 'valueLabel'.
	valuePresenter := self add: TextPresenter new name: 'value'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	keyPresenter
		when: #valueChanged
		send: #onChanged
		to: self.
	valuePresenter
		when: #valueChanged
		send: #onChanged
		to: self
!

keyLabel: aString
	"Set the text to use as the label for the key/name field."

	keyLabelPresenter value: aString
!

keyPresenter
	^keyPresenter!

model: pairSubjectModel 
	| buf |
	super model: pairSubjectModel.
	buf := self model.
	keyPresenter model: (buf aspectValue: #key).
	valuePresenter model: (buf aspectValue: #value)!

onChanged
	"Private - The key or value has been edited. Initiate delayed validation."

	self deferredValidate!

prompt: aString
	"Set the text to use as the description in the dialog box."

	promptPresenter value: aString
!

validationResultPresenterClass
	^ValidationHintPresenter!

valueLabel: aString
	"Set the text to use as the label for the value field."

	valueLabelPresenter value: aString
!

valuePresenter
	^valuePresenter! !

!UI.KeyValuePrompter categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
keyLabel:!accessing!public! !
keyPresenter!accessing!public! !
model:!accessing!public! !
onChanged!event handling!private! !
prompt:!accessing!public! !
validationResultPresenterClass!constants!public! !
valueLabel:!accessing!public! !
valuePresenter!accessing!public! !
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13107200 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[10 0 0 0 125 0 0 0 23 1 0 0 156 0 0 0] 193 272 8 '' 240 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 10 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850944 1 720 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 8 '' nil nil 5 nil nil nil 720 nil nil 518 #{UI.NullConverter} nil nil true 338 50 1 386 #createWindow: 50 1 434 466 8 #[10 0 0 0 10 0 0 0 8 1 0 0 35 0 0 0] 193 752 nil 720 3 8 #() 546 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 21 1074 #fixedParentRight 1 1074 #fixedParentTop 21 1074 #fixedViewTop 51 18 #{UI.TextEdit} 50 20 nil 576 50 2 8 1140916352 1025 1152 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 1152 nil nil 866 nil nil 1 #perChar nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[65 0 0 0 41 0 0 0 13 1 0 0 63 0 0 0] 193 1184 nil 1152 386 #setMarginWidths: 50 1 8 #(3 3) 1152 3 8 #() 546 193 193 nil 45 1042 1074 #fixedPreviousRight 21 1104 11 1074 #fixedPreviousTop -7 1136 45 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850944 1 1504 nil nil nil 5 nil nil nil 1504 nil nil 866 nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[10 0 0 0 45 0 0 0 55 0 0 0 65 0 0 0] 193 1536 nil 1504 386 #text: 50 1 8 'Name:' 1504 3 8 #() 546 193 193 nil 27 1042 1088 21 1074 #fixedViewLeft 91 1074 #fixedPreviousBottom 21 1136 41 18 #{UI.TextEdit} 50 20 nil 576 50 2 8 1140916352 1025 1824 nil 1232 nil 5 nil nil nil 1824 nil nil 866 nil nil 1 #perChar nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[65 0 0 0 77 0 0 0 13 1 0 0 99 0 0 0] 193 1856 nil 1824 386 #setMarginWidths: 50 1 8 #(3 3) 1824 3 8 #() 546 193 193 nil 45 1042 1472 31 1104 11 1488 -7 1136 45 18 #{UI.StaticText} 50 16 nil 576 50 2 8 1140850944 1 2112 nil nil nil 5 nil nil nil 2112 nil nil 866 nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[12 0 0 0 81 0 0 0 50 0 0 0 101 0 0 0] 193 2144 nil 2112 386 #text: 50 1 8 'Value:' 2112 3 8 #() 546 193 193 nil 27 1042 1088 25 1792 77 1808 37 1136 41 674 #{Core.IdentityDictionary} 50 10 1152 8 'key' 1504 8 'keyLabel' 720 8 'prompt' 1824 8 'value' 2112 8 'valueLabel' 518 #{Graphics.Rectangle} 546 1 1 546 11 1 338 50 1 386 #createWindow: 50 1 434 466 8 #[10 0 0 0 10 0 0 0 23 1 0 0 125 0 0 0] 193 608 8 '' 576 3 50 5 720 1504 1152 2112 1824 546 193 193 nil 27 550 #{Core.IdentityDictionary} 0 2514 546 21 21 546 21 21 nil nil nil nil 1 nil nil nil nil 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 338 50 2 386 #createWindow: 50 1 518 #{UI.CreateDialog} 2514 546 7679 21 546 8289 431 193 32 386 #setWindowText: 50 1 8 'Please respond:' 32 1 50 2 576 240 546 193 193 nil 29)! !

!UI.KeyValuePrompter class categoriesForMethods!
createOn:prompt:caption:!instance creation!public! !
icon!constants!public! !
on:prompt:caption:!instance creation!public! !
prompt:!instance creation!public! !
prompt:caption:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

