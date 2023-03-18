"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'UI.Examples.VideoLibraryShell'
	instanceVariableNames: 'ownerPresenter tapesPresenter recordingsPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.VideoLibraryShell guid: (Core.GUID fromString: '{46aa1198-1908-4799-b06c-c003165d09ff}')!
UI.Examples.VideoLibraryShell comment: 'VideoLibraryShell a modeless user interface for displaying and editing the contents of a VideoLibrary. This class is part of the Video Library sample package. Please see the package comment for more details.

Example:usage

VideoLibraryShell show.

or 

VideoLibraryShell showOn: (VideoLibrary new owner: ''Mary Joe'')'!
!UI.Examples.VideoLibraryShell categoriesForClass!Samples! !
!UI.Examples.VideoLibraryShell methodsFor!

addTape
	"Create a new tape and add it to the receiver's library"

	| tape |
	tape := NewVideoTapeDialog showModal.
	tape notNil
		ifTrue: 
			[tapesPresenter model add: tape.
			self tape: tape]!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	ownerPresenter := self add: TextPresenter new name: 'owner'.
	tapesPresenter := self add: ListPresenter new name: 'tapes'.
	recordingsPresenter := self add: ListPresenter new name: 'recordings'.

!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring.
	tapesPresenter when: #selectionChanged send: #onTapeSelected to: self.
	recordingsPresenter when: #actionPerformed send: #editRecording to: self.
	!

editRecording
	"Edits the current recording in a VideoRecordingDialog"

	VideoRecordingDialog showModalOn: self recording!

erase
	"Removes a programme recording from the current tape"

	recordingsPresenter model remove: self recording.
	!

hasSelectedRecording
	"Answer true if there is a recording selected in the receiver"

	^recordingsPresenter hasSelection!

hasSelectedTape
	"Answer true if there is a tape selected in the receiver"

	^tapesPresenter hasSelection!

