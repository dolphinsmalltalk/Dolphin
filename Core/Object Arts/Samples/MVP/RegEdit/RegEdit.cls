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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 656 nil 480 nil 5 nil nil nil 656 nil 8 1914952576 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 656 nil 459270 ##(Smalltalk.Message) #fullPath 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) 8 'key name' 34 1 784 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 656 nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 594 1 633 594 1349 43 656 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 60 1 0 0 162 2 0 0 81 1 0 0] 8 #() 594 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 1168 nil 480 nil 5 nil nil nil 1168 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.Splitter) 34 12 nil 1168 34 2 8 1140850688 1 1296 nil 480 nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 1296 nil 1 #left nil nil nil 594 1 1 594 9 9 nil 1392 nil 946 138 144 34 1 1010 #createAt:extent: 34 2 594 443 1 594 19 633 1296 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 0 0 0 0 0 0 0 230 0 0 0 60 1 0 0] 8 #() 1152 nil 27 1 410 ##(Smalltalk.ListView) 34 30 nil 1168 34 2 8 1140955717 1025 1584 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 480 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #modifySelectedValue 8 'Modify' 1 5 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1794 1 1826 #deleteSelectedValue 8 '&Delete' 1 1 nil nil nil 1794 1 1826 #renameSelectedValue 8 '&Rename' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1584 nil 8 1915211424 ##(Smalltalk.BasicListAbstract) 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:o | (RegEdit iconFor: o value) imageIndex]' 8 #[32 105 45 17 142 177 160 106] 721414 ##(Smalltalk.Association) #RegEdit ##(Smalltalk.RegEdit) #iconFor: #imageIndex 2048 7 257 nil 864 nil nil nil nil nil nil 138 144 34 2 920646 5 ##(Smalltalk.ListViewColumn) 8 'Name' 451 #left 2034 0 nil 2066 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x isEmpty ifTrue: [''(Default)''] ifFalse: [x displayString]]' 8 #[32 105 17 158 119 30 106 17 160 106] #isEmpty 8 '(Default)' #displayString 2256 7 257 nil 2034 0 nil 2066 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a <= b]' 8 #[29 105 233 1 130 106] 2352 7 513 nil 802 #key 8 #() nil 1584 2208 1 nil nil 2210 8 'Data' 601 #left 2034 0 nil 2066 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:v | RegEdit displayStringForValue: v]' 8 #[31 105 45 17 177 106] 2160 #displayStringForValue: 2496 7 257 nil 2034 0 nil 2066 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a displayString <= b displayString]' 8 #[30 105 17 158 18 158 130 106] #displayString 2576 7 513 nil 802 #value 8 #() nil 1584 2208 1 nil nil #report 1696 nil 131073 nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 594 461 1 594 889 633 1584 1010 #contextMenu: 34 1 1760 1584 1010 #text: 34 1 8 'Name' 1584 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 230 0 0 0 0 0 0 0 162 2 0 0 60 1 0 0] 8 #() 1152 nil 27 5 false 170 192 34 4 1584 8 'values' 410 ##(Smalltalk.TreeView) 34 27 nil 1168 34 2 8 1140916743 1025 2976 590918 3 ##(Smalltalk.TreeModel) nil 1728 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 1696 480 nil 5 1746 nil true 34 11 1794 1 1826 #expandSelection 8 'Expand/Collapse' 1 1 nil nil nil 1746 nil true 34 5 1794 1 1826 #newKey 8 '&Key' 1 5 nil nil nil 1874 4097 1794 1 1826 #newStringValue 8 '&String Value' 1 1 nil nil nil 1794 1 1826 #newBinaryValue 8 '&Binary Value' 1 1 nil nil nil 1794 1 1826 #newDWORDValue 8 '&DWORD Value' 1 1 nil nil nil 8 '&New' nil 1 nil nil nil nil nil 1794 1 1826 #findItem 8 '&Find...' 1 5 nil nil nil 1874 4097 1794 1 1826 #deleteSelectedKey 8 '&Delete' 1 1 nil nil nil 1794 1 1826 #renameSelectedKey 8 '&Rename' 1 1 nil nil nil 1874 4097 1794 1 1826 #exportRegistryFile 8 '&Export' 1 1 nil nil nil 1794 1 1826 #permissions 8 '&Permissions...' 1 1 nil nil nil 1874 4097 1794 1 1826 #copyKeyName 8 '&Copy Key Name' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2976 nil 8 1914975136 802 #name 8 #() 2034 0 nil 2066 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:k | RegEdit keyIcon imageIndex]' 8 #[32 105 45 159 160 106] 2160 #keyIcon #imageIndex 3856 7 257 nil 864 nil nil nil nil nil 170 176 1696 9 #smallIcons 1 170 ##(Smalltalk.PluggableLookupTable) 1696 946 138 144 34 2 1010 #createAt:extent: 34 2 594 1 1 594 443 633 2976 1010 #contextMenu: 34 1 3120 2976 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 221 0 0 0 60 1 0 0] 8 #() 1152 nil 27 8 'keys' nil 946 138 144 34 1 1010 #createAt:extent: 34 2 594 1 1 594 1349 633 1168 1090 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 162 2 0 0 60 1 0 0] 34 3 2976 1296 1584 1152 nil 27 170 192 1696 nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 1746 nil true 34 12 1794 1 1826 #importRegistryFile 8 'Import...' 1 1 nil nil nil 1794 1 1826 #exportRegistryFile 8 '&Export...' 1 1 nil nil nil 1874 4097 1794 1 1826 #loadHive 8 '&Load Hive' 1 1 nil nil nil 1794 1 1826 #unloadHive 8 '&Unload Hive' 1 1 nil nil nil 1874 4097 1794 1 1826 #connectNetworkRegistry 8 '&Connect Network Registry' 1 1 nil nil nil 1794 1 1826 #disconnectNetworkRegistry 8 '&Disconnect Network Registry' 1 1 nil nil nil 1874 4097 1794 1 1826 #print 8 '&Print' 8353 1 nil nil nil 1874 4097 1794 1 1826 #exit 8 'E&xit' 1 1 nil nil nil 8 '&Registry' nil 1 nil nil 46737 nil nil 1746 nil true 34 11 1746 nil true 34 7 1794 1 1826 #newKey 8 '&Key' 1 1 nil nil nil 1874 4097 1794 1 1826 #newStringValue 8 '&String Value' 1 1 nil nil nil 1794 1 1826 #newBinaryValue 8 '&Binary Value' 1 1 nil nil nil 1794 1 1826 #newDWORDValue 8 '&DWORD Value' 1 1 nil nil nil 1794 1 1826 #newMultiStringValue 8 '&Multi-String Value' 1 1 nil nil nil 1794 1 1826 #newExpandableStringValue 8 '&Expandable String Value' 1 1 nil nil nil 8 '&New' nil 1 nil nil 46751 nil nil 4640 1794 1 1826 #permissions 8 '&Permissions...' 1 1 nil nil nil 4640 1794 1 1826 #delete 8 '&Delete' 605 1 nil nil nil 1794 1 1826 #rename 8 '&Rename' 1 1 nil nil nil 1874 4097 1794 1 1826 #copyKeyName 8 '&Copy Key Name' 1 1 nil nil nil 1874 4097 1794 1 1826 #find 8 '&Find...' 8333 1 nil nil nil 1794 1 1826 #findNext 8 'Find Ne&xt' 229 1 nil nil nil 8 '&Edit' nil 1 nil nil 46765 nil nil 1746 nil true 34 7 1794 1 1826 #toggleStatusBar 8 '&Status Bar' 1 1 nil nil nil 1874 4097 1794 1 1826 #viewSplit 8 'Sp&lit' 1 1 nil nil nil 4640 1794 1 1826 #viewDisplayBinary 8 '&Display Binary Data' 1 1 nil nil nil 1874 4097 1794 1 1826 #refresh 8 '&Refresh' 233 1 nil nil nil 8 '&View' nil 1 nil nil 46775 nil nil 1746 nil true 34 2 1794 1 1826 #helpTopics 8 '&Help Topics' 1 1 nil nil nil 1794 1 1826 #aboutRegistryEditor 8 '&About Registry Editor' 1 1 nil nil nil 8 '&Help' nil 1 nil nil 46781 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 594 417 417 594 1381 791 416 1010 #text: 34 1 8 'Dolphin Registry Editor' 416 1010 #updateMenuBar 1696 416 1090 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 208 0 0 0 208 0 0 0 130 3 0 0 91 2 0 0] 34 2 1168 656 1152 nil 27 )!

shutdownOnExit
	"Answer whether a runtime session should be shutdown when an instance of the receiver is closed."

	^true!

stringIcon
	"Answers an Icon that can be used to string values."

	^RegKeyValues icon! !
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

