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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 328198 ##(Smalltalk.Point) 981 951 517 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 84 97 104 111 109 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 514 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 672 nil 721158 ##(Smalltalk.SystemColor) 31 nil 5 nil nil nil 672 852230 ##(Smalltalk.FramingLayout) 170 176 34 16 410 ##(Smalltalk.TextEdit) 34 16 nil 672 34 2 8 1140916352 1025 832 nil 480 nil 5 nil nil nil 832 nil 8 1915280032 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 514 151 81 514 331 41 832 1010 #setMarginWidths: 34 1 8 #(3 3) 832 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 0 0 0 40 0 0 0 240 0 0 0 60 0 0 0] 8 #() 514 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 21 1250 #fixedParentRight -463 1250 #fixedPreviousTop -9 1250 #fixedViewTop 41 410 ##(Smalltalk.PushButton) 34 20 nil 672 34 2 8 1140928514 1 1328 nil 480 nil 5 nil nil nil 1328 nil 8 1915188384 1180998 4 ##(Smalltalk.CommandDescription) #toggleMonitoring 8 '&Monitor' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 514 783 77 514 151 51 1328 1010 #isEnabled: 8 #(false) 1328 1010 #text: 34 1 8 '&Monitor' 1328 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 135 1 0 0 38 0 0 0 210 1 0 0 63 0 0 0] 8 #() 1200 nil 29 1218 1264 13 1250 #fixedViewLeft 151 1296 -3 1312 51 410 ##(Smalltalk.ContainerView) 34 15 nil 672 34 2 8 1140850688 131073 1728 nil 752 nil 5 nil nil nil 1728 656390 ##(Smalltalk.GridLayout) 7 7 1 1 170 192 34 16 410 ##(Smalltalk.CheckBox) 34 16 nil 1728 34 2 8 1140924419 1 1856 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false 480 nil 5 nil nil nil 1856 nil 8 1915188384 914 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 514 309 95 514 309 47 1856 1010 #text: 34 1 8 'Si&ze' 1856 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 154 0 0 0 47 0 0 0 52 1 0 0 70 0 0 0] 8 #() 1200 nil 27 8 'notifySize' 410 ##(Smalltalk.CheckBox) 34 16 nil 1728 34 2 8 1140924419 1 2240 1922 nil nil 1968 false 480 nil 5 nil nil nil 2240 nil 8 1915188384 914 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 514 1 95 514 309 47 2240 1010 #text: 34 1 8 '&Security Settings' 2240 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 47 0 0 0 154 0 0 0 70 0 0 0] 8 #() 1200 nil 27 8 'notifySecurity' 410 ##(Smalltalk.CheckBox) 34 16 nil 1728 34 2 8 1140924419 1 2576 1922 nil nil 1968 false 480 nil 5 nil nil nil 2576 nil 8 1915188384 914 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 514 309 1 514 309 47 2576 1010 #text: 34 1 8 'Directory &Name' 2576 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 154 0 0 0 0 0 0 0 52 1 0 0 23 0 0 0] 8 #() 1200 nil 27 8 'notifyDirectoryName' 410 ##(Smalltalk.CheckBox) 34 16 nil 1728 34 2 8 1141055491 1 2912 1922 nil nil 1968 false 480 nil 5 nil nil nil 2912 nil 8 1915188384 914 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 514 1 1 514 309 47 2912 1010 #text: 34 1 8 '&Attributes' 2912 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 154 0 0 0 23 0 0 0] 8 #() 1200 nil 27 8 'notifyAttributes' 410 ##(Smalltalk.CheckBox) 34 16 nil 1728 34 2 8 1140924419 1 3248 1922 nil nil 1968 false 480 nil 5 nil nil nil 3248 nil 8 1915188384 914 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 514 617 47 514 309 49 3248 1010 #text: 34 1 8 'Last &Write Time' 3248 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 1 0 0 23 0 0 0 206 1 0 0 47 0 0 0] 8 #() 1200 nil 27 8 'notifyLastWrite' 410 ##(Smalltalk.CheckBox) 34 16 nil 1728 34 2 8 1140924419 1 3584 1922 nil nil 1968 false 480 nil 5 nil nil nil 3584 nil 8 1915188384 914 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 514 309 47 514 309 49 3584 1010 #text: 34 1 8 '&Last Access Time' 3584 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 154 0 0 0 23 0 0 0 52 1 0 0 47 0 0 0] 8 #() 1200 nil 27 8 'notifyLastAccess' 410 ##(Smalltalk.CheckBox) 34 16 nil 1728 34 2 8 1140924419 1 3920 1922 nil nil 1968 false 480 nil 5 nil nil nil 3920 nil 8 1915188384 914 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 514 617 1 514 309 47 3920 1010 #text: 34 1 8 '&Creation Time' 3920 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 1 0 0 0 0 0 0 206 1 0 0 23 0 0 0] 8 #() 1200 nil 27 8 'notifyCreateTime' 410 ##(Smalltalk.CheckBox) 34 16 nil 1728 34 2 8 1140924419 1 4256 1922 nil nil 1968 false 480 nil 5 nil nil nil 4256 nil 8 1915188384 914 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 514 1 47 514 309 49 4256 1010 #text: 34 1 8 'F&ile Name' 4256 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 0 0 0 154 0 0 0 47 0 0 0] 8 #() 1200 nil 27 8 'notifyFileName' nil 946 138 144 34 1 1010 #createAt:extent: 34 2 514 21 171 514 925 141 1728 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 85 0 0 0 216 1 0 0 155 0 0 0] 34 8 2912 2576 3920 4256 3584 3248 2240 1856 1200 nil 27 1218 1250 #fixedParentLeft 1 1280 1 1250 #fixedParentTop 151 1250 #fixedParentBottom 1 410 ##(Smalltalk.CheckBox) 34 16 nil 672 34 2 8 1140924419 1 4816 1922 nil nil 1968 false 480 nil 5 nil nil nil 4816 nil 8 1915188384 914 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 514 501 81 514 271 41 4816 1010 #text: 34 1 8 'Include s&ub-directories?' 4816 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 250 0 0 0 40 0 0 0 129 1 0 0 60 0 0 0] 8 #() 1200 nil 27 1218 1264 21 1712 271 1296 1 1312 41 410 ##(Smalltalk.TextEdit) 34 16 nil 672 34 2 8 1140981888 1025 5152 1922 nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) 8 '' 480 nil 5 nil nil nil 5152 nil 8 1915280032 914 nil nil 3 946 138 144 34 2 1010 #createAt:extent: 34 2 514 151 21 514 735 41 5152 1010 #setMarginWidths: 34 1 8 #(3 3) 5152 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 0 0 0 10 0 0 0 186 1 0 0 30 0 0 0] 8 #() 1200 nil 27 1218 1264 21 1280 -59 1296 1 1312 41 410 ##(Smalltalk.StaticText) 34 16 nil 672 34 2 8 1140850944 1 5536 nil nil nil 5 nil nil nil 5536 nil 8 1915124368 914 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 514 21 21 514 111 31 5536 1010 #text: 34 1 8 '&Directory:' 5536 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 65 0 0 0 25 0 0 0] 8 #() 1200 nil 27 1218 4768 1 1712 111 4784 1 1312 31 410 ##(Smalltalk.PushButton) 34 20 nil 672 34 2 8 1140924416 1 5856 nil 480 nil 5 nil nil nil 5856 nil 8 1915188384 1410 #chooseDirectory 8 '...' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 514 895 21 514 41 41 5856 1010 #isEnabled: 8 #(false) 5856 1010 #text: 34 1 8 '...' 5856 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 1 0 0 10 0 0 0 211 1 0 0 30 0 0 0] 8 #() 1200 nil 29 1218 1264 11 1712 41 1296 1 1312 41 410 ##(Smalltalk.StaticText) 34 16 nil 672 34 2 8 1140850944 1 6224 nil nil nil 5 nil nil nil 6224 nil 8 1915124368 914 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 514 21 91 514 111 41 6224 1010 #text: 34 1 8 'Fi&lters:' 6224 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 45 0 0 0 65 0 0 0 65 0 0 0] 8 #() 1200 nil 27 1218 4768 1 1712 111 1250 #fixedPreviousBottom 31 1312 41 170 192 34 10 1328 8 'isMonitoring' 832 8 'filters' 5856 8 'chooseDirectory' 5152 8 'directoryName' 4816 8 'includeSubDirs' 590342 ##(Smalltalk.Rectangle) 514 21 21 514 21 21 946 138 144 34 1 1010 #createAt:extent: 34 2 514 1 1 514 965 331 672 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 226 1 0 0 165 0 0 0] 34 8 5536 5152 5856 6224 832 4816 1328 1728 1200 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 30 nil 416 34 2 8 1140985933 1025 6896 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 480 nil 5 nil nil nil 6896 nil 8 1915211424 459270 ##(Smalltalk.Message) #displayString 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Time' 133 #left 7074 #displayString 8 #() 7074 #<= 7248 7074 #second 7248 nil 6896 nil 1 nil nil 7186 8 'Change' 145 #left 7074 #displayString 7104 ##(Smalltalk.SortedCollection) 7074 #first 7248 nil 6896 nil 1 nil nil 7186 8 'Path' 689 #left 7074 #displayString 7248 7074 #<= 7248 7074 #third 7248 nil 6896 nil 3 nil nil #report 7008 nil 131169 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 514 1 331 514 965 513 6896 1010 #text: 34 1 8 'Time' 6896 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 165 0 0 0 226 1 0 0 165 1 0 0] 8 #() 1200 nil 27 170 192 34 2 6896 8 'changeList' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 3 265030 4 ##(Smalltalk.Menu) nil true 34 3 984134 2 ##(Smalltalk.CommandMenuItem) 1 1410 #toggleMonitoring 8 'Monitor Changes' 9355 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 7794 1 1410 #exit 8 '&Exit' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 43877 nil nil 7746 nil true 34 1 7794 1 1410 #clear 8 '&Clear' 9393 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 43881 nil nil 7746 nil true 34 1 7794 1 1410 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 43885 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 514 261 261 514 981 951 416 1010 #text: 34 1 8 'Dolphin File System Monitor' 416 1010 #updateMenuBar 7008 416 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 130 0 0 0 130 0 0 0 108 2 0 0 93 2 0 0] 34 2 672 6896 1200 nil 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !
!FileSystemMonitor class categoriesFor: #defaultModel!models!public! !
!FileSystemMonitor class categoriesFor: #icon!public! !
!FileSystemMonitor class categoriesFor: #initialize!development!initializing!private! !
!FileSystemMonitor class categoriesFor: #resource_Default_view!public!resources-views! !
!FileSystemMonitor class categoriesFor: #shutdownOnExit!public!testing! !

