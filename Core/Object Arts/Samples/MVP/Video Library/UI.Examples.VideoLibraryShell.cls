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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #face3d nil 5 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 16 18 #{UI.TabViewXP} 50 28 nil 32 50 2 8 1140916738 1 320 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 112 nil 5 nil nil nil 320 nil nil 518 #{Core.Message} #displayString 8 #() 482 #iconImageIndex 512 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil #noIcons nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 210 11 21 210 1155 707 320 626 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 320 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 70 2 0 0 107 1 0 0] 8 #() 210 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 11 850 #fixedParentRight -13 850 #fixedParentTop 21 850 #fixedParentBottom -95 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140920397 1025 928 386 418 0 nil 464 98 #default nil 5 nil nil nil 928 nil nil 482 #displayString 8 #() 482 #iconImageIndex 1056 560 nil nil nil nil nil nil 418 4 3142 5 #{UI.ListViewColumn} 8 'Programme' 607 #left 1040 482 #<= 8 #() 482 #title 8 #() nil 928 nil 3 nil nil 1106 8 'Length' 101 #left 1040 482 #<= 8 #() 482 #length 1200 nil 928 nil 1 nil nil 1106 8 'Date' 201 #left 1040 482 #<= 8 #() 482 #date 1200 nil 928 nil 1 nil nil 1106 8 'Time' 201 #left 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 6 1 1408 8 'doIt' 8 '[:t | | stream |
	stream := String writeStream.
	t printOn: stream format: ''hh:mmtt''.
	stream contents]' 8 #[34 105 45 159 90 233 1 31 193 97 226 36 106] 1094 2 #{Kernel.VariableBinding} #String #{Core.String} #{Core} 1 #writeStream 8 'hh:mmtt' #printOn:format: #contents 1424 7 65793 nil 482 #<= 8 #() 482 #time 1200 nil 928 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 578 50 2 626 #createAt:extent: 50 2 210 31 41 210 1115 467 928 626 #text: 50 1 8 'Programme' 928 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 20 0 0 0 60 2 0 0 253 0 0 0] 8 #() 800 nil 35 818 864 31 880 -33 896 41 912 -315 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 1840 nil 1024 nil 5 nil nil nil 1840 nil nil 1350 4 #{UI.CommandDescription} #record 8 'Re&cord' 1 1 nil nil false nil nil nil 578 50 3 626 #createAt:extent: 50 2 210 785 527 210 171 51 1840 626 #isEnabled: 8 #(false) 1840 626 #text: 50 1 8 'Re&cord' 1840 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 7 1 0 0 221 1 0 0 32 1 0 0] 8 #() 800 nil 29 818 880 -393 850 #fixedViewLeft 171 912 -295 850 #fixedViewTop 51 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 2224 nil 1024 nil 5 nil nil nil 2224 nil nil 1906 #erase 8 '&Erase' 1 1 nil nil false nil nil nil 578 50 3 626 #createAt:extent: 50 2 210 975 527 210 171 51 2224 626 #isEnabled: 8 #(false) 2224 626 #text: 50 1 8 '&Erase' 2224 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 231 1 0 0 7 1 0 0 60 2 0 0 32 1 0 0] 8 #() 800 nil 29 818 880 -203 2192 171 912 -295 2208 51 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2560 nil nil nil 5 nil nil nil 2560 nil nil 518 #{UI.NullConverter} nil nil nil 578 50 2 626 #createAt:extent: 50 2 210 21 747 210 171 41 2560 626 #text: 50 1 8 'Library Name:' 2560 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 117 1 0 0 95 0 0 0 137 1 0 0] 8 #() 800 nil 27 818 864 21 2192 171 912 -75 2208 41 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140916352 1025 2864 nil 1024 nil 5 nil nil nil 2864 nil nil 2626 nil nil 1 #focusLost nil nil nil 578 50 1 626 #createAt:extent: 50 2 210 191 747 210 575 41 2864 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 117 1 0 0 126 1 0 0 137 1 0 0] 8 #() 800 nil 45 818 864 191 880 -413 912 -75 2208 41 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 3104 nil 1024 nil 5 nil nil nil 3104 nil nil 1906 #addTape 8 '&Add Tape' 1 1 nil nil false nil nil nil 578 50 3 626 #createAt:extent: 50 2 210 785 747 210 171 51 3104 626 #isEnabled: 8 #(false) 3104 626 #text: 50 1 8 '&Add Tape' 3104 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 117 1 0 0 221 1 0 0 142 1 0 0] 8 #() 800 nil 29 818 880 -393 2192 171 912 -75 2208 51 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 3440 nil 1024 nil 5 nil nil nil 3440 nil nil 1906 #removeTape 8 '&Remove Tape' 1 1 nil nil false nil nil nil 578 50 3 626 #createAt:extent: 50 2 210 975 747 210 171 51 3440 626 #isEnabled: 8 #(false) 3440 626 #text: 50 1 8 '&Remove Tape' 3440 738 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 231 1 0 0 117 1 0 0 60 2 0 0 142 1 0 0] 8 #() 800 nil 29 818 880 -203 2192 171 912 -75 2208 51 274 #{Core.IdentityDictionary} 50 6 2864 8 'owner' 928 8 'recordings' 320 8 'tapes' nil nil nil nil nil 1 nil nil nil 210 791 491 1 nil nil 578 50 2 626 #createAt:extent: 50 2 210 6143 21 210 1211 901 32 626 #text: 50 1 8 'Video Library' 32 738 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 92 14 0 0 204 1 0 0] 50 8 2560 2864 3104 3440 928 1840 2224 320 800 nil 27)!

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

