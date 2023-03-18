"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'UI.Examples.VideoRecordingDialog'
	instanceVariableNames: 'titlePresenter datePresenter timePresenter lengthPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.VideoRecordingDialog guid: (Core.GUID fromString: '{b4dcfba4-e0f6-4408-a0fc-722995bb0697}')!
UI.Examples.VideoRecordingDialog comment: 'VideoRecordingDialog provides a modal user interface for editing the contents of a VideoRecording object in place. This class is part of the Video Library sample package. Please see the package comment for more details.

Example:
self showModalOn: VideoRecording new "Display it"'!
!UI.Examples.VideoRecordingDialog categoriesForClass!Samples! !
!UI.Examples.VideoRecordingDialog methodsFor!

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
!UI.Examples.VideoRecordingDialog categoriesForMethods!
createComponents!initializing!public! !
model:!accessing!public! !
!

!UI.Examples.VideoRecordingDialog class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^VideoRecording new!

icon
	"Answers an Icon that can be used to represent this class"

	^VideoRecording icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13107200 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 nil 170 192 34 8 410 #{UI.DateTimePicker} 34 16 nil 416 34 2 8 1140916233 1 640 918598 2 #{UI.ValueHolder} nil nil 1835526 #{Kernel.PluggableSearchPolicy} 786950 #{Core.Message} #= 8 #() 770 #hash 8 #() 590150 1 #{Core.Time} 1 917510 #{Graphics.Color} #default nil 7 nil nil nil 640 nil 8 1815752800 1049094 #{UI.NullConverter} nil nil 8 'hh:mmtt' 1310982 #{Core.MessageSequence} 34 3 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 573 91 578 249 41 640 1026 #text: 34 1 8 '12:00AM' 640 1026 #range: 34 1 8 #(nil nil) 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 1 0 0 45 0 0 0 154 1 0 0 65 0 0 0] 8 #() 578 193 193 nil 27 8 'time' 410 #{UI.TextEdit} 34 16 nil 416 34 2 8 1140916352 1025 1296 nil 896 nil 7 nil nil nil 1296 nil 8 1815092992 930 nil nil 1 978 34 1 1026 #createAt:extent: 34 2 578 211 31 578 613 41 1296 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 0 0 0 15 0 0 0 155 1 0 0 35 0 0 0] 8 #() 1264 nil 27 8 'title' 410 #{UI.DateTimePicker} 34 16 nil 416 34 2 8 1140916228 1 1552 706 nil nil 738 770 #= 8 #() 770 #hash 832 590086 #{Core.Date} 70769 896 nil 7 nil nil nil 1552 nil 8 1815752800 930 nil nil nil 978 34 3 1026 #createAt:extent: 34 2 578 211 91 578 343 41 1552 1026 #text: 34 1 8 '17 November 1997' 1552 1026 #range: 34 1 8 #(nil nil) 1552 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 0 0 0 45 0 0 0 20 1 0 0 65 0 0 0] 8 #() 1264 nil 27 8 'date' 410 #{UI.Slider} 34 18 nil 416 34 2 8 1140916480 1 2016 706 nil false 738 770 #= 8 #() 770 #hash 832 1 nil nil 7 nil nil nil 2016 nil 8 1814871328 930 nil nil 3 nil nil 978 34 5 1026 #createAt:extent: 34 2 578 201 161 578 633 41 2016 1026 #ticks: 34 1 8 #(0 30 60 90 240) 2016 1026 #pageSize: 8 #(30) 2016 1026 #lineSize: 8 #(5) 2016 1026 #range: 34 1 852742 #{Core.Interval} 1 481 3 2016 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 80 0 0 0 160 1 0 0 100 0 0 0] 8 #() 1264 nil 27 8 'length' nil nil nil nil nil 66451 nil nil nil nil 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 978 34 2 1026 #createAt:extent: 34 2 578 12287 21 578 875 373 416 1026 #text: 34 1 8 'Edit Recording Details' 416 1202 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 180 25 0 0 196 0 0 0] 34 8 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 2768 nil nil nil 7 nil nil nil 2768 nil 8 1815137184 930 nil nil nil 978 34 2 1026 #createAt:extent: 34 2 578 31 31 578 171 31 2768 1026 #text: 34 1 8 'Title:' 2768 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 15 0 0 0 100 0 0 0 30 0 0 0] 8 #() 1264 nil 27 1296 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 3056 nil nil nil 7 nil nil nil 3056 nil 8 1815137184 930 nil nil nil 978 34 2 1026 #createAt:extent: 34 2 578 31 91 578 171 41 3056 1026 #text: 34 1 8 'Date and Time:' 3056 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 45 0 0 0 100 0 0 0 65 0 0 0] 8 #() 1264 nil 27 1552 640 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 3344 nil nil nil 7 nil nil nil 3344 nil 8 1815137184 930 nil nil nil 978 34 2 1026 #createAt:extent: 34 2 578 31 161 578 151 41 3344 1026 #text: 34 1 8 'Duration:' 3344 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 80 0 0 0 90 0 0 0 100 0 0 0] 8 #() 1264 nil 27 2016 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 3632 nil nil nil 7 nil nil nil 3632 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 978 34 1 1026 #createAt:extent: 34 2 578 481 211 578 341 71 3632 1202 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 240 0 0 0 105 0 0 0 154 1 0 0 140 0 0 0] 8 #() 1264 nil 27 1264 nil 27)! !
!UI.Examples.VideoRecordingDialog class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

