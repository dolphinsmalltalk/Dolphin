"Filed out from Dolphin Smalltalk 7"!

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
!NewVideoTapeDialog categoriesFor: #apply!commands!public! !
!NewVideoTapeDialog categoriesFor: #createComponents!initializing!public! !
!NewVideoTapeDialog categoriesFor: #length!accessing!public! !
!NewVideoTapeDialog categoriesFor: #name!accessing!public! !
!NewVideoTapeDialog categoriesFor: #onViewOpened!event handling!public! !

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 786950 ##(Smalltalk.DefaultColor) #dialog nil 167 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 nil 170 192 34 4 410 ##(Smalltalk.ComboBox) 34 17 nil 416 34 2 8 1144063491 1025 640 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 nil nil nil 640 nil 8 1912552560 ##(Smalltalk.BasicListAbstract) 752 401 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 223 91 578 279 43 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 111 0 0 0 45 0 0 0 250 0 0 0 66 0 0 0] 8 #() 578 193 193 nil 27 8 'length' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916352 1025 1104 nil 802 832 nil 7 nil nil nil 1104 nil 8 1912718128 852486 ##(Smalltalk.NullConverter) nil nil 1 866 138 144 34 1 930 #createAt:extent: 34 2 578 223 31 578 279 41 1104 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 111 0 0 0 15 0 0 0 250 0 0 0 35 0 0 0] 8 #() 1072 nil 27 8 'name' nil nil nil nil nil 23163 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2007257760 866 138 144 34 3 930 #createAt:extent: 34 2 578 3839 21 578 551 305 416 930 #text: 34 1 8 'Add New Tape' 416 930 #updateMenuBar 752 416 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 146 8 0 0 162 0 0 0] 34 5 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 1680 nil nil nil 7 nil nil nil 1680 nil 8 1912674480 1202 nil nil nil 866 138 144 34 2 930 #createAt:extent: 34 2 578 21 35 578 171 41 1680 930 #text: 34 1 8 'Tape Name:' 1680 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 17 0 0 0 95 0 0 0 37 0 0 0] 8 #() 1072 nil 27 1104 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 1984 nil nil nil 7 nil nil nil 1984 nil 8 1912674480 1202 nil nil nil 866 138 144 34 2 930 #createAt:extent: 34 2 578 21 101 578 201 41 1984 930 #text: 34 1 8 'Tape Length (mins):' 1984 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 50 0 0 0 110 0 0 0 70 0 0 0] 8 #() 1072 nil 27 640 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 2288 nil nil nil 7 nil nil nil 2288 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 866 138 144 34 1 930 #createAt:extent: 34 2 578 175 147 578 331 67 2288 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 87 0 0 0 73 0 0 0 252 0 0 0 106 0 0 0] 752 1072 nil 27 1072 nil 27 )! !
!NewVideoTapeDialog class categoriesFor: #icon!constants!public! !
!NewVideoTapeDialog class categoriesFor: #resource_Default_view!public!resources-views! !

