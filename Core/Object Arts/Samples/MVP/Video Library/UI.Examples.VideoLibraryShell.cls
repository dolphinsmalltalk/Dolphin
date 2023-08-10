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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #face3d nil 7 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 8 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140920397 1025 304 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 98 #default nil 7 nil nil nil 304 nil 8 1853243664 518 #{Core.Message} #displayString 8 #() 498 #iconImageIndex 528 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 402 4 3142 5 #{UI.ListViewColumn} 8 'Programme' 607 #left 512 498 #<= 8 #() 498 #title 8 #() nil 304 nil 3 nil nil 610 8 'Length' 101 #left 512 498 #<= 8 #() 498 #length 704 nil 304 nil 1 nil nil 610 8 'Date' 201 #left 512 498 #<= 8 #() 498 #date 704 nil 304 nil 1 nil nil 610 8 'Time' 201 #left 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 6 1 912 8 'doIt' 8 '[:t | | stream |
	stream := String writeStream.
	t printOn: stream format: ''hh:mmtt''.
	stream contents]' 8 #[34 105 45 159 90 233 1 31 193 97 226 36 106] 1094 2 #{Kernel.VariableBinding} #String #{Core.String} #{Core} 1 #writeStream 8 'hh:mmtt' #printOn:format: #contents 928 7 65793 nil 498 #<= 8 #() 498 #time 704 nil 304 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 31 41 210 1115 467 304 1186 #text: 50 1 8 'Programme' 304 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 20 0 0 0 60 2 0 0 253 0 0 0] 8 #() 210 193 193 nil 35 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 31 1426 #fixedParentRight -33 1426 #fixedParentTop 41 1426 #fixedParentBottom -315 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 1504 nil 464 nil 7 nil nil nil 1504 nil 8 1853182784 1350 4 #{UI.CommandDescription} #record 8 'Re&cord' 1 1 nil nil false nil nil nil 1138 50 3 1186 #createAt:extent: 50 2 210 785 527 210 171 51 1504 1186 #isEnabled: 8 #(false) 1504 1186 #text: 50 1 8 'Re&cord' 1504 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 7 1 0 0 221 1 0 0 32 1 0 0] 8 #() 1376 nil 29 1394 1456 -393 1426 #fixedViewLeft 171 1488 -295 1426 #fixedViewTop 51 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 1904 nil 464 nil 7 nil nil nil 1904 nil 8 1853182784 1586 #erase 8 '&Erase' 1 1 nil nil false nil nil nil 1138 50 3 1186 #createAt:extent: 50 2 210 975 527 210 171 51 1904 1186 #isEnabled: 8 #(false) 1904 1186 #text: 50 1 8 '&Erase' 1904 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 231 1 0 0 7 1 0 0 60 2 0 0 32 1 0 0] 8 #() 1376 nil 29 1394 1456 -203 1872 171 1488 -295 1888 51 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 2256 nil 464 nil 7 nil nil nil 2256 nil 8 1853182784 1586 #removeTape 8 '&Remove Tape' 1 1 nil nil false nil nil nil 1138 50 3 1186 #createAt:extent: 50 2 210 975 747 210 171 51 2256 1186 #isEnabled: 8 #(false) 2256 1186 #text: 50 1 8 '&Remove Tape' 2256 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 231 1 0 0 117 1 0 0 60 2 0 0 142 1 0 0] 8 #() 1376 nil 29 1394 1456 -203 1872 171 1488 -75 1888 51 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 2608 nil 464 nil 7 nil nil nil 2608 nil 8 1853182784 1586 #addTape 8 '&Add Tape' 1 1 nil nil false nil nil nil 1138 50 3 1186 #createAt:extent: 50 2 210 785 747 210 171 51 2608 1186 #isEnabled: 8 #(false) 2608 1186 #text: 50 1 8 '&Add Tape' 2608 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 117 1 0 0 221 1 0 0 142 1 0 0] 8 #() 1376 nil 29 1394 1456 -393 1872 171 1488 -75 1888 51 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2960 nil nil nil 7 nil nil nil 2960 nil 8 1853387904 518 #{UI.NullConverter} nil nil nil 1138 50 2 1186 #createAt:extent: 50 2 210 21 747 210 171 41 2960 1186 #text: 50 1 8 'Library Name:' 2960 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 117 1 0 0 95 0 0 0 137 1 0 0] 8 #() 1376 nil 27 1394 1440 21 1872 171 1488 -75 1888 41 18 #{UI.TabViewXP} 50 28 nil 32 50 2 8 1140916738 1 3280 370 402 0 nil 448 112 nil 7 nil nil nil 3280 nil 8 1852839600 498 #displayString 8 #() 498 #iconImageIndex 3408 576 nil nil nil nil nil #noIcons nil nil nil nil nil 1138 50 2 1186 #createAt:extent: 50 2 210 11 21 210 1155 707 3280 1186 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 3280 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 70 2 0 0 107 1 0 0] 8 #() 1376 nil 27 1394 1440 11 1456 -13 1472 21 1488 -95 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140916352 1025 3632 nil 464 nil 7 nil nil nil 3632 nil 8 1853175488 3042 nil nil 1 #focusLost nil nil nil 1138 50 1 1186 #createAt:extent: 50 2 210 191 747 210 575 41 3632 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 117 1 0 0 126 1 0 0 137 1 0 0] 8 #() 1376 nil 45 1394 1440 191 1456 -413 1488 -75 1888 41 550 #{Core.IdentityDictionary} 3 304 8 'recordings' 3280 8 'tapes' 3632 8 'owner' nil nil nil nil nil 1 nil nil nil 210 791 491 1 nil nil 1138 50 2 1186 #createAt:extent: 50 2 210 6143 21 210 1211 901 32 1186 #text: 50 1 8 'Video Library' 32 1314 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 92 14 0 0 204 1 0 0] 50 8 2960 3632 2608 2256 304 1504 1904 3280 1376 nil 27)!

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

