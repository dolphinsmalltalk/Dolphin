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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 721158 ##(Smalltalk.SystemColor) 31 nil 5 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 16 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 672 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 672 nil 8 1915188384 1180998 4 ##(Smalltalk.CommandDescription) #record 8 'Re&cord' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 801 537 578 171 51 672 914 #isEnabled: 8 #(false) 672 914 #text: 34 1 8 'Re&cord' 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 144 1 0 0 12 1 0 0 229 1 0 0 37 1 0 0] 8 #() 578 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentRight -393 1186 #fixedViewLeft 171 1186 #fixedParentBottom -295 1186 #fixedViewTop 51 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916352 1025 1264 nil 752 nil 5 nil nil nil 1264 nil 8 1915280032 852486 ##(Smalltalk.NullConverter) nil nil 1 850 138 144 34 1 914 #createAt:extent: 34 2 578 191 757 578 591 41 1264 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 122 1 0 0 134 1 0 0 142 1 0 0] 8 #() 1136 nil 27 1154 1186 #fixedParentLeft 191 1200 -413 1232 -75 1248 41 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 1568 nil 752 nil 5 nil nil nil 1568 nil 8 1915188384 802 #removeTape 8 '&Remove Tape' 1 1 nil nil false nil nil nil 850 138 144 34 3 914 #createAt:extent: 34 2 578 991 757 578 171 51 1568 914 #isEnabled: 8 #(false) 1568 914 #text: 34 1 8 '&Remove Tape' 1568 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 239 1 0 0 122 1 0 0 68 2 0 0 147 1 0 0] 8 #() 1136 nil 29 1154 1200 -203 1216 171 1232 -75 1248 51 410 ##(Smalltalk.TabViewXP) 34 28 nil 416 34 2 8 1140916738 1 1936 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 480 nil 5 nil nil nil 1936 nil 8 1915274640 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #noIcons nil nil nil nil nil 850 138 144 34 2 914 #createAt:extent: 34 2 578 11 21 578 1171 717 1936 914 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 1936 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 78 2 0 0 112 1 0 0] 8 #() 1136 nil 27 1154 1552 11 1200 -13 1186 #fixedParentTop 21 1232 -95 410 ##(Smalltalk.ListView) 34 30 nil 416 34 2 8 1140920397 1025 2368 2002 138 144 2048 nil 2080 752 nil 5 nil nil nil 2368 nil 8 1915211424 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2128 nil nil nil nil nil nil 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Programme' 623 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x title]' 8 #[30 105 17 158 106] #title 2576 7 257 nil nil 2368 nil 3 nil nil 2514 8 'Length' 101 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 2562 0 nil 2594 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x length ]
' 8 #[30 105 17 158 106] #length 2704 7 257 nil nil 2368 nil 1 nil nil 2514 8 'Date' 201 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 2562 0 nil 2594 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x date]' 8 #[30 105 17 158 106] #date 2816 7 257 nil nil 2368 nil 1 nil nil 2514 8 'Time' 201 #left 2562 0 nil 2594 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:t | | stream |
	stream := String writeStream.
	t printOn: stream format: ''hh:mmtt''.
	stream contents ]' 8 #[34 105 45 159 90 233 1 31 193 74 162 106] 721414 ##(Smalltalk.Association) #String 16 #writeStream 8 'hh:mmtt' #printOn:format: #contents 2928 7 65793 nil ##(Smalltalk.SortedCollection) 2562 0 nil 2594 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x time]' 8 #[30 105 17 158 106] #time 3056 7 257 nil nil 2368 nil 1 nil nil #report 2048 nil 131169 nil nil 850 138 144 34 2 914 #createAt:extent: 34 2 578 31 41 578 1131 477 2368 914 #text: 34 1 8 'Programme' 2368 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 20 0 0 0 68 2 0 0 2 1 0 0] 8 #() 1136 nil 27 1154 1552 31 1200 -33 2352 41 1232 -315 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3360 nil nil nil 5 nil nil nil 3360 nil 8 1915124368 1346 nil nil nil 850 138 144 34 2 914 #createAt:extent: 34 2 578 21 757 578 171 41 3360 914 #text: 34 1 8 'Library Name:' 3360 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 122 1 0 0 95 0 0 0 142 1 0 0] 8 #() 1136 nil 27 1154 1552 21 1216 171 1232 -75 1248 41 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 3680 nil 752 nil 5 nil nil nil 3680 nil 8 1915188384 802 #addTape 8 '&Add Tape' 1 1 nil nil false nil nil nil 850 138 144 34 3 914 #createAt:extent: 34 2 578 801 757 578 171 51 3680 914 #isEnabled: 8 #(false) 3680 914 #text: 34 1 8 '&Add Tape' 3680 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 144 1 0 0 122 1 0 0 229 1 0 0 147 1 0 0] 8 #() 1136 nil 29 1154 1200 -393 1216 171 1232 -75 1248 51 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 4048 nil 752 nil 5 nil nil nil 4048 nil 8 1915188384 802 #erase 8 '&Erase' 1 1 nil nil false nil nil nil 850 138 144 34 3 914 #createAt:extent: 34 2 578 991 537 578 171 51 4048 914 #isEnabled: 8 #(false) 4048 914 #text: 34 1 8 '&Erase' 4048 1074 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 239 1 0 0 12 1 0 0 68 2 0 0 37 1 0 0] 8 #() 1136 nil 29 1154 1200 -203 1216 171 1232 -295 1248 51 170 192 34 6 2368 8 'recordings' 1936 8 'tapes' 1264 8 'owner' nil nil nil nil nil 1 nil nil nil 578 791 491 1 nil nil 850 138 144 34 3 914 #createAt:extent: 34 2 578 261 261 578 1211 901 416 914 #text: 34 1 8 'Video Library' 416 914 #updateMenuBar 2048 416 1074 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 130 0 0 0 130 0 0 0 223 2 0 0 68 2 0 0] 34 8 3360 1264 3680 1568 2368 672 4048 1936 1136 nil 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !
!VideoLibraryShell class categoriesFor: #defaultModel!models!public! !
!VideoLibraryShell class categoriesFor: #displayOn:!displaying!public! !
!VideoLibraryShell class categoriesFor: #icon!constants!public! !
!VideoLibraryShell class categoriesFor: #initialize!development!initializing!private! !
!VideoLibraryShell class categoriesFor: #resource_Default_view!public!resources-views! !
!VideoLibraryShell class categoriesFor: #shutdownOnExit!public!testing! !

