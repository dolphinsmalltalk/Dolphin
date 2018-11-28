"Filed out from Dolphin Smalltalk 7"!

Shell subclass: #VideoLibraryShell
	instanceVariableNames: 'ownerPresenter tapesPresenter recordingsPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VideoLibraryShell guid: (GUID fromString: '{46aa1198-1908-4799-b06c-c003165d09ff}')!
VideoLibraryShell comment: 'VideoLibraryShell a modeless user interface for displaying and editing the contents of a VideoLibrary. This class is part of the Video Library sample package. Please see the package comment for more details.

Example:usage

VideoLibraryShell show.

or 

VideoLibraryShell showOn: (VideoLibrary new owner: ''Mary Joe'')'!
!VideoLibraryShell categoriesForClass!Samples! !
!VideoLibraryShell methodsFor!

addTape
	"Create a new tape and add it to the receiver's library"

	| tape |
	tape := NewVideoTapeDialog showModal.
	tape notNil ifTrue: [
		tapesPresenter model add: tape.
		self tape: tape ]!

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

	VideoRecordingDialog showModalOn: self recording
	!

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
	recording notNil ifTrue: [
		recordingsPresenter model add: recording.
		self recording: recording ].
	!

recording
	"Answer the current selected recording in the receiver or nil if there is none"

	^recordingsPresenter selectionOrNil!

recording: aVideoRecordingOrNil
	"Sets the current selected video recording  in the receiver to aVideoRecordingOrNil"

	^recordingsPresenter selectionOrNil: aVideoRecordingOrNil!

removeTape
	"Removes the current tape from the receiver's library"

	| index |
	index := tapesPresenter selectionByIndex.
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
!VideoLibraryShell categoriesFor: #addTape!commands!public! !
!VideoLibraryShell categoriesFor: #createComponents!initializing!public! !
!VideoLibraryShell categoriesFor: #createSchematicWiring!initializing!public! !
!VideoLibraryShell categoriesFor: #editRecording!commands!public! !
!VideoLibraryShell categoriesFor: #erase!commands!public! !
!VideoLibraryShell categoriesFor: #hasSelectedRecording!accessing!public! !
!VideoLibraryShell categoriesFor: #hasSelectedTape!accessing!public! !
!VideoLibraryShell categoriesFor: #model:!accessing!public! !
!VideoLibraryShell categoriesFor: #onTapeSelected!event handling!private! !
!VideoLibraryShell categoriesFor: #onViewOpened!event handling!public! !
!VideoLibraryShell categoriesFor: #queryCommand:!commands!private! !
!VideoLibraryShell categoriesFor: #record!commands!public! !
!VideoLibraryShell categoriesFor: #recording!accessing!public! !
!VideoLibraryShell categoriesFor: #recording:!accessing!public! !
!VideoLibraryShell categoriesFor: #removeTape!commands!public! !
!VideoLibraryShell categoriesFor: #tape!accessing!public! !
!VideoLibraryShell categoriesFor: #tape:!accessing!public! !