model: aVideoLibrary
	"Set the model associated with the receiver to be aVideoLibrary."

	super model: aVideoLibrary.
	ownerPresenter model: (self model aspectValue: #owner).
	tapesPresenter model: (ListModel on: self model tapes).

!

onTapeSelected
	"Private - Event handler for when a new tape has been selected. Transfer the
	recordings into the recordingsPresenter."

	recordingsPresenter clear.
	self hasSelectedTape ifTrue: [
		recordingsPresenter list: self tape recordings ].!

onViewOpened
	"Received when the receiver's view is been connected. "

	super onViewOpened.
	self onTapeSelected.
!

queryCommand: aCommandQuery
	"Private - Enters details about a potential command for the receiver into aCommandQuery"

	super queryCommand: aCommandQuery.
	(#(removeTape record) includes: aCommandQuery command) ifTrue: [
		aCommandQuery isEnabled: self hasSelectedTape ].
	(#(erase) includes: aCommandQuery command) ifTrue: [
		aCommandQuery isEnabled: self hasSelectedRecording ]
!

record
	"Adds a programme recording to the current tape"

	| recording |
	recording := VideoRecordingDialog showModalOn: VideoRecording new.
	recording notNil
		ifTrue: 
			[recordingsPresenter model add: recording.
			self recording: recording]!

recording
	"Answer the current selected recording in the receiver or nil if there is none"

	^recordingsPresenter selectionOrNil!

recording: aVideoRecordingOrNil
	"Sets the current selected video recording  in the receiver to aVideoRecordingOrNil"

	^recordingsPresenter selectionOrNil: aVideoRecordingOrNil!

removeTape
	"Removes the current tape from the receiver's library"

	(MessageBox confirm: ('Are you sure you wish to remove the tape:
<1d> from this library?' 
				expandMacrosWith: self tape)
		caption: 'Remove Tape') ifTrue: [tapesPresenter model remove: self tape]!

tape
	"Answer the current selected tape in the receiver or nil if there is none"

	^tapesPresenter selectionOrNil!

tape: aVideoTapeOrNil
	"Sets the current selected tape in the receiver to aVideoTapeOrNil"

	^tapesPresenter selectionOrNil: aVideoTapeOrNil! !
!UI.Examples.VideoLibraryShell categoriesForMethods!
addTape!commands!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
editRecording!commands!public! !
erase!commands!public! !
hasSelectedRecording!accessing!public! !
hasSelectedTape!accessing!public! !
model:!accessing!public! !
onTapeSelected!event handling!private! !
onViewOpened!event handling!public! !
queryCommand:!commands!private! !
record!commands!public! !
recording!accessing!public! !
recording:!accessing!public! !
removeTape!commands!public! !
tape!accessing!public! !
tape:!accessing!public! !
!

!UI.Examples.VideoLibraryShell class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^VideoLibrary default!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Video Library'!

icon
	"Answers an Icon that can be used to represent this class"

	^VideoLibrary icon!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"

	Smalltalk developmentSystem 
		addSamplesFolderIconFor: self
		description: self displayString
		helpId: 10617!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 #{Graphics.Color} #face3d nil 39 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 1048838 #{UI.FramingLayout} 170 176 34 16 410 #{UI.TabViewXP} 34 28 nil 416 34 2 8 1140916738 1 672 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 480 nil 7 nil nil nil 672 nil 8 1814862704 786950 #{Core.Message} #displayString 8 #() 850 #iconImageIndex 880 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil #noIcons nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 11 21 578 1155 707 672 994 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 672 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 70 2 0 0 107 1 0 0] 8 #() 578 193 193 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 11 1218 #fixedParentRight -13 1218 #fixedParentTop 21 1218 #fixedParentBottom -95 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 1296 nil 466 #default nil 7 nil nil nil 1296 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #addTape 8 '&Add Tape' 1 1 nil nil false nil nil nil 946 34 3 994 #createAt:extent: 34 2 578 785 747 578 171 51 1296 994 #isEnabled: 8 #(false) 1296 994 #text: 34 1 8 '&Add Tape' 1296 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 117 1 0 0 221 1 0 0 142 1 0 0] 8 #() 1168 nil 29 1186 1248 -393 1218 #fixedViewLeft 171 1280 -75 1218 #fixedViewTop 51 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 1712 nil nil nil 7 nil nil nil 1712 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 946 34 2 994 #createAt:extent: 34 2 578 21 747 578 171 41 1712 994 #text: 34 1 8 'Library Name:' 1712 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 117 1 0 0 95 0 0 0 137 1 0 0] 8 #() 1168 nil 27 1186 1232 21 1680 171 1280 -75 1696 41 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 2032 nil 1360 nil 7 nil nil nil 2032 nil 8 1815097472 1394 #removeTape 8 '&Remove Tape' 1 1 nil nil false nil nil nil 946 34 3 994 #createAt:extent: 34 2 578 975 747 578 171 51 2032 994 #isEnabled: 8 #(false) 2032 994 #text: 34 1 8 '&Remove Tape' 2032 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 231 1 0 0 117 1 0 0 60 2 0 0 142 1 0 0] 8 #() 1168 nil 29 1186 1248 -203 1680 171 1280 -75 1696 51 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 2384 nil 1360 nil 7 nil nil nil 2384 nil 8 1815097472 1394 #record 8 'Re&cord' 1 1 nil nil false nil nil nil 946 34 3 994 #createAt:extent: 34 2 578 785 527 578 171 51 2384 994 #isEnabled: 8 #(false) 2384 994 #text: 34 1 8 'Re&cord' 2384 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 7 1 0 0 221 1 0 0 32 1 0 0] 8 #() 1168 nil 29 1186 1248 -393 1680 171 1280 -295 1696 51 410 #{UI.PushButton} 34 20 nil 416 34 2 8 1140924416 1 2736 nil 1360 nil 7 nil nil nil 2736 nil 8 1815097472 1394 #erase 8 '&Erase' 1 1 nil nil false nil nil nil 946 34 3 994 #createAt:extent: 34 2 578 975 527 578 171 51 2736 994 #isEnabled: 8 #(false) 2736 994 #text: 34 1 8 '&Erase' 2736 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 231 1 0 0 7 1 0 0 60 2 0 0 32 1 0 0] 8 #() 1168 nil 29 1186 1248 -203 1680 171 1280 -295 1696 51 410 #{UI.TextEdit} 34 16 nil 416 34 2 8 1140916352 1025 3088 nil 1360 nil 7 nil nil nil 3088 nil 8 1815092992 1794 nil nil 1 946 34 1 994 #createAt:extent: 34 2 578 191 747 578 575 41 3088 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 117 1 0 0 126 1 0 0 137 1 0 0] 8 #() 1168 nil 27 1186 1232 191 1248 -413 1280 -75 1696 41 410 #{UI.ListView} 34 45 nil 416 34 2 8 1140920397 1025 3344 738 138 144 784 nil 816 1360 nil 7 nil nil nil 3344 nil 8 1815049392 850 #displayString 8 #() 850 #iconImageIndex 3472 928 nil nil nil nil nil nil 138 144 34 4 1117254 5 #{UI.ListViewColumn} 8 'Programme' 607 #left 3456 850 #<= 8 #() 850 #title 784 nil 3344 nil 3 nil nil 3538 8 'Length' 101 #left 3456 850 #<= 8 #() 850 #length 784 nil 3344 nil 1 nil nil 3538 8 'Date' 201 #left 3456 850 #<= 8 #() 850 #date 784 nil 3344 nil 1 nil nil 3538 8 'Time' 201 #left 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 6 1 3824 8 'doIt' 8 '[:t | | stream |
	stream := String writeStream.
	t printOn: stream format: ''hh:mmtt''.
	stream contents]' 8 #[34 105 45 159 90 233 1 31 193 97 226 36 106] 1442886 2 #{Kernel.VariableBinding} #String #{Core.String} #{Core} 1 #writeStream 8 'hh:mmtt' #printOn:format: #contents 3840 7 65793 nil 850 #<= 8 #() 850 #time 784 nil 3344 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 946 34 2 994 #createAt:extent: 34 2 578 31 41 578 1115 467 3344 994 #text: 34 1 8 'Programme' 3344 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 20 0 0 0 60 2 0 0 253 0 0 0] 8 #() 1168 nil 35 1186 1232 31 1248 -33 1264 41 1280 -315 170 192 34 6 3344 8 'recordings' 672 8 'tapes' 3088 8 'owner' nil nil nil nil nil 1 nil nil nil 578 791 491 1 nil nil 946 34 2 994 #createAt:extent: 34 2 578 12287 21 578 1211 901 416 994 #text: 34 1 8 'Video Library' 416 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 92 26 0 0 204 1 0 0] 34 8 1712 3088 1296 2032 3344 2384 2736 672 1168 nil 27)!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !
!UI.Examples.VideoLibraryShell class categoriesForMethods!
defaultModel!models!public! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!development!initializing!private! !
resource_Default_view!public!resources-views! !
shutdownOnExit!public!testing! !
!

