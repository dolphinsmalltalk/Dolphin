"Filed out from Dolphin Smalltalk"!

UI.Shell
	subclass: #'UI.Examples.RegEdit'
	instanceVariableNames: 'keyPresenter valuesPresenter statusModel'
	classVariableNames: 'ResourceLib'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.RegEdit guid: (Core.GUID fromString: '{87b4c69e-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.Examples.RegEdit comment: 'RegEdit is a <topShell> sample application which implements most of the functionality of the Windows utility, RegEdit. It does not implement the full functionality of the standard tool because it is primarily intended as a demonstration of the use of registry access classes, and the tree and enhanced list views. It supports in-place registry key name editing.

Example:
RegEdit show

BE WARNED, as with the standard RegEdit, it is possible to corrupt your registry with this tool, so please use with care!!

Instance Variables:
	keyPresenter	<TreePresenter> holding the hierarchy of registry keys.
	valuesPresenter	<ListPresenter> displaying the registry entries for selected keys.
	statusModel	<ValueHolder> for displaying status information.

Class Variables:
	ResourceLib	<ExternalResourceLibrary> for accessing resources within the standard REGEDIT.EXE.





'!
!UI.Examples.RegEdit categoriesForClass!MVP-Presenters!Samples! !
!UI.Examples.RegEdit methodsFor!

aboutRegistryEditor
	"Private - Pop up a little helpful info. about this sample program."

	self class about!

chooseFont
	"Private - Pop the font dialog to allow selection of font for the text in the receiver.
	Note how we easily we can modify the font simply by opening FontDialog on the
	font aspect of the view."

	FontDialog showModalOn: (self view aspectValue: #font)!

copyKeyName
	"Private - Copy the full path name of the currently selected key to the clipboard."

	self selectedKey fullPath copyToClipboard!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	keyPresenter := self add: (TreePresenter on: RegTreeModel new) name: 'keys'.
	valuesPresenter := self add: ListPresenter new name: 'values'!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring.

	keyPresenter 
		when: #selectionChanged send: #onKeySelected to: self;
		when: #labelOf:editedTo:accept: send: #onKey:renamedTo:accept: to: self;
		when: #aboutToEditLabel:accept: send: #onAboutToRenameKey:accept: to: self";
		when: #selectionChanging: send: #onSelectionChanging: to: self".

	valuesPresenter
		when: #labelOf:editedTo:accept: send: #onValue:renamedTo:accept: to: self;
		when: #aboutToEditLabel:accept: send: #onAboutToRenameValue:accept: to: self
		!

delete
	"Private - Delete the selected item (if confirmed)."

	keyPresenter view hasFocus ifTrue: [^self deleteSelectedKey].
	valuesPresenter view hasFocus ifTrue: [^self deleteSelectedValue].
	Sound warningBeep!

deleteSelectedKey
	"Private - Delete the selected registry key."

	| key mb |
	key := self selectedKey.
	key isRoot ifTrue: [^nil].	"Can't delete root key."
	mb := MessageBox new.
	mb text: 'Are you sure you want to permanently delete this key and all of its subkeys?'.
	mb caption: 'Confirm Key Delete'.
	mb icon: Warning icon.
	mb buttonStyle: #yesNo.
	mb open == #yes 
		ifTrue: 
			[| parentKey |
			parentKey := key parentKey.
			
			[parentKey removeKey: key name ifAbsent: [^self].
			keyPresenter model remove: key] 
					on: HRESULTError
					do: [:e | e okCancel]]!

deleteSelectedValue
	"Private - Delete the selected registry value."

	| idx mb |
	idx := valuesPresenter selectionByIndex.
	idx == 0 ifTrue: [^self].
	mb := MessageBox new.
	mb text: 'Deleting certain registry values could cause system instability. Are you sure you want to permanently delete these values?'.
	mb caption: 'Confirm Value Delete'.
	mb icon: Warning icon.
	mb buttonStyle: #yesNo.
	mb open == #yes 
		ifTrue: 
			[
			[| value |
			value := valuesPresenter model at: idx.
			self selectedKey subValues removeKey: value key ifAbsent: [^self].
			value value: nil.
			value key isEmpty 
				ifTrue: [valuesPresenter model refreshAtIndex: idx]
				ifFalse: [valuesPresenter model removeAtIndex: idx]] 
					on: HRESULTError
					do: [:e | e okCancel]]!

exportKey: key toFile: path 
	"Private - Write a .reg file describing the selected key and its subkeys to the specified
	path."

	| stream |
	stream := FileStream write: path.
	stream
		nextPutAll: 'REGEDIT4';
		cr;
		cr.	"RegEdit 4.0 format"
	key fileOutOn: stream.
	stream close!

exportRegistryFile
	"Private - Write a .reg file describing the selected key and its subkeys."

	| openFilename |
	openFilename := (FileSaveDialog new)
				fileTypes: self fileTypes;
				caption: 'Export Registry File';
				showModal.
	openFilename notNil 
		ifTrue: [Cursor wait showWhile: [self exportKey: self selectedKey toFile: openFilename]].
	#todo	"Implement - custom file save dialog template"!

fileTypes
	"Private - Answer an Array of file types used for registry import/export."

	| strings |
	strings := #('Registration Files (*.reg)' '*.reg' 'Registry Hive Files (*.*)' '*.*' 'All Files' '*.*').
	^(1 to: strings size by: 2) collect: [:i | {strings at: i. strings at: i + 1}]!

importRegistryFile
	"Private - Import a .reg file selected by the user into the registry."

	| openFilename |
	openFilename := FileOpenDialog new
				fileTypes: self fileTypes;
				caption: 'Import Registry File';
				showModal.
	openFilename notNil ifTrue: [Shell32 shellOpen: openFilename]!

initialize
	"Private - Initialize the receiver"

	super initialize.
	keyPresenter model roots: {RegKey classesRoot: #read.
				RegKey userRoot.
				RegKey localMachineRoot: #read.
				RegKey usersRoot.
				RegKey configRoot}!

newBinaryValue
	"Add a new, empty, string value under the currently selected key."

	self newValue: ByteArray new!

newDWORDValue
	"Add a new, empty, string value under the currently selected key."

	self newValue: 0!

newKey
	"Add a new, empty, sub-key under the currently selected key, 
	and leave the receiver in key renaming mode."

	| i sel newKey |
	i := 1.
	sel := self selectedKey.
	"Generate a unique key name"
	[newKey := 'New Key #', i displayString. sel includesKey: newKey] whileTrue: [i := i + 1].
	newKey := sel createKey: newKey.
	keyPresenter model add: newKey asChildOf: sel.
	keyPresenter
		selection: newKey;
		view editSelectionLabel!

newStringValue
	"Add a new, empty, string value under the currently selected key."

	self newValue: ''!

newValue: anObject
	"Add a new, empty, value under the currently selected key
	initialized with the specified value."

	| sel newValue |
	newValue := self newValueName.
	sel := self selectedKey subValues.
	sel at: newValue put: anObject.
	sel := valuesPresenter model addAnsweringIndex: newValue -> anObject.
	valuesPresenter
		selectionByIndex: sel;
		view editSelectionLabel!

newValueName
	"Private - Answer a new unique value name under the currently selected key."

	| i sel unique |
	i := 1.
	sel := self selectedKey subValues.
	
	[unique := 'New Value #' , i displayString.
	sel includesKey: unique] whileTrue: [i := i + 1].
	^unique!

onAboutToRenameKey: key accept: booleanValue
	"The registry key, key, is about to experience an in-place label edit.
	Determine whether to allow it."

	booleanValue value: key isRoot not!

onAboutToRenameValue: value accept: booleanValue
	"The registry value represented by the <Association>, value, 
	is about to experience an in-place label edit.  Determine 
	whether to allow it and set the <valueHolder>, booleanValue
	accordingly."

	booleanValue value: value key notEmpty!

onKey: key renamedTo: text accept: booleanValue
	"The registry key, key, has been renamed by the user to, text, by editing the label
	in the tree. Attempt to rename the key, and if successful, then set booleanValue 
	accordingly to indicate acceptance or otherwise."

	Warning signal: 'Key renaming is not yet implemented'.
	booleanValue value: key isRoot not!

onKeySelected
	"Private - The key selected within the receiver has changed. 
	Refresh the value pane."

	| key |
	key := self selectedKey.
	key isNil 
		ifTrue: 
			[valuesPresenter clear
			"statusModel value: nil"]
		ifFalse: 
			[| values |
			values := SortedCollection sortBlock: [:a :b | a key < b key].
			key subValues keysAndValuesDo: [:k :v | values add: k -> v].
			(values isEmpty or: [values first key notEmpty]) ifTrue: [values add: '' -> nil].
			valuesPresenter list: values asOrderedCollection.
			statusModel value: key]!

onValue: value renamedTo: text accept: booleanValue
	"The registry value represented by the <Association>, value, 
	has been renamed by the user to, text, by editing the label
	in the list view. Attempt to rename the value, and if successful, 
	then set <ValueHolder> booleanValue accordingly to indicate 
	acceptance or otherwise."

	| key |
	key := self selectedKey.
	key subValues changeKey: value key to: text.
	"We must also update the value to reflect the modification (could hook off nmSetDispInfo: ?)"
	value key: text.
	booleanValue value: true!

onViewOpened
	"Received when the receiver's view is been connected. "

	| statusItem |
	super onViewOpened.
	statusItem := self view viewNamed: 'key name' ifNone: [^self].
	statusModel := ValueHolder new.
	statusItem model: statusModel!

queryCommand: query
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery>,  query."

	| command selKey selVal |
	command := query command.
	#toggleStatusBar == command
		ifTrue: 
			[query
				isEnabled: true;
				isChecked: self statusBar isWindowVisible.
			^true].
	selKey := self selectedKey.
	(#(#newKey #newStringValue #newDWORDValue #newBinaryValue) includes: command)
		ifTrue: 
			[query isEnabled: (selKey notNil and: [selKey isWriteable]).
			^true].
	(#(#exportRegistryFile #copyKeyName) includes: command)
		ifTrue: 
			[query isEnabled: selKey notNil.
			^true].
	"Modification of the root keys is not permitted."
	(#(#deleteSelectedKey #renameSelectedKey) includes: command)
		ifTrue: 
			[query isEnabled: (selKey notNil and: [selKey isWriteable and: [selKey isRoot not]]).
			^true].
	selVal := self selectedValue.
	#renameSelectedValue == command
		ifTrue: 
			[query isEnabled: (selVal notNil and: [selVal key notEmpty and: [selKey isWriteable]]).
			^true].
	#deleteSelectedValue == command
		ifTrue: 
			[query isEnabled: selVal notNil.
			^true].
	(#(#delete #rename) includes: query command)
		ifTrue: 
			[keyPresenter view hasFocus
				ifTrue: 
					[query isEnabled: (selKey notNil and: [selKey isWriteable and: [selKey isRoot not]]).
					^true].
			valuesPresenter view hasFocus
				ifTrue: 
					[query isEnabled: (selVal notNil and: [selVal key notEmpty and: [selKey isWriteable]]).
					^true]].
	^super queryCommand: query!

refresh
	| selection |
	selection := keyPresenter selectionOrNil.
	keyPresenter view refreshContents.
	keyPresenter selection: selection ifAbsent: []!

rename
	"Private - Initiate in-place label edit of the selected item."

	<acceleratorKey: 'F2'>
	keyPresenter view hasFocus ifTrue: [^self renameSelectedKey].
	valuesPresenter view hasFocus ifTrue: [^self renameSelectedValue].
	Sound warningBeep!

renameSelectedKey
	"Private - Initiate in-place label edit of the selected key."

	keyPresenter view editSelectionLabel!

renameSelectedValue
	"Private - Initiate in-place label edit of the selected key."

	valuesPresenter view editSelectionLabel!

resourceLib
	"Answer the registry editor resource library (regedit.exe)."

	^ResourceLib!

selectedKey
	"Answer the currently selected registry key."

	^keyPresenter selectionOrNil!

selectedValue
	"Answer the currently selected registry entry."

	^valuesPresenter selectionOrNil!

statusBar
	^self view viewNamed: 'status'!

toggleStatusBar
	| statusBar |
	statusBar := self statusBar.
	statusBar isWindowVisible ifTrue: [statusBar hide] ifFalse: [statusBar show]! !
!UI.Examples.RegEdit categoriesForMethods!
aboutRegistryEditor!commands!private! !
chooseFont!commands!private! !
copyKeyName!commands!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
delete!commands!private! !
deleteSelectedKey!commands!private! !
deleteSelectedValue!commands!private! !
exportKey:toFile:!filing!private! !
exportRegistryFile!commands!private! !
fileTypes!constants!private! !
importRegistryFile!commands!private! !
initialize!initializing!private! !
newBinaryValue!commands!public! !
newDWORDValue!commands!public! !
newKey!commands!public! !
newStringValue!commands!public! !
newValue:!commands!public! !
newValueName!commands!private! !
onAboutToRenameKey:accept:!event handling!public! !
onAboutToRenameValue:accept:!event handling!public! !
onKey:renamedTo:accept:!event handling!public! !
onKeySelected!event handling!private! !
onValue:renamedTo:accept:!event handling!public! !
onViewOpened!event handling!public! !
queryCommand:!commands!private! !
refresh!commands!private! !
rename!commands!private! !
renameSelectedKey!commands!private! !
renameSelectedValue!commands!private! !
resourceLib!constants!public! !
selectedKey!accessing!public! !
selectedValue!accessing!public! !
statusBar!commands!private! !
toggleStatusBar!commands!private! !
!

!UI.Examples.RegEdit class methodsFor!

about
	"Private - Pop up a little helpful info. about this sample program."

	MessageBox new
		caption: 'About Dolphin Registry Editor';
		icon: self icon;
		headline: 'Simple Registry Editor Sample.';
		text: 'Copyright © Object Arts Ltd, 1998-2011.<n><1s>' << VM fullVersion;
		detailsText: 'This is a reduced functionality implementation of the standard system utility REGEDIT.EXE, intended to demonstrate various features of Dolphin''s application framework such as virtual tree models, and in-place label editing.<n><n>DISCLAIMER: This software is freely provided purely as an educational sample and as such it is provided "as is", WITHOUT ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. Furthermore, as with the real registry editor extreme care and expert knowledge are required to avoid damaging the installation of the operating system or other software on your machine if any modifications to the registry are attempted. Please take care - we accept no responsibility for any damage to your computer''s configuration which may be caused by the use of this sample.'
					expandMacros;
		open!

binaryIcon
	"Answers an Icon that can be used to represent binary values."

	^Icon fromId: 'RegValueBin.ico'!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Registry Editor'!

displayStringForValue: anObject
	"Private - Answer an appropriate registry editor display string for the argument, anObject.
	Not clean, but we don't want to add these as polymorphic operations into the types
	of object in the registry.
	This method also illustrates the use of the C-runtime library function sprintf() for
	fast string formatting."

	| s n max |
	anObject isNil ifTrue: [^'(value not set)'].
	anObject isInteger ifTrue: [^'0x%08x (%u)' sprintfWith: anObject with: anObject].
	anObject isString ifTrue: [^anObject].
	anObject class == Array ifTrue: [^$\x20 join: anObject].
	"Assume its a byte array"
	anObject isEmpty ifTrue: [^'(zero-length binary value)'].
	n := anObject size.
	max := 64 min: n.
	s := String writeStream: (max + 1) * 3.
	s locale: Locale invariant.
	(1 to: max) do: [:i | s nextPutAll: ('%02x' sprintfWith: (anObject basicAt: i))]
		separatedBy: [s space].
	max < n ifTrue: [s nextPutAll: '…'].
	^s contents!

icon
	^RegKeyAbstract icon!

iconFor: anObject
	"Private - Answer an appropriate registry editor icon for the argument, anObject.
	Not clean, but..."

	^(anObject isNil or: [anObject isKindOf: String])
		ifTrue: [self stringIcon]
		ifFalse: [self binaryIcon]!

initialize
	"Private - Initialize the receiver's class variables
		self initialize
	"

	Smalltalk developmentSystem 
		addSamplesFolderIconFor: self
		description: self displayString
		helpId: 10622!

keyIcon
	"Answers an Icon that can be used to registry keys."

	^Icon shellStock: SHSTOCKICONID.SIID_FOLDER!

onPreStripImage
	"Private - The image is about to be stripped. Nil any lazily initialized class variables."

	!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 #{Graphics.Color} #default nil 39 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.StatusBar} 34 21 nil 416 34 2 8 1140850956 1 640 nil 480 nil 7 nil nil nil 640 nil 8 1814628368 170 192 34 2 1050438 1 #{UI.StatusBarItem} 8193 -1 640 nil 786950 #{Core.Message} #fullPath 8 #() nil nil 8 'key name' nil nil nil 34 1 768 1311814 1 #{UI.StatusBarNullItem} 8705 1 640 nil nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 1 631 578 1349 43 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 59 1 0 0 162 2 0 0 80 1 0 0] 8 #() 578 193 193 nil 29 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 1104 nil 480 nil 7 nil nil nil 1104 1376774 #{UI.ProportionalLayout} 170 176 34 4 410 #{UI.ListView} 34 45 nil 1104 34 2 8 1140955717 1025 1232 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 480 nil 7 461638 4 #{UI.Menu} nil true 34 4 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #modifySelectedValue 8 'Modify' 1 5 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 1442 1 1474 #deleteSelectedValue 8 '&Delete' 1 1 nil nil nil 1442 1 1474 #renameSelectedValue 8 '&Rename' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1232 nil 8 1815049392 786 #displayString 8 #() 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 4 1 1712 8 'doIt' 8 '[:o | (UI.Examples.RegEdit iconFor: o value) imageIndex]' 8 #[32 105 45 17 142 177 160 106] 1442886 2 #{Kernel.VariableBinding} #RegEdit #{UI.Examples.RegEdit} #{UI.Examples} 1 #iconFor: #imageIndex 1728 7 257 nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 2 1117254 5 #{UI.ListViewColumn} 8 'Name' 451 #left 1714 0 nil 1746 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x isEmpty ifTrue: [''(Default)''] ifFalse: [x displayString]]' 8 #[32 105 17 158 119 30 106 17 160 106] #isEmpty 8 '(Default)' #displayString 1968 7 257 nil 1714 0 nil 1746 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a <= b]' 8 #[29 105 233 1 130 106] 2064 7 513 nil 786 #key 8 #() nil 1232 786 #iconImageIndex 1344 1 nil nil 1922 8 'Data' 601 #left 1714 0 nil 1746 3 1 1712 8 'doIt' 8 '[:v | UI.Examples.RegEdit displayStringForValue: v]' 8 #[31 105 45 17 177 106] 1840 #displayStringForValue: 2224 7 257 nil 1714 0 nil 1746 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a displayString <= b displayString]' 8 #[30 105 17 158 18 158 130 106] #displayString 2304 7 513 nil 786 #value 8 #() nil 1232 786 #iconImageIndex 1696 1 nil nil #report 8 #() nil 131073 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 898 34 3 946 #createAt:extent: 34 2 578 457 1 578 893 631 1232 946 #contextMenu: 34 1 1408 1232 946 #text: 34 1 8 'Name' 1232 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 228 0 0 0 0 0 0 0 162 2 0 0 59 1 0 0] 8 #() 1088 nil 35 5 410 #{UI.Splitter} 34 12 nil 1104 34 2 8 1140850688 1 2672 nil 480 nil 519 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 2672 nil 1 #left nil nil nil 578 1 1 578 9 9 nil 2768 nil 898 34 1 946 #createAt:extent: 34 2 578 447 1 578 11 631 2672 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 223 0 0 0 0 0 0 0 228 0 0 0 59 1 0 0] 8 #() 1088 nil 27 1 false 170 192 34 4 1232 8 'values' 410 #{UI.TreeView} 34 27 nil 1104 34 2 8 1140916743 1025 2992 787526 3 #{UI.TreeModel} nil 1376 721670 #{UI.TreeNode} nil nil nil 170 192 1344 480 nil 7 1394 nil true 34 11 1442 1 1474 #expandSelection 8 'Expand/Collapse' 1 1 nil nil nil 1394 nil true 34 5 1442 1 1474 #newKey 8 '&Key' 1 5 nil nil nil 1522 4097 1442 1 1474 #newStringValue 8 '&String Value' 1 1 nil nil nil 1442 1 1474 #newBinaryValue 8 '&Binary Value' 1 1 nil nil nil 1442 1 1474 #newDWORDValue 8 '&DWORD Value' 1 1 nil nil nil 8 '&New' nil 1 nil nil nil nil nil 1442 1 1474 #findItem 8 '&Find…' 1 5 nil nil nil 1522 4097 1442 1 1474 #deleteSelectedKey 8 '&Delete' 1 1 nil nil nil 1442 1 1474 #renameSelectedKey 8 '&Rename' 1 1 nil nil nil 1522 4097 1442 1 1474 #exportRegistryFile 8 '&Export' 1 1 nil nil nil 1442 1 1474 #permissions 8 '&Permissions…' 1 1 nil nil nil 1522 4097 1442 1 1474 #copyKeyName 8 '&Copy Key Name' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2992 nil 8 1814826960 786 #name 8 #() 1714 0 nil 1746 4 1 1712 8 'doIt' 8 '[:k | UI.Examples.RegEdit keyIcon imageIndex]' 8 #[32 105 45 159 160 106] 1840 #keyIcon #imageIndex 3872 7 257 nil 1872 nil nil nil nil nil 170 176 1344 9 #smallIcons 1 170 192 1344 898 34 2 946 #createAt:extent: 34 2 578 1 1 578 447 631 2992 946 #contextMenu: 34 1 3136 2992 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 223 0 0 0 59 1 0 0] 8 #() 1088 nil 27 8 'keys' nil 898 34 1 946 #createAt:extent: 34 2 578 1 1 578 1349 631 1104 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 162 2 0 0 59 1 0 0] 34 3 2992 2672 1232 1088 nil 27 170 192 34 2 640 8 'status' nil 658246 4 #{UI.MenuBar} nil true 34 4 1394 nil true 34 12 1442 1 1474 #importRegistryFile 8 'Import…' 1 1 nil nil nil 1442 1 1474 #exportRegistryFile 8 '&Export…' 1 1 nil nil nil 1522 4097 1442 1 1474 #loadHive 8 '&Load Hive' 1 1 nil nil nil 1442 1 1474 #unloadHive 8 '&Unload Hive' 1 1 nil nil nil 1522 4097 1442 1 1474 #connectNetworkRegistry 8 '&Connect Network Registry' 1 1 nil nil nil 1442 1 1474 #disconnectNetworkRegistry 8 '&Disconnect Network Registry' 1 1 nil nil nil 1522 4097 1442 1 1474 #print 8 '&Print' 8353 1 nil nil nil 1522 4097 1442 1 1474 #exit 8 'E&xit' 1 1 nil nil nil 8 '&Registry' nil 1 nil nil 32737 nil nil 1394 nil true 34 11 1394 nil true 34 7 1442 1 1474 #newKey 8 '&Key' 1 1 nil nil nil 1522 4097 1442 1 1474 #newStringValue 8 '&String Value' 1 1 nil nil nil 1442 1 1474 #newBinaryValue 8 '&Binary Value' 1 1 nil nil nil 1442 1 1474 #newDWORDValue 8 '&DWORD Value' 1 1 nil nil nil 1442 1 1474 #newMultiStringValue 8 '&Multi-String Value' 1 1 nil nil nil 1442 1 1474 #newExpandableStringValue 8 '&Expandable String Value' 1 1 nil nil nil 8 '&New' nil 1 nil nil 32751 nil nil 1522 4097 1442 1 1474 #permissions 8 '&Permissions…' 1 1 nil nil nil 1522 4097 1442 1 1474 #delete 8 '&Delete' 605 1 nil nil nil 1442 1 1474 #rename 8 '&Rename' 1 1 nil nil nil 1522 4097 1442 1 1474 #copyKeyName 8 '&Copy Key Name' 1 1 nil nil nil 1522 4097 1442 1 1474 #find 8 '&Find…' 8333 1 nil nil nil 1442 1 1474 #findNext 8 'Find Ne&xt' 229 1 nil nil nil 8 '&Edit' nil 1 nil nil 32765 nil nil 1394 nil true 34 8 1442 1 1474 #toggleStatusBar 8 '&Status Bar' 1 1 nil nil nil 1522 4097 1442 1 1474 #viewSplit 8 'Sp&lit' 1 1 nil nil nil 1522 4097 1442 1 1474 #viewDisplayBinary 8 '&Display Binary Data' 1 1 nil nil nil 1522 4097 1442 1 1474 #refresh 8 '&Refresh' 233 1 nil nil nil 1442 1 1474 #chooseFont 8 '&Font' 1 1 nil nil nil 8 '&View' nil 1 nil nil 32777 nil nil 1394 nil true 34 1 1442 1 1474 #aboutRegistryEditor 8 '&About Registry Editor' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 32781 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 898 34 2 946 #createAt:extent: 34 2 578 12287 21 578 1381 791 416 946 #text: 34 1 8 'Dolphin Registry Editor' 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 177 26 0 0 149 1 0 0] 34 2 1104 640 1088 nil 27)!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true!

stringIcon
	"Answers an Icon that can be used to string values."

	^RegKeyValues icon! !
!UI.Examples.RegEdit class categoriesForMethods!
about!enquiries!private! !
binaryIcon!constants!public! !
displayOn:!displaying!public! !
displayStringForValue:!displaying!private! !
icon!constants!public! !
iconFor:!constants!displaying!private! !
initialize!development!initializing!private! !
keyIcon!constants!public! !
onPreStripImage!class hierarchy-removing!private! !
resource_Default_view!public!resources-views! !
shutdownOnExit!public!testing! !
stringIcon!constants!public! !
!

