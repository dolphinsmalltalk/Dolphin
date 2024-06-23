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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default 518 #{Graphics.Point} 981 951 517 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 88 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 32 0 83 0 101 0 109 0 105 0 98 0 111 0 108 0 100 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 130 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 288 nil 98 #face3d nil 5 nil nil nil 288 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 16 18 #{UI.StaticText} 50 16 nil 288 50 2 8 1140850944 1 448 nil nil nil 5 nil nil nil 448 nil nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 130 21 21 130 111 31 448 594 #text: 50 1 8 '&Directory:' 448 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 65 0 0 0 25 0 0 0] 8 #() 130 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 1 834 #fixedViewLeft 111 834 #fixedParentTop 1 834 #fixedViewTop 31 18 #{UI.TextEdit} 50 20 nil 288 50 2 8 1140981888 1025 912 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} 8 '' 112 nil 5 nil nil nil 912 nil nil 514 nil nil 3 #focusLost nil nil nil 546 50 2 594 #createAt:extent: 50 2 130 151 21 130 719 41 912 594 #setMarginWidths: 50 1 8 #(3 3) 912 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 0 0 0 10 0 0 0 178 1 0 0 30 0 0 0] 8 #() 784 nil 45 802 834 #fixedPreviousRight 21 834 #fixedParentRight -59 834 #fixedPreviousTop 1 896 41 18 #{UI.PushButton} 50 20 nil 288 50 2 8 1140924416 1 1328 nil 112 nil 5 nil nil nil 1328 nil nil 1350 4 #{UI.CommandDescription} #chooseDirectory 8 '…' 1 1 nil nil false nil nil nil 546 50 3 594 #createAt:extent: 50 2 130 879 21 130 41 41 1328 594 #isEnabled: 8 #(false) 1328 594 #text: 50 1 8 '…' 1328 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 183 1 0 0 10 0 0 0 203 1 0 0 30 0 0 0] 8 #() 784 nil 29 802 1280 11 864 41 1312 1 896 41 18 #{UI.PushButton} 50 20 nil 288 50 2 8 1140928514 1 1680 nil 112 nil 5 nil nil nil 1680 nil nil 1394 #toggleMonitoring 8 '&Monitor' 1 1 nil nil false nil nil nil 546 50 3 594 #createAt:extent: 50 2 130 781 79 130 141 51 1680 594 #isEnabled: 8 #(false) 1680 594 #text: 50 1 8 '&Monitor' 1680 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 134 1 0 0 39 0 0 0 204 1 0 0 64 0 0 0] 8 #() 784 nil 29 802 1280 25 864 141 1312 -1 896 51 18 #{UI.TextEdit} 50 20 nil 288 50 2 8 1140916352 1025 2016 nil 112 nil 5 nil nil nil 2016 nil nil 514 nil nil 1 #focusLost nil nil nil 546 50 2 594 #createAt:extent: 50 2 130 151 81 130 315 41 2016 594 #setMarginWidths: 50 1 8 #(3 3) 2016 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 75 0 0 0 40 0 0 0 232 0 0 0 60 0 0 0] 8 #() 784 nil 45 802 1280 21 1296 -463 1312 -9 896 41 18 #{UI.CheckBox} 50 16 nil 288 50 2 8 1140924419 1 2304 978 nil nil 6 #{Kernel.NeverSearchPolicy} false 112 nil 5 nil nil nil 2304 nil nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 130 485 81 130 273 41 2304 594 #text: 50 1 8 'Include s&ub-directories?' 2304 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 242 0 0 0 40 0 0 0 122 1 0 0 60 0 0 0] 8 #() 784 nil 27 802 1280 21 864 273 1312 1 896 41 18 #{UI.StaticText} 50 16 nil 288 50 2 8 1140850944 1 2640 nil nil nil 5 nil nil nil 2640 nil nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 130 21 91 130 111 41 2640 594 #text: 50 1 8 'Fi&lters:' 2640 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 45 0 0 0 65 0 0 0 65 0 0 0] 8 #() 784 nil 27 802 848 1 864 111 834 #fixedPreviousBottom 31 896 41 18 #{UI.ContainerView} 50 15 nil 288 50 2 8 1140850688 131073 2944 nil 352 nil 5 nil nil nil 2944 1030 #{UI.GridLayout} 7 7 1 1 402 #{Core.IdentityDictionary} 50 16 18 #{UI.CheckBox} 50 16 nil 2944 50 2 8 1141055491 1 3072 978 nil nil 2400 false 112 nil 5 nil nil nil 3072 nil nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 130 1 1 130 303 47 3072 594 #text: 50 1 8 '&Attributes' 3072 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 151 0 0 0 23 0 0 0] 8 #() 784 nil 27 8 'notifyAttributes' 18 #{UI.CheckBox} 50 16 nil 2944 50 2 8 1140924419 1 3376 978 nil nil 2400 false 112 nil 5 nil nil nil 3376 nil nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 130 607 1 130 303 47 3376 594 #text: 50 1 8 '&Creation Time' 3376 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 47 1 0 0 0 0 0 0 198 1 0 0 23 0 0 0] 8 #() 784 nil 27 8 'notifyCreateTime' 18 #{UI.CheckBox} 50 16 nil 2944 50 2 8 1140924419 1 3680 978 nil nil 2400 false 112 nil 5 nil nil nil 3680 nil nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 130 303 1 130 305 47 3680 594 #text: 50 1 8 'Directory &Name' 3680 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 0 0 0 0 47 1 0 0 23 0 0 0] 8 #() 784 nil 27 8 'notifyDirectoryName' 18 #{UI.CheckBox} 50 16 nil 2944 50 2 8 1140924419 1 3984 978 nil nil 2400 false 112 nil 5 nil nil nil 3984 nil nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 130 1 47 130 303 49 3984 594 #text: 50 1 8 'F&ile Name' 3984 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 0 0 0 151 0 0 0 47 0 0 0] 8 #() 784 nil 27 8 'notifyFileName' 18 #{UI.CheckBox} 50 16 nil 2944 50 2 8 1140924419 1 4288 978 nil nil 2400 false 112 nil 5 nil nil nil 4288 nil nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 130 303 47 130 305 49 4288 594 #text: 50 1 8 '&Last Access Time' 4288 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 23 0 0 0 47 1 0 0 47 0 0 0] 8 #() 784 nil 27 8 'notifyLastAccess' 18 #{UI.CheckBox} 50 16 nil 2944 50 2 8 1140924419 1 4592 978 nil nil 2400 false 112 nil 5 nil nil nil 4592 nil nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 130 607 47 130 303 49 4592 594 #text: 50 1 8 'Last &Write Time' 4592 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 47 1 0 0 23 0 0 0 198 1 0 0 47 0 0 0] 8 #() 784 nil 27 8 'notifyLastWrite' 18 #{UI.CheckBox} 50 16 nil 2944 50 2 8 1140924419 1 4896 978 nil nil 2400 false 112 nil 5 nil nil nil 4896 nil nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 130 1 95 130 303 47 4896 594 #text: 50 1 8 '&Security Settings' 4896 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 47 0 0 0 151 0 0 0 70 0 0 0] 8 #() 784 nil 27 8 'notifySecurity' 18 #{UI.CheckBox} 50 16 nil 2944 50 2 8 1140924419 1 5200 978 nil nil 2400 false 112 nil 5 nil nil nil 5200 nil nil 514 nil nil nil 546 50 2 594 #createAt:extent: 50 2 130 303 95 130 305 47 5200 594 #text: 50 1 8 'Si&ze' 5200 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 151 0 0 0 47 0 0 0 47 1 0 0 70 0 0 0] 8 #() 784 nil 27 8 'notifySize' nil 546 50 1 594 #createAt:extent: 50 2 130 21 171 130 909 141 2944 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 85 0 0 0 208 1 0 0 155 0 0 0] 50 8 3072 3680 3376 3984 4288 4592 4896 5200 784 nil 27 802 848 1 1296 1 880 151 834 #fixedParentBottom 1 402 #{Core.IdentityDictionary} 50 10 1328 8 'chooseDirectory' 912 8 'directoryName' 2016 8 'filters' 2304 8 'includeSubDirs' 1680 8 'isMonitoring' 518 #{Graphics.Rectangle} 130 21 21 130 21 21 546 50 1 594 #createAt:extent: 50 2 130 1 1 130 949 331 288 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 218 1 0 0 165 0 0 0] 50 8 448 912 1328 2640 2016 2304 1680 2944 784 nil 27 nil nil nil 18 #{UI.ListView} 50 45 nil 32 50 2 8 1140985933 1025 6000 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 112 nil 5 nil nil nil 6000 nil nil 518 #{Core.Message} #displayString 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 6098 3 3142 5 #{UI.ListViewColumn} 8 'Time' 161 #left 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 6304 8 'doIt' 8 '[:dt | dt printStringFormat: ''HH:mm:ssFFF'']' 8 #[31 105 17 29 177 106] 8 'HH:mm:ssFFF' #printStringFormat: 6320 7 257 nil 6162 #<= 8 #() 6162 #second 6448 nil 6000 nil 1 nil nil 6258 8 'Change' 145 #left 6162 #displayString 6192 6162 #<= 8 #() 6162 #first 6448 nil 6000 nil 1 nil nil 6258 8 'Path' 665 #left 6162 #displayString 6448 6162 #<= 6448 6162 #third 6448 nil 6000 nil 3 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 546 50 2 594 #createAt:extent: 50 2 130 1 331 130 949 503 6000 594 #text: 50 1 8 'Time' 6000 722 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 165 0 0 0 218 1 0 0 160 1 0 0] 8 #() 784 nil 35 402 #{Core.IdentityDictionary} 50 2 6000 8 'changeList' nil 2886 4 #{UI.MenuBar} nil true 50 3 2886 4 #{UI.Menu} nil true 50 3 1094 2 #{UI.CommandMenuItem} 1 1394 #toggleMonitoring 8 'Monitor Changes' 9355 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 7010 1 1394 #exit 8 '&Exit' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 6962 nil true 50 1 7010 1 1394 #clear 8 '&Clear' 9393 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 6962 nil true 50 1 7010 1 1394 #about 8 '&About' 1 1 nil nil nil 8 '&Help' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 546 50 2 594 #createAt:extent: 50 2 130 6143 21 130 981 951 32 594 #text: 50 1 8 'Dolphin File System Monitor' 32 722 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 233 13 0 0 229 1 0 0] 50 2 288 6000 784 nil 27)!

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

