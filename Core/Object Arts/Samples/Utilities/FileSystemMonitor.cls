"Filed out from Dolphin Smalltalk 7"!

Shell subclass: #FileSystemMonitor
	instanceVariableNames: 'directoryName notifyAttributes notifyDirectoryName notifyCreateTime notifyFileName notifyLastAccess notifyLastWrite notifySecurity notifySize filters includeSubDirs changeList'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileSystemMonitor guid: (GUID fromString: '{1c0d9cfc-b0a6-4b19-b2c6-cc6e373ff4fa}')!
FileSystemMonitor comment: 'FileSystemMonitor is a <topShell> sample application which is capable of displaying a list of the changes being made to a specified directory hierarchy in the file system. It is mainly intended to demonstrate the FileSystemWatcher class.

Note that if you initiate monitoring on the root of your system drive (typically c:\) with sub-directory monitoring enabled (the default), you may start to receive a very large number of notifications!!

Instance Variables:
	directoryName		<TextPresenter>
	notifyAttributes		<BooleanPresenter>
	notifyDirectoryName	<BooleanPresenter>
	notifyCreateTime		<BooleanPresenter>
	notifyFileName		<BooleanPresenter>
	notifyLastAccess	<BooleanPresenter>
	notifyLastWrite		<BooleanPresenter>
	notifySecurity		<BooleanPresenter>
	notifySize			<BooleanPresenter>
	filters				<TextPresenter>
	includeSubDirs		<BooleanPresenter>
	changeList			<ListPresenter>
'!
!FileSystemMonitor categoriesForClass!MVP-Presenters! !
!FileSystemMonitor methodsFor!

about
	"Private - Pop up a little helpful info. about this sample program."

	(MessageBox new)
		caption: 'About ' , self class name asPhrase;
		icon: self icon;
		text: ('Directory change monitoring sample. Copyright (c) Object Arts Ltd, 2005.<n><1s><n>
This sample monitors and displays file system changes occurring with a directory hierarchy as reported by the operating system. 
It is mainly intended to demonstrate the use of the FileSystemWatcher class.<n>
DISCLAIMER: This software is freely provided purely as an educational sample and as such it is provided "as is", WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.' 
					expandMacrosWith: VMLibrary default fullVersion);
		open!

addChange: anArray 
	| i |
	i := changeList model addAnsweringIndex: anArray.
	changeList view ensureVisible: i!

chooseDirectory
	BrowseFolderDialog showModalOn: directoryName model!

clear
	changeList clear!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	directoryName := self add: TextPresenter new name: 'directoryName'.
	notifyAttributes := self add: BooleanPresenter new name: 'notifyAttributes'.
	notifyDirectoryName := self add: BooleanPresenter new name: 'notifyDirectoryName'.
	notifyCreateTime := self add: BooleanPresenter new name: 'notifyCreateTime'.
	notifyFileName := self add: BooleanPresenter new name: 'notifyFileName'.
	notifyLastAccess := self add: BooleanPresenter new name: 'notifyLastAccess'.
	notifyLastWrite := self add: BooleanPresenter new name: 'notifyLastWrite'.
	notifySecurity := self add: BooleanPresenter new name: 'notifySecurity'.
	notifySize := self add: BooleanPresenter new name: 'notifySize'.
	filters := self add: TextPresenter new name: 'filters'.
	includeSubDirs := self add: BooleanPresenter new name: 'includeSubDirs'.
	changeList := self add: ListPresenter new name: 'changeList'!

createSchematicWiring
	(self model)
		when: #fileAdded:
			send: #onFileAdded:
			to: self;
		when: #fileRemoved:
			send: #onFileRemoved:
			to: self;
		when: #fileModified:
			send: #onFileModified:
			to: self;
		when: #fileRenamedFrom:to:
			send: #onFileRenamedFrom:to:
			to: self!

