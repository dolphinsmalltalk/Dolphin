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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 165 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 nil 170 192 34 8 410 ##(Smalltalk.DateTimePicker) 34 16 nil 416 34 2 8 1140916233 1 640 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 770 #hash 8 #() 262470 1 ##(Smalltalk.Time) 1 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 640 nil 8 1904605520 852486 ##(Smalltalk.NullConverter) nil nil 8 'hh:mmtt' 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 573 91 578 249 41 640 1042 #text: 34 1 8 '12:00AM' 640 1042 #range: 34 1 8 #(nil nil) 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 1 0 0 45 0 0 0 154 1 0 0 65 0 0 0] 8 #() 578 193 193 nil 27 8 'time' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916352 1025 1312 nil 896 nil 7 nil nil nil 1312 nil 8 1903872368 930 nil nil 1 978 138 144 34 1 1042 #createAt:extent: 34 2 578 211 31 578 613 41 1312 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 0 0 0 15 0 0 0 155 1 0 0 35 0 0 0] 8 #() 1280 nil 27 8 'title' 410 ##(Smalltalk.DateTimePicker) 34 16 nil 416 34 2 8 1140916228 1 1584 706 nil nil 738 770 #= 8 #() 770 #hash 832 262406 ##(Smalltalk.Date) 70769 896 nil 7 nil nil nil 1584 nil 8 1904605520 930 nil nil nil 978 138 144 34 3 1042 #createAt:extent: 34 2 578 211 91 578 343 41 1584 1042 #text: 34 1 8 '17 November 1997' 1584 1042 #range: 34 1 8 #(nil nil) 1584 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 0 0 0 45 0 0 0 20 1 0 0 65 0 0 0] 8 #() 1280 nil 27 8 'date' 410 ##(Smalltalk.Slider) 34 18 nil 416 34 2 8 1140916480 1 2064 706 nil false 738 770 #= 8 #() 770 #hash 832 1 nil nil 7 nil nil nil 2064 nil 8 1903799248 930 nil nil 3 nil nil 978 138 144 34 5 1042 #createAt:extent: 34 2 578 201 161 578 633 41 2064 1042 #ticks: 34 1 8 #(0 30 60 90 240) 2064 1042 #pageSize: 8 #(30) 2064 1042 #lineSize: 8 #(5) 2064 1042 #range: 34 1 525062 ##(Smalltalk.Interval) 1 481 3 2064 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 80 0 0 0 160 1 0 0 100 0 0 0] 8 #() 1280 nil 27 8 'length' nil nil nil nil nil 10221 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 1998684880 978 138 144 34 3 1042 #createAt:extent: 34 2 578 3839 21 578 875 373 416 1042 #text: 34 1 8 'Edit Recording Details' 416 1042 #updateMenuBar 8 #() 416 1218 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 52 9 0 0 196 0 0 0] 34 8 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2880 nil nil nil 7 nil nil nil 2880 nil 8 1903849936 930 nil nil nil 978 138 144 34 2 1042 #createAt:extent: 34 2 578 31 31 578 171 31 2880 1042 #text: 34 1 8 'Title:' 2880 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 15 0 0 0 100 0 0 0 30 0 0 0] 8 #() 1280 nil 27 1312 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3184 nil nil nil 7 nil nil nil 3184 nil 8 1903849936 930 nil nil nil 978 138 144 34 2 1042 #createAt:extent: 34 2 578 31 91 578 171 41 3184 1042 #text: 34 1 8 'Date and Time:' 3184 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 45 0 0 0 100 0 0 0 65 0 0 0] 8 #() 1280 nil 27 1584 640 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3488 nil nil nil 7 nil nil nil 3488 nil 8 1903849936 930 nil nil nil 978 138 144 34 2 1042 #createAt:extent: 34 2 578 31 161 578 151 41 3488 1042 #text: 34 1 8 'Duration:' 3488 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 80 0 0 0 90 0 0 0 100 0 0 0] 8 #() 1280 nil 27 2064 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 3792 nil nil nil 7 nil nil nil 3792 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 978 138 144 34 1 1042 #createAt:extent: 34 2 578 481 211 578 341 71 3792 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 240 0 0 0 105 0 0 0 154 1 0 0 140 0 0 0] 2816 1280 nil 27 1280 nil 27 )! !
!VideoRecordingDialog class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

