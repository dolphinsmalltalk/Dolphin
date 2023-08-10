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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13107200 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 nil 550 #{Core.IdentityDictionary} 4 18 #{UI.DateTimePicker} 50 16 nil 32 50 2 8 1140916228 1 272 1094 2 #{UI.ValueHolder} nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 402 #hash 8 #() 262 #{Core.Date} 70769 6 #{Graphics.Color} #default nil 7 nil nil nil 272 nil 8 1853911008 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 3 774 #{Core.MessageSend} #createAt:extent: 50 2 210 211 91 210 343 41 272 642 #text: 50 1 8 '17 November 1997' 272 642 #range: 50 1 8 #(nil nil) 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 0 0 0 45 0 0 0 20 1 0 0 65 0 0 0] 8 #() 210 193 193 nil 27 8 'date' 18 #{UI.DateTimePicker} 50 16 nil 32 50 2 8 1140916233 1 912 338 nil nil 370 402 #= 8 #() 402 #hash 464 326 1 #{Core.Time} 1 528 nil 7 nil nil nil 912 nil 8 1853911008 562 nil nil 8 'hh:mmtt' 594 50 3 642 #createAt:extent: 50 2 210 573 91 210 249 41 912 642 #text: 50 1 8 '12:00AM' 912 642 #range: 50 1 8 #(nil nil) 912 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 1 0 0 45 0 0 0 154 1 0 0 65 0 0 0] 8 #() 880 nil 27 8 'time' 18 #{UI.Slider} 50 18 nil 32 50 2 8 1140916480 1 1392 338 nil false 370 402 #= 8 #() 402 #hash 464 1 nil nil 7 nil nil nil 1392 nil 8 1852832256 562 nil nil 3 nil nil 594 50 5 642 #createAt:extent: 50 2 210 201 161 210 633 41 1392 642 #ticks: 50 1 8 #(0 30 60 90 240) 1392 642 #pageSize: 8 #(30) 1392 642 #lineSize: 8 #(5) 1392 642 #range: 50 1 774 #{Core.Interval} 1 481 3 1392 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 80 0 0 0 160 1 0 0 100 0 0 0] 8 #() 880 nil 27 8 'length' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140916352 1025 1904 nil 528 nil 7 nil nil nil 1904 nil 8 1853175488 562 nil nil 1 #focusLost nil nil nil 594 50 1 642 #createAt:extent: 50 2 210 211 31 210 613 41 1904 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 105 0 0 0 15 0 0 0 155 1 0 0 35 0 0 0] 8 #() 880 nil 45 8 'title' nil nil nil nil nil 13487 nil nil nil nil 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 594 50 2 642 #createAt:extent: 50 2 210 6143 21 210 875 373 32 642 #text: 50 1 8 'Edit Recording Details' 32 818 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 180 13 0 0 196 0 0 0] 50 8 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2400 nil nil nil 7 nil nil nil 2400 nil 8 1853387904 562 nil nil nil 594 50 2 642 #createAt:extent: 50 2 210 31 31 210 171 31 2400 642 #text: 50 1 8 'Title:' 2400 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 15 0 0 0 100 0 0 0 30 0 0 0] 8 #() 880 nil 27 1904 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2688 nil nil nil 7 nil nil nil 2688 nil 8 1853387904 562 nil nil nil 594 50 2 642 #createAt:extent: 50 2 210 31 91 210 171 41 2688 642 #text: 50 1 8 'Date and Time:' 2688 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 45 0 0 0 100 0 0 0 65 0 0 0] 8 #() 880 nil 27 272 912 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2976 nil nil nil 7 nil nil nil 2976 nil 8 1853387904 562 nil nil nil 594 50 2 642 #createAt:extent: 50 2 210 31 161 210 151 41 2976 642 #text: 50 1 8 'Duration:' 2976 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 80 0 0 0 90 0 0 0 100 0 0 0] 8 #() 880 nil 27 1392 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 3264 nil nil nil 7 nil nil nil 3264 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 594 50 1 642 #createAt:extent: 50 2 210 481 211 210 341 71 3264 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 240 0 0 0 105 0 0 0 154 1 0 0 140 0 0 0] 8 #() 880 nil 27 880 nil 27)! !
!UI.Examples.VideoRecordingDialog class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

