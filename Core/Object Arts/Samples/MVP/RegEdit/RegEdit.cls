"Filed out from Dolphin Smalltalk 7"!

Shell subclass: #RegEdit
	instanceVariableNames: 'keyPresenter valuesPresenter statusModel'
	classVariableNames: 'ResourceLib'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RegEdit guid: (GUID fromString: '{87b4c69e-026e-11d3-9fd7-00a0cc3e4a32}')!
RegEdit comment: 'RegEdit is a <topShell> sample application which implements most of the functionality of the Windows utility, RegEdit. It does not implement the full functionality of the standard tool because it is primarily intended as a demonstration of the use of registry access classes, and the tree and enhanced list views. It supports in-place registry key name editing.

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
!RegEdit categoriesForClass!MVP-Presenters!Samples! !
!RegEdit methodsFor!

aboutRegistryEditor
	"Private - Pop up a little helpful info. about this sample program."

	self class about!

additionalAccelerators
	^#(#(#renameIt 'F2'))!

copyKeyName
	"Private - Copy the full path name of the currently selected key to the clipboard."

	self selectedKey fullPath copyToClipboard!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	keyPresenter := self add: (TreePresenter on: RegTreeModel new)  name: 'keys'.
	valuesPresenter := self add: ListPresenter new name: 'values'.!

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
	^(1 to: strings size by: 2) 
		collect: [:i | Array with: (strings at: i) with: (strings at: i + 1)]!

helpTopics
	"Private - Pop up the registry editor help"

	ShellLibrary default 
		shellOpen: 'regedit.hlp' 
		directory: (File composePath: SessionManager current windowsDirectory subPath: 'help')!

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

	#toggleStatusBar == command ifTrue: [
		query isEnabled: false; isChecked: true.
		^true].

	selKey := self selectedKey.
	(#(newKey newStringValue newDWORDValue newBinaryValue 
			exportRegistryFile copyKeyName) includes: command) ifTrue: [
		query isEnabled: selKey notNil. 
		^true].

	"Modification of the root keys is not permitted."
	(#(deleteSelectedKey renameSelectedKey) includes: command) ifTrue: [
		query isEnabled: (selKey notNil and: [selKey isRoot not]). 
		^true].

	selVal := self selectedValue.

	#renameSelectedValue == command ifTrue: [
		query isEnabled: (selVal notNil and: [selVal key notEmpty]). 
		^true].

	#deleteSelectedValue == command ifTrue: [
		query isEnabled: selVal notNil.
		^true].

	(#(delete rename) includes: query command) ifTrue: [
		keyPresenter view hasFocus ifTrue: [
			query isEnabled: (selKey notNil and: [selKey isRoot not]). 
			^true].
		valuesPresenter view hasFocus ifTrue: [
			query isEnabled: (selVal notNil and: [selVal key notEmpty]). 
			^true]].

	^super queryCommand: query.
!

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

	^valuesPresenter selectionOrNil! !
!RegEdit categoriesFor: #aboutRegistryEditor!commands!private! !
!RegEdit categoriesFor: #additionalAccelerators!constants!private! !
!RegEdit categoriesFor: #copyKeyName!commands!private! !
!RegEdit categoriesFor: #createComponents!initializing!public! !
!RegEdit categoriesFor: #createSchematicWiring!initializing!public! !
!RegEdit categoriesFor: #delete!commands!private! !
!RegEdit categoriesFor: #deleteSelectedKey!commands!private! !
!RegEdit categoriesFor: #deleteSelectedValue!commands!private! !
!RegEdit categoriesFor: #exportKey:toFile:!filing!private! !
!RegEdit categoriesFor: #exportRegistryFile!commands!private! !
!RegEdit categoriesFor: #fileTypes!constants!private! !
!RegEdit categoriesFor: #helpTopics!commands!private! !
!RegEdit categoriesFor: #importRegistryFile!commands!private! !
!RegEdit categoriesFor: #initialize!initializing!private! !
!RegEdit categoriesFor: #newBinaryValue!commands!public! !
!RegEdit categoriesFor: #newDWORDValue!commands!public! !
!RegEdit categoriesFor: #newKey!commands!public! !
!RegEdit categoriesFor: #newStringValue!commands!public! !
!RegEdit categoriesFor: #newValue:!commands!public! !
!RegEdit categoriesFor: #newValueName!commands!private! !
!RegEdit categoriesFor: #onAboutToRenameKey:accept:!event handling!public! !
!RegEdit categoriesFor: #onAboutToRenameValue:accept:!event handling!public! !
!RegEdit categoriesFor: #onKey:renamedTo:accept:!event handling!public! !
!RegEdit categoriesFor: #onKeySelected!event handling!private! !
!RegEdit categoriesFor: #onValue:renamedTo:accept:!event handling!public! !
!RegEdit categoriesFor: #onViewOpened!event handling!public! !
!RegEdit categoriesFor: #queryCommand:!commands!private! !
!RegEdit categoriesFor: #rename!commands!private! !
!RegEdit categoriesFor: #renameSelectedKey!commands!private! !
!RegEdit categoriesFor: #renameSelectedValue!commands!private! !
!RegEdit categoriesFor: #resourceLib!constants!public! !
!RegEdit categoriesFor: #selectedKey!accessing!public! !
!RegEdit categoriesFor: #selectedValue!accessing!public! !

