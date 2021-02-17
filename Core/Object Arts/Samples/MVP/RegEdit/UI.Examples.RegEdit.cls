"Filed out from Dolphin Smalltalk 7"!

UI.Shell subclass: #'UI.Examples.RegEdit'
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

additionalAccelerators
	^#(#(#renameIt 'F2'))!

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
	openFilename := (FileOpenDialog new)
				fileTypes: self fileTypes;
				caption: 'Import Registry File';
				showModal.
	openFilename notNil ifTrue: [ShellLibrary default shellOpen: openFilename]!

initialize
	"Private - Initialize the receiver"

	super initialize.
	keyPresenter model roots: RegKey roots!

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
	(#(#newKey #newStringValue #newDWORDValue #newBinaryValue #exportRegistryFile #copyKeyName)
		includes: command)
			ifTrue: 
				[query isEnabled: selKey notNil.
				^true].

	"Modification of the root keys is not permitted."
	(#(#deleteSelectedKey #renameSelectedKey) includes: command)
		ifTrue: 
			[query isEnabled: (selKey notNil and: [selKey isRoot not]).
			^true].
	selVal := self selectedValue.
	#renameSelectedValue == command
		ifTrue: 
			[query isEnabled: (selVal notNil and: [selVal key notEmpty]).
			^true].
	#deleteSelectedValue == command
		ifTrue: 
			[query isEnabled: selVal notNil.
			^true].
	(#(#delete #rename) includes: query command)
		ifTrue: 
			[keyPresenter view hasFocus
				ifTrue: 
					[query isEnabled: (selKey notNil and: [selKey isRoot not]).
					^true].
			valuesPresenter view hasFocus
				ifTrue: 
					[query isEnabled: (selVal notNil and: [selVal key notEmpty]).
					^true]].
	^super queryCommand: query!

refresh
	| selection |
	selection := keyPresenter selectionOrNil.
	keyPresenter view refreshContents.
	keyPresenter selection: selection ifAbsent: []!

rename
	"Private - Initiate in-place label edit of the selected item."

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
!UI.Examples.RegEdit categoriesFor: #aboutRegistryEditor!commands!private! !
!UI.Examples.RegEdit categoriesFor: #additionalAccelerators!constants!private! !
!UI.Examples.RegEdit categoriesFor: #chooseFont!commands!private! !
!UI.Examples.RegEdit categoriesFor: #copyKeyName!commands!private! !
!UI.Examples.RegEdit categoriesFor: #createComponents!initializing!public! !
!UI.Examples.RegEdit categoriesFor: #createSchematicWiring!initializing!public! !
!UI.Examples.RegEdit categoriesFor: #delete!commands!private! !
!UI.Examples.RegEdit categoriesFor: #deleteSelectedKey!commands!private! !
!UI.Examples.RegEdit categoriesFor: #deleteSelectedValue!commands!private! !
!UI.Examples.RegEdit categoriesFor: #exportKey:toFile:!filing!private! !
!UI.Examples.RegEdit categoriesFor: #exportRegistryFile!commands!private! !
!UI.Examples.RegEdit categoriesFor: #fileTypes!constants!private! !
!UI.Examples.RegEdit categoriesFor: #importRegistryFile!commands!private! !
!UI.Examples.RegEdit categoriesFor: #initialize!initializing!private! !
!UI.Examples.RegEdit categoriesFor: #newBinaryValue!commands!public! !
!UI.Examples.RegEdit categoriesFor: #newDWORDValue!commands!public! !
!UI.Examples.RegEdit categoriesFor: #newKey!commands!public! !
!UI.Examples.RegEdit categoriesFor: #newStringValue!commands!public! !
!UI.Examples.RegEdit categoriesFor: #newValue:!commands!public! !
!UI.Examples.RegEdit categoriesFor: #newValueName!commands!private! !
!UI.Examples.RegEdit categoriesFor: #onAboutToRenameKey:accept:!event handling!public! !
!UI.Examples.RegEdit categoriesFor: #onAboutToRenameValue:accept:!event handling!public! !
!UI.Examples.RegEdit categoriesFor: #onKey:renamedTo:accept:!event handling!public! !
!UI.Examples.RegEdit categoriesFor: #onKeySelected!event handling!private! !
!UI.Examples.RegEdit categoriesFor: #onValue:renamedTo:accept:!event handling!public! !
!UI.Examples.RegEdit categoriesFor: #onViewOpened!event handling!public! !
!UI.Examples.RegEdit categoriesFor: #queryCommand:!commands!private! !
!UI.Examples.RegEdit categoriesFor: #refresh!commands!private! !
!UI.Examples.RegEdit categoriesFor: #rename!commands!private! !
!UI.Examples.RegEdit categoriesFor: #renameSelectedKey!commands!private! !
!UI.Examples.RegEdit categoriesFor: #renameSelectedValue!commands!private! !
!UI.Examples.RegEdit categoriesFor: #resourceLib!constants!public! !
!UI.Examples.RegEdit categoriesFor: #selectedKey!accessing!public! !
!UI.Examples.RegEdit categoriesFor: #selectedValue!accessing!public! !
!UI.Examples.RegEdit categoriesFor: #statusBar!commands!private! !
!UI.Examples.RegEdit categoriesFor: #toggleStatusBar!commands!private! !

!UI.Examples.RegEdit class methodsFor!

about
	"Private - Pop up a little helpful info. about this sample program."

	(MessageBox new)
		caption: 'About Dolphin Registry Editor';
		icon: self icon;
		text: ('Simple Registry Editor Sample. Copyright (c) Object Arts Ltd, 1998-2011.<n><1s><n>
This is a reduced functionality implementation of the standard system utility REGEDIT.EXE, intended to demonstrate various features of Dolphin''s application framework such as virtual tree models, and in-place label editing.<n> 
DISCLAIMER: This software is freely provided purely as an educational sample and as such it is provided "as is", WITHOUT ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. Furthermore, as with the real registry editor extreme care and expert knowledge are required to avoid damaging the installation of the operating system or other software on your machine if any modifications to the registry are attempted. Please take care - we accept no responsibility for any damage to your computer''s configuration which may be caused by the use of this sample.' 
					expandMacrosWith: VMLibrary default fullVersion);
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
	"Assume its a byte array"
	anObject isEmpty ifTrue: [^'(zero-length binary value)'].
	n := anObject size.
	max := 64 min: n.
	s := String writeStream: (max + 1) * 3.
	s locale: Locale invariant.
	(1 to: max) do: [:i | s nextPutAll: ('%02x' sprintfWith: (anObject basicAt: i))]
		separatedBy: [s space].
	max < n ifTrue: [s nextPutAll: '...'].
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

	^RegKey icon!

onPreStripImage
	"Private - The image is about to be stripped. Nil any lazily initialized class variables."

	!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 ##(Graphics.Color) #default nil 39 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil 410 ##(UI.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 640 nil 480 nil 7 nil nil nil 640 nil 8 1857562352 170 192 34 2 1050374 ##(UI.StatusBarItem) 1 -1 640 nil 786950 ##(Core.Message) #fullPath 8 #() nil nil 8 'key name' 34 1 768 1311750 ##(UI.StatusBarNullItem) 513 1 640 nil nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 1 631 578 1349 43 640 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 59 1 0 0 162 2 0 0 80 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1120 nil 480 nil 7 nil nil nil 1120 1376774 ##(UI.ProportionalLayout) 170 176 34 4 410 ##(UI.ListView) 34 45 nil 1120 34 2 8 1140955717 1025 1248 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) 480 nil 7 461638 4 ##(UI.Menu) nil true 34 4 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #modifySelectedValue 8 'Modify' 1 5 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 1458 1 1490 #deleteSelectedValue 8 '&Delete' 1 1 nil nil nil 1458 1 1490 #renameSelectedValue 8 '&Rename' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1248 nil 8 1857839872 ##(UI.BasicListAbstract) 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:o | (RegEdit iconFor: o value) imageIndex]' 8 #[32 105 45 17 142 177 160 106] 1049094 ##(Core.Association) #'UI.Examples.RegEdit' ##(UI.Examples.RegEdit) #iconFor: #imageIndex 1712 7 257 nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 2 1117254 5 ##(UI.ListViewColumn) 8 'Name' 451 #left 1698 0 nil 1730 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | x isEmpty ifTrue: [''(Default)''] ifFalse: [x displayString]]' 8 #[32 105 17 158 119 30 106 17 160 106] #isEmpty 8 '(Default)' #displayString 1952 7 257 nil 1698 0 nil 1730 1 83886081 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a :b | a <= b]' 8 #[29 105 233 1 130 106] 2048 7 513 nil 786 #key 8 #() nil 1248 1904 1 nil nil 1906 8 'Data' 601 #left 1698 0 nil 1730 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:v | RegEdit displayStringForValue: v]' 8 #[31 105 45 17 177 106] 1824 #displayStringForValue: 2192 7 257 nil 1698 0 nil 1730 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a :b | a displayString <= b displayString]' 8 #[30 105 17 158 18 158 130 106] #displayString 2272 7 513 nil 786 #value 8 #() nil 1248 1904 1 nil nil #report 8 #() nil 131073 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 578 457 1 578 893 631 1248 962 #contextMenu: 34 1 1424 1248 962 #text: 34 1 8 'Name' 1248 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 228 0 0 0 0 0 0 0 162 2 0 0 59 1 0 0] 8 #() 1104 nil 35 5 410 ##(UI.Splitter) 34 12 nil 1120 34 2 8 1140850688 1 2640 nil 480 nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 2640 nil 1 #left nil nil nil 578 1 1 578 9 9 nil 2736 nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 447 1 578 11 631 2640 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 223 0 0 0 0 0 0 0 228 0 0 0 59 1 0 0] 8 #() 1104 nil 27 1 false 170 192 34 4 410 ##(UI.TreeView) 34 27 nil 1120 34 2 8 1140916743 1025 2960 787526 3 ##(UI.TreeModel) nil 1392 721670 ##(UI.TreeNode) nil nil nil 170 192 1360 480 nil 7 1410 nil true 34 11 1458 1 1490 #expandSelection 8 'Expand/Collapse' 1 1 nil nil nil 1410 nil true 34 5 1458 1 1490 #newKey 8 '&Key' 1 5 nil nil nil 1538 4097 1458 1 1490 #newStringValue 8 '&String Value' 1 1 nil nil nil 1458 1 1490 #newBinaryValue 8 '&Binary Value' 1 1 nil nil nil 1458 1 1490 #newDWORDValue 8 '&DWORD Value' 1 1 nil nil nil 8 '&New' nil 1 nil nil nil nil nil 1458 1 1490 #findItem 8 '&Find...' 1 5 nil nil nil 1538 4097 1458 1 1490 #deleteSelectedKey 8 '&Delete' 1 1 nil nil nil 1458 1 1490 #renameSelectedKey 8 '&Rename' 1 1 nil nil nil 1538 4097 1458 1 1490 #exportRegistryFile 8 '&Export' 1 1 nil nil nil 1458 1 1490 #permissions 8 '&Permissions...' 1 1 nil nil nil 1538 4097 1458 1 1490 #copyKeyName 8 '&Copy Key Name' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2960 nil 8 1857683408 786 #name 8 #() 1698 0 nil 1730 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:k | RegEdit keyIcon imageIndex]' 8 #[32 105 45 159 160 106] 1824 #keyIcon #imageIndex 3840 7 257 nil 1856 nil nil nil nil nil 170 176 1360 9 #smallIcons 1 170 192 1360 898 138 144 34 2 962 #createAt:extent: 34 2 578 1 1 578 447 631 2960 962 #contextMenu: 34 1 3104 2960 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 223 0 0 0 59 1 0 0] 8 #() 1104 nil 27 8 'keys' 1248 8 'values' nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 1 1 578 1349 631 1120 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 162 2 0 0 59 1 0 0] 34 3 2960 2640 1248 1104 nil 27 170 192 34 2 640 8 'status' nil 658246 4 ##(UI.MenuBar) nil true 34 4 1410 nil true 34 12 1458 1 1490 #importRegistryFile 8 'Import...' 1 1 nil nil nil 1458 1 1490 #exportRegistryFile 8 '&Export...' 1 1 nil nil nil 1538 4097 1458 1 1490 #loadHive 8 '&Load Hive' 1 1 nil nil nil 1458 1 1490 #unloadHive 8 '&Unload Hive' 1 1 nil nil nil 1538 4097 1458 1 1490 #connectNetworkRegistry 8 '&Connect Network Registry' 1 1 nil nil nil 1458 1 1490 #disconnectNetworkRegistry 8 '&Disconnect Network Registry' 1 1 nil nil nil 1538 4097 1458 1 1490 #print 8 '&Print' 8353 1 nil nil nil 1538 4097 1458 1 1490 #exit 8 'E&xit' 1 1 nil nil nil 8 '&Registry' nil 1 nil nil 27219 nil nil 1410 nil true 34 11 1410 nil true 34 7 1458 1 1490 #newKey 8 '&Key' 1 1 nil nil nil 1538 4097 1458 1 1490 #newStringValue 8 '&String Value' 1 1 nil nil nil 1458 1 1490 #newBinaryValue 8 '&Binary Value' 1 1 nil nil nil 1458 1 1490 #newDWORDValue 8 '&DWORD Value' 1 1 nil nil nil 1458 1 1490 #newMultiStringValue 8 '&Multi-String Value' 1 1 nil nil nil 1458 1 1490 #newExpandableStringValue 8 '&Expandable String Value' 1 1 nil nil nil 8 '&New' nil 1 nil nil 27233 nil nil 1538 4097 1458 1 1490 #permissions 8 '&Permissions...' 1 1 nil nil nil 1538 4097 1458 1 1490 #delete 8 '&Delete' 605 1 nil nil nil 1458 1 1490 #rename 8 '&Rename' 1 1 nil nil nil 1538 4097 1458 1 1490 #copyKeyName 8 '&Copy Key Name' 1 1 nil nil nil 1538 4097 1458 1 1490 #find 8 '&Find...' 8333 1 nil nil nil 1458 1 1490 #findNext 8 'Find Ne&xt' 229 1 nil nil nil 8 '&Edit' nil 1 nil nil 27247 nil nil 1410 nil true 34 8 1458 1 1490 #toggleStatusBar 8 '&Status Bar' 1 1 nil nil nil 1538 4097 1458 1 1490 #viewSplit 8 'Sp&lit' 1 1 nil nil nil 1538 4097 1458 1 1490 #viewDisplayBinary 8 '&Display Binary Data' 1 1 nil nil nil 1538 4097 1458 1 1490 #refresh 8 '&Refresh' 233 1 nil nil nil 1458 1 1490 #chooseFont 8 '&Font' 1 1 nil nil nil 8 '&View' nil 1 nil nil 27259 nil nil 1410 nil true 34 1 1458 1 1490 #aboutRegistryEditor 8 '&About Registry Editor' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 27263 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 6143 21 578 1381 791 416 962 #text: 34 1 8 'Dolphin Registry Editor' 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 177 14 0 0 149 1 0 0] 34 2 1120 640 1104 nil 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true!

stringIcon
	"Answers an Icon that can be used to string values."

	^RegKeyValues icon! !
!UI.Examples.RegEdit class categoriesFor: #about!enquiries!private! !
!UI.Examples.RegEdit class categoriesFor: #binaryIcon!constants!public! !
!UI.Examples.RegEdit class categoriesFor: #displayOn:!displaying!public! !
!UI.Examples.RegEdit class categoriesFor: #displayStringForValue:!displaying!private! !
!UI.Examples.RegEdit class categoriesFor: #icon!constants!public! !
!UI.Examples.RegEdit class categoriesFor: #iconFor:!constants!displaying!private! !
!UI.Examples.RegEdit class categoriesFor: #initialize!development!initializing!private! !
!UI.Examples.RegEdit class categoriesFor: #keyIcon!constants!public! !
!UI.Examples.RegEdit class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!UI.Examples.RegEdit class categoriesFor: #resource_Default_view!public!resources-views! !
!UI.Examples.RegEdit class categoriesFor: #shutdownOnExit!public!testing! !
!UI.Examples.RegEdit class categoriesFor: #stringIcon!constants!public! !

