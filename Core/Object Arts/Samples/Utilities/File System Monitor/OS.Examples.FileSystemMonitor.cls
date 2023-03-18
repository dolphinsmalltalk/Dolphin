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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 #{Graphics.Color} #default 918022 #{Graphics.Point} 981 951 551 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 88 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 32 0 83 0 101 0 109 0 105 0 98 0 111 0 108 0 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 656 nil 466 #face3d nil 7 nil nil nil 656 1048838 #{UI.FramingLayout} 170 176 34 16 410 #{UI.StaticText} 34 16 nil 656 34 2 8 1140850944 1 800 nil nil nil 7 nil nil nil 800 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 498 21 21 498 111 31 800 962 #text: 34 1 8 '&Directory:' 800 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 65 0 0 0 25 0 0 0] 8 #() 498 193 193 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 1 1202 #fixedViewLeft 111 1202 #fixedParentTop 1 1202 #fixedViewTop 31 410 #{UI.ContainerView} 34 15 nil 656 34 2 8 1140850688 131073 1280 nil 720 nil 7 nil nil nil 1280 852998 #{UI.GridLayout} 7 7 1 1 170 192 34 16 410 #{UI.CheckBox} 34 16 nil 1280 34 2 8 1140924419 1 1408 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} false 480 nil 7 nil nil nil 1408 nil 8 1815097472 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 607 47 498 303 49 1408 962 #text: 34 1 8 'Last &Write Time' 1408 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 47 1 0 0 23 0 0 0 198 1 0 0 47 0 0 0] 8 #() 1152 nil 27 8 'notifyLastWrite' 410 #{UI.CheckBox} 34 16 nil 1280 34 2 8 1140924419 1 1776 1474 nil nil 1520 false 480 nil 7 nil nil nil 1776 nil 8 1815097472 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 303 1 498 305 47 1776 962 #text: 34 1 8 'Directory &Name' 1776 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 0 0 0 0 47 1 0 0 23 0 0 0] 8 #() 1152 nil 27 8 'notifyDirectoryName' 410 #{UI.CheckBox} 34 16 nil 1280 34 2 8 1140924419 1 2096 1474 nil nil 1520 false 480 nil 7 nil nil nil 2096 nil 8 1815097472 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 303 47 498 305 49 2096 962 #text: 34 1 8 '&Last Access Time' 2096 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 23 0 0 0 47 1 0 0 47 0 0 0] 8 #() 1152 nil 27 8 'notifyLastAccess' 410 #{UI.CheckBox} 34 16 nil 1280 34 2 8 1140924419 1 2416 1474 nil nil 1520 false 480 nil 7 nil nil nil 2416 nil 8 1815097472 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 1 95 498 303 47 2416 962 #text: 34 1 8 '&Security Settings' 2416 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 47 0 0 0 151 0 0 0 70 0 0 0] 8 #() 1152 nil 27 8 'notifySecurity' 410 #{UI.CheckBox} 34 16 nil 1280 34 2 8 1140924419 1 2736 1474 nil nil 1520 false 480 nil 7 nil nil nil 2736 nil 8 1815097472 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 607 1 498 303 47 2736 962 #text: 34 1 8 '&Creation Time' 2736 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 47 1 0 0 0 0 0 0 198 1 0 0 23 0 0 0] 8 #() 1152 nil 27 8 'notifyCreateTime' 410 #{UI.CheckBox} 34 16 nil 1280 34 2 8 1141055491 1 3056 1474 nil nil 1520 false 480 nil 7 nil nil nil 3056 nil 8 1815097472 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 1 1 498 303 47 3056 962 #text: 34 1 8 '&Attributes' 3056 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 151 0 0 0 23 0 0 0] 8 #() 1152 nil 27 8 'notifyAttributes' 410 #{UI.CheckBox} 34 16 nil 1280 34 2 8 1140924419 1 3376 1474 nil nil 1520 false 480 nil 7 nil nil nil 3376 nil 8 1815097472 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 1 47 498 303 49 3376 962 #text: 34 1 8 'F&ile Name' 3376 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 0 0 0 151 0 0 0 47 0 0 0] 8 #() 1152 nil 27 8 'notifyFileName' 410 #{UI.CheckBox} 34 16 nil 1280 34 2 8 1140924419 1 3696 1474 nil nil 1520 false 480 nil 7 nil nil nil 3696 nil 8 1815097472 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 303 95 498 305 47 3696 962 #text: 34 1 8 'Si&ze' 3696 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 47 0 0 0 47 1 0 0 70 0 0 0] 8 #() 1152 nil 27 8 'notifySize' nil 914 34 1 962 #createAt:extent: 34 2 498 21 171 498 909 141 1280 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 85 0 0 0 208 1 0 0 155 0 0 0] 34 8 3056 1776 2736 3376 2096 1408 2416 3696 1152 nil 27 1170 1216 1 1202 #fixedParentRight 1 1248 151 1202 #fixedParentBottom 1 410 #{UI.PushButton} 34 20 nil 656 34 2 8 1140928514 1 4208 nil 480 nil 7 nil nil nil 4208 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #toggleMonitoring 8 '&Monitor' 1 1 nil nil false nil nil nil 914 34 3 962 #createAt:extent: 34 2 498 781 79 498 141 51 4208 962 #isEnabled: 8 #(false) 4208 962 #text: 34 1 8 '&Monitor' 4208 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 134 1 0 0 39 0 0 0 204 1 0 0 64 0 0 0] 8 #() 1152 nil 29 1170 1202 #fixedPreviousRight 25 1232 141 1202 #fixedPreviousTop -1 1264 51 410 #{UI.TextEdit} 34 16 nil 656 34 2 8 1140916352 1025 4608 nil 480 nil 7 nil nil nil 4608 nil 8 1815092992 882 nil nil 1 914 34 2 962 #createAt:extent: 34 2 498 151 81 498 315 41 4608 962 #setMarginWidths: 34 1 8 #(3 3) 4608 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 0 0 0 40 0 0 0 232 0 0 0 60 0 0 0] 8 #() 1152 nil 27 1170 4576 21 4176 -463 4592 -9 1264 41 410 #{UI.TextEdit} 34 16 nil 656 34 2 8 1140981888 1025 4912 1474 nil false 1769478 #{Kernel.EqualitySearchPolicy} 8 '' 480 nil 7 nil nil nil 4912 nil 8 1815092992 882 nil nil 3 914 34 2 962 #createAt:extent: 34 2 498 151 21 498 719 41 4912 962 #setMarginWidths: 34 1 8 #(3 3) 4912 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 0 0 0 10 0 0 0 178 1 0 0 30 0 0 0] 8 #() 1152 nil 27 1170 4576 21 4176 -59 4592 1 1264 41 410 #{UI.PushButton} 34 20 nil 656 34 2 8 1140924416 1 5280 nil 480 nil 7 nil nil nil 5280 nil 8 1815097472 4290 #chooseDirectory 8 '…' 1 1 nil nil false nil nil nil 914 34 3 962 #createAt:extent: 34 2 498 879 21 498 41 41 5280 962 #isEnabled: 8 #(false) 5280 962 #text: 34 1 8 '…' 5280 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 183 1 0 0 10 0 0 0 203 1 0 0 30 0 0 0] 8 #() 1152 nil 29 1170 4576 11 1232 41 4592 1 1264 41 410 #{UI.StaticText} 34 16 nil 656 34 2 8 1140850944 1 5632 nil nil nil 7 nil nil nil 5632 nil 8 1815137184 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 21 91 498 111 41 5632 962 #text: 34 1 8 'Fi&lters:' 5632 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 45 0 0 0 65 0 0 0 65 0 0 0] 8 #() 1152 nil 27 1170 1216 1 1232 111 1202 #fixedPreviousBottom 31 1264 41 410 #{UI.CheckBox} 34 16 nil 656 34 2 8 1140924419 1 5952 1474 nil nil 1520 false 480 nil 7 nil nil nil 5952 nil 8 1815097472 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 485 81 498 273 41 5952 962 #text: 34 1 8 'Include s&ub-directories?' 5952 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 242 0 0 0 40 0 0 0 122 1 0 0 60 0 0 0] 8 #() 1152 nil 27 1170 4576 21 1232 273 4592 1 1264 41 170 192 34 10 4208 8 'isMonitoring' 4608 8 'filters' 4912 8 'directoryName' 5280 8 'chooseDirectory' 5952 8 'includeSubDirs' 1180166 #{Graphics.Rectangle} 498 21 21 498 21 21 914 34 1 962 #createAt:extent: 34 2 498 1 1 498 949 331 656 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 218 1 0 0 165 0 0 0] 34 8 800 4912 5280 5632 4608 5952 4208 1280 1152 nil 27 nil nil nil 410 #{UI.ListView} 34 45 nil 416 34 2 8 1140985933 1025 6592 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 480 nil 7 nil nil nil 6592 nil 8 1815049392 786950 #{Core.Message} #displayString 8 #() nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 3 1117254 5 #{UI.ListViewColumn} 8 'Time' 161 #left 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 3 1 6928 8 'doIt' 8 '[:dt | dt printStringFormat: ''HH:mm:ssFFF'']' 8 #[31 105 17 29 177 106] 8 'HH:mm:ssFFF' #printStringFormat: 6944 7 257 nil 6770 #<= 8 #() 6770 #second 7072 nil 6592 nil 1 nil nil 6882 8 'Change' 145 #left 6770 #displayString 6800 6770 #<= 8 #() 6770 #first 7072 nil 6592 nil 1 nil nil 6882 8 'Path' 665 #left 6770 #displayString 7072 6770 #<= 7072 6770 #third 7072 nil 6592 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 1 331 498 949 503 6592 962 #text: 34 1 8 'Time' 6592 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 165 0 0 0 218 1 0 0 160 1 0 0] 8 #() 1152 nil 35 170 192 34 2 6592 8 'changeList' nil 658246 4 #{UI.MenuBar} nil true 34 3 461638 4 #{UI.Menu} nil true 34 3 1180742 2 #{UI.CommandMenuItem} 1 4290 #toggleMonitoring 8 'Monitor Changes' 9355 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 7634 1 4290 #exit 8 '&Exit' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 52995 nil nil 7586 nil true 34 1 7634 1 4290 #clear 8 '&Clear' 9393 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 52999 nil nil 7586 nil true 34 1 7634 1 4290 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 53003 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 914 34 2 962 #createAt:extent: 34 2 498 12287 21 498 981 951 416 962 #text: 34 1 8 'Dolphin File System Monitor' 416 1090 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 233 25 0 0 229 1 0 0] 34 2 656 6592 1152 nil 27)!

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