!RegEdit class methodsFor!

about
	"Private - Pop up a little helpful info. about this sample program."

	(MessageBox new)
		caption: 'About Dolphin Registry Editor';
		text: ('Simple Registry Editor Sample. Copyright (c) Object Arts Ltd, 1998-2011.<n><1s><n>
This is a reduced functionality implementation of the standard system utility REGEDIT.EXE, intended to demonstrate various features of Dolphin''s application framework such as virtual tree models, and in-place label editing.<n> 
DISCLAIMER: This software is freely provided purely as an educational sample and as such it is provided "as is", WITHOUT ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. Furthermore, as with the real registry editor extreme care and expert knowledge are required to avoid damaging the installation of the operating system or other software on your machine if any modifications to the registry are attempted. Please take care - we accept no responsibility for any damage to your computer''s configuration which may be caused by the use of this sample.' 
					expandMacrosWith: VMLibrary default fullVersion);
		open!

binaryIcon
	"Answers an Icon that can be used to represent binary values."

	^Icon fromId: 'RegValueBin.ico'!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Registry Editor'!

displayStringForValue: anObject 
	"Private - Answer an appropriate registry editor display string for the argument, anObject.
	Not clean, but we don't want to add these as polymorphic operations into the types
	of object in the registry.
	This method also illustrates the use of the C-runtime library function sprintf() for
	fast string formatting."

	| s n max |
	anObject isNil 
		ifTrue: 
			[^'(value not set)'].
	anObject isInteger ifTrue: [^'0x%08x (%u)' sprintfWith: anObject with: anObject].
	(anObject isKindOf: String) ifTrue: [^'"' , anObject , '"'].
	"Assume its a byte array"
	anObject isEmpty 
		ifTrue: 
			[^'(zero-length binary value)'].
	n := anObject size.
	max := 64 min: n.
	s := String writeStream: (max + 1) * 3.
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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 39 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.StatusBar)  98 18 0 416 98 2 8 1140850956 1 672 0 482 512 0 7 0 0 0 672 0 8 4294909639 234 256 98 2 853766 ##(Smalltalk.StatusBarItem)  1 -1 672 0 459270 ##(Smalltalk.Message)  8 #fullPath 98 0 0 1049926 1 ##(Smalltalk.IconImageManager)  8 'key name' 98 1 832 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 672 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 610 1 633 610 1349 43 672 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 1 0 0 162 2 0 0 81 1 0 0] 98 0 610 193 193 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 1248 0 482 512 0 7 0 0 0 1248 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 4 410 8 ##(Smalltalk.ListView)  98 30 0 1248 98 2 8 1140955717 1025 1408 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 512 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #modifySelectedValue 8 'Modify' 1 5 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 1650 1 1682 8 #deleteSelectedValue 8 '&Delete' 1 1 0 0 0 1650 1 1682 8 #renameSelectedValue 8 '&Rename' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 1408 0 8 4294912849 8 ##(Smalltalk.BasicListAbstract)  787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  4 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:o | (RegEdit iconFor: o value) imageIndex]' 8 #[32 105 45 17 142 177 160 106] 721414 ##(Smalltalk.Association)  8 #RegEdit 8 ##(Smalltalk.RegEdit)  8 #iconFor: 8 #imageIndex 1968 7 257 0 928 0 0 0 0 0 0 202 208 98 2 920646 5 ##(Smalltalk.ListViewColumn)  8 'Name' 451 8 #left 1954 0 0 1986 4 1 2016 8 'doIt' 8 '[:x | x isEmpty ifTrue: [''(Default)''] ifFalse: [x displayString]]' 8 #[32 105 17 158 119 30 106 17 160 106] 8 #isEmpty 8 '(Default)' 8 #displayString 2272 7 257 0 1954 0 0 1986 1 83886081 2016 8 'doIt' 8 '[:a :b | a <= b]' 8 #[29 105 233 1 130 106] 2400 7 513 0 850 8 #key 98 0 0 1408 2208 1 0 0 2210 8 'Data' 601 2256 1954 0 0 1986 3 1 2016 8 'doIt' 8 '[:v | RegEdit displayStringForValue: v]' 8 #[31 105 45 17 177 106] 2096 8 #displayStringForValue: 2560 7 257 0 1954 0 0 1986 2 1 2016 8 'doIt' 8 '[:a :b | a displayString <= b displayString]' 8 #[30 105 17 158 18 158 130 106] 2384 2656 7 513 0 850 8 #value 98 0 0 1408 2208 1 0 0 8 #report 1536 0 131073 0 0 1010 202 208 98 3 1074 1104 98 2 610 461 1 610 889 633 1408 1074 8 #contextMenu: 98 1 1616 1408 1074 8 #text: 98 1 8 'Name' 1408 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 230 0 0 0 0 0 0 0 162 2 0 0 60 1 0 0] 98 0 1232 0 27 5 410 8 ##(Smalltalk.Splitter)  98 12 0 1248 98 2 8 1140850688 1 3072 0 482 512 0 519 0 0 0 3072 1010 202 208 98 1 1074 1104 98 2 610 443 1 610 19 633 3072 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 0 0 0 0 0 0 0 230 0 0 0 60 1 0 0] 98 0 1232 0 27 1 32 234 256 98 4 1408 8 'values' 410 8 ##(Smalltalk.TreeView)  98 27 0 1248 98 2 8 1140916743 1025 3376 590918 3 ##(Smalltalk.TreeModel)  0 1568 525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 1536 482 512 0 7 1602 0 16 98 11 1650 1 1682 8 #expandSelection 8 'Expand/Collapse' 1 1 0 0 0 1602 0 16 98 5 1650 1 1682 8 #newKey 8 '&Key' 1 5 0 0 0 1746 4097 1650 1 1682 8 #newStringValue 8 '&String Value' 1 1 0 0 0 1650 1 1682 8 #newBinaryValue 8 '&Binary Value' 1 1 0 0 0 1650 1 1682 8 #newDWORDValue 8 '&DWORD Value' 1 1 0 0 0 8 '&New' 0 1 0 0 0 0 0 1650 1 1682 8 #findItem 8 '&Find...' 1 5 0 0 0 1746 4097 1650 1 1682 8 #deleteSelectedKey 8 '&Delete' 1 1 0 0 0 1650 1 1682 8 #renameSelectedKey 8 '&Rename' 1 1 0 0 0 1746 4097 1650 1 1682 8 #exportRegistryFile 8 '&Export' 1 1 0 0 0 1650 1 1682 8 #permissions 8 '&Permissions...' 1 1 0 0 0 1746 4097 1650 1 1682 8 #copyKeyName 8 '&Copy Key Name' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 3376 0 8 4294909825 850 8 #name 98 0 1954 0 0 1986 4 1 2016 8 'doIt' 8 '[:k | RegEdit keyIcon imageIndex]' 8 #[32 105 45 159 160 106] 2096 8 #keyIcon 2160 4480 7 257 0 928 0 0 0 0 0 234 240 1536 9 8 #smallIcons 1 0 1010 202 208 98 2 1074 1104 98 2 610 1 1 610 443 633 3376 1074 2928 98 1 3552 3376 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 221 0 0 0 60 1 0 0] 98 0 1232 0 27 8 'keys' 0 1010 202 208 98 1 1074 1104 98 2 610 1 1 610 1349 633 1248 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 162 2 0 0 60 1 0 0] 98 3 3376 3072 1408 1232 0 27 234 256 1536 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 4 1602 0 16 98 12 1650 1 1682 8 #importRegistryFile 8 'Import...' 1 1 0 0 0 1650 1 1682 4224 8 '&Export...' 1 1 0 0 0 1746 4097 1650 1 1682 8 #loadHive 8 '&Load Hive' 1 1 0 0 0 1650 1 1682 8 #unloadHive 8 '&Unload Hive' 1 1 0 0 0 1746 4097 1650 1 1682 8 #connectNetworkRegistry 8 '&Connect Network Registry' 1 1 0 0 0 1650 1 1682 8 #disconnectNetworkRegistry 8 '&Disconnect Network Registry' 1 1 0 0 0 1746 4097 1650 1 1682 8 #print 8 '&Print' 8353 1 0 0 0 1746 4097 1650 1 1682 8 #exit 8 'E&xit' 1 1 0 0 0 8 '&Registry' 0 1 0 0 13287 0 0 1602 0 16 98 11 1602 0 16 98 7 1650 1 1682 3712 8 '&Key' 1 1 0 0 0 1746 4097 1650 1 1682 3792 8 '&String Value' 1 1 0 0 0 1650 1 1682 3856 8 '&Binary Value' 1 1 0 0 0 1650 1 1682 3920 8 '&DWORD Value' 1 1 0 0 0 1650 1 1682 8 #newMultiStringValue 8 '&Multi-String Value' 1 1 0 0 0 1650 1 1682 8 #newExpandableStringValue 8 '&Expandable String Value' 1 1 0 0 0 8 '&New' 0 1 0 0 13301 0 0 5328 1650 1 1682 4288 8 '&Permissions...' 1 1 0 0 0 5328 1650 1 1682 8 #delete 8 '&Delete' 605 1 0 0 0 1650 1 1682 8 #rename 8 '&Rename' 1 1 0 0 0 1746 4097 1650 1 1682 4368 8 '&Copy Key Name' 1 1 0 0 0 1746 4097 1650 1 1682 8 #find 8 '&Find...' 8333 1 0 0 0 1650 1 1682 8 #findNext 8 'Find Ne&xt' 229 1 0 0 0 8 '&Edit' 0 1 0 0 13315 0 0 1602 0 16 98 7 1650 1 1682 8 #toggleStatusBar 8 '&Status Bar' 1 1 0 0 0 1746 4097 1650 1 1682 8 #viewSplit 8 'Sp&lit' 1 1 0 0 0 5328 1650 1 1682 8 #viewDisplayBinary 8 '&Display Binary Data' 1 1 0 0 0 1746 4097 1650 1 1682 8 #refresh 8 '&Refresh' 233 1 0 0 0 8 '&View' 0 1 0 0 13325 0 0 1602 0 16 98 2 1650 1 1682 8 #helpTopics 8 '&Help Topics' 1 1 0 0 0 1650 1 1682 8 #aboutRegistryEditor 8 '&About Registry Editor' 1 1 0 0 0 8 '&Help' 0 1 0 0 13331 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1010 202 208 98 3 1074 1104 98 2 610 3359 21 610 1381 791 416 1074 2976 98 1 8 'Dolphin Registry Editor' 416 1074 8 #updateMenuBar 1536 416 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 65 9 0 0 149 1 0 0] 98 2 1248 672 1232 0 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true!

stringIcon
	"Answers an Icon that can be used to string values."

	^RegKeyValues icon!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system.
		self uninitialize
	"

	Smalltalk developmentSystem removeSystemFolderIconNamed: self displayString! !
!RegEdit class categoriesFor: #about!enquiries!private! !
!RegEdit class categoriesFor: #binaryIcon!constants!public! !
!RegEdit class categoriesFor: #displayOn:!displaying!public! !
!RegEdit class categoriesFor: #displayStringForValue:!displaying!private! !
!RegEdit class categoriesFor: #icon!constants!public! !
!RegEdit class categoriesFor: #iconFor:!constants!displaying!private! !
!RegEdit class categoriesFor: #initialize!development!initializing!private! !
!RegEdit class categoriesFor: #keyIcon!constants!public! !
!RegEdit class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!RegEdit class categoriesFor: #resource_Default_view!public!resources-views! !
!RegEdit class categoriesFor: #shutdownOnExit!public!testing! !
!RegEdit class categoriesFor: #stringIcon!constants!public! !
!RegEdit class categoriesFor: #uninitialize!development!initializing!private! !