model: aFileSystemWatcher 
	super model: aFileSystemWatcher.
	directoryName model: (aFileSystemWatcher aspectValue: #directory).
	filters model: (aFileSystemWatcher aspectValue: #filterString).
	notifyAttributes model: (aFileSystemWatcher aspectValue: #notifyAttributes).
	notifyDirectoryName model: (aFileSystemWatcher aspectValue: #notifyDirectoryName).
	notifyCreateTime model: (aFileSystemWatcher aspectValue: #notifyCreationTime).
	notifyFileName model: (aFileSystemWatcher aspectValue: #notifyFileName).
	notifyLastAccess model: (aFileSystemWatcher aspectValue: #notifyLastAccess).
	notifyLastWrite model: (aFileSystemWatcher aspectValue: #notifyLastWrite).
	notifySecurity model: (aFileSystemWatcher aspectValue: #notifySecurity).
	notifySize model: (aFileSystemWatcher aspectValue: #notifySize).
	includeSubDirs model: (aFileSystemWatcher aspectValue: #watchSubDirs)!

onFileAdded: aString 
	self addChange: (Array 
				with: 'Added'
				with: Time now
				with: aString)!

onFileModified: aString 
	self addChange: (Array 
				with: 'Modified'
				with: Time now
				with: aString)!

onFileRemoved: aString 
	self addChange: (Array 
				with: 'Removed'
				with: Time now
				with: aString)!

onFileRenamedFrom: aString to: aString2 
	self addChange: (Array 
				with: 'Renamed'
				with: Time now
				with: aString -> aString2)!

queryCommand: aCommandQuery 
	| cmd |
	cmd := aCommandQuery commandSymbol.
	cmd == #toggleMonitoring 
		ifTrue: 
			[aCommandQuery
				isEnabled: (directoryName value ifNil: [false] ifNotNil: [:text | text notEmpty]);
				isChecked: self model isMonitoring.
			^true].
	^super queryCommand: aCommandQuery!

toggleMonitoring
	self model isMonitoring: self model isMonitoring not! !
!FileSystemMonitor categoriesFor: #about!enquiries!private! !
!FileSystemMonitor categoriesFor: #addChange:!helpers!private! !
!FileSystemMonitor categoriesFor: #chooseDirectory!commands!public! !
!FileSystemMonitor categoriesFor: #clear!commands!public! !
!FileSystemMonitor categoriesFor: #createComponents!initializing!public! !
!FileSystemMonitor categoriesFor: #createSchematicWiring!initializing!public! !
!FileSystemMonitor categoriesFor: #model:!accessing!public! !
!FileSystemMonitor categoriesFor: #onFileAdded:!event handling!private! !
!FileSystemMonitor categoriesFor: #onFileModified:!event handling!private! !
!FileSystemMonitor categoriesFor: #onFileRemoved:!event handling!private! !
!FileSystemMonitor categoriesFor: #onFileRenamedFrom:to:!event handling!private! !
!FileSystemMonitor categoriesFor: #queryCommand:!public! !
!FileSystemMonitor categoriesFor: #toggleMonitoring!public! !

!FileSystemMonitor class methodsFor!

defaultModel
	^FileSystemWatcher new!

icon
	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"

	Smalltalk developmentSystem
		addSamplesFolderIconFor: self description: self displayString!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 328198 ##(Smalltalk.Point)  981 951 551 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 84 97 104 111 109 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 530 193 193 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 688 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 688 852230 ##(Smalltalk.FramingLayout)  234 240 98 16 410 8 ##(Smalltalk.PushButton)  98 17 0 688 98 2 8 1140924416 1 864 0 482 512 0 7 0 0 0 864 0 8 4294904825 1180998 4 ##(Smalltalk.CommandDescription)  8 #chooseDirectory 8 '...' 1 1 0 0 32 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 530 895 21 530 41 41 864 1106 8 #isEnabled: 98 1 32 864 1106 8 #text: 98 1 8 '...' 864 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 1 0 0 10 0 0 0 211 1 0 0 30 0 0 0] 98 0 530 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedPreviousRight 11 1426 8 #fixedViewLeft 41 1426 8 #fixedPreviousTop 1 1426 8 #fixedViewTop 41 410 8 ##(Smalltalk.StaticText)  98 16 0 688 98 2 8 1140850944 1 1568 0 0 0 7 0 0 0 1568 0 8 4294904295 852486 ##(Smalltalk.NullConverter)  0 0 0 1042 202 208 98 2 1106 1136 98 2 530 21 91 530 111 41 1568 1106 1264 98 1 8 'Fi&lters:' 1568 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 45 0 0 0 65 0 0 0 65 0 0 0] 98 0 1376 0 27 1394 1426 8 #fixedParentLeft 1 1472 111 1426 8 #fixedPreviousBottom 31 1536 41 410 880 98 17 0 688 98 2 8 1140928514 1 1984 0 482 512 0 7 0 0 0 1984 0 8 4294904825 978 8 #toggleMonitoring 8 '&Monitor' 1 1 0 0 32 1042 202 208 98 3 1106 1136 98 2 530 783 77 530 151 51 1984 1106 1216 98 1 32 1984 1106 1264 98 1 8 '&Monitor' 1984 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 135 1 0 0 38 0 0 0 210 1 0 0 63 0 0 0] 98 0 1376 0 27 1394 1440 13 1472 151 1504 -3 1536 51 410 704 98 15 0 688 98 2 8 1140850688 131073 2384 0 770 31 0 7 0 0 0 2384 656390 ##(Smalltalk.GridLayout)  7 7 1 1 234 256 98 16 410 8 ##(Smalltalk.CheckBox)  98 16 0 2384 98 2 8 1140924419 1 2528 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  32 482 512 0 7 0 0 0 2528 0 8 4294904825 1666 0 0 0 1042 202 208 98 2 1106 1136 98 2 530 309 47 530 309 49 2528 1106 1264 98 1 8 '&Last Access Time' 2528 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 154 0 0 0 23 0 0 0 52 1 0 0 47 0 0 0] 98 0 1376 0 27 8 'notifyLastAccess' 410 2544 98 16 0 2384 98 2 8 1140924419 1 2944 2610 0 0 2656 32 482 512 0 7 0 0 0 2944 0 8 4294904825 1666 0 0 0 1042 202 208 98 2 1106 1136 98 2 530 309 1 530 309 47 2944 1106 1264 98 1 8 'Directory &Name' 2944 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 154 0 0 0 0 0 0 0 52 1 0 0 23 0 0 0] 98 0 1376 0 27 8 'notifyDirectoryName' 410 2544 98 16 0 2384 98 2 8 1140924419 1 3296 2610 0 0 2656 32 482 512 0 7 0 0 0 3296 0 8 4294904825 1666 0 0 0 1042 202 208 98 2 1106 1136 98 2 530 617 1 530 309 47 3296 1106 1264 98 1 8 '&Creation Time' 3296 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 1 0 0 0 0 0 0 206 1 0 0 23 0 0 0] 98 0 1376 0 27 8 'notifyCreateTime' 410 2544 98 16 0 2384 98 2 8 1141055491 1 3648 2610 0 0 2656 32 482 512 0 7 0 0 0 3648 0 8 4294904825 1666 0 0 0 1042 202 208 98 2 1106 1136 98 2 530 1 1 530 309 47 3648 1106 1264 98 1 8 '&Attributes' 3648 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 154 0 0 0 23 0 0 0] 98 0 1376 0 27 8 'notifyAttributes' 410 2544 98 16 0 2384 98 2 8 1140924419 1 4000 2610 0 0 2656 32 482 512 0 7 0 0 0 4000 0 8 4294904825 1666 0 0 0 1042 202 208 98 2 1106 1136 98 2 530 1 47 530 309 49 4000 1106 1264 98 1 8 'F&ile Name' 4000 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 0 0 0 154 0 0 0 47 0 0 0] 98 0 1376 0 27 8 'notifyFileName' 410 2544 98 16 0 2384 98 2 8 1140924419 1 4352 2610 0 0 2656 32 482 512 0 7 0 0 0 4352 0 8 4294904825 1666 0 0 0 1042 202 208 98 2 1106 1136 98 2 530 617 47 530 309 49 4352 1106 1264 98 1 8 'Last &Write Time' 4352 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 1 0 0 23 0 0 0 206 1 0 0 47 0 0 0] 98 0 1376 0 27 8 'notifyLastWrite' 410 2544 98 16 0 2384 98 2 8 1140924419 1 4704 2610 0 0 2656 32 482 512 0 7 0 0 0 4704 0 8 4294904825 1666 0 0 0 1042 202 208 98 2 1106 1136 98 2 530 309 95 530 309 47 4704 1106 1264 98 1 8 'Si&ze' 4704 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 154 0 0 0 47 0 0 0 52 1 0 0 70 0 0 0] 98 0 1376 0 27 8 'notifySize' 410 2544 98 16 0 2384 98 2 8 1140924419 1 5056 2610 0 0 2656 32 482 512 0 7 0 0 0 5056 0 8 4294904825 1666 0 0 0 1042 202 208 98 2 1106 1136 98 2 530 1 95 530 309 47 5056 1106 1264 98 1 8 '&Security Settings' 5056 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 47 0 0 0 154 0 0 0 70 0 0 0] 98 0 1376 0 27 8 'notifySecurity' 0 1042 202 208 98 1 1106 1136 98 2 530 21 171 530 925 141 2384 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 85 0 0 0 216 1 0 0 155 0 0 0] 98 8 3648 2944 3296 4000 2528 4352 5056 4704 1376 0 27 1394 1920 1 1426 8 #fixedParentRight 1 1426 8 #fixedParentTop 151 1426 8 #fixedParentBottom 1 410 2544 98 16 0 688 98 2 8 1140924419 1 5680 2610 0 0 2656 32 482 512 0 7 0 0 0 5680 0 8 4294904825 1666 0 0 0 1042 202 208 98 2 1106 1136 98 2 530 501 81 530 271 41 5680 1106 1264 98 1 8 'Include s&ub-directories?' 5680 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 250 0 0 0 40 0 0 0 129 1 0 0 60 0 0 0] 98 0 1376 0 27 1394 1440 21 1472 271 1504 1 1536 41 410 1584 98 16 0 688 98 2 8 1140850944 1 6032 0 0 0 7 0 0 0 6032 0 8 4294904295 1666 0 0 0 1042 202 208 98 2 1106 1136 98 2 530 21 21 530 111 31 6032 1106 1264 98 1 8 '&Directory:' 6032 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 65 0 0 0 25 0 0 0] 98 0 1376 0 27 1394 1920 1 1472 111 5616 1 1536 31 410 8 ##(Smalltalk.TextEdit)  98 16 0 688 98 2 8 1140916352 1025 6352 0 482 512 0 7 0 0 0 6352 0 8 4294904765 1666 0 0 1 1042 202 208 98 4 1106 1136 98 2 530 151 81 530 331 41 6352 1106 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 6352 1106 8 #isTextModified: 98 1 32 6352 1106 8 #setMarginWidths: 98 1 98 2 7 7 6352 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 0 0 0 40 0 0 0 240 0 0 0 60 0 0 0] 98 0 1376 0 27 1394 1440 21 5584 -463 1504 -9 1536 41 410 6368 98 16 0 688 98 2 8 1140981888 1025 6848 2610 0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  8 '' 482 512 0 7 0 0 0 6848 0 8 4294904765 1666 0 0 3 1042 202 208 98 4 1106 1136 98 2 530 151 21 530 735 41 6848 1106 6608 98 1 6642 3 1 3 6848 1106 6688 98 1 32 6848 1106 6736 98 1 98 2 7 7 6848 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 0 0 0 10 0 0 0 186 1 0 0 30 0 0 0] 98 0 1376 0 27 1394 1440 21 5584 -59 1504 1 1536 41 234 256 98 10 1984 8 'isMonitoring' 6352 8 'filters' 5680 8 'includeSubDirs' 864 8 'chooseDirectory' 6848 8 'directoryName' 590342 ##(Smalltalk.Rectangle)  530 21 21 530 21 21 1042 202 208 98 1 1106 1136 98 2 530 1 1 530 965 331 688 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 226 1 0 0 165 0 0 0] 98 8 6032 6848 864 1568 6352 5680 1984 2384 1376 0 27 0 0 0 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140985933 1025 7664 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 512 0 7 0 0 0 7664 0 8 4294904359 459270 ##(Smalltalk.Message)  8 #displayString 98 0 0 1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 3 920646 5 ##(Smalltalk.ListViewColumn)  8 'Time' 133 8 #left 7874 7904 98 0 7874 8 #<= 8080 7874 8 #second 8080 0 7664 0 1 0 0 8002 8 'Change' 145 8048 7874 7904 7920 8 ##(Smalltalk.SortedCollection)  7874 8 #first 8080 0 7664 0 1 0 0 8002 8 'Path' 689 8048 7874 7904 8080 7874 8112 8080 7874 8 #third 8080 0 7664 0 3 0 0 8 #report 7792 0 131169 0 0 1042 202 208 98 2 1106 1136 98 2 530 1 331 530 965 513 7664 1106 1264 98 1 8 'Time' 7664 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 165 0 0 0 226 1 0 0 165 1 0 0] 98 0 1376 0 27 234 256 98 2 7664 8 'changeList' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 3 265030 4 ##(Smalltalk.Menu)  0 16 98 3 984134 2 ##(Smalltalk.CommandMenuItem)  1 978 2096 8 'Monitor Changes' 9355 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 8722 1 978 8 #exit 8 '&Exit' 1 1 0 0 0 8 '&File' 0 134217729 0 0 15671 0 0 8674 0 16 98 1 8722 1 978 8 #clear 8 '&Clear' 9393 1 0 0 0 8 '&Edit' 0 134217729 0 0 15675 0 0 8674 0 16 98 1 8722 1 978 8 #about 8 '&About' 1 1 0 0 0 8 '&Help' 0 134217729 0 0 15679 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1042 202 208 98 3 1106 1136 98 2 530 2799 21 530 981 951 416 1106 1264 98 1 8 'Dolphin File System Monitor' 416 1106 8 #updateMenuBar 7792 416 1314 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 97 7 0 0 229 1 0 0] 98 2 688 7664 1376 0 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self displayString! !
!FileSystemMonitor class categoriesFor: #defaultModel!models!public! !
!FileSystemMonitor class categoriesFor: #icon!public! !
!FileSystemMonitor class categoriesFor: #initialize!development!initializing!private! !
!FileSystemMonitor class categoriesFor: #resource_Default_view!public!resources-views! !
!FileSystemMonitor class categoriesFor: #shutdownOnExit!public!testing! !
!FileSystemMonitor class categoriesFor: #uninitialize!development!initializing!private! !

