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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 nil 170 192 34 8 410 ##(Smalltalk.Slider) 34 18 nil 416 34 2 8 1140916480 1 640 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 770 #hash 8 #() 1 nil nil 5 nil nil nil 640 nil 8 1915076416 852486 ##(Smalltalk.NullConverter) nil nil 3 nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 5 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 201 161 578 633 41 640 962 #ticks: 34 1 8 #(0 30 60 90 240) 640 962 #pageSize: 8 #(30) 640 962 #lineSize: 8 #(5) 640 962 #range: 34 1 525062 ##(Smalltalk.Interval) 1 481 3 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 80 0 0 0 160 1 0 0 100 0 0 0] 8 #() 578 193 193 nil 27 8 'length' 410 ##(Smalltalk.DateTimePicker) 34 16 nil 416 34 2 8 1140916233 1 1312 706 nil nil 738 770 #= 8 #() 770 #hash 832 262406 ##(Smalltalk.Time) 1 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 1312 nil 8 1915873632 866 nil nil 8 'hh:mmtt' 898 138 144 34 3 962 #createAt:extent: 34 2 578 573 91 578 249 41 1312 962 #text: 34 1 8 '12:00AM' 1312 962 #range: 34 1 8 #(nil nil) 1312 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 1 0 0 45 0 0 0 154 1 0 0 65 0 0 0] 8 #() 1280 nil 27 8 'time' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916352 1025 1856 nil 1504 nil 5 nil nil nil 1856 nil 8 1915280032 866 nil nil 1 898 138 144 34 1 962 #createAt:extent: 34 2 578 211 31 578 613 41 1856 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 0 0 0 15 0 0 0 155 1 0 0 35 0 0 0] 8 #() 1280 nil 27 8 'title' 410 ##(Smalltalk.DateTimePicker) 34 16 nil 416 34 2 8 1140916228 1 2128 706 nil nil 738 770 #= 8 #() 770 #hash 832 262406 ##(Smalltalk.Date) 70769 1504 nil 5 nil nil nil 2128 nil 8 1915873632 866 nil nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 578 211 91 578 343 41 2128 962 #text: 34 1 8 '17 November 1997' 2128 962 #range: 34 1 8 #(nil nil) 2128 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 0 0 0 45 0 0 0 20 1 0 0 65 0 0 0] 8 #() 1280 nil 27 8 'date' nil nil nil nil nil 15073 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2011052416 898 138 144 34 3 962 #createAt:extent: 34 2 578 1483 895 578 875 373 416 962 #text: 34 1 8 'Edit Recording Details' 416 962 #updateMenuBar 8 #() 416 1218 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 229 2 0 0 191 1 0 0 154 4 0 0 121 2 0 0] 34 8 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2896 nil nil nil 5 nil nil nil 2896 nil 8 1915124368 866 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 31 31 578 171 31 2896 962 #text: 34 1 8 'Title:' 2896 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 15 0 0 0 100 0 0 0 30 0 0 0] 8 #() 1280 nil 27 1856 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3200 nil nil nil 5 nil nil nil 3200 nil 8 1915124368 866 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 31 91 578 171 41 3200 962 #text: 34 1 8 'Date and Time:' 3200 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 45 0 0 0 100 0 0 0 65 0 0 0] 8 #() 1280 nil 27 2128 1312 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3504 nil nil nil 5 nil nil nil 3504 nil 8 1915124368 866 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 31 161 578 151 41 3504 962 #text: 34 1 8 'Duration:' 3504 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 80 0 0 0 90 0 0 0 100 0 0 0] 8 #() 1280 nil 27 640 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 3808 nil nil nil 5 nil nil nil 3808 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 481 211 578 341 71 3808 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 240 0 0 0 105 0 0 0 154 1 0 0 140 0 0 0] 2832 1280 nil 27 1280 nil 27 )! !
!VideoRecordingDialog class categoriesFor: #defaultModel!models!public! !
!VideoRecordingDialog class categoriesFor: #icon!constants!public! !
!VideoRecordingDialog class categoriesFor: #resource_Default_view!public!resources-views! !

