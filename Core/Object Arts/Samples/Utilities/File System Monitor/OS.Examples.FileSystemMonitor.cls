"Filed out from Dolphin Smalltalk"!

UI.Shell subclass: #'OS.Examples.FileSystemMonitor'
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
		text: ('Directory change monitoring sample.<n>Copyright © Object Arts Ltd, 2005.<n><1s><n>
This sample monitors and displays file system changes occurring with a directory hierarchy as reported by the operating system. 
It is mainly intended to demonstrate the use of the FileSystemWatcher class.<n>
DISCLAIMER: This software is freely provided purely as an educational sample and as such it is provided "as is", WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.'
					expandMacrosWith: VM fullVersion);
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
!OS.Examples.FileSystemMonitor categoriesFor: #about!enquiries!private! !
!OS.Examples.FileSystemMonitor categoriesFor: #addChange:!helpers!private! !
!OS.Examples.FileSystemMonitor categoriesFor: #chooseDirectory!commands!public! !
!OS.Examples.FileSystemMonitor categoriesFor: #clear!commands!public! !
!OS.Examples.FileSystemMonitor categoriesFor: #createComponents!initializing!public! !
!OS.Examples.FileSystemMonitor categoriesFor: #createSchematicWiring!initializing!public! !
!OS.Examples.FileSystemMonitor categoriesFor: #model:!accessing!public! !
!OS.Examples.FileSystemMonitor categoriesFor: #onFileAdded:!event handling!private! !
!OS.Examples.FileSystemMonitor categoriesFor: #onFileModified:!event handling!private! !
!OS.Examples.FileSystemMonitor categoriesFor: #onFileRemoved:!event handling!private! !
!OS.Examples.FileSystemMonitor categoriesFor: #onFileRenamedFrom:to:!event handling!private! !
!OS.Examples.FileSystemMonitor categoriesFor: #queryCommand:!public! !
!OS.Examples.FileSystemMonitor categoriesFor: #toggleMonitoring!public! !

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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 ##(Graphics.Color) #default 918022 ##(Graphics.Point) 981 951 551 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 88 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 32 0 83 0 101 0 109 0 105 0 98 0 111 0 108 0 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 656 nil 466 #face3d nil 7 nil nil nil 656 1048838 ##(UI.FramingLayout) 170 176 34 16 410 ##(UI.StaticText) 34 16 nil 656 34 2 8 1140850944 1 800 nil nil nil 7 nil nil nil 800 nil 8 1868316128 1049094 ##(UI.NullConverter) nil nil nil 1310982 ##(Core.MessageSequence) 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 498 21 91 498 111 41 800 962 #text: 34 1 8 'Fi&lters:' 800 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 45 0 0 0 65 0 0 0 65 0 0 0] 8 #() 498 193 193 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 1 1202 #fixedViewLeft 111 1202 #fixedPreviousBottom 31 1202 #fixedViewTop 41 410 ##(UI.TextEdit) 34 16 nil 656 34 2 8 1140981888 1025 1280 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) 8 '' 480 nil 7 nil nil nil 1280 nil 8 1868457584 882 nil nil 3 914 34 2 962 #createAt:extent: 34 2 498 151 21 498 719 41 1280 962 #setMarginWidths: 34 1 8 #(3 3) 1280 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 0 0 0 10 0 0 0 178 1 0 0 30 0 0 0] 8 #() 1152 nil 27 1170 1202 #fixedPreviousRight 21 1202 #fixedParentRight -59 1202 #fixedPreviousTop 1 1264 41 410 ##(UI.PushButton) 34 20 nil 656 34 2 8 1140928514 1 1712 nil 480 nil 7 nil nil nil 1712 nil 8 1868462064 1377606 4 ##(UI.CommandDescription) #toggleMonitoring 8 '&Monitor' 1 1 nil nil false nil nil nil 914 34 3 962 #createAt:extent: 34 2 498 781 79 498 141 51 1712 962 #isEnabled: 8 #(false) 1712 962 #text: 34 1 8 '&Monitor' 1712 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 134 1 0 0 39 0 0 0 204 1 0 0 64 0 0 0] 8 #() 1152 nil 29 1170 1664 25 1232 141 1696 -1 1264 51 410 ##(UI.TextEdit) 34 16 nil 656 34 2 8 1140916352 1025 2080 nil 480 nil 7 nil nil nil 2080 nil 8 1868457584 882 nil nil 1 914 34 2 962 #createAt:extent: 34 2 498 151 81 498 315 41 2080 962 #setMarginWidths: 34 1 8 #(3 3) 2080 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 0 0 0 40 0 0 0 232 0 0 0 60 0 0 0] 8 #() 1152 nil 27 1170 1664 21 1680 -463 1696 -9 1264 41 410 ##(UI.StaticText) 34 16 nil 656 34 2 8 1140850944 1 2384 nil nil nil 7 nil nil nil 2384 nil 8 1868316128 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 21 21 498 111 31 2384 962 #text: 34 1 8 '&Directory:' 2384 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 65 0 0 0 25 0 0 0] 8 #() 1152 nil 27 1170 1216 1 1232 111 1202 #fixedParentTop 1 1264 31 410 ##(UI.CheckBox) 34 16 nil 656 34 2 8 1140924419 1 2704 1346 nil nil 1572870 ##(Kernel.NeverSearchPolicy) false 480 nil 7 nil nil nil 2704 nil 8 1868462064 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 485 81 498 273 41 2704 962 #text: 34 1 8 'Include s&ub-directories?' 2704 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 242 0 0 0 40 0 0 0 122 1 0 0 60 0 0 0] 8 #() 1152 nil 27 1170 1664 21 1232 273 1696 1 1264 41 410 ##(UI.PushButton) 34 20 nil 656 34 2 8 1140924416 1 3056 nil 480 nil 7 nil nil nil 3056 nil 8 1868462064 1794 #chooseDirectory 8 '…' 1 1 nil nil false nil nil nil 914 34 3 962 #createAt:extent: 34 2 498 879 21 498 41 41 3056 962 #isEnabled: 8 #(false) 3056 962 #text: 34 1 8 '…' 3056 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 183 1 0 0 10 0 0 0 203 1 0 0 30 0 0 0] 8 #() 1152 nil 29 1170 1664 11 1232 41 1696 1 1264 41 410 ##(UI.ContainerView) 34 15 nil 656 34 2 8 1140850688 131073 3408 nil 720 nil 7 nil nil nil 3408 852998 ##(UI.GridLayout) 7 7 1 1 170 192 34 16 410 ##(UI.CheckBox) 34 16 nil 3408 34 2 8 1140924419 1 3536 1346 nil nil 2800 false 480 nil 7 nil nil nil 3536 nil 8 1868462064 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 303 95 498 305 47 3536 962 #text: 34 1 8 'Si&ze' 3536 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 47 0 0 0 47 1 0 0 70 0 0 0] 8 #() 1152 nil 27 8 'notifySize' 410 ##(UI.CheckBox) 34 16 nil 3408 34 2 8 1140924419 1 3856 1346 nil nil 2800 false 480 nil 7 nil nil nil 3856 nil 8 1868462064 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 303 1 498 305 47 3856 962 #text: 34 1 8 'Directory &Name' 3856 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 0 0 0 0 47 1 0 0 23 0 0 0] 8 #() 1152 nil 27 8 'notifyDirectoryName' 410 ##(UI.CheckBox) 34 16 nil 3408 34 2 8 1140924419 1 4176 1346 nil nil 2800 false 480 nil 7 nil nil nil 4176 nil 8 1868462064 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 1 95 498 303 47 4176 962 #text: 34 1 8 '&Security Settings' 4176 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 47 0 0 0 151 0 0 0 70 0 0 0] 8 #() 1152 nil 27 8 'notifySecurity' 410 ##(UI.CheckBox) 34 16 nil 3408 34 2 8 1140924419 1 4496 1346 nil nil 2800 false 480 nil 7 nil nil nil 4496 nil 8 1868462064 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 303 47 498 305 49 4496 962 #text: 34 1 8 '&Last Access Time' 4496 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 23 0 0 0 47 1 0 0 47 0 0 0] 8 #() 1152 nil 27 8 'notifyLastAccess' 410 ##(UI.CheckBox) 34 16 nil 3408 34 2 8 1140924419 1 4816 1346 nil nil 2800 false 480 nil 7 nil nil nil 4816 nil 8 1868462064 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 607 1 498 303 47 4816 962 #text: 34 1 8 '&Creation Time' 4816 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 47 1 0 0 0 0 0 0 198 1 0 0 23 0 0 0] 8 #() 1152 nil 27 8 'notifyCreateTime' 410 ##(UI.CheckBox) 34 16 nil 3408 34 2 8 1140924419 1 5136 1346 nil nil 2800 false 480 nil 7 nil nil nil 5136 nil 8 1868462064 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 607 47 498 303 49 5136 962 #text: 34 1 8 'Last &Write Time' 5136 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 47 1 0 0 23 0 0 0 198 1 0 0 47 0 0 0] 8 #() 1152 nil 27 8 'notifyLastWrite' 410 ##(UI.CheckBox) 34 16 nil 3408 34 2 8 1140924419 1 5456 1346 nil nil 2800 false 480 nil 7 nil nil nil 5456 nil 8 1868462064 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 1 47 498 303 49 5456 962 #text: 34 1 8 'F&ile Name' 5456 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 0 0 0 151 0 0 0 47 0 0 0] 8 #() 1152 nil 27 8 'notifyFileName' 410 ##(UI.CheckBox) 34 16 nil 3408 34 2 8 1141055491 1 5776 1346 nil nil 2800 false 480 nil 7 nil nil nil 5776 nil 8 1868462064 882 nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 1 1 498 303 47 5776 962 #text: 34 1 8 '&Attributes' 5776 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 151 0 0 0 23 0 0 0] 8 #() 1152 nil 27 8 'notifyAttributes' nil 914 34 1 962 #createAt:extent: 34 2 498 21 171 498 909 141 3408 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 85 0 0 0 208 1 0 0 155 0 0 0] 34 8 5776 3856 4816 5456 4496 5136 4176 3536 1152 nil 27 1170 1216 1 1680 1 2688 151 1202 #fixedParentBottom 1 170 192 34 10 1280 8 'directoryName' 1712 8 'isMonitoring' 2080 8 'filters' 2704 8 'includeSubDirs' 3056 8 'chooseDirectory' 1180166 ##(Graphics.Rectangle) 498 21 21 498 21 21 914 34 1 962 #createAt:extent: 34 2 498 1 1 498 949 331 656 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 218 1 0 0 165 0 0 0] 34 8 2384 1280 3056 800 2080 2704 1712 3408 1152 nil 27 nil nil nil 410 ##(UI.ListView) 34 45 nil 416 34 2 8 1140985933 1025 6592 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) 480 nil 7 nil nil nil 6592 nil 8 1868406528 786950 ##(Core.Message) #displayString 8 #() nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 3 1117254 5 ##(UI.ListViewColumn) 8 'Time' 161 #left 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 3 1 6928 8 'doIt' 8 '[:dt | dt printStringFormat: ''HH:mm:ssFFF'']' 8 #[31 105 17 29 177 106] 8 'HH:mm:ssFFF' #printStringFormat: 6944 7 257 nil 6770 #<= 8 #() 6770 #second 7072 nil 6592 nil 1 nil nil 6882 8 'Change' 145 #left 6770 #displayString 6800 6770 #<= 8 #() 6770 #first 7072 nil 6592 nil 1 nil nil 6882 8 'Path' 665 #left 6770 #displayString 7072 6770 #<= 7072 6770 #third 7072 nil 6592 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 914 34 2 962 #createAt:extent: 34 2 498 1 331 498 949 503 6592 962 #text: 34 1 8 'Time' 6592 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 165 0 0 0 218 1 0 0 160 1 0 0] 8 #() 1152 nil 35 170 192 34 2 6592 8 'changeList' nil 658246 4 ##(UI.MenuBar) nil true 34 3 461638 4 ##(UI.Menu) nil true 34 3 1180742 2 ##(UI.CommandMenuItem) 1 1794 #toggleMonitoring 8 'Monitor Changes' 9355 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 7634 1 1794 #exit 8 '&Exit' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 54677 nil nil 7586 nil true 34 1 7634 1 1794 #clear 8 '&Clear' 9393 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 54681 nil nil 7586 nil true 34 1 7634 1 1794 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 54685 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 914 34 2 962 #createAt:extent: 34 2 498 12287 21 498 981 951 416 962 #text: 34 1 8 'Dolphin File System Monitor' 416 1090 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 233 25 0 0 229 1 0 0] 34 2 656 6592 1152 nil 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !
!OS.Examples.FileSystemMonitor class categoriesFor: #defaultModel!models!public! !
!OS.Examples.FileSystemMonitor class categoriesFor: #displayOn:!displaying!public! !
!OS.Examples.FileSystemMonitor class categoriesFor: #icon!public! !
!OS.Examples.FileSystemMonitor class categoriesFor: #initialize!development!initializing!private! !
!OS.Examples.FileSystemMonitor class categoriesFor: #resource_Default_view!public!resources-views! !
!OS.Examples.FileSystemMonitor class categoriesFor: #shutdownOnExit!public!testing! !

