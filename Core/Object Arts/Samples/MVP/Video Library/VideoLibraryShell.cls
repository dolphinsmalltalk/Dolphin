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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d nil 37 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 16 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 672 nil 466 #default nil 7 nil nil nil 672 nil 8 1903885040 1180998 4 ##(Smalltalk.CommandDescription) #erase 8 '&Erase' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 975 527 578 171 51 672 882 #isEnabled: 8 #(false) 672 882 #text: 34 1 8 '&Erase' 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 231 1 0 0 7 1 0 0 60 2 0 0 32 1 0 0] 8 #() 578 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentRight -203 1154 #fixedViewLeft 171 1154 #fixedParentBottom -295 1154 #fixedViewTop 51 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 1232 nil 736 nil 7 nil nil nil 1232 nil 8 1903885040 770 #addTape 8 '&Add Tape' 1 1 nil nil false nil nil nil 818 138 144 34 3 882 #createAt:extent: 34 2 578 785 747 578 171 51 1232 882 #isEnabled: 8 #(false) 1232 882 #text: 34 1 8 '&Add Tape' 1232 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 117 1 0 0 221 1 0 0 142 1 0 0] 8 #() 1104 nil 29 1122 1168 -393 1184 171 1200 -75 1216 51 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916352 1025 1600 nil 736 nil 7 nil nil nil 1600 nil 8 1903872368 852486 ##(Smalltalk.NullConverter) nil nil 1 818 138 144 34 1 882 #createAt:extent: 34 2 578 191 747 578 575 41 1600 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 117 1 0 0 126 1 0 0 137 1 0 0] 8 #() 1104 nil 27 1122 1154 #fixedParentLeft 191 1168 -413 1200 -75 1216 41 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 1904 nil 736 nil 7 nil nil nil 1904 nil 8 1903885040 770 #record 8 'Re&cord' 1 1 nil nil false nil nil nil 818 138 144 34 3 882 #createAt:extent: 34 2 578 785 527 578 171 51 1904 882 #isEnabled: 8 #(false) 1904 882 #text: 34 1 8 'Re&cord' 1904 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 1 0 0 7 1 0 0 221 1 0 0 32 1 0 0] 8 #() 1104 nil 29 1122 1168 -393 1184 171 1200 -295 1216 51 410 ##(Smalltalk.TabViewXP) 34 28 nil 416 34 2 8 1140916738 1 2272 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 480 nil 7 nil nil nil 2272 nil 8 1904010400 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #noIcons nil nil nil nil nil 818 138 144 34 2 882 #createAt:extent: 34 2 578 11 21 578 1155 707 2272 882 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 2272 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 70 2 0 0 107 1 0 0] 8 #() 1104 nil 27 1122 1888 11 1168 -13 1154 #fixedParentTop 21 1200 -95 410 ##(Smalltalk.ListView) 34 30 nil 416 34 2 8 1140920397 1025 2704 2338 138 144 2384 nil 2416 736 nil 7 nil nil nil 2704 nil 8 1903904528 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2464 nil nil nil nil nil nil 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Programme' 607 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x title]' 8 #[30 105 17 158 106] #title 2960 7 257 nil nil 2704 nil 3 nil nil 2850 8 'Length' 101 #left ##(Smalltalk.BasicListAbstract) 2898 #<= 8 #() 2946 0 nil 2978 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x length ]
' 8 #[30 105 17 158 106] #length 3120 7 257 nil nil 2704 nil 1 nil nil 2850 8 'Date' 201 #left ##(Smalltalk.BasicListAbstract) 2898 #<= 8 #() 2946 0 nil 2978 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x date]' 8 #[30 105 17 158 106] #date 3264 7 257 nil nil 2704 nil 1 nil nil 2850 8 'Time' 201 #left 2946 0 nil 2978 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:t | | stream |
	stream := String writeStream.
	t printOn: stream format: ''hh:mmtt''.
	stream contents ]' 8 #[34 105 45 159 90 233 1 31 193 74 162 106] 721414 ##(Smalltalk.Association) #String 16 #writeStream 8 'hh:mmtt' #printOn:format: #contents 3376 7 65793 nil 2898 #<= 8 #() 2946 0 nil 2978 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x time]' 8 #[30 105 17 158 106] #time 3536 7 257 nil nil 2704 nil 1 nil nil #report 2384 nil 131169 nil 34 4 nil nil 578 1 1 nil 818 138 144 34 2 882 #createAt:extent: 34 2 578 31 41 578 1115 467 2704 882 #text: 34 1 8 'Programme' 2704 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 20 0 0 0 60 2 0 0 253 0 0 0] 8 #() 1104 nil 27 1122 1888 31 1168 -33 2688 41 1200 -315 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 3872 nil 736 nil 7 nil nil nil 3872 nil 8 1903885040 770 #removeTape 8 '&Remove Tape' 1 1 nil nil false nil nil nil 818 138 144 34 3 882 #createAt:extent: 34 2 578 975 747 578 171 51 3872 882 #isEnabled: 8 #(false) 3872 882 #text: 34 1 8 '&Remove Tape' 3872 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 231 1 0 0 117 1 0 0 60 2 0 0 142 1 0 0] 8 #() 1104 nil 29 1122 1168 -203 1184 171 1200 -75 1216 51 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 4240 nil nil nil 7 nil nil nil 4240 nil 8 1903849936 1682 nil nil nil 818 138 144 34 2 882 #createAt:extent: 34 2 578 21 747 578 171 41 4240 882 #text: 34 1 8 'Library Name:' 4240 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 117 1 0 0 95 0 0 0 137 1 0 0] 8 #() 1104 nil 27 1122 1888 21 1184 171 1200 -75 1216 41 170 192 34 6 1600 8 'owner' 2704 8 'recordings' 2272 8 'tapes' nil nil nil nil nil 1 nil nil nil 578 791 491 1 nil nil 818 138 144 34 3 882 #createAt:extent: 34 2 578 3839 21 578 1211 901 416 882 #text: 34 1 8 'Video Library' 416 882 #updateMenuBar 2384 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 220 9 0 0 204 1 0 0] 34 8 4240 1600 1232 3872 2704 1904 672 2272 1104 nil 27 )!

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

