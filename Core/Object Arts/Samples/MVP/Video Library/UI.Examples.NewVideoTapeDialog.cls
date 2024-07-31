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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13107200 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 77 0 105 0 99 0 114 0 111 0 115 0 111 0 102 0 116 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 18 #{UI.ComboBox} 50 17 nil 32 50 2 8 1144063491 1025 256 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 256 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 401 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[111 0 0 0 45 0 0 0 250 0 0 0 7 1 0 0] 193 288 8 '' 256 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 8 'length' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140916352 1025 768 nil 432 nil 5 nil nil nil 768 nil nil 518 #{UI.NullConverter} nil nil 1 #focusLost nil nil nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[111 0 0 0 15 0 0 0 250 0 0 0 35 0 0 0] 193 800 nil 768 3 8 #() 722 193 193 nil 45 8 'name' nil nil nil nil nil 1 nil nil nil nil 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 514 50 2 562 #createWindow: 50 1 518 #{UI.CreateDialog} 518 #{Graphics.Rectangle} 722 7679 21 722 8229 325 193 32 562 #setWindowText: 50 1 8 'Add New Tape' 32 1 50 5 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 1280 nil nil nil 5 nil nil nil 1280 nil nil 834 nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[10 0 0 0 17 0 0 0 95 0 0 0 37 0 0 0] 193 1312 nil 1280 562 #text: 50 1 8 'Tape Name:' 1280 3 8 #() 722 193 193 nil 27 768 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 1552 nil nil nil 5 nil nil nil 1552 nil nil 834 nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[10 0 0 0 50 0 0 0 110 0 0 0 70 0 0 0] 193 1584 nil 1552 562 #text: 50 1 8 'Tape Length (mins):' 1552 3 8 #() 722 193 193 nil 27 256 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 1824 nil nil nil 5 nil nil nil 1824 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[87 0 0 0 73 0 0 0 252 0 0 0 106 0 0 0] 193 1856 8 '' 1824 3 8 #() 722 193 193 nil 27 722 193 193 nil 29)! !

!UI.Examples.NewVideoTapeDialog class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

