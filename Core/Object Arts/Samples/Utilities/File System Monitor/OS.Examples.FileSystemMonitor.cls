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

queryToggleMonitoring: aCommandQuery
	aCommandQuery
		isEnabled: (directoryName value ifNil: [false] ifNotNil: [:text | text notEmpty]);
		isChecked: self model isMonitoring!

toggleMonitoring
	<commandQuery: #queryToggleMonitoring:>
	self model isMonitoring: self model isMonitoring not! !

!OS.Examples.FileSystemMonitor categoriesForMethods!
about!enquiries!private! !
addChange:!helpers!private! !
chooseDirectory!commands-actions!public! !
clear!commands-actions!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
model:!accessing!public! !
onFileAdded:!event handling!private! !
onFileModified:!event handling!private! !
onFileRemoved:!event handling!private! !
onFileRenamedFrom:to:!event handling!private! !
queryToggleMonitoring:!commands-queries!private! !
toggleMonitoring!commands-actions!public! !
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default 518 #{Graphics.Point} 981 951 517 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 88 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 32 0 83 0 101 0 109 0 105 0 98 0 111 0 108 0 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil 98 #face3d nil 5 nil nil nil 272 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 16 18 #{UI.StaticText} 50 16 nil 272 50 2 8 1140850944 1 432 nil nil nil 5 nil nil nil 432 nil nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[10 0 0 0 10 0 0 0 65 0 0 0 25 0 0 0] 193 464 nil 432 578 #text: 50 1 8 '&Directory:' 432 3 8 #() 130 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 1 818 #fixedViewLeft 111 818 #fixedParentTop 1 818 #fixedViewTop 31 18 #{UI.TextEdit} 50 20 nil 272 50 2 8 1140981888 1025 896 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} 8 '' 112 nil 5 nil nil nil 896 nil nil 498 nil nil 3 #focusLost nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[75 0 0 0 10 0 0 0 178 1 0 0 30 0 0 0] 193 928 nil 896 578 #setMarginWidths: 50 1 8 #(3 3) 896 3 8 #() 130 193 193 nil 45 786 818 #fixedPreviousRight 21 818 #fixedParentRight -59 818 #fixedPreviousTop 1 880 41 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 1312 nil 112 nil 5 nil nil nil 1312 nil nil 1350 4 #{UI.CommandDescription} #chooseDirectory 8 '…' 1 1 nil nil false nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[183 1 0 0 10 0 0 0 203 1 0 0 30 0 0 0] 193 1344 8 '…' 1312 578 #isEnabled: 8 #(false) 1312 3 8 #() 130 193 193 nil 29 786 1264 11 848 41 1296 1 880 41 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140928514 1 1632 nil 112 nil 5 nil nil nil 1632 nil nil 1378 #toggleMonitoring 8 '&Monitor' 1 1 nil nil false nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[134 1 0 0 39 0 0 0 204 1 0 0 64 0 0 0] 193 1664 8 '&Monitor' 1632 578 #isEnabled: 8 #(false) 1632 3 8 #() 130 193 193 nil 29 786 1264 25 848 141 1296 -1 880 51 18 #{UI.TextEdit} 50 20 nil 272 50 2 8 1140916352 1025 1936 nil 112 nil 5 nil nil nil 1936 nil nil 498 nil nil 1 #focusLost nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[75 0 0 0 40 0 0 0 232 0 0 0 60 0 0 0] 193 1968 nil 1936 578 #setMarginWidths: 50 1 8 #(3 3) 1936 3 8 #() 130 193 193 nil 45 786 1264 21 1280 -463 1296 -9 880 41 18 #{UI.CheckBox} 50 16 nil 272 50 2 8 1140924419 1 2224 962 nil nil 6 #{Kernel.NeverSearchPolicy} false 112 nil 5 nil nil nil 2224 nil nil 498 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[242 0 0 0 40 0 0 0 122 1 0 0 60 0 0 0] 193 2256 8 'Include s&ub-directories?' 2224 3 8 #() 130 193 193 nil 27 786 1264 21 848 273 1296 1 880 41 18 #{UI.StaticText} 50 16 nil 272 50 2 8 1140850944 1 2528 nil nil nil 5 nil nil nil 2528 nil nil 498 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[10 0 0 0 45 0 0 0 65 0 0 0 65 0 0 0] 193 2560 nil 2528 578 #text: 50 1 8 'Fi&lters:' 2528 3 8 #() 130 193 193 nil 27 786 832 1 848 111 818 #fixedPreviousBottom 31 880 41 18 #{UI.ContainerView} 50 15 nil 272 50 2 8 1140850688 131073 2832 nil 336 nil 5 nil nil nil 2832 1030 #{UI.GridLayout} 7 7 1 1 386 #{Core.IdentityDictionary} 50 16 18 #{UI.CheckBox} 50 16 nil 2832 50 2 8 1141055491 1 2960 962 nil nil 2320 false 112 nil 5 nil nil nil 2960 nil nil 498 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 151 0 0 0 23 0 0 0] 193 2992 8 '&Attributes' 2960 3 8 #() 130 193 193 nil 27 8 'notifyAttributes' 18 #{UI.CheckBox} 50 16 nil 2832 50 2 8 1140924419 1 3232 962 nil nil 2320 false 112 nil 5 nil nil nil 3232 nil nil 498 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[47 1 0 0 0 0 0 0 198 1 0 0 23 0 0 0] 193 3264 8 '&Creation Time' 3232 3 8 #() 130 193 193 nil 27 8 'notifyCreateTime' 18 #{UI.CheckBox} 50 16 nil 2832 50 2 8 1140924419 1 3504 962 nil nil 2320 false 112 nil 5 nil nil nil 3504 nil nil 498 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[151 0 0 0 0 0 0 0 47 1 0 0 23 0 0 0] 193 3536 8 'Directory &Name' 3504 3 8 #() 130 193 193 nil 27 8 'notifyDirectoryName' 18 #{UI.CheckBox} 50 16 nil 2832 50 2 8 1140924419 1 3776 962 nil nil 2320 false 112 nil 5 nil nil nil 3776 nil nil 498 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 23 0 0 0 151 0 0 0 47 0 0 0] 193 3808 8 'F&ile Name' 3776 3 8 #() 130 193 193 nil 27 8 'notifyFileName' 18 #{UI.CheckBox} 50 16 nil 2832 50 2 8 1140924419 1 4048 962 nil nil 2320 false 112 nil 5 nil nil nil 4048 nil nil 498 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[151 0 0 0 23 0 0 0 47 1 0 0 47 0 0 0] 193 4080 8 '&Last Access Time' 4048 3 8 #() 130 193 193 nil 27 8 'notifyLastAccess' 18 #{UI.CheckBox} 50 16 nil 2832 50 2 8 1140924419 1 4320 962 nil nil 2320 false 112 nil 5 nil nil nil 4320 nil nil 498 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[47 1 0 0 23 0 0 0 198 1 0 0 47 0 0 0] 193 4352 8 'Last &Write Time' 4320 3 8 #() 130 193 193 nil 27 8 'notifyLastWrite' 18 #{UI.CheckBox} 50 16 nil 2832 50 2 8 1140924419 1 4592 962 nil nil 2320 false 112 nil 5 nil nil nil 4592 nil nil 498 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 47 0 0 0 151 0 0 0 70 0 0 0] 193 4624 8 '&Security Settings' 4592 3 8 #() 130 193 193 nil 27 8 'notifySecurity' 18 #{UI.CheckBox} 50 16 nil 2832 50 2 8 1140924419 1 4864 962 nil nil 2320 false 112 nil 5 nil nil nil 4864 nil nil 498 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[151 0 0 0 47 0 0 0 47 1 0 0 70 0 0 0] 193 4896 8 'Si&ze' 4864 3 8 #() 130 193 193 nil 27 8 'notifySize' nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[10 0 0 0 85 0 0 0 208 1 0 0 155 0 0 0] 193 2864 8 '' 2832 3 50 8 2960 3504 3232 3776 4048 4320 4592 4864 130 193 193 nil 27 786 832 1 1280 1 864 151 818 #fixedParentBottom 1 386 #{Core.IdentityDictionary} 50 10 1312 8 'chooseDirectory' 896 8 'directoryName' 1936 8 'filters' 2224 8 'includeSubDirs' 1632 8 'isMonitoring' 518 #{Graphics.Rectangle} 130 21 21 130 21 21 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 218 1 0 0 165 0 0 0] 193 304 8 '' 272 3 50 8 432 896 1312 2528 1936 2224 1632 2832 130 193 193 nil 27 nil nil nil 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140985933 1025 5664 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 112 nil 5 nil nil nil 5664 nil nil 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 5762 3 3142 5 #{UI.ListViewColumn} 8 'Time' 161 #left 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 5968 8 'doIt' 8 '[:dt | dt printStringFormat: ''HH:mm:ssFFF'']' 8 #[31 105 17 29 177 106] 8 'HH:mm:ssFFF' #printStringFormat: 5984 7 257 nil 5826 #<= 8 #() 5826 #second 6112 nil 5664 nil 1 nil nil 5922 8 'Change' 145 #left 5826 #displayString 5856 5826 #<= 8 #() 5826 #first 6112 nil 5664 nil 1 nil nil 5922 8 'Path' 665 #left 5826 #displayString 6112 5826 #<= 6112 5826 #third 6112 nil 5664 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 5664 nil nil nil nil nil nil nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 165 0 0 0 218 1 0 0 160 1 0 0] 193 5696 8 'Time' 5664 3 8 #() 130 193 193 nil 35 386 #{Core.IdentityDictionary} 50 2 5664 8 'changeList' nil 2886 4 #{UI.MenuBar} nil true 50 3 2886 4 #{UI.Menu} nil true 50 3 1094 2 #{UI.CommandMenuItem} 1 1378 #toggleMonitoring 8 'Monitor Changes' 9355 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 6674 1 1378 #exit 8 '&Exit' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 6626 nil true 50 1 6674 1 1378 #clear 8 '&Clear' 9393 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 6626 nil true 50 1 6674 1 1378 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 530 50 1 578 #createWindow: 50 1 626 5442 130 7679 21 130 8659 971 193 80 8 'Dolphin File System Monitor' 32 1 50 2 272 5664 130 193 193 nil 27)!

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

