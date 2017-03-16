"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #VideoRecordingDialog
	instanceVariableNames: 'titlePresenter datePresenter timePresenter lengthPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VideoRecordingDialog guid: (GUID fromString: '{b4dcfba4-e0f6-4408-a0fc-722995bb0697}')!
VideoRecordingDialog comment: 'VideoRecordingDialog provides a modal user interface for editing the contents of a VideoRecording object in place. This class is part of the Video Library sample package. Please see the package comment for more details.

Example:
self showModalOn: VideoRecording new "Display it"'!
!VideoRecordingDialog categoriesForClass!Samples! !
!VideoRecordingDialog methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	titlePresenter := self add: TextPresenter new name: 'title'.
	datePresenter := self add: DatePresenter new name: 'date'.
	timePresenter := self add: TimePresenter new name: 'time'.
	lengthPresenter := self add: NumberPresenter new name: 'length'.



!

model: aVideoRecording
	"Set the model associated with the receiver to aVideoRecording."

	super model: aVideoRecording.

	"From this point on 'self model' is the buffered version of aVideoRecording"
	titlePresenter model: (self model aspectValue: #title).
	datePresenter model: (self model aspectValue: #date).
	timePresenter model: (self model aspectValue: #time).
	lengthPresenter model: (self model aspectValue: #length).

! !
!VideoRecordingDialog categoriesFor: #createComponents!initializing!public! !
!VideoRecordingDialog categoriesFor: #model:!accessing!public! !

!VideoRecordingDialog class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^VideoRecording new
!

icon
	"Answers an Icon that can be used to represent this class"

	^VideoRecording icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(ColorRef)  8 4278190080 0 133 0 263174 ##(Font)  0 16 459014 ##(LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Point)  193 193 0 416 0 234 256 98 8 410 8 ##(Slider)  98 18 0 416 98 2 8 1140916480 1 672 721990 2 ##(ValueHolder)  0 32 1376774 ##(PluggableSearchPolicy)  459270 ##(Message)  8 #= 98 0 818 8 #hash 98 0 1 482 512 0 5 0 0 0 672 0 8 4294907137 852486 ##(NullConverter)  0 0 3 0 0 983302 ##(MessageSequence)  202 208 98 5 721670 ##(MessageSend)  8 #createAt:extent: 98 2 610 211 161 610 621 41 672 1058 8 #ticks: 98 1 98 5 1 61 121 181 481 672 1058 8 #pageSize: 98 1 61 672 1058 8 #lineSize: 98 1 11 672 1058 8 #range: 98 1 525062 ##(Interval)  1 481 3 672 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 0 0 0 80 0 0 0 159 1 0 0 100 0 0 0] 98 0 610 193 193 0 27 8 'length' 410 8 ##(TextEdit)  98 16 0 416 98 2 8 1140916352 1025 1488 0 482 512 0 5 0 0 0 1488 0 8 4294906635 962 0 0 1 994 202 208 98 3 1058 1088 98 2 610 211 31 610 621 41 1488 1058 8 #selectionRange: 98 1 1362 3 1 3 1488 1058 8 #isTextModified: 98 1 32 1488 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 0 0 0 15 0 0 0 159 1 0 0 35 0 0 0] 98 0 1456 0 27 8 'title' 410 8 ##(DateTimePicker)  98 16 0 416 98 2 8 1140916228 1 1904 754 0 0 786 818 848 98 0 818 896 912 262406 ##(Date)  70769 482 512 0 5 0 0 0 1904 0 8 4294907103 962 0 0 0 994 202 208 98 3 1058 1088 98 2 610 211 91 610 351 41 1904 1058 8 #text: 98 1 8 '17 November 1997' 1904 1058 1328 98 1 98 2 0 0 1904 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 0 0 0 45 0 0 0 24 1 0 0 65 0 0 0] 98 0 1456 0 27 8 'date' 410 1920 98 16 0 416 98 2 8 1140916233 1 2432 754 0 0 786 818 848 98 0 818 896 912 262406 ##(Time)  1 482 512 0 5 0 0 0 2432 0 8 4294907103 962 0 0 8 'hh:mmtt' 994 202 208 98 3 1058 1088 98 2 610 581 91 610 251 41 2432 1058 2272 98 1 8 '12:00AM' 2432 1058 1328 98 1 98 2 0 0 2432 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 34 1 0 0 45 0 0 0 159 1 0 0 65 0 0 0] 98 0 1456 0 27 8 'time' 0 0 0 0 0 15999 0 0 0 0 1 0 0 590598 ##(Semaphore)  0 0 1 0 8 2010572111 994 202 208 98 3 1058 1088 98 2 610 1163 1015 610 875 373 416 1058 2272 98 1 8 'Edit Recording Details' 416 1058 8 #menuBar: 98 1 0 416 1394 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 69 2 0 0 251 1 0 0 250 3 0 0 181 2 0 0] 98 8 410 8 ##(StaticText)  98 16 0 416 98 2 8 1140850944 1 3248 0 0 0 5 0 0 0 3248 0 8 4294906439 962 0 0 0 994 202 208 98 2 1058 1088 98 2 610 31 31 610 171 31 3248 1058 2272 98 1 8 'Title:' 3248 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 15 0 0 0 100 0 0 0 30 0 0 0] 98 0 1456 0 27 1488 410 3264 98 16 0 416 98 2 8 1140850944 1 3568 0 0 0 5 0 0 0 3568 0 8 4294906439 962 0 0 0 994 202 208 98 2 1058 1088 98 2 610 31 91 610 171 41 3568 1058 2272 98 1 8 'Date and Time:' 3568 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 45 0 0 0 100 0 0 0 65 0 0 0] 98 0 1456 0 27 1904 2432 410 3264 98 16 0 416 98 2 8 1140850944 1 3872 0 0 0 5 0 0 0 3872 0 8 4294906439 962 0 0 0 994 202 208 98 2 1058 1088 98 2 610 31 161 610 151 41 3872 1058 2272 98 1 8 'Duration:' 3872 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 80 0 0 0 90 0 0 0 100 0 0 0] 98 0 1456 0 27 672 410 8 ##(ContainerView)  98 15 0 416 98 2 8 1140850688 131073 4176 0 721158 ##(SystemColor)  31 0 5 0 0 0 4176 852230 ##(FramingLayout)  234 240 98 4 410 8 ##(PushButton)  98 17 0 4176 98 2 8 1140924416 1 4352 0 482 512 0 5 0 0 0 4352 0 8 4294906781 1180998 4 ##(CommandDescription)  8 #ok 8 'OK' 1 1 0 0 16 994 202 208 98 3 1058 1088 98 2 610 11 11 610 141 51 4352 1058 8 #isEnabled: 98 1 32 4352 1058 2272 98 1 8 'OK' 4352 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 75 0 0 0 30 0 0 0] 98 0 1456 0 27 1181766 2 ##(FramingConstraints)  1114638 ##(STBSingletonProxy)  8 ##(FramingCalculation)  8 #fixedViewRight -139 4826 4848 8 #fixedParentRight -149 4826 4848 8 #fixedParentTop 1 4826 4848 8 #fixedViewTop 51 410 4368 98 17 0 4176 98 2 8 1140924416 1 4976 0 482 512 0 5 0 0 0 4976 0 8 4294906781 4466 8 #cancel 8 'Cancel' 1 1 0 0 32 994 202 208 98 2 1058 1088 98 2 610 157 11 610 141 51 4976 1058 2272 98 1 8 'Cancel' 4976 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 78 0 0 0 5 0 0 0 148 0 0 0 30 0 0 0] 98 0 1456 0 27 4786 4832 -139 4880 -3 4912 1 4944 51 234 256 98 0 590342 ##(Rectangle)  610 11 11 610 11 11 994 202 208 98 1 1058 1088 98 2 610 531 221 610 311 71 4176 1394 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 1 0 0 110 0 0 0 164 1 0 0 145 0 0 0] 98 2 4352 4976 1456 0 27 1456 0 27 )! !
!VideoRecordingDialog class categoriesFor: #defaultModel!models!public! !
!VideoRecordingDialog class categoriesFor: #icon!constants!public! !
!VideoRecordingDialog class categoriesFor: #resource_Default_view!public!resources-views! !

