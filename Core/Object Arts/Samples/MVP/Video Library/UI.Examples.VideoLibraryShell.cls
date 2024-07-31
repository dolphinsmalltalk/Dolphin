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

	<commandQuery: #hasSelectedRecording>
	recordingsPresenter model remove: self recording!

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

record
	"Adds a programme recording to the current tape"

	<commandQuery: #hasSelectedTape>
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

	<commandQuery: #hasSelectedTape>
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
addTape!commands-actions!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
editRecording!commands-actions!public! !
erase!commands-actions!public! !
hasSelectedRecording!accessing!public! !
hasSelectedTape!accessing!public! !
model:!accessing!public! !
onTapeSelected!event handling!private! !
onViewOpened!event handling!public! !
record!commands-actions!public! !
recording!accessing!public! !
recording:!accessing!public! !
removeTape!commands-actions!public! !
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #face3d nil 5 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 16 18 #{UI.TabViewXP} 50 28 nil 32 50 2 8 1140916738 1 288 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 112 nil 5 nil nil nil 288 nil nil 518 #{Core.Message} #displayString 8 #() 450 #iconImageIndex 480 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil #noIcons nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[5 0 0 0 10 0 0 0 70 2 0 0 107 1 0 0] 193 320 8 '' 288 594 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 288 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 11 850 #fixedParentRight -13 850 #fixedParentTop 21 850 #fixedParentBottom -95 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140920397 1025 928 354 386 0 nil 432 98 #default nil 5 nil nil nil 928 nil nil 450 #displayString 8 #() 450 #iconImageIndex 1056 528 nil nil nil nil nil nil 386 4 3142 5 #{UI.ListViewColumn} 8 'Programme' 607 #left 1040 450 #<= 8 #() 450 #title 8 #() nil 928 nil 3 nil nil 1106 8 'Length' 101 #left 1040 450 #<= 8 #() 450 #length 1200 nil 928 nil 1 nil nil 1106 8 'Date' 201 #left 1040 450 #<= 8 #() 450 #date 1200 nil 928 nil 1 nil nil 1106 8 'Time' 201 #left 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 6 1 1408 8 'doIt' 8 '[:t | | stream |
	stream := String writeStream.
	t printOn: stream format: ''hh:mmtt''.
	stream contents]' 8 #[34 105 45 159 90 233 1 31 193 97 226 36 106] 1094 2 #{Kernel.VariableBinding} #String #{Core.String} #{Core} 1 #writeStream 8 'hh:mmtt' #printOn:format: #contents 1424 7 65793 nil 450 #<= 8 #() 450 #time 1200 nil 928 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 928 nil nil nil nil nil nil nil nil nil 546 50 1 594 #createWindow: 50 1 642 674 8 #[15 0 0 0 20 0 0 0 60 2 0 0 253 0 0 0] 193 960 8 'Programme' 928 3 8 #() 786 193 193 nil 35 818 864 31 880 -33 896 41 912 -315 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 1840 nil 1024 nil 5 nil nil nil 1840 nil nil 1350 4 #{UI.CommandDescription} #record 8 'Re&cord' 1 1 nil nil false nil nil nil 546 50 2 594 #createWindow: 50 1 642 674 8 #[136 1 0 0 7 1 0 0 221 1 0 0 32 1 0 0] 193 1872 8 'Re&cord' 1840 594 #isEnabled: 8 #(false) 1840 3 8 #() 786 193 193 nil 29 818 880 -393 850 #fixedViewLeft 171 912 -295 850 #fixedViewTop 51 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 2192 nil 1024 nil 5 nil nil nil 2192 nil nil 1906 #erase 8 '&Erase' 1 1 nil nil false nil nil nil 546 50 2 594 #createWindow: 50 1 642 674 8 #[231 1 0 0 7 1 0 0 60 2 0 0 32 1 0 0] 193 2224 8 '&Erase' 2192 594 #isEnabled: 8 #(false) 2192 3 8 #() 786 193 193 nil 29 818 880 -203 2160 171 912 -295 2176 51 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2496 nil nil nil 5 nil nil nil 2496 nil nil 518 #{UI.NullConverter} nil nil nil 546 50 2 594 #createWindow: 50 1 642 674 8 #[10 0 0 0 117 1 0 0 95 0 0 0 137 1 0 0] 193 2528 nil 2496 594 #text: 50 1 8 'Library Name:' 2496 3 8 #() 786 193 193 nil 27 818 864 21 2160 171 912 -75 2176 41 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140916352 1025 2800 nil 1024 nil 5 nil nil nil 2800 nil nil 2562 nil nil 1 #focusLost nil nil nil 546 50 1 594 #createWindow: 50 1 642 674 8 #[95 0 0 0 117 1 0 0 126 1 0 0 137 1 0 0] 193 2832 nil 2800 3 8 #() 786 193 193 nil 45 818 864 191 880 -413 912 -75 2176 41 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 3040 nil 1024 nil 5 nil nil nil 3040 nil nil 1906 #addTape 8 '&Add Tape' 1 1 nil nil false nil nil nil 546 50 2 594 #createWindow: 50 1 642 674 8 #[136 1 0 0 117 1 0 0 221 1 0 0 142 1 0 0] 193 3072 8 '&Add Tape' 3040 594 #isEnabled: 8 #(false) 3040 3 8 #() 786 193 193 nil 29 818 880 -393 2160 171 912 -75 2176 51 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 3344 nil 1024 nil 5 nil nil nil 3344 nil nil 1906 #removeTape 8 '&Remove Tape' 1 1 nil nil false nil nil nil 546 50 2 594 #createWindow: 50 1 642 674 8 #[231 1 0 0 117 1 0 0 60 2 0 0 142 1 0 0] 193 3376 8 '&Remove Tape' 3344 594 #isEnabled: 8 #(false) 3344 3 8 #() 786 193 193 nil 29 818 880 -203 2160 171 912 -75 2176 51 242 #{Core.IdentityDictionary} 50 6 2800 8 'owner' 928 8 'recordings' 288 8 'tapes' nil nil nil nil nil 1 nil nil nil 786 791 491 1 nil 193 546 50 1 594 #createWindow: 50 1 642 518 #{Graphics.Rectangle} 786 7679 21 786 8889 921 193 80 8 'Video Library' 32 1 50 8 2496 2800 3040 3344 928 1840 2192 288 786 193 193 nil 27)!

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