!VideoLibraryShell class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^VideoLibrary default!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Video Library'!

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 721158 ##(Smalltalk.SystemColor) 31 nil 37 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 16 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 672 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 7 nil nil nil 672 nil 8 1915188384 1180998 4 ##(Smalltalk.CommandDescription) #record 8 'Re&cord' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 785 527 578 171 51 672 914 #isEnabled: 8 #(false) 672 914 #text: 34 1 8 'Re&cord' 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 7 1 0 0 221 1 0 0 32 1 0 0] 8 #() 578 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentRight -393 1186 #fixedViewLeft 171 1186 #fixedParentBottom -295 1186 #fixedViewTop 51 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 1264 nil nil nil 7 nil nil nil 1264 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil nil 850 138 144 34 2 914 #createAt:extent: 34 2 578 21 747 578 171 41 1264 914 #text: 34 1 8 'Library Name:' 1264 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 117 1 0 0 95 0 0 0 137 1 0 0] 8 #() 1136 nil 27 1154 1186 #fixedParentLeft 21 1216 171 1232 -75 1248 41 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 1616 nil 752 nil 7 nil nil nil 1616 nil 8 1915188384 802 #addTape 8 '&Add Tape' 1 1 nil nil false nil nil nil 850 138 144 34 3 914 #createAt:extent: 34 2 578 785 747 578 171 51 1616 914 #isEnabled: 8 #(false) 1616 914 #text: 34 1 8 '&Add Tape' 1616 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 117 1 0 0 221 1 0 0 142 1 0 0] 8 #() 1136 nil 29 1154 1200 -393 1216 171 1232 -75 1248 51 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 1984 nil 752 nil 7 nil nil nil 1984 nil 8 1915188384 802 #erase 8 '&Erase' 1 1 nil nil false nil nil nil 850 138 144 34 3 914 #createAt:extent: 34 2 578 975 527 578 171 51 1984 914 #isEnabled: 8 #(false) 1984 914 #text: 34 1 8 '&Erase' 1984 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 231 1 0 0 7 1 0 0 60 2 0 0 32 1 0 0] 8 #() 1136 nil 29 1154 1200 -203 1216 171 1232 -295 1248 51 410 ##(Smalltalk.TabViewXP) 34 28 nil 416 34 2 8 1140916738 1 2352 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 480 nil 7 nil nil nil 2352 nil 8 1915274640 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #noIcons nil nil nil nil nil 850 138 144 34 2 914 #createAt:extent: 34 2 578 11 21 578 1155 707 2352 914 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 2352 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 70 2 0 0 107 1 0 0] 8 #() 1136 nil 27 1154 1600 11 1200 -13 1186 #fixedParentTop 21 1232 -95 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 2784 nil 752 nil 7 nil nil nil 2784 nil 8 1915188384 802 #removeTape 8 '&Remove Tape' 1 1 nil nil false nil nil nil 850 138 144 34 3 914 #createAt:extent: 34 2 578 975 747 578 171 51 2784 914 #isEnabled: 8 #(false) 2784 914 #text: 34 1 8 '&Remove Tape' 2784 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 231 1 0 0 117 1 0 0 60 2 0 0 142 1 0 0] 8 #() 1136 nil 29 1154 1200 -203 1216 171 1232 -75 1248 51 410 ##(Smalltalk.ListView) 34 30 nil 416 34 2 8 1140920397 1025 3152 2418 138 144 2464 nil 2496 752 nil 7 nil nil nil 3152 nil 8 1915211424 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2544 nil nil nil nil nil nil 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Programme' 607 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x title]' 8 #[30 105 17 158 106] #title 3408 7 257 nil nil 3152 nil 3 nil nil 3298 8 'Length' 101 #left ##(Smalltalk.BasicListAbstract) 3346 #<= 8 #() 3394 0 nil 3426 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x length ]
' 8 #[30 105 17 158 106] #length 3568 7 257 nil nil 3152 nil 1 nil nil 3298 8 'Date' 201 #left ##(Smalltalk.BasicListAbstract) 3346 #<= 8 #() 3394 0 nil 3426 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x date]' 8 #[30 105 17 158 106] #date 3712 7 257 nil nil 3152 nil 1 nil nil 3298 8 'Time' 201 #left 3394 0 nil 3426 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:t | | stream |
	stream := String writeStream.
	t printOn: stream format: ''hh:mmtt''.
	stream contents ]' 8 #[34 105 45 159 90 233 1 31 193 74 162 106] 721414 ##(Smalltalk.Association) #String 16 #writeStream 8 'hh:mmtt' #printOn:format: #contents 3824 7 65793 nil 3346 #<= 8 #() 3394 0 nil 3426 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x time]' 8 #[30 105 17 158 106] #time 3984 7 257 nil nil 3152 nil 1 nil nil #report 2464 nil 131169 nil 34 4 nil nil 578 1 1 nil 850 138 144 34 2 914 #createAt:extent: 34 2 578 31 41 578 1115 467 3152 914 #text: 34 1 8 'Programme' 3152 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 20 0 0 0 60 2 0 0 253 0 0 0] 8 #() 1136 nil 27 1154 1600 31 1200 -33 2768 41 1232 -315 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916352 1025 4320 nil 752 nil 7 nil nil nil 4320 nil 8 1915280032 1346 nil nil 1 850 138 144 34 1 914 #createAt:extent: 34 2 578 191 747 578 575 41 4320 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 117 1 0 0 126 1 0 0 137 1 0 0] 8 #() 1136 nil 27 1154 1600 191 1200 -413 1232 -75 1248 41 170 192 34 6 3152 8 'recordings' 4320 8 'owner' 2352 8 'tapes' nil nil nil nil nil 1 nil nil nil 578 791 491 1 nil nil 850 138 144 34 3 914 #createAt:extent: 34 2 578 3839 21 578 1211 901 416 914 #text: 34 1 8 'Video Library' 416 914 #updateMenuBar 2464 416 1074 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 220 9 0 0 204 1 0 0] 34 8 1264 4320 1616 2784 3152 672 1984 2352 1136 nil 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !
!VideoLibraryShell class categoriesFor: #defaultModel!models!public! !
!VideoLibraryShell class categoriesFor: #displayOn:!displaying!public! !
!VideoLibraryShell class categoriesFor: #icon!constants!public! !
!VideoLibraryShell class categoriesFor: #initialize!development!initializing!private! !
!VideoLibraryShell class categoriesFor: #resource_Default_view!public!resources-views! !
!VideoLibraryShell class categoriesFor: #shutdownOnExit!public!testing! !

