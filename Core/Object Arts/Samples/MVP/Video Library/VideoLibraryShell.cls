"Filed out from Dolphin Smalltalk"!

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

!VideoLibraryShell categoriesForMethods!
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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d nil 5 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 16 410 ##(Smalltalk.TabViewXP) 34 28 nil 416 34 2 8 1140916738 1 640 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 480 nil 5 nil nil nil 640 nil 8 1758664336 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #noIcons nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[5 0 0 0 10 0 0 0 70 2 0 0 107 1 0 0] 193 672 8 '' 640 914 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 640 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 11 1170 #fixedParentRight -13 1170 #fixedParentTop 21 1170 #fixedParentBottom -95 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 1248 nil 466 #default nil 5 nil nil nil 1248 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #addTape 8 '&Add Tape' 1 1 nil nil false nil nil nil 850 138 144 34 2 914 #createWindow: 34 1 962 994 8 #[136 1 0 0 117 1 0 0 221 1 0 0 142 1 0 0] 193 1280 8 '&Add Tape' 1248 914 #isEnabled: 8 #(false) 1248 3 8 #() 1106 193 193 nil 29 1138 1200 -393 1170 #fixedViewLeft 171 1232 -75 1170 #fixedViewTop 51 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 1648 nil 1312 nil 5 nil nil nil 1648 nil 8 1759007584 1346 #record 8 'Re&cord' 1 1 nil nil false nil nil nil 850 138 144 34 2 914 #createWindow: 34 1 962 994 8 #[136 1 0 0 7 1 0 0 221 1 0 0 32 1 0 0] 193 1680 8 'Re&cord' 1648 914 #isEnabled: 8 #(false) 1648 3 8 #() 1106 193 193 nil 29 1138 1200 -393 1616 171 1232 -295 1632 51 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 1984 nil 1312 nil 5 nil nil nil 1984 nil 8 1759007584 1346 #removeTape 8 '&Remove Tape' 1 1 nil nil false nil nil nil 850 138 144 34 2 914 #createWindow: 34 1 962 994 8 #[231 1 0 0 117 1 0 0 60 2 0 0 142 1 0 0] 193 2016 8 '&Remove Tape' 1984 914 #isEnabled: 8 #(false) 1984 3 8 #() 1106 193 193 nil 29 1138 1200 -203 1616 171 1232 -75 1632 51 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916352 1025 2320 nil 1312 nil 5 nil nil nil 2320 nil 8 1759000288 852486 ##(Smalltalk.NullConverter) nil nil 1 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[95 0 0 0 117 1 0 0 126 1 0 0 137 1 0 0] 193 2352 nil 2320 3 8 #() 1106 193 193 nil 27 1138 1184 191 1200 -413 1232 -75 1632 41 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140920397 1025 2608 706 138 144 752 nil 784 1312 nil 5 nil nil nil 2608 nil 8 1759068368 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 832 nil nil nil nil nil nil 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Programme' 607 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x title]' 8 #[30 105 17 158 106] #title 2864 7 257 nil nil 2608 nil 3 nil nil 2754 8 'Length' 101 #left ##(Smalltalk.BasicListAbstract) 2802 #<= 8 #() 2850 0 nil 2882 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x length ]
' 8 #[30 105 17 158 106] #length 3024 7 257 nil nil 2608 nil 1 nil nil 2754 8 'Date' 201 #left ##(Smalltalk.BasicListAbstract) 2802 #<= 8 #() 2850 0 nil 2882 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x date]' 8 #[30 105 17 158 106] #date 3168 7 257 nil nil 2608 nil 1 nil nil 2754 8 'Time' 201 #left 2850 0 nil 2882 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:t | | stream |
	stream := String writeStream.
	t printOn: stream format: ''hh:mmtt''.
	stream contents ]' 8 #[34 105 45 159 90 233 1 31 193 74 162 106] 721414 ##(Smalltalk.Association) #String 16 #writeStream 8 'hh:mmtt' #printOn:format: #contents 3280 7 65793 nil 2802 #<= 8 #() 2850 0 nil 2882 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x time]' 8 #[30 105 17 158 106] #time 3440 7 257 nil nil 2608 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 850 138 144 34 1 914 #createWindow: 34 1 962 994 8 #[15 0 0 0 20 0 0 0 60 2 0 0 253 0 0 0] 193 2640 8 'Programme' 2608 3 8 #() 1106 193 193 nil 35 1138 1184 31 1200 -33 1216 41 1232 -315 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 3728 nil 1312 nil 5 nil nil nil 3728 nil 8 1759007584 1346 #erase 8 '&Erase' 1 1 nil nil false nil nil nil 850 138 144 34 2 914 #createWindow: 34 1 962 994 8 #[231 1 0 0 7 1 0 0 60 2 0 0 32 1 0 0] 193 3760 8 '&Erase' 3728 914 #isEnabled: 8 #(false) 3728 3 8 #() 1106 193 193 nil 29 1138 1200 -203 1616 171 1232 -295 1632 51 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 4064 nil nil nil 5 nil nil nil 4064 nil 8 1759212608 2402 nil nil nil 850 138 144 34 2 914 #createWindow: 34 1 962 994 8 #[10 0 0 0 117 1 0 0 95 0 0 0 137 1 0 0] 193 4096 nil 4064 914 #text: 34 1 8 'Library Name:' 4064 3 8 #() 1106 193 193 nil 27 1138 1184 21 1616 171 1232 -75 1632 41 170 192 34 6 2608 8 'recordings' 2320 8 'owner' 640 8 'tapes' nil nil nil nil nil 1 nil nil nil 1106 791 491 1 nil 193 850 138 144 34 1 914 #createWindow: 34 1 962 590342 ##(Smalltalk.Rectangle) 1106 1 1 1106 1211 901 193 448 8 'Video Library' 416 1 34 8 4064 2320 1248 1984 2608 1648 3728 640 1106 193 193 nil 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !

!VideoLibraryShell class categoriesForMethods!
defaultModel!models!public! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!development!initializing!private! !
resource_Default_view!public!resources-views! !
shutdownOnExit!public!testing! !
!

