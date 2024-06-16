"Filed out from Dolphin Smalltalk"!

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

!VideoRecordingDialog categoriesForMethods!
createComponents!initializing!public! !
model:!accessing!public! !
!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13107200 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 nil 170 192 34 8 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916352 1025 608 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 608 nil 8 1759000288 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[105 0 0 0 15 0 0 0 155 1 0 0 35 0 0 0] 193 640 nil 608 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'title' 410 ##(Smalltalk.DateTimePicker) 34 16 nil 416 34 2 8 1140916228 1 1008 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 1138 #hash 8 #() 262406 ##(Smalltalk.Date) 70769 688 nil 5 nil nil nil 1008 nil 8 1759735488 722 nil nil nil 754 138 144 34 2 818 #createWindow: 34 1 866 898 8 #[105 0 0 0 45 0 0 0 20 1 0 0 65 0 0 0] 193 1040 8 '17 November 1997' 1008 818 #range: 34 1 8 #(nil nil) 1008 3 8 #() 962 193 193 nil 27 8 'date' 410 ##(Smalltalk.DateTimePicker) 34 16 nil 416 34 2 8 1140916233 1 1520 1074 nil nil 1106 1138 #= 8 #() 1138 #hash 1200 262470 1 ##(Smalltalk.Time) 1 688 nil 5 nil nil nil 1520 nil 8 1759735488 722 nil nil 8 'hh:mmtt' 754 138 144 34 2 818 #createWindow: 34 1 866 898 8 #[30 1 0 0 45 0 0 0 154 1 0 0 65 0 0 0] 193 1552 8 '12:00AM' 1520 818 #range: 34 1 8 #(nil nil) 1520 3 8 #() 962 193 193 nil 27 8 'time' 410 ##(Smalltalk.Slider) 34 18 nil 416 34 2 8 1140916480 1 1984 1074 nil false 1106 1138 #= 8 #() 1138 #hash 1200 1 nil nil 5 nil nil nil 1984 nil 8 1758656992 722 nil nil 3 nil nil 754 138 144 34 5 818 #createWindow: 34 1 866 898 8 #[100 0 0 0 80 0 0 0 160 1 0 0 100 0 0 0] 193 2016 8 '' 1984 818 #ticks: 34 1 8 #(0 30 60 90 240) 1984 818 #pageSize: 8 #(30) 1984 818 #lineSize: 8 #(5) 1984 818 #range: 34 1 525062 ##(Smalltalk.Interval) 1 481 3 1984 3 8 #() 962 193 193 nil 27 8 'length' nil nil nil nil nil 13741 nil nil nil nil 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 754 138 144 34 2 818 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 590342 ##(Smalltalk.Rectangle) 962 1 1 962 875 373 193 416 818 #setWindowText: 34 1 8 'Edit Recording Details' 416 1 34 8 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2816 nil nil nil 5 nil nil nil 2816 nil 8 1759212608 722 nil nil nil 754 138 144 34 2 818 #createWindow: 34 1 866 898 8 #[15 0 0 0 15 0 0 0 100 0 0 0 30 0 0 0] 193 2848 nil 2816 818 #text: 34 1 8 'Title:' 2816 3 8 #() 962 193 193 nil 27 608 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3120 nil nil nil 5 nil nil nil 3120 nil 8 1759212608 722 nil nil nil 754 138 144 34 2 818 #createWindow: 34 1 866 898 8 #[15 0 0 0 45 0 0 0 100 0 0 0 65 0 0 0] 193 3152 nil 3120 818 #text: 34 1 8 'Date and Time:' 3120 3 8 #() 962 193 193 nil 27 1008 1520 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3424 nil nil nil 5 nil nil nil 3424 nil 8 1759212608 722 nil nil nil 754 138 144 34 2 818 #createWindow: 34 1 866 898 8 #[15 0 0 0 80 0 0 0 90 0 0 0 100 0 0 0] 193 3456 nil 3424 818 #text: 34 1 8 'Duration:' 3424 3 8 #() 962 193 193 nil 27 1984 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 3728 nil nil nil 5 nil nil nil 3728 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 754 138 144 34 1 818 #createWindow: 34 1 866 898 8 #[240 0 0 0 105 0 0 0 154 1 0 0 140 0 0 0] 193 3760 8 '' 3728 3 8 #() 962 193 193 nil 27 962 193 193 nil 29 )! !

!VideoRecordingDialog class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

