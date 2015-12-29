"Filed out from Dolphin Smalltalk X6.2"!

Shell subclass: #VideoLibraryShell
	instanceVariableNames: 'ownerPresenter tapesPresenter recordingsPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VideoLibraryShell guid: (GUID fromString: '{46AA1198-1908-4799-B06C-C003165D09FF}')!
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

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ShellView)  98 27 0 0 98 2 27131905 131073 416 0 721158 ##(SystemColor)  31 0 5 0 263174 ##(Font)  0 16 459014 ##(LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Point)  193 193 0 416 852230 ##(FramingLayout)  234 240 98 16 410 8 ##(PushButton)  98 17 0 416 98 2 8 1140924416 1 688 0 524550 ##(ColorRef)  8 4278190080 0 5 0 0 0 688 0 8 4294906781 1180998 4 ##(CommandDescription)  8 #removeTape 8 '&Remove Tape' 1 1 0 0 32 983302 ##(MessageSequence)  202 208 98 3 721670 ##(MessageSend)  8 #createAt:extent: 98 2 594 991 757 594 171 51 688 962 8 #isEnabled: 98 1 32 688 962 8 #text: 98 1 8 '&Remove Tape' 688 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 239 1 0 0 122 1 0 0 68 2 0 0 147 1 0 0] 98 0 594 193 193 0 27 1181766 2 ##(FramingConstraints)  1114638 ##(STBSingletonProxy)  8 ##(FramingCalculation)  8 #fixedParentRight -203 1290 1312 8 #fixedViewLeft 171 1290 1312 8 #fixedParentBottom -75 1290 1312 8 #fixedViewTop 51 410 704 98 17 0 416 98 2 8 1140924416 1 1440 0 770 800 0 5 0 0 0 1440 0 8 4294906781 834 8 #addTape 8 '&Add Tape' 1 1 0 0 32 898 202 208 98 3 962 992 98 2 594 801 757 594 171 51 1440 962 1072 98 1 32 1440 962 1120 98 1 8 '&Add Tape' 1440 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 144 1 0 0 122 1 0 0 229 1 0 0 147 1 0 0] 98 0 1232 0 27 1250 1296 -393 1344 171 1376 -75 1408 51 410 8 ##(ListView)  98 30 0 416 98 2 8 1140920397 1025 1840 590662 2 ##(ListModel)  202 208 98 0 0 1290 8 ##(SearchPolicy)  8 #identity 770 800 0 5 0 0 0 1840 0 8 4294902987 8 ##(BasicListAbstract)  8 ##(IconicListAbstract)  1290 8 ##(IconImageManager)  8 #current 0 0 0 0 0 0 202 208 98 4 920646 5 ##(ListViewColumn)  8 'Programme' 623 8 #left 2064 8 ##(SortedCollection)  787814 3 ##(BlockClosure)  0 0 1180966 ##(CompiledExpression)  2 1 8 ##(UndefinedObject)  8 'doIt' 8 '[:x | x title]' 8 #[30 105 17 158 106] 8 #title 2272 7 257 0 0 1840 0 3 0 0 2178 8 'Length' 101 2224 2064 2240 2258 0 0 2290 2 1 2320 8 'doIt' 8 '[:x | x length ]
' 8 #[30 105 17 158 106] 8 #length 2432 7 257 0 0 1840 0 1 0 0 2178 8 'Date' 201 2224 2064 2240 2258 0 0 2290 2 1 2320 8 'doIt' 8 '[:x | x date]' 8 #[30 105 17 158 106] 8 #date 2560 7 257 0 0 1840 0 1 0 0 2178 8 'Time' 201 2224 2258 0 0 2290 6 1 2320 8 'doIt' 8 '[:t | | stream |
	stream := String writeStream.
	t printOn: stream format: ''hh:mmtt''.
	stream contents ]' 8 #[34 105 45 159 90 233 1 31 193 74 162 106] 721414 ##(Association)  8 #String 80 8 #writeStream 8 'hh:mmtt' 8 #printOn:format: 8 #contents 2688 7 65793 0 2240 2258 0 0 2290 2 1 2320 8 'doIt' 8 '[:x | x time]' 8 #[30 105 17 158 106] 8 #time 2880 7 257 0 0 1840 0 1 0 0 8 #report 1968 0 131169 0 0 898 202 208 98 2 962 992 98 2 594 31 41 594 1131 477 1840 962 1120 98 1 8 'Programme' 1840 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 20 0 0 0 68 2 0 0 2 1 0 0] 98 0 1232 0 27 1250 1290 1312 8 #fixedParentLeft 31 1296 -33 1290 1312 8 #fixedParentTop 41 1376 -315 410 8 ##(StaticText)  98 16 0 416 98 2 8 1140850944 1 3280 0 0 0 5 0 0 0 3280 0 8 4294906439 852486 ##(NullConverter)  0 0 0 898 202 208 98 2 962 992 98 2 594 21 757 594 171 41 3280 962 1120 98 1 8 'Library Name:' 3280 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 122 1 0 0 95 0 0 0 142 1 0 0] 98 0 1232 0 27 1250 3216 21 1344 171 1376 -75 1408 41 410 704 98 17 0 416 98 2 8 1140924416 1 3632 0 770 800 0 5 0 0 0 3632 0 8 4294906781 834 8 #record 8 'Re&cord' 1 1 0 0 32 898 202 208 98 3 962 992 98 2 594 801 537 594 171 51 3632 962 1072 98 1 32 3632 962 1120 98 1 8 'Re&cord' 3632 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 144 1 0 0 12 1 0 0 229 1 0 0 37 1 0 0] 98 0 1232 0 27 1250 1296 -393 1344 171 1376 -295 1408 51 410 8 ##(TextEdit)  98 16 0 416 98 2 8 1140916352 1025 4032 0 770 800 0 5 0 0 0 4032 0 8 4294906635 3378 0 0 1 898 202 208 98 3 962 992 98 2 594 191 757 594 591 41 4032 962 8 #selectionRange: 98 1 525062 ##(Interval)  3 1 3 4032 962 8 #isTextModified: 98 1 32 4032 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 122 1 0 0 134 1 0 0 142 1 0 0] 98 0 1232 0 27 1250 3216 191 1296 -413 1376 -75 1408 41 410 704 98 17 0 416 98 2 8 1140924416 1 4464 0 770 800 0 5 0 0 0 4464 0 8 4294906781 834 8 #erase 8 '&Erase' 1 1 0 0 32 898 202 208 98 3 962 992 98 2 594 991 537 594 171 51 4464 962 1072 98 1 32 4464 962 1120 98 1 8 '&Erase' 4464 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 239 1 0 0 12 1 0 0 68 2 0 0 37 1 0 0] 98 0 1232 0 27 1250 1296 -203 1344 171 1376 -295 1408 51 410 8 ##(TabView)  98 23 0 416 98 2 8 1140916738 1 4864 1922 202 208 1968 0 1984 482 31 0 5 0 0 0 4864 0 8 4294906623 2064 2080 2096 0 0 0 0 0 8 #noIcons 898 202 208 98 2 962 992 98 2 594 11 21 594 1171 717 4864 962 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 4864 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 10 0 0 0 78 2 0 0 112 1 0 0] 98 0 1232 0 27 1250 3216 11 1296 -13 3248 21 1376 -95 234 256 98 6 4864 8 'tapes' 4032 8 'owner' 1840 8 'recordings' 0 0 0 0 0 1 0 0 0 594 791 491 1 0 0 898 202 208 98 3 962 992 98 2 594 221 291 594 1211 901 416 962 1120 98 1 8 'Video Library' 416 962 8 #menuBar: 98 1 0 416 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 145 0 0 0 203 2 0 0 83 2 0 0] 98 8 3280 4032 1440 688 1840 3632 4464 4864 1232 0 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self displayString! !
!VideoLibraryShell class categoriesFor: #defaultModel!models!public! !
!VideoLibraryShell class categoriesFor: #displayOn:!displaying!public! !
!VideoLibraryShell class categoriesFor: #icon!constants!public! !
!VideoLibraryShell class categoriesFor: #initialize!development!initializing!private! !
!VideoLibraryShell class categoriesFor: #resource_Default_view!public!resources-views! !
!VideoLibraryShell class categoriesFor: #shutdownOnExit!public!testing! !
!VideoLibraryShell class categoriesFor: #uninitialize!development!initializing!private! !

