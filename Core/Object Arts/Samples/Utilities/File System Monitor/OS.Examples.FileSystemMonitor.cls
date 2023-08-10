"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'OS.Examples.FileSystemMonitor'
	instanceVariableNames: 'directoryName notifyAttributes notifyDirectoryName notifyCreateTime notifyFileName notifyLastAccess notifyLastWrite notifySecurity notifySize filters includeSubDirs changeList'
	classVariableNames: ''
	imports: #(#{UI})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Examples.FileSystemMonitor guid: (Core.GUID fromString: '{1c0d9cfc-b0a6-4b19-b2c6-cc6e373ff4fa}')!
OS.Examples.FileSystemMonitor comment: 'FileSystemMonitor is a <topShell> sample application which is capable of displaying a list of the changes being made to a specified directory hierarchy in the file system. It is mainly intended to demonstrate the FileSystemWatcher class.

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
!OS.Examples.FileSystemMonitor categoriesForClass!MVP-Presenters! !
!OS.Examples.FileSystemMonitor methodsFor!

about
	"Private - Pop up a little helpful info. about this sample program."

	MessageBox new
		caption: 'About ' , self class name asPhrase;
		icon: self icon;
		headline: 'Directory change monitoring sample';
		text: 'Copyright © Object Arts Ltd, 2005.<n><1s>' << VM fullVersion;
		detailsText: 'This sample monitors and displays file system changes occurring with a directory hierarchy as reported by the operating system. It is mainly intended to demonstrate the use of the FileSystemWatcher class.

DISCLAIMER: This software is freely provided purely as an educational sample and as such it is provided "as is", WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.';
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
	self addChange: {'Added'. DateAndTime now. aString}!

onFileModified: aString
	self addChange: {'Modified'. DateAndTime now. aString}!

onFileRemoved: aString
	self addChange: {'Removed'. DateAndTime now. aString}!

onFileRenamedFrom: aString to: aString2
	self addChange: {'Renamed'. DateAndTime now. aString -> aString2}!

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
!OS.Examples.FileSystemMonitor categoriesForMethods!
about!enquiries!private! !
addChange:!helpers!private! !
chooseDirectory!commands!public! !
clear!commands!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
model:!accessing!public! !
onFileAdded:!event handling!private! !
onFileModified:!event handling!private! !
onFileRemoved:!event handling!private! !
onFileRenamedFrom:to:!event handling!private! !
queryCommand:!public! !
toggleMonitoring!public! !
!

!OS.Examples.FileSystemMonitor class methodsFor!

