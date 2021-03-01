"Filed out from Dolphin Smalltalk 7"!

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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 ##(Graphics.Color) #default 918022 ##(Graphics.Point) 981 951 551 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 84 97 104 111 109 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 656 nil 466 #face3d nil 7 nil nil nil 656 1048838 ##(UI.FramingLayout) 170 176 34 16 410 ##(UI.StaticText) 34 16 nil 656 34 2 8 1140850944 1 800 nil nil nil 7 nil nil nil 800 nil 8 1857752800 1049094 ##(UI.NullConverter) nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 498 21 21 498 111 31 800 978 #text: 34 1 8 '&Directory:' 800 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 65 0 0 0 25 0 0 0] 8 #() 498 193 193 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 1 1218 #fixedViewLeft 111 1218 #fixedParentTop 1 1218 #fixedViewTop 31 410 ##(UI.PushButton) 34 20 nil 656 34 2 8 1140928514 1 1296 nil 480 nil 7 nil nil nil 1296 nil 8 1857904592 1377606 4 ##(UI.CommandDescription) #toggleMonitoring 8 '&Monitor' 1 1 nil nil false nil nil nil 914 138 144 34 3 978 #createAt:extent: 34 2 498 767 77 498 151 51 1296 978 #isEnabled: 8 #(false) 1296 978 #text: 34 1 8 '&Monitor' 1296 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 1 0 0 38 0 0 0 202 1 0 0 63 0 0 0] 8 #() 1168 nil 29 1186 1218 #fixedPreviousRight 13 1248 151 1218 #fixedPreviousTop -3 1280 51 410 ##(UI.TextEdit) 34 16 nil 656 34 2 8 1140981888 1025 1712 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) 8 '' 480 nil 7 nil nil nil 1712 nil 8 1857896400 882 nil nil 3 914 138 144 34 2 978 #createAt:extent: 34 2 498 151 21 498 719 41 1712 978 #setMarginWidths: 34 1 8 #(3 3) 1712 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 0 0 0 10 0 0 0 178 1 0 0 30 0 0 0] 8 #() 1168 nil 27 1186 1680 21 1218 #fixedParentRight -59 1696 1 1280 41 410 ##(UI.PushButton) 34 20 nil 656 34 2 8 1140924416 1 2128 nil 480 nil 7 nil nil nil 2128 nil 8 1857904592 1378 #chooseDirectory 8 '...' 1 1 nil nil false nil nil nil 914 138 144 34 3 978 #createAt:extent: 34 2 498 879 21 498 41 41 2128 978 #isEnabled: 8 #(false) 2128 978 #text: 34 1 8 '...' 2128 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 183 1 0 0 10 0 0 0 203 1 0 0 30 0 0 0] 8 #() 1168 nil 29 1186 1680 11 1248 41 1696 1 1280 41 410 ##(UI.ContainerView) 34 15 nil 656 34 2 8 1140850688 131073 2496 nil 720 nil 7 nil nil nil 2496 852998 ##(UI.GridLayout) 7 7 1 1 170 192 34 16 410 ##(UI.CheckBox) 34 16 nil 2496 34 2 8 1140924419 1 2624 1778 nil nil 1572870 ##(Kernel.NeverSearchPolicy) false 480 nil 7 nil nil nil 2624 nil 8 1857904592 882 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 498 1 47 498 303 49 2624 978 #text: 34 1 8 'F&ile Name' 2624 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 0 0 0 151 0 0 0 47 0 0 0] 8 #() 1168 nil 27 8 'notifyFileName' 410 ##(UI.CheckBox) 34 16 nil 2496 34 2 8 1140924419 1 2992 1778 nil nil 2720 false 480 nil 7 nil nil nil 2992 nil 8 1857904592 882 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 498 303 47 498 305 49 2992 978 #text: 34 1 8 '&Last Access Time' 2992 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 23 0 0 0 47 1 0 0 47 0 0 0] 8 #() 1168 nil 27 8 'notifyLastAccess' 410 ##(UI.CheckBox) 34 16 nil 2496 34 2 8 1140924419 1 3328 1778 nil nil 2720 false 480 nil 7 nil nil nil 3328 nil 8 1857904592 882 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 498 607 47 498 303 49 3328 978 #text: 34 1 8 'Last &Write Time' 3328 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 47 1 0 0 23 0 0 0 198 1 0 0 47 0 0 0] 8 #() 1168 nil 27 8 'notifyLastWrite' 410 ##(UI.CheckBox) 34 16 nil 2496 34 2 8 1141055491 1 3664 1778 nil nil 2720 false 480 nil 7 nil nil nil 3664 nil 8 1857904592 882 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 498 1 1 498 303 47 3664 978 #text: 34 1 8 '&Attributes' 3664 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 151 0 0 0 23 0 0 0] 8 #() 1168 nil 27 8 'notifyAttributes' 410 ##(UI.CheckBox) 34 16 nil 2496 34 2 8 1140924419 1 4000 1778 nil nil 2720 false 480 nil 7 nil nil nil 4000 nil 8 1857904592 882 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 498 1 95 498 303 47 4000 978 #text: 34 1 8 '&Security Settings' 4000 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 47 0 0 0 151 0 0 0 70 0 0 0] 8 #() 1168 nil 27 8 'notifySecurity' 410 ##(UI.CheckBox) 34 16 nil 2496 34 2 8 1140924419 1 4336 1778 nil nil 2720 false 480 nil 7 nil nil nil 4336 nil 8 1857904592 882 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 498 303 1 498 305 47 4336 978 #text: 34 1 8 'Directory &Name' 4336 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 0 0 0 0 47 1 0 0 23 0 0 0] 8 #() 1168 nil 27 8 'notifyDirectoryName' 410 ##(UI.CheckBox) 34 16 nil 2496 34 2 8 1140924419 1 4672 1778 nil nil 2720 false 480 nil 7 nil nil nil 4672 nil 8 1857904592 882 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 498 607 1 498 303 47 4672 978 #text: 34 1 8 '&Creation Time' 4672 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 47 1 0 0 0 0 0 0 198 1 0 0 23 0 0 0] 8 #() 1168 nil 27 8 'notifyCreateTime' 410 ##(UI.CheckBox) 34 16 nil 2496 34 2 8 1140924419 1 5008 1778 nil nil 2720 false 480 nil 7 nil nil nil 5008 nil 8 1857904592 882 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 498 303 95 498 305 47 5008 978 #text: 34 1 8 'Si&ze' 5008 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 47 0 0 0 47 1 0 0 70 0 0 0] 8 #() 1168 nil 27 8 'notifySize' nil 914 138 144 34 1 978 #createAt:extent: 34 2 498 21 171 498 909 141 2496 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 85 0 0 0 208 1 0 0 155 0 0 0] 34 8 3664 4336 4672 2624 2992 3328 4000 5008 1168 nil 27 1186 1232 1 2112 1 1264 151 1218 #fixedParentBottom 1 410 ##(UI.StaticText) 34 16 nil 656 34 2 8 1140850944 1 5536 nil nil nil 7 nil nil nil 5536 nil 8 1857752800 882 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 498 21 91 498 111 41 5536 978 #text: 34 1 8 'Fi&lters:' 5536 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 45 0 0 0 65 0 0 0 65 0 0 0] 8 #() 1168 nil 27 1186 1232 1 1248 111 1218 #fixedPreviousBottom 31 1280 41 410 ##(UI.CheckBox) 34 16 nil 656 34 2 8 1140924419 1 5872 1778 nil nil 2720 false 480 nil 7 nil nil nil 5872 nil 8 1857904592 882 nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 498 485 81 498 271 41 5872 978 #text: 34 1 8 'Include s&ub-directories?' 5872 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 242 0 0 0 40 0 0 0 121 1 0 0 60 0 0 0] 8 #() 1168 nil 27 1186 1680 21 1248 271 1696 1 1280 41 410 ##(UI.TextEdit) 34 16 nil 656 34 2 8 1140916352 1025 6208 nil 480 nil 7 nil nil nil 6208 nil 8 1857896400 882 nil nil 1 914 138 144 34 2 978 #createAt:extent: 34 2 498 151 81 498 315 41 6208 978 #setMarginWidths: 34 1 8 #(3 3) 6208 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 0 0 0 40 0 0 0 232 0 0 0 60 0 0 0] 8 #() 1168 nil 27 1186 1680 21 2112 -463 1696 -9 1280 41 170 192 34 10 1296 8 'isMonitoring' 1712 8 'directoryName' 2128 8 'chooseDirectory' 5872 8 'includeSubDirs' 6208 8 'filters' 1180166 ##(Graphics.Rectangle) 498 21 21 498 21 21 914 138 144 34 1 978 #createAt:extent: 34 2 498 1 1 498 949 331 656 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 218 1 0 0 165 0 0 0] 34 8 800 1712 2128 5536 6208 5872 1296 2496 1168 nil 27 nil nil nil 410 ##(UI.ListView) 34 45 nil 416 34 2 8 1140985933 1025 6864 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) 480 nil 7 nil nil nil 6864 nil 8 1857839872 786950 ##(Core.Message) #displayString 8 #() nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 3 1117254 5 ##(UI.ListViewColumn) 8 'Time' 161 #left 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 3 1 7200 8 'doIt' 8 '[:dt | dt printStringFormat: ''HH:mm:ssFFF'']' 8 #[31 105 17 29 177 106] 8 'HH:mm:ssFFF' #printStringFormat: 7216 7 257 nil 7042 #<= 8 #() 7042 #second 7344 nil 6864 nil 1 nil nil 7154 8 'Change' 145 #left 7042 #displayString 7072 7042 #<= 8 #() 7042 #first 7344 nil 6864 nil 1 nil nil 7154 8 'Path' 665 #left 7042 #displayString 7344 7042 #<= 7344 7042 #third 7344 nil 6864 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 498 1 331 498 949 503 6864 978 #text: 34 1 8 'Time' 6864 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 165 0 0 0 218 1 0 0 160 1 0 0] 8 #() 1168 nil 35 170 192 34 2 6864 8 'changeList' nil 658246 4 ##(UI.MenuBar) nil true 34 3 461638 4 ##(UI.Menu) nil true 34 3 1180742 2 ##(UI.CommandMenuItem) 1 1378 #toggleMonitoring 8 'Monitor Changes' 9355 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 7922 1 1378 #exit 8 '&Exit' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 30547 nil nil 7874 nil true 34 1 7922 1 1378 #clear 8 '&Clear' 9393 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 30551 nil nil 7874 nil true 34 1 7922 1 1378 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 30555 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 914 138 144 34 2 978 #createAt:extent: 34 2 498 6143 21 498 981 951 416 978 #text: 34 1 8 'Dolphin File System Monitor' 416 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 233 13 0 0 229 1 0 0] 34 2 656 6864 1168 nil 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !
!OS.Examples.FileSystemMonitor class categoriesFor: #defaultModel!models!public! !
!OS.Examples.FileSystemMonitor class categoriesFor: #displayOn:!displaying!public! !
!OS.Examples.FileSystemMonitor class categoriesFor: #icon!public! !
!OS.Examples.FileSystemMonitor class categoriesFor: #initialize!development!initializing!private! !
!OS.Examples.FileSystemMonitor class categoriesFor: #resource_Default_view!public!resources-views! !
!OS.Examples.FileSystemMonitor class categoriesFor: #shutdownOnExit!public!testing! !

