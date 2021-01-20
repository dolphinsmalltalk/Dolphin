"Filed out from Dolphin Smalltalk 7"!

UI.Shell subclass: #FileSystemMonitor
	instanceVariableNames: 'directoryName notifyAttributes notifyDirectoryName notifyCreateTime notifyFileName notifyLastAccess notifyLastWrite notifySecurity notifySize filters includeSubDirs changeList'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
FileSystemMonitor guid: (Core.GUID fromString: '{1c0d9cfc-b0a6-4b19-b2c6-cc6e373ff4fa}')!
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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default 328198 ##(Smalltalk.Point) 981 951 549 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 84 97 104 111 109 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 656 nil 466 #face3d nil 7 nil nil nil 656 852230 ##(Smalltalk.FramingLayout) 170 176 34 16 410 ##(Smalltalk.CheckBox) 34 16 nil 656 34 2 8 1140924419 1 800 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false 480 nil 7 nil nil nil 800 nil 8 1903885040 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 485 81 498 271 41 800 1042 #text: 34 1 8 'Include s&ub-directories?' 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 242 0 0 0 40 0 0 0 121 1 0 0 60 0 0 0] 8 #() 498 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 21 1282 #fixedViewLeft 271 1282 #fixedPreviousTop 1 1282 #fixedViewTop 41 410 ##(Smalltalk.StaticText) 34 16 nil 656 34 2 8 1140850944 1 1360 nil nil nil 7 nil nil nil 1360 nil 8 1903849936 946 nil nil nil 978 138 144 34 2 1042 #createAt:extent: 34 2 498 21 91 498 111 41 1360 1042 #text: 34 1 8 'Fi&lters:' 1360 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 45 0 0 0 65 0 0 0 65 0 0 0] 8 #() 1232 nil 27 1250 1282 #fixedParentLeft 1 1312 111 1282 #fixedPreviousBottom 31 1344 41 410 ##(Smalltalk.StaticText) 34 16 nil 656 34 2 8 1140850944 1 1712 nil nil nil 7 nil nil nil 1712 nil 8 1903849936 946 nil nil nil 978 138 144 34 2 1042 #createAt:extent: 34 2 498 21 21 498 111 31 1712 1042 #text: 34 1 8 '&Directory:' 1712 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 65 0 0 0 25 0 0 0] 8 #() 1232 nil 27 1250 1680 1 1312 111 1282 #fixedParentTop 1 1344 31 410 ##(Smalltalk.TextEdit) 34 16 nil 656 34 2 8 1140981888 1025 2048 866 nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) 8 '' 480 nil 7 nil nil nil 2048 nil 8 1903872368 946 nil nil 3 978 138 144 34 2 1042 #createAt:extent: 34 2 498 151 21 498 719 41 2048 1042 #setMarginWidths: 34 1 8 #(3 3) 2048 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 0 0 0 10 0 0 0 178 1 0 0 30 0 0 0] 8 #() 1232 nil 27 1250 1296 21 1282 #fixedParentRight -59 1328 1 1344 41 410 ##(Smalltalk.PushButton) 34 20 nil 656 34 2 8 1140928514 1 2448 nil 480 nil 7 nil nil nil 2448 nil 8 1903885040 1180998 4 ##(Smalltalk.CommandDescription) #toggleMonitoring 8 '&Monitor' 1 1 nil nil false nil nil nil 978 138 144 34 3 1042 #createAt:extent: 34 2 498 767 77 498 151 51 2448 1042 #isEnabled: 8 #(false) 2448 1042 #text: 34 1 8 '&Monitor' 2448 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 1 0 0 38 0 0 0 202 1 0 0 63 0 0 0] 8 #() 1232 nil 29 1250 1296 13 1312 151 1328 -3 1344 51 410 ##(Smalltalk.PushButton) 34 20 nil 656 34 2 8 1140924416 1 2832 nil 480 nil 7 nil nil nil 2832 nil 8 1903885040 2530 #chooseDirectory 8 '...' 1 1 nil nil false nil nil nil 978 138 144 34 3 1042 #createAt:extent: 34 2 498 879 21 498 41 41 2832 1042 #isEnabled: 8 #(false) 2832 1042 #text: 34 1 8 '...' 2832 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 183 1 0 0 10 0 0 0 203 1 0 0 30 0 0 0] 8 #() 1232 nil 29 1250 1296 11 1312 41 1328 1 1344 41 410 ##(Smalltalk.TextEdit) 34 16 nil 656 34 2 8 1140916352 1025 3200 nil 480 nil 7 nil nil nil 3200 nil 8 1903872368 946 nil nil 1 978 138 144 34 2 1042 #createAt:extent: 34 2 498 151 81 498 315 41 3200 1042 #setMarginWidths: 34 1 8 #(3 3) 3200 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 0 0 0 40 0 0 0 232 0 0 0 60 0 0 0] 8 #() 1232 nil 27 1250 1296 21 2432 -463 1328 -9 1344 41 410 ##(Smalltalk.ContainerView) 34 15 nil 656 34 2 8 1140850688 131073 3520 nil 720 nil 7 nil nil nil 3520 656390 ##(Smalltalk.GridLayout) 7 7 1 1 170 192 34 16 410 ##(Smalltalk.CheckBox) 34 16 nil 3520 34 2 8 1140924419 1 3648 866 nil nil 912 false 480 nil 7 nil nil nil 3648 nil 8 1903885040 946 nil nil nil 978 138 144 34 2 1042 #createAt:extent: 34 2 498 607 47 498 303 49 3648 1042 #text: 34 1 8 'Last &Write Time' 3648 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 47 1 0 0 23 0 0 0 198 1 0 0 47 0 0 0] 8 #() 1232 nil 27 8 'notifyLastWrite' 410 ##(Smalltalk.CheckBox) 34 16 nil 3520 34 2 8 1140924419 1 3984 866 nil nil 912 false 480 nil 7 nil nil nil 3984 nil 8 1903885040 946 nil nil nil 978 138 144 34 2 1042 #createAt:extent: 34 2 498 1 47 498 303 49 3984 1042 #text: 34 1 8 'F&ile Name' 3984 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 0 0 0 151 0 0 0 47 0 0 0] 8 #() 1232 nil 27 8 'notifyFileName' 410 ##(Smalltalk.CheckBox) 34 16 nil 3520 34 2 8 1140924419 1 4320 866 nil nil 912 false 480 nil 7 nil nil nil 4320 nil 8 1903885040 946 nil nil nil 978 138 144 34 2 1042 #createAt:extent: 34 2 498 303 95 498 305 47 4320 1042 #text: 34 1 8 'Si&ze' 4320 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 47 0 0 0 47 1 0 0 70 0 0 0] 8 #() 1232 nil 27 8 'notifySize' 410 ##(Smalltalk.CheckBox) 34 16 nil 3520 34 2 8 1140924419 1 4656 866 nil nil 912 false 480 nil 7 nil nil nil 4656 nil 8 1903885040 946 nil nil nil 978 138 144 34 2 1042 #createAt:extent: 34 2 498 303 47 498 305 49 4656 1042 #text: 34 1 8 '&Last Access Time' 4656 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 23 0 0 0 47 1 0 0 47 0 0 0] 8 #() 1232 nil 27 8 'notifyLastAccess' 410 ##(Smalltalk.CheckBox) 34 16 nil 3520 34 2 8 1141055491 1 4992 866 nil nil 912 false 480 nil 7 nil nil nil 4992 nil 8 1903885040 946 nil nil nil 978 138 144 34 2 1042 #createAt:extent: 34 2 498 1 1 498 303 47 4992 1042 #text: 34 1 8 '&Attributes' 4992 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 151 0 0 0 23 0 0 0] 8 #() 1232 nil 27 8 'notifyAttributes' 410 ##(Smalltalk.CheckBox) 34 16 nil 3520 34 2 8 1140924419 1 5328 866 nil nil 912 false 480 nil 7 nil nil nil 5328 nil 8 1903885040 946 nil nil nil 978 138 144 34 2 1042 #createAt:extent: 34 2 498 1 95 498 303 47 5328 1042 #text: 34 1 8 '&Security Settings' 5328 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 47 0 0 0 151 0 0 0 70 0 0 0] 8 #() 1232 nil 27 8 'notifySecurity' 410 ##(Smalltalk.CheckBox) 34 16 nil 3520 34 2 8 1140924419 1 5664 866 nil nil 912 false 480 nil 7 nil nil nil 5664 nil 8 1903885040 946 nil nil nil 978 138 144 34 2 1042 #createAt:extent: 34 2 498 303 1 498 305 47 5664 1042 #text: 34 1 8 'Directory &Name' 5664 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 0 0 0 0 47 1 0 0 23 0 0 0] 8 #() 1232 nil 27 8 'notifyDirectoryName' 410 ##(Smalltalk.CheckBox) 34 16 nil 3520 34 2 8 1140924419 1 6000 866 nil nil 912 false 480 nil 7 nil nil nil 6000 nil 8 1903885040 946 nil nil nil 978 138 144 34 2 1042 #createAt:extent: 34 2 498 607 1 498 303 47 6000 1042 #text: 34 1 8 '&Creation Time' 6000 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 47 1 0 0 0 0 0 0 198 1 0 0 23 0 0 0] 8 #() 1232 nil 27 8 'notifyCreateTime' nil 978 138 144 34 1 1042 #createAt:extent: 34 2 498 21 171 498 909 141 3520 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 85 0 0 0 208 1 0 0 155 0 0 0] 34 8 4992 5664 6000 3984 4656 3648 5328 4320 1232 nil 27 1250 1680 1 2432 1 2032 151 1282 #fixedParentBottom 1 170 192 34 10 800 8 'includeSubDirs' 2048 8 'directoryName' 2448 8 'isMonitoring' 2832 8 'chooseDirectory' 3200 8 'filters' 590342 ##(Smalltalk.Rectangle) 498 21 21 498 21 21 978 138 144 34 1 1042 #createAt:extent: 34 2 498 1 1 498 949 331 656 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 218 1 0 0 165 0 0 0] 34 8 1712 2048 2832 1360 3200 800 2448 3520 1232 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 30 nil 416 34 2 8 1140985933 1025 6864 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 480 nil 7 nil nil nil 6864 nil 8 1903904528 459270 ##(Smalltalk.Message) #displayString 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Time' 161 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 7200 8 'doIt' 8 '[:dt | dt printStringFormat: ''HH:mm:ssFFF'']' 8 #[31 105 17 29 177 106] 8 'HH:mm:ssFFF' #printStringFormat: 7216 7 257 nil 7042 #<= 8 #() 7042 #second 7344 nil 6864 nil 1 nil nil 7154 8 'Change' 145 #left 7042 #displayString 7072 7042 #<= 8 #() 7042 #first 7344 nil 6864 nil 1 nil nil 7154 8 'Path' 665 #left 7042 #displayString 7344 7042 #<= 7344 7042 #third 7344 nil 6864 nil 3 nil nil #report 6976 nil 131169 nil 34 4 nil nil 498 1 1 nil 978 138 144 34 2 1042 #createAt:extent: 34 2 498 1 331 498 949 503 6864 1042 #text: 34 1 8 'Time' 6864 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 165 0 0 0 218 1 0 0 160 1 0 0] 8 #() 1232 nil 27 170 192 34 2 6864 8 'changeList' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 3 265030 4 ##(Smalltalk.Menu) nil true 34 3 984134 2 ##(Smalltalk.CommandMenuItem) 1 2530 #toggleMonitoring 8 'Monitor Changes' 9355 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 7938 1 2530 #exit 8 '&Exit' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 9967 nil nil 7890 nil true 34 1 7938 1 2530 #clear 8 '&Clear' 9393 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 9993 nil nil 7890 nil true 34 1 7938 1 2530 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil 9997 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 978 138 144 34 3 1042 #createAt:extent: 34 2 498 3839 21 498 981 951 416 1042 #text: 34 1 8 'Dolphin File System Monitor' 416 1042 #updateMenuBar 6976 416 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 105 9 0 0 229 1 0 0] 34 2 656 6864 1232 nil 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true! !
!FileSystemMonitor class categoriesFor: #defaultModel!models!public! !
!FileSystemMonitor class categoriesFor: #displayOn:!displaying!public! !
!FileSystemMonitor class categoriesFor: #icon!public! !
!FileSystemMonitor class categoriesFor: #initialize!development!initializing!private! !
!FileSystemMonitor class categoriesFor: #resource_Default_view!public!resources-views! !
!FileSystemMonitor class categoriesFor: #shutdownOnExit!public!testing! !

