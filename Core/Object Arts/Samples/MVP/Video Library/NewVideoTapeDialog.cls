"Filed out from Dolphin Smalltalk"!

ValueDialog subclass: #NewVideoTapeDialog
	instanceVariableNames: 'namePresenter lengthPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NewVideoTapeDialog guid: (GUID fromString: '{4166d470-8af8-4ed9-b347-41fe5ec72d9e}')!

NewVideoTapeDialog comment: 'NewVideoTapeDialog provides a modal user interface gathering the necessary information that is required before a new VideoTape can be instantiated. The dialog is somewhat different than many other dialogs because it does not attempt to edit a specialised model (in this case a VideoTape). Since the VideoTape class has a Instance Creation Method, #name:length:, that require name and length parameters, the NewVideoTapeDialog is used only to collect this information prior to the creation of a tape instance. 

This class is part of the Video Library sample package. Please see the package comment for more details.

Example usage:
NewVideoTapeDialog showModal. "Display it"
'!

!NewVideoTapeDialog categoriesForClass!Samples! !

!NewVideoTapeDialog methodsFor!

apply
	"Apply the changes cached in the receiver back to the model. "

	self value: (VideoTape name: self name length: self length).
	super apply

	!

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

!NewVideoTapeDialog categoriesForMethods!
apply!commands!public! !
createComponents!initializing!public! !
length!accessing!public! !
name!accessing!public! !
onViewOpened!event handling!public! !
!

!NewVideoTapeDialog class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^VideoTape icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13107200 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 77 0 105 0 99 0 114 0 111 0 115 0 111 0 102 0 116 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 nil 170 192 34 4 410 ##(Smalltalk.ComboBox) 34 17 nil 416 34 2 8 1144063491 1025 608 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 608 nil 8 1758616864 ##(Smalltalk.BasicListAbstract) 8 #() 401 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[111 0 0 0 45 0 0 0 250 0 0 0 7 1 0 0] 193 640 8 '' 608 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'length' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916352 1025 1104 nil 784 nil 5 nil nil nil 1104 nil 8 1759000288 852486 ##(Smalltalk.NullConverter) nil nil 1 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[111 0 0 0 15 0 0 0 250 0 0 0 35 0 0 0] 193 1136 nil 1104 3 8 #() 1058 193 193 nil 27 8 'name' nil nil nil nil nil 11905 nil nil nil nil 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 834 138 144 34 2 898 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 590342 ##(Smalltalk.Rectangle) 1058 1 1 1058 551 305 193 416 898 #setWindowText: 34 1 8 'Add New Tape' 416 1 34 5 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 1680 nil nil nil 5 nil nil nil 1680 nil 8 1759212608 1186 nil nil nil 834 138 144 34 2 898 #createWindow: 34 1 946 978 8 #[10 0 0 0 17 0 0 0 95 0 0 0 37 0 0 0] 193 1712 nil 1680 898 #text: 34 1 8 'Tape Name:' 1680 3 8 #() 1058 193 193 nil 27 1104 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 1984 nil nil nil 5 nil nil nil 1984 nil 8 1759212608 1186 nil nil nil 834 138 144 34 2 898 #createWindow: 34 1 946 978 8 #[10 0 0 0 50 0 0 0 110 0 0 0 70 0 0 0] 193 2016 nil 1984 898 #text: 34 1 8 'Tape Length (mins):' 1984 3 8 #() 1058 193 193 nil 27 608 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2288 nil nil nil 5 nil nil nil 2288 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[87 0 0 0 73 0 0 0 252 0 0 0 106 0 0 0] 193 2320 8 '' 2288 3 720 1058 193 193 nil 27 1058 193 193 nil 29 )! !

!NewVideoTapeDialog class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

