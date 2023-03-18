"Filed out from Dolphin Smalltalk"!

UI.ValueDialog
	subclass: #'UI.Examples.NewVideoTapeDialog'
	instanceVariableNames: 'namePresenter lengthPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.NewVideoTapeDialog guid: (Core.GUID fromString: '{4166d470-8af8-4ed9-b347-41fe5ec72d9e}')!
UI.Examples.NewVideoTapeDialog comment: 'NewVideoTapeDialog provides a modal user interface gathering the necessary information that is required before a new VideoTape can be instantiated. The dialog is somewhat different than many other dialogs because it does not attempt to edit a specialised model (in this case a VideoTape). Since the VideoTape class has a Instance Creation Method, #name:length:, that require name and length parameters, the NewVideoTapeDialog is used only to collect this information prior to the creation of a tape instance. 

This class is part of the Video Library sample package. Please see the package comment for more details.

Example usage:
NewVideoTapeDialog showModal. "Display it"
'!
!UI.Examples.NewVideoTapeDialog categoriesForClass!Samples! !
!UI.Examples.NewVideoTapeDialog methodsFor!

apply
	"Apply the changes cached in the receiver back to the model. "

	self value: (VideoTape name: self name length: self length).
	super apply!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	namePresenter := self add: TextPresenter new name: 'name'.
	lengthPresenter := (self add: ChoicePresenter new name: 'length').
	



!

length
	"Answer the <Integer> contents of the length field"

	^lengthPresenter value!

name
	"Answer the <readableString> contents of the name field"

	^namePresenter value!

onViewOpened
	"Received when the receiver's view has been connected. "

	super onViewOpened.
	namePresenter value: '<New Tape>'.
	lengthPresenter
		choices: #(30 60 120 180 240);
		value: 240.
! !
!UI.Examples.NewVideoTapeDialog categoriesForMethods!
apply!commands!public! !
createComponents!initializing!public! !
length!accessing!public! !
name!accessing!public! !
onViewOpened!event handling!public! !
!

!UI.Examples.NewVideoTapeDialog class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^VideoTape icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13107200 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 nil 170 192 34 4 410 #{UI.TextEdit} 34 16 nil 416 34 2 8 1140916352 1025 640 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 640 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 1 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 223 31 578 279 41 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 111 0 0 0 15 0 0 0 250 0 0 0 35 0 0 0] 8 #() 578 193 193 nil 27 8 'name' 410 #{UI.ComboBox} 34 17 nil 416 34 2 8 1144063491 1025 1008 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 720 nil 7 nil nil nil 1008 nil 8 1814646992 786950 #{Core.Message} #displayString 1120 8 #() 401 786 34 1 834 #createAt:extent: 34 2 578 223 91 578 279 43 1008 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 111 0 0 0 45 0 0 0 250 0 0 0 66 0 0 0] 8 #() 976 nil 27 8 'length' nil nil nil nil nil 43237 nil nil nil nil 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 786 34 2 834 #createAt:extent: 34 2 578 12287 21 578 551 305 416 834 #text: 34 1 8 'Add New Tape' 416 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 18 25 0 0 162 0 0 0] 34 5 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 1632 nil nil nil 7 nil nil nil 1632 nil 8 1815137184 754 nil nil nil 786 34 2 834 #createAt:extent: 34 2 578 21 35 578 171 41 1632 834 #text: 34 1 8 'Tape Name:' 1632 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 17 0 0 0 95 0 0 0 37 0 0 0] 8 #() 976 nil 27 640 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 1920 nil nil nil 7 nil nil nil 1920 nil 8 1815137184 754 nil nil nil 786 34 2 834 #createAt:extent: 34 2 578 21 101 578 201 41 1920 834 #text: 34 1 8 'Tape Length (mins):' 1920 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 50 0 0 0 110 0 0 0 70 0 0 0] 8 #() 976 nil 27 1008 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 2208 nil nil nil 7 nil nil nil 2208 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 786 34 1 834 #createAt:extent: 34 2 578 175 147 578 331 67 2208 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 87 0 0 0 73 0 0 0 252 0 0 0 106 0 0 0] 1120 976 nil 27 976 nil 27)! !
!UI.Examples.NewVideoTapeDialog class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

