"Filed out from Dolphin Smalltalk"!

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
				with: DateAndTime now
				with: aString)!

onFileModified: aString 
	self addChange: (Array 
				with: 'Modified'
				with: DateAndTime now
				with: aString)!

onFileRemoved: aString 
	self addChange: (Array 
				with: 'Removed'
				with: DateAndTime now
				with: aString)!

onFileRenamedFrom: aString to: aString2 
	self addChange: (Array 
				with: 'Renamed'
				with: DateAndTime now
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

!FileSystemMonitor categoriesForMethods!
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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 981 951 517 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 84 0 97 0 104 0 111 0 109 0 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil 466 #face3d nil 5 nil nil nil 640 852230 ##(Smalltalk.FramingLayout) 170 176 34 16 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140928514 1 784 nil 480 nil 5 nil nil nil 784 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #toggleMonitoring 8 '&Monitor' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[127 1 0 0 38 0 0 0 202 1 0 0 63 0 0 0] 193 816 8 '&Monitor' 784 978 #isEnabled: 8 #(false) 784 3 8 #() 498 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 13 1218 #fixedViewLeft 151 1218 #fixedPreviousTop -3 1218 #fixedViewTop 51 410 ##(Smalltalk.CheckBox) 34 16 nil 640 34 2 8 1140924419 1 1296 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false 480 nil 5 nil nil nil 1296 nil 8 1759007584 852486 ##(Smalltalk.NullConverter) nil nil nil 914 138 144 34 1 978 #createWindow: 34 1 1026 1058 8 #[242 0 0 0 40 0 0 0 121 1 0 0 60 0 0 0] 193 1328 8 'Include s&ub-directories?' 1296 3 8 #() 498 193 193 nil 27 1186 1232 21 1248 271 1264 1 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 640 34 2 8 1140850944 1 1664 nil nil nil 5 nil nil nil 1664 nil 8 1759212608 1442 nil nil nil 914 138 144 34 2 978 #createWindow: 34 1 1026 1058 8 #[10 0 0 0 45 0 0 0 65 0 0 0 65 0 0 0] 193 1696 nil 1664 978 #text: 34 1 8 'Fi&lters:' 1664 3 8 #() 498 193 193 nil 27 1186 1218 #fixedParentLeft 1 1248 111 1218 #fixedPreviousBottom 31 1280 41 410 ##(Smalltalk.TextEdit) 34 16 nil 640 34 2 8 1140981888 1025 2016 1362 nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) 8 '' 480 nil 5 nil nil nil 2016 nil 8 1759000288 1442 nil nil 3 914 138 144 34 2 978 #createWindow: 34 1 1026 1058 8 #[75 0 0 0 10 0 0 0 178 1 0 0 30 0 0 0] 193 2048 nil 2016 978 #setMarginWidths: 34 1 8 #(3 3) 2016 3 8 #() 498 193 193 nil 27 1186 1232 21 1218 #fixedParentRight -59 1264 1 1280 41 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2416 nil 480 nil 5 nil nil nil 2416 nil 8 1759007584 866 #chooseDirectory 8 '...' 1 1 nil nil false nil nil nil 914 138 144 34 2 978 #createWindow: 34 1 1026 1058 8 #[183 1 0 0 10 0 0 0 203 1 0 0 30 0 0 0] 193 2448 8 '...' 2416 978 #isEnabled: 8 #(false) 2416 3 8 #() 498 193 193 nil 29 1186 1232 11 1248 41 1264 1 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 640 34 2 8 1140850944 1 2752 nil nil nil 5 nil nil nil 2752 nil 8 1759212608 1442 nil nil nil 914 138 144 34 2 978 #createWindow: 34 1 1026 1058 8 #[10 0 0 0 10 0 0 0 65 0 0 0 25 0 0 0] 193 2784 nil 2752 978 #text: 34 1 8 '&Directory:' 2752 3 8 #() 498 193 193 nil 27 1186 1984 1 1248 111 1218 #fixedParentTop 1 1280 31 410 ##(Smalltalk.TextEdit) 34 16 nil 640 34 2 8 1140916352 1025 3088 nil 480 nil 5 nil nil nil 3088 nil 8 1759000288 1442 nil nil 1 914 138 144 34 2 978 #createWindow: 34 1 1026 1058 8 #[75 0 0 0 40 0 0 0 232 0 0 0 60 0 0 0] 193 3120 nil 3088 978 #setMarginWidths: 34 1 8 #(3 3) 3088 3 8 #() 498 193 193 nil 27 1186 1232 21 2400 -463 1264 -9 1280 41 410 ##(Smalltalk.ContainerView) 34 15 nil 640 34 2 8 1140850688 131073 3408 nil 704 nil 5 nil nil nil 3408 656390 ##(Smalltalk.GridLayout) 7 7 1 1 170 192 34 16 410 ##(Smalltalk.CheckBox) 34 16 nil 3408 34 2 8 1140924419 1 3536 1362 nil nil 1408 false 480 nil 5 nil nil nil 3536 nil 8 1759007584 1442 nil nil nil 914 138 144 34 1 978 #createWindow: 34 1 1026 1058 8 #[151 0 0 0 0 0 0 0 47 1 0 0 23 0 0 0] 193 3568 8 'Directory &Name' 3536 3 8 #() 498 193 193 nil 27 8 'notifyDirectoryName' 410 ##(Smalltalk.CheckBox) 34 16 nil 3408 34 2 8 1141055491 1 3840 1362 nil nil 1408 false 480 nil 5 nil nil nil 3840 nil 8 1759007584 1442 nil nil nil 914 138 144 34 1 978 #createWindow: 34 1 1026 1058 8 #[0 0 0 0 0 0 0 0 151 0 0 0 23 0 0 0] 193 3872 8 '&Attributes' 3840 3 8 #() 498 193 193 nil 27 8 'notifyAttributes' 410 ##(Smalltalk.CheckBox) 34 16 nil 3408 34 2 8 1140924419 1 4144 1362 nil nil 1408 false 480 nil 5 nil nil nil 4144 nil 8 1759007584 1442 nil nil nil 914 138 144 34 1 978 #createWindow: 34 1 1026 1058 8 #[47 1 0 0 23 0 0 0 198 1 0 0 47 0 0 0] 193 4176 8 'Last &Write Time' 4144 3 8 #() 498 193 193 nil 27 8 'notifyLastWrite' 410 ##(Smalltalk.CheckBox) 34 16 nil 3408 34 2 8 1140924419 1 4448 1362 nil nil 1408 false 480 nil 5 nil nil nil 4448 nil 8 1759007584 1442 nil nil nil 914 138 144 34 1 978 #createWindow: 34 1 1026 1058 8 #[151 0 0 0 23 0 0 0 47 1 0 0 47 0 0 0] 193 4480 8 '&Last Access Time' 4448 3 8 #() 498 193 193 nil 27 8 'notifyLastAccess' 410 ##(Smalltalk.CheckBox) 34 16 nil 3408 34 2 8 1140924419 1 4752 1362 nil nil 1408 false 480 nil 5 nil nil nil 4752 nil 8 1759007584 1442 nil nil nil 914 138 144 34 1 978 #createWindow: 34 1 1026 1058 8 #[47 1 0 0 0 0 0 0 198 1 0 0 23 0 0 0] 193 4784 8 '&Creation Time' 4752 3 8 #() 498 193 193 nil 27 8 'notifyCreateTime' 410 ##(Smalltalk.CheckBox) 34 16 nil 3408 34 2 8 1140924419 1 5056 1362 nil nil 1408 false 480 nil 5 nil nil nil 5056 nil 8 1759007584 1442 nil nil nil 914 138 144 34 1 978 #createWindow: 34 1 1026 1058 8 #[0 0 0 0 23 0 0 0 151 0 0 0 47 0 0 0] 193 5088 8 'F&ile Name' 5056 3 8 #() 498 193 193 nil 27 8 'notifyFileName' 410 ##(Smalltalk.CheckBox) 34 16 nil 3408 34 2 8 1140924419 1 5360 1362 nil nil 1408 false 480 nil 5 nil nil nil 5360 nil 8 1759007584 1442 nil nil nil 914 138 144 34 1 978 #createWindow: 34 1 1026 1058 8 #[151 0 0 0 47 0 0 0 47 1 0 0 70 0 0 0] 193 5392 8 'Si&ze' 5360 3 8 #() 498 193 193 nil 27 8 'notifySize' 410 ##(Smalltalk.CheckBox) 34 16 nil 3408 34 2 8 1140924419 1 5664 1362 nil nil 1408 false 480 nil 5 nil nil nil 5664 nil 8 1759007584 1442 nil nil nil 914 138 144 34 1 978 #createWindow: 34 1 1026 1058 8 #[0 0 0 0 47 0 0 0 151 0 0 0 70 0 0 0] 193 5696 8 '&Security Settings' 5664 3 8 #() 498 193 193 nil 27 8 'notifySecurity' nil 914 138 144 34 1 978 #createWindow: 34 1 1026 1058 8 #[10 0 0 0 85 0 0 0 208 1 0 0 155 0 0 0] 193 3440 8 '' 3408 3 34 8 3840 3536 4752 5056 4448 4144 5664 5360 498 193 193 nil 27 1186 1984 1 2400 1 3072 151 1218 #fixedParentBottom 1 170 192 34 10 784 8 'isMonitoring' 1296 8 'includeSubDirs' 2016 8 'directoryName' 2416 8 'chooseDirectory' 3088 8 'filters' 590342 ##(Smalltalk.Rectangle) 498 21 21 498 21 21 914 138 144 34 1 978 #createWindow: 34 1 1026 1058 8 #[0 0 0 0 0 0 0 0 218 1 0 0 165 0 0 0] 193 672 8 '' 640 3 34 8 2752 2016 2416 1664 3088 1296 784 3408 498 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140985933 1025 6528 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 480 nil 5 nil nil nil 6528 nil 8 1759068368 459270 ##(Smalltalk.Message) #displayString 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Time' 161 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 6864 8 'doIt' 8 '[:dt | dt printStringFormat: ''HH:mm:ssFFF'']' 8 #[31 105 17 29 177 106] 8 'HH:mm:ssFFF' #printStringFormat: 6880 7 257 nil 6706 #<= 8 #() 6706 #second 7008 nil 6528 nil 1 nil nil 6818 8 'Change' 145 #left 6706 #displayString 6736 6706 #<= 8 #() 6706 #first 7008 nil 6528 nil 1 nil nil 6818 8 'Path' 665 #left 6706 #displayString 7008 6706 #<= 7008 6706 #third 7008 nil 6528 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 914 138 144 34 1 978 #createWindow: 34 1 1026 1058 8 #[0 0 0 0 165 0 0 0 218 1 0 0 160 1 0 0] 193 6560 8 'Time' 6528 3 8 #() 498 193 193 nil 35 170 192 34 2 6528 8 'changeList' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 3 265030 4 ##(Smalltalk.Menu) nil true 34 3 984134 2 ##(Smalltalk.CommandMenuItem) 1 866 #toggleMonitoring 8 'Monitor Changes' 9355 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 7554 1 866 #exit 8 '&Exit' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 12831 nil nil 7506 nil true 34 1 7554 1 866 #clear 8 '&Clear' 9393 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 12835 nil nil 7506 nil true 34 1 7554 1 866 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 12839 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 914 138 144 34 1 978 #createWindow: 34 1 1026 6290 498 1 1 498 981 951 193 448 8 'Dolphin File System Monitor' 416 1 34 2 640 6528 498 193 193 nil 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !

!FileSystemMonitor class categoriesForMethods!
defaultModel!models!public! !
icon!public! !
initialize!development!initializing!private! !
resource_Default_view!public!resources-views! !
shutdownOnExit!public!testing! !
!

