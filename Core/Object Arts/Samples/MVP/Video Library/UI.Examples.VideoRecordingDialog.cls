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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13107200 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 8 18 #{UI.DateTimePicker} 50 16 nil 32 50 2 8 1140916228 1 256 1094 2 #{UI.ValueHolder} nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 386 #hash 8 #() 262 #{Core.Date} 70769 6 #{Graphics.Color} #default nil 5 nil nil nil 256 nil nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[105 0 0 0 45 0 0 0 20 1 0 0 65 0 0 0] 193 288 8 '17 November 1997' 256 610 #range: 50 1 8 #(nil nil) 256 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 8 'date' 18 #{UI.Slider} 50 18 nil 32 50 2 8 1140916480 1 864 322 nil false 354 386 #= 8 #() 386 #hash 448 1 nil nil 5 nil nil nil 864 nil nil 530 nil nil 3 nil nil 562 50 5 610 #createWindow: 50 1 658 690 8 #[100 0 0 0 80 0 0 0 160 1 0 0 100 0 0 0] 193 896 8 '' 864 610 #ticks: 50 1 8 #(0 30 60 90 240) 864 610 #pageSize: 8 #(30) 864 610 #lineSize: 8 #(5) 864 610 #range: 50 1 774 #{Core.Interval} 1 481 3 864 3 8 #() 818 193 193 nil 27 8 'length' 18 #{UI.DateTimePicker} 50 16 nil 32 50 2 8 1140916233 1 1376 322 nil nil 354 386 #= 8 #() 386 #hash 448 326 1 #{Core.Time} 1 512 nil 5 nil nil nil 1376 nil nil 530 nil nil 8 'hh:mmtt' 562 50 2 610 #createWindow: 50 1 658 690 8 #[30 1 0 0 45 0 0 0 154 1 0 0 65 0 0 0] 193 1408 8 '12:00AM' 1376 610 #range: 50 1 8 #(nil nil) 1376 3 8 #() 818 193 193 nil 27 8 'time' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140916352 1025 1808 nil 512 nil 5 nil nil nil 1808 nil nil 530 nil nil 1 #focusLost nil nil nil 562 50 1 610 #createWindow: 50 1 658 690 8 #[105 0 0 0 15 0 0 0 155 1 0 0 35 0 0 0] 193 1840 nil 1808 3 8 #() 818 193 193 nil 45 8 'title' nil nil nil nil nil 1 nil nil nil nil 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 562 50 2 610 #createWindow: 50 1 518 #{UI.CreateDialog} 518 #{Graphics.Rectangle} 818 7679 21 818 8553 393 193 32 610 #setWindowText: 50 1 8 'Edit Recording Details' 32 1 50 8 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2304 nil nil nil 5 nil nil nil 2304 nil nil 530 nil nil nil 562 50 2 610 #createWindow: 50 1 658 690 8 #[15 0 0 0 15 0 0 0 100 0 0 0 30 0 0 0] 193 2336 nil 2304 610 #text: 50 1 8 'Title:' 2304 3 8 #() 818 193 193 nil 27 1808 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2576 nil nil nil 5 nil nil nil 2576 nil nil 530 nil nil nil 562 50 2 610 #createWindow: 50 1 658 690 8 #[15 0 0 0 45 0 0 0 100 0 0 0 65 0 0 0] 193 2608 nil 2576 610 #text: 50 1 8 'Date and Time:' 2576 3 8 #() 818 193 193 nil 27 256 1376 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2848 nil nil nil 5 nil nil nil 2848 nil nil 530 nil nil nil 562 50 2 610 #createWindow: 50 1 658 690 8 #[15 0 0 0 80 0 0 0 90 0 0 0 100 0 0 0] 193 2880 nil 2848 610 #text: 50 1 8 'Duration:' 2848 3 8 #() 818 193 193 nil 27 864 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 3120 nil nil nil 5 nil nil nil 3120 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 562 50 1 610 #createWindow: 50 1 658 690 8 #[240 0 0 0 105 0 0 0 154 1 0 0 140 0 0 0] 193 3152 8 '' 3120 3 8 #() 818 193 193 nil 27 818 193 193 nil 29)! !

!UI.Examples.VideoRecordingDialog class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

