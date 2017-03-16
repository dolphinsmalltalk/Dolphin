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

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(ColorRef)  8 4278190080 0 133 0 263174 ##(Font)  0 16 459014 ##(LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Point)  193 193 0 416 0 234 256 98 4 410 8 ##(TextEdit)  98 16 0 416 98 2 8 1140916352 1025 672 0 482 512 0 5 0 0 0 672 0 8 4294906635 852486 ##(NullConverter)  0 0 1 983302 ##(MessageSequence)  202 208 98 3 721670 ##(MessageSend)  8 #createAt:extent: 98 2 610 231 31 610 291 41 672 882 8 #selectionRange: 98 1 525062 ##(Interval)  3 1 3 672 882 8 #isTextModified: 98 1 32 672 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 115 0 0 0 15 0 0 0 4 1 0 0 35 0 0 0] 98 0 610 193 193 0 27 8 'name' 410 8 ##(ComboBox)  98 17 0 416 98 2 8 1144063491 1025 1200 590662 2 ##(ListModel)  202 208 98 0 0 1114638 ##(STBSingletonProxy)  8 ##(SearchPolicy)  8 #identity 482 512 0 5 0 0 0 1200 0 8 4294906641 8 ##(BasicListAbstract)  1328 401 818 202 208 98 1 882 912 98 2 610 231 91 610 291 43 1200 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 115 0 0 0 45 0 0 0 4 1 0 0 66 0 0 0] 98 0 1168 0 27 8 'length' 0 0 0 0 0 13383 0 0 0 0 1 0 0 590598 ##(Semaphore)  0 0 1 0 8 2010572111 818 202 208 98 3 882 912 98 2 610 1325 1049 610 551 305 416 882 8 #text: 98 1 8 'Add New Tape' 416 882 8 #menuBar: 98 1 0 416 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 150 2 0 0 12 2 0 0 169 3 0 0 164 2 0 0] 98 5 410 8 ##(StaticText)  98 16 0 416 98 2 8 1140850944 1 1952 0 0 0 5 0 0 0 1952 0 8 4294906439 786 0 0 0 818 202 208 98 2 882 912 98 2 610 21 31 610 171 41 1952 882 1808 98 1 8 'Tape Name:' 1952 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 15 0 0 0 95 0 0 0 35 0 0 0] 98 0 1168 0 27 672 410 1968 98 16 0 416 98 2 8 1140850944 1 2272 0 0 0 5 0 0 0 2272 0 8 4294906439 786 0 0 0 818 202 208 98 2 882 912 98 2 610 21 101 610 201 41 2272 882 1808 98 1 8 'Tape Length (mins):' 2272 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 50 0 0 0 110 0 0 0 70 0 0 0] 98 0 1168 0 27 1200 410 8 ##(ContainerView)  98 15 0 416 98 2 8 1140850688 131073 2576 0 721158 ##(SystemColor)  31 0 5 0 0 0 2576 852230 ##(FramingLayout)  234 240 98 4 410 8 ##(PushButton)  98 17 0 2576 98 2 8 1140924416 1 2752 0 482 512 0 5 0 0 0 2752 0 8 4294906781 1180998 4 ##(CommandDescription)  8 #ok 8 'OK' 1 1 0 0 16 818 202 208 98 2 882 912 98 2 610 31 11 610 141 51 2752 882 1808 98 1 8 'OK' 2752 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 85 0 0 0 30 0 0 0] 98 0 1168 0 27 1181766 2 ##(FramingConstraints)  1354 8 ##(FramingCalculation)  8 #fixedViewRight -139 1354 3184 8 #fixedParentRight -149 1354 3184 8 #fixedParentTop 1 1354 3184 8 #fixedViewTop 51 410 2768 98 17 0 2576 98 2 8 1140924416 1 3312 0 482 512 0 5 0 0 0 3312 0 8 4294906781 2866 8 #cancel 8 'Cancel' 1 1 0 0 32 818 202 208 98 2 882 912 98 2 610 177 11 610 141 51 3312 882 1808 98 1 8 'Cancel' 3312 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 88 0 0 0 5 0 0 0 158 0 0 0 30 0 0 0] 98 0 1168 0 27 3138 3168 -139 3216 -3 3248 1 3280 51 234 256 1328 590342 ##(Rectangle)  610 11 11 610 11 11 818 202 208 98 1 882 912 98 2 610 201 161 610 331 71 2576 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 80 0 0 0 9 1 0 0 115 0 0 0] 98 2 2752 3312 1168 0 27 1168 0 27 )! !
!NewVideoTapeDialog class categoriesFor: #icon!constants!public! !
!NewVideoTapeDialog class categoriesFor: #resource_Default_view!public!resources-views! !