defaultModel
	^FileSystemWatcher new!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Filesystem Monitor'!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default 518 #{Graphics.Point} 981 951 519 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 88 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 32 0 83 0 101 0 109 0 105 0 98 0 111 0 108 0 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 130 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 288 nil 98 #face3d nil 7 nil nil nil 288 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 8 18 #{UI.CheckBox} 50 16 nil 288 50 2 8 1140924419 1 432 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false 112 nil 7 nil nil nil 432 nil 8 1853182784 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 130 485 81 130 273 41 432 658 #text: 50 1 8 'Include s&ub-directories?' 432 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 242 0 0 0 40 0 0 0 122 1 0 0 60 0 0 0] 8 #() 130 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 21 898 #fixedViewLeft 273 898 #fixedPreviousTop 1 898 #fixedViewTop 41 18 #{UI.ContainerView} 50 15 nil 288 50 2 8 1140850688 131073 976 nil 352 nil 7 nil nil nil 976 1030 #{UI.GridLayout} 7 7 1 1 550 #{Core.IdentityDictionary} 8 18 #{UI.CheckBox} 50 16 nil 976 50 2 8 1140924419 1 1104 498 nil nil 544 false 112 nil 7 nil nil nil 1104 nil 8 1853182784 578 nil nil nil 610 50 2 658 #createAt:extent: 50 2 130 303 1 130 305 47 1104 658 #text: 50 1 8 'Directory &Name' 1104 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 0 0 0 0 47 1 0 0 23 0 0 0] 8 #() 848 nil 27 8 'notifyDirectoryName' 18 #{UI.CheckBox} 50 16 nil 976 50 2 8 1140924419 1 1424 498 nil nil 544 false 112 nil 7 nil nil nil 1424 nil 8 1853182784 578 nil nil nil 610 50 2 658 #createAt:extent: 50 2 130 303 95 130 305 47 1424 658 #text: 50 1 8 'Si&ze' 1424 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 47 0 0 0 47 1 0 0 70 0 0 0] 8 #() 848 nil 27 8 'notifySize' 18 #{UI.CheckBox} 50 16 nil 976 50 2 8 1140924419 1 1744 498 nil nil 544 false 112 nil 7 nil nil nil 1744 nil 8 1853182784 578 nil nil nil 610 50 2 658 #createAt:extent: 50 2 130 607 47 130 303 49 1744 658 #text: 50 1 8 'Last &Write Time' 1744 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 47 1 0 0 23 0 0 0 198 1 0 0 47 0 0 0] 8 #() 848 nil 27 8 'notifyLastWrite' 18 #{UI.CheckBox} 50 16 nil 976 50 2 8 1140924419 1 2064 498 nil nil 544 false 112 nil 7 nil nil nil 2064 nil 8 1853182784 578 nil nil nil 610 50 2 658 #createAt:extent: 50 2 130 1 95 130 303 47 2064 658 #text: 50 1 8 '&Security Settings' 2064 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 47 0 0 0 151 0 0 0 70 0 0 0] 8 #() 848 nil 27 8 'notifySecurity' 18 #{UI.CheckBox} 50 16 nil 976 50 2 8 1140924419 1 2384 498 nil nil 544 false 112 nil 7 nil nil nil 2384 nil 8 1853182784 578 nil nil nil 610 50 2 658 #createAt:extent: 50 2 130 1 47 130 303 49 2384 658 #text: 50 1 8 'F&ile Name' 2384 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 0 0 0 151 0 0 0 47 0 0 0] 8 #() 848 nil 27 8 'notifyFileName' 18 #{UI.CheckBox} 50 16 nil 976 50 2 8 1141055491 1 2704 498 nil nil 544 false 112 nil 7 nil nil nil 2704 nil 8 1853182784 578 nil nil nil 610 50 2 658 #createAt:extent: 50 2 130 1 1 130 303 47 2704 658 #text: 50 1 8 '&Attributes' 2704 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 151 0 0 0 23 0 0 0] 8 #() 848 nil 27 8 'notifyAttributes' 18 #{UI.CheckBox} 50 16 nil 976 50 2 8 1140924419 1 3024 498 nil nil 544 false 112 nil 7 nil nil nil 3024 nil 8 1853182784 578 nil nil nil 610 50 2 658 #createAt:extent: 50 2 130 607 1 130 303 47 3024 658 #text: 50 1 8 '&Creation Time' 3024 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 47 1 0 0 0 0 0 0 198 1 0 0 23 0 0 0] 8 #() 848 nil 27 8 'notifyCreateTime' 18 #{UI.CheckBox} 50 16 nil 976 50 2 8 1140924419 1 3344 498 nil nil 544 false 112 nil 7 nil nil nil 3344 nil 8 1853182784 578 nil nil nil 610 50 2 658 #createAt:extent: 50 2 130 303 47 130 305 49 3344 658 #text: 50 1 8 '&Last Access Time' 3344 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 23 0 0 0 47 1 0 0 47 0 0 0] 8 #() 848 nil 27 8 'notifyLastAccess' nil 610 50 1 658 #createAt:extent: 50 2 130 21 171 130 909 141 976 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 85 0 0 0 208 1 0 0 155 0 0 0] 50 8 2704 1104 3024 2384 3344 1744 2064 1424 848 nil 27 866 898 #fixedParentLeft 1 898 #fixedParentRight 1 898 #fixedParentTop 151 898 #fixedParentBottom 1 18 #{UI.PushButton} 50 20 nil 288 50 2 8 1140924416 1 3888 nil 112 nil 7 nil nil nil 3888 nil 8 1853182784 1350 4 #{UI.CommandDescription} #chooseDirectory 8 '…' 1 1 nil nil false nil nil nil 610 50 3 658 #createAt:extent: 50 2 130 879 21 130 41 41 3888 658 #isEnabled: 8 #(false) 3888 658 #text: 50 1 8 '…' 3888 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 183 1 0 0 10 0 0 0 203 1 0 0 30 0 0 0] 8 #() 848 nil 29 866 912 11 928 41 944 1 960 41 18 #{UI.PushButton} 50 20 nil 288 50 2 8 1140928514 1 4256 nil 112 nil 7 nil nil nil 4256 nil 8 1853182784 3970 #toggleMonitoring 8 '&Monitor' 1 1 nil nil false nil nil nil 610 50 3 658 #createAt:extent: 50 2 130 781 79 130 141 51 4256 658 #isEnabled: 8 #(false) 4256 658 #text: 50 1 8 '&Monitor' 4256 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 134 1 0 0 39 0 0 0 204 1 0 0 64 0 0 0] 8 #() 848 nil 29 866 912 25 928 141 944 -1 960 51 18 #{UI.StaticText} 50 16 nil 288 50 2 8 1140850944 1 4608 nil nil nil 7 nil nil nil 4608 nil 8 1853387904 578 nil nil nil 610 50 2 658 #createAt:extent: 50 2 130 21 91 130 111 41 4608 658 #text: 50 1 8 'Fi&lters:' 4608 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 45 0 0 0 65 0 0 0 65 0 0 0] 8 #() 848 nil 27 866 3824 1 928 111 898 #fixedPreviousBottom 31 960 41 18 #{UI.StaticText} 50 16 nil 288 50 2 8 1140850944 1 4928 nil nil nil 7 nil nil nil 4928 nil 8 1853387904 578 nil nil nil 610 50 2 658 #createAt:extent: 50 2 130 21 21 130 111 31 4928 658 #text: 50 1 8 '&Directory:' 4928 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 65 0 0 0 25 0 0 0] 8 #() 848 nil 27 866 3824 1 928 111 3856 1 960 31 18 #{UI.TextEdit} 50 20 nil 288 50 2 8 1140916352 1025 5232 nil 112 nil 7 nil nil nil 5232 nil 8 1853175488 578 nil nil 1 #focusLost nil nil nil 610 50 2 658 #createAt:extent: 50 2 130 151 81 130 315 41 5232 658 #setMarginWidths: 50 1 8 #(3 3) 5232 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 0 0 0 40 0 0 0 232 0 0 0 60 0 0 0] 8 #() 848 nil 45 866 912 21 3840 -463 944 -9 960 41 18 #{UI.TextEdit} 50 20 nil 288 50 2 8 1140981888 1025 5536 498 nil false 6 #{Kernel.EqualitySearchPolicy} 8 '' 112 nil 7 nil nil nil 5536 nil 8 1853175488 578 nil nil 3 #focusLost nil nil nil 610 50 2 658 #createAt:extent: 50 2 130 151 21 130 719 41 5536 658 #setMarginWidths: 50 1 8 #(3 3) 5536 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 0 0 0 10 0 0 0 178 1 0 0 30 0 0 0] 8 #() 848 nil 45 866 912 21 3840 -59 944 1 960 41 1074 5 432 8 'includeSubDirs' 3888 8 'chooseDirectory' 4256 8 'isMonitoring' 5232 8 'filters' 5536 8 'directoryName' 518 #{Graphics.Rectangle} 130 21 21 130 21 21 610 50 1 658 #createAt:extent: 50 2 130 1 1 130 949 331 288 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 218 1 0 0 165 0 0 0] 50 8 4928 5536 3888 4608 5232 432 4256 976 848 nil 27 nil nil nil 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140985933 1025 6208 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 112 nil 7 nil nil nil 6208 nil 8 1853243664 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 6306 3 3142 5 #{UI.ListViewColumn} 8 'Time' 161 #left 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 6528 8 'doIt' 8 '[:dt | dt printStringFormat: ''HH:mm:ssFFF'']' 8 #[31 105 17 29 177 106] 8 'HH:mm:ssFFF' #printStringFormat: 6544 7 257 nil 6386 #<= 8 #() 6386 #second 6672 nil 6208 nil 1 nil nil 6482 8 'Change' 145 #left 6386 #displayString 6416 6386 #<= 8 #() 6386 #first 6672 nil 6208 nil 1 nil nil 6482 8 'Path' 665 #left 6386 #displayString 6672 6386 #<= 6672 6386 #third 6672 nil 6208 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 610 50 2 658 #createAt:extent: 50 2 130 1 331 130 949 503 6208 658 #text: 50 1 8 'Time' 6208 786 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 165 0 0 0 218 1 0 0 160 1 0 0] 8 #() 848 nil 35 1074 1 6208 8 'changeList' nil 2886 4 #{UI.MenuBar} nil true 50 3 2886 4 #{UI.Menu} nil true 50 3 1094 2 #{UI.CommandMenuItem} 1 3970 #toggleMonitoring 8 'Monitor Changes' 9355 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 7218 1 3970 #exit 8 '&Exit' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 47113 nil nil 7170 nil true 50 1 7218 1 3970 #clear 8 '&Clear' 9393 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 47117 nil nil 7170 nil true 50 1 7218 1 3970 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 47121 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 610 50 2 658 #createAt:extent: 50 2 130 6143 21 130 981 951 32 658 #text: 50 1 8 'Dolphin File System Monitor' 32 786 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 233 13 0 0 229 1 0 0] 50 2 288 6208 848 nil 27)!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !
!OS.Examples.FileSystemMonitor class categoriesForMethods!
defaultModel!models!public! !
displayOn:!displaying!public! !
icon!public! !
initialize!development!initializing!private! !
resource_Default_view!public!resources-views! !
shutdownOnExit!public!testing! !
!

