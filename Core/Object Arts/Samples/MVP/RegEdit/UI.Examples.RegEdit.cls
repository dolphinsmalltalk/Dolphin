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

	<commandQuery: #hasKeySelected>
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

	<commandQuery: #queryDeleteCommand:>
	self perform: self deleteCommand!

deleteCommand
	"Private - Answer the context-sensitive Delete command, or nil if inactive."

	keyPresenter view hasFocus ifTrue: [^#deleteSelectedKey].
	valuesPresenter view hasFocus ifTrue: [^#deleteSelectedValue].
	^nil!

deleteSelectedKey
	"Private - Delete the selected registry key."

	<commandQuery: #hasWriteableNonRootKeySelected>
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

	<commandQuery: #hasValueOfWriteableKeySelected>
	| idx mb |
	idx := valuesPresenter selectionByIndex.
	idx == 0 ifTrue: [^self].
	mb := MessageBox new.
	mb
		text: 'Deleting certain registry values could cause system instability. Are you sure you want to permanently delete these values?'.
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

	<commandQuery: #hasKeySelected>
	| openFilename |
	openFilename := FileSaveDialog new
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

hasKeySelected
	^self selectedKey notNil!

hasRenameableValueSelected
	| selVal |
	selVal := self selectedValue.
	^selVal notNil and: [selVal key notEmpty and: [self hasWriteableKeySelected]]!

hasValueOfWriteableKeySelected
	^self hasWriteableKeySelected and: [self hasValueSelected]!

hasValueSelected
	^self selectedValue notNil!

hasWriteableKeySelected
	^self hasKeySelected and: [self selectedKey isWriteable]!

hasWriteableNonRootKeySelected
	^self hasWriteableKeySelected and: [self selectedKey isRoot not]!

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

	<commandQuery: #hasWriteableKeySelected>
	self newValue: ByteArray new!

newDWORDValue
	"Add a new, empty, string value under the currently selected key."

	<commandQuery: #hasWriteableKeySelected>
	self newValue: 0!

newKey
	"Add a new, empty, sub-key under the currently selected key, 
	and leave the receiver in key renaming mode."

	<commandQuery: #hasWriteableKeySelected>
	| i sel newKey |
	i := 1.
	sel := self selectedKey.
	"Generate a unique key name"
	
	[newKey := 'New Key #' , i displayString.
	sel includesKey: newKey] whileTrue: [i := i + 1].
	newKey := sel createKey: newKey.
	keyPresenter model add: newKey asChildOf: sel.
	(keyPresenter
		selection: newKey;
		view) editSelectionLabel!

newStringValue
	"Add a new, empty, string value under the currently selected key."

	<commandQuery: #hasWriteableKeySelected>
	self newValue: ''!

newValue: anObject
	"Private - Add a new, empty, value under the currently selected key
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

	Warning signal: 'Key renaming is not yet implemented, but if it were <1p> would be renamed to <2p>'
				<< { key name. text }.
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

queryDeleteCommand: aCommandQuery
	"Private - Query the context-sensitive Delete command."

	self deleteCommand ifNotNil: [:selector | self queryContextCommand: aCommandQuery as: selector]!

queryRenameCommand: aCommandQuery
	"Private - Query the context-sensitive Rename command."

	self renameCommand ifNotNil: [:selector | self queryContextCommand: aCommandQuery as: selector]!

queryToggleStatusBar: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: self statusBar isWindowVisible!

refresh
	| selection |
	selection := keyPresenter selectionOrNil.
	keyPresenter view refreshContents.
	keyPresenter selection: selection ifAbsent: []!

rename
	"Private - Initiate in-place label edit of the selected item."

	<acceleratorKey: 'F2'>
	<commandQuery: #queryRenameCommand:>
	self perform: self renameCommand!

renameCommand
	"Private - Answer the context-sensitive Rename command, or nil if inactive."

	keyPresenter view hasFocus ifTrue: [^#renameSelectedKey].
	valuesPresenter view hasFocus ifTrue: [^#renameSelectedValue].
	^nil!

renameSelectedKey
	"Private - Initiate in-place label edit of the selected key."

	<commandQuery: #hasWriteableNonRootKeySelected>
	keyPresenter view editSelectionLabel!

renameSelectedValue
	"Private - Initiate in-place label edit of the selected key."

	<commandQuery: #hasRenameableValueSelected>
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
	<commandQuery: #queryToggleStatusBar:>
	| statusBar |
	statusBar := self statusBar.
	statusBar isWindowVisible ifTrue: [statusBar hide] ifFalse: [statusBar show].
	self view invalidateLayout! !
!UI.Examples.RegEdit categoriesForMethods!
aboutRegistryEditor!commands-actions!private! !
chooseFont!commands-actions!private! !
copyKeyName!commands-actions!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
delete!commands-actions!private! !
deleteCommand!commands-mappings!private! !
deleteSelectedKey!commands-actions!private! !
deleteSelectedValue!commands-actions!private! !
exportKey:toFile:!filing!private! !
exportRegistryFile!commands-actions!private! !
fileTypes!constants!private! !
hasKeySelected!commands-queries!private!testing! !
hasRenameableValueSelected!commands-queries!private! !
hasValueOfWriteableKeySelected!commands-queries!private! !
hasValueSelected!commands-queries!private! !
hasWriteableKeySelected!commands-queries!private! !
hasWriteableNonRootKeySelected!commands-queries!private! !
importRegistryFile!commands-actions!private! !
initialize!initializing!private! !
newBinaryValue!commands-actions!public! !
newDWORDValue!commands-actions!public! !
newKey!commands-actions!public! !
newStringValue!commands-actions!public! !
newValue:!helpers!private! !
newValueName!helpers!private! !
onAboutToRenameKey:accept:!event handling!public! !
onAboutToRenameValue:accept:!event handling!public! !
onKey:renamedTo:accept:!event handling!public! !
onKeySelected!event handling!private! !
onValue:renamedTo:accept:!event handling!public! !
onViewOpened!event handling!public! !
queryDeleteCommand:!commands-queries!private! !
queryRenameCommand:!commands-queries!private! !
queryToggleStatusBar:!commands-queries!private! !
refresh!commands-actions!private! !
rename!commands-actions!private! !
renameCommand!commands-mappings!private! !
renameSelectedKey!commands-actions!private! !
renameSelectedValue!commands-actions!private! !
resourceLib!constants!public! !
selectedKey!accessing!public! !
selectedValue!accessing!public! !
statusBar!accessing!private! !
toggleStatusBar!commands-actions!private! !
!

!UI.Examples.RegEdit class methodsFor!

about
	"Private - Pop up a little helpful info. about this sample program."

	MessageBox new
		caption: 'About Dolphin Registry Editor';
		icon: self icon;
		headline: 'Simple Registry Editor Sample.';
		text: 'Copyright © Object Arts Ltd, 1998-2023.<n><1s>' << VM fullVersion;
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default nil 5 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140850956 1 272 nil 112 nil 5 nil nil nil 272 nil nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 1862 1 #{UI.StatusBarItem} 8193 -1 272 nil 518 #{Core.Message} #fullPath 8 #() nil nil 8 'key name' nil nil nil 50 1 400 1094 1 #{UI.StatusBarNullItem} 8705 1 272 nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 1 631 210 1349 43 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 59 1 0 0 162 2 0 0 80 1 0 0] 8 #() 210 193 193 nil 29 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 736 nil 112 nil 5 nil nil nil 736 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.LookupTable} 50 2 518 #{Core.Association} 18 #{UI.Splitter} 50 12 nil 736 50 2 8 1140850688 1 912 nil 112 nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 912 nil 1 #left nil nil nil 210 1 1 210 9 9 nil 1008 nil 530 50 1 578 #createAt:extent: 50 2 210 447 1 210 11 631 912 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 223 0 0 0 0 0 0 0 228 0 0 0 59 1 0 0] 8 #() 720 nil 27 1 882 18 #{UI.ListView} 50 45 nil 736 50 2 8 1140955717 1025 1200 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 112 nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #modifySelectedValue 8 'Modify' 1 5 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1410 1 1442 #deleteSelectedValue 8 '&Delete' 1 1 nil nil nil 1410 1 1442 #renameSelectedValue 8 '&Rename' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1200 nil nil 418 #displayString 8 #() 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 4 1 1664 8 'doIt' 8 '[:o | (UI.Examples.RegEdit iconFor: o value) imageIndex]' 8 #[32 105 45 17 142 177 160 106] 1094 2 #{Kernel.VariableBinding} #RegEdit #{UI.Examples.RegEdit} #{UI.Examples} 1 #iconFor: #imageIndex 1680 7 257 nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 1298 2 3142 5 #{UI.ListViewColumn} 8 'Name' 451 #left 1666 0 nil 1698 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x isEmpty ifTrue: [''(Default)''] ifFalse: [x displayString]]' 8 #[32 105 17 158 119 30 106 17 160 106] #isEmpty 8 '(Default)' #displayString 1904 7 257 nil 1666 0 nil 1698 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a <= b]' 8 #[29 105 233 1 130 106] 2000 7 513 nil 418 #key 8 #() nil 1200 418 #iconImageIndex 8 #() 1 nil nil 1858 8 'Data' 601 #left 1666 0 nil 1698 3 1 1664 8 'doIt' 8 '[:v | UI.Examples.RegEdit displayStringForValue: v]' 8 #[31 105 45 17 177 106] 1792 #displayStringForValue: 2176 7 257 nil 1666 0 nil 1698 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a displayString <= b displayString]' 8 #[30 105 17 158 18 158 130 106] #displayString 2256 7 513 nil 418 #value 8 #() nil 1200 418 #iconImageIndex 1648 1 nil nil #report 8 #() nil 131073 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 530 50 2 578 #createAt:extent: 50 2 210 457 1 210 893 631 1200 578 #text: 50 1 8 'Name' 1200 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 228 0 0 0 0 0 0 0 162 2 0 0 59 1 0 0] 8 #() 720 nil 35 5 false 338 #{Core.IdentityDictionary} 50 4 18 #{UI.TreeView} 50 27 nil 736 50 2 8 1140916743 1025 2624 1094 3 #{UI.TreeModel} nil 1344 774 #{UI.TreeNode} nil nil nil 550 #{Core.IdentityDictionary} 0 112 nil 5 1362 nil true 50 11 1410 1 1442 #expandSelection 8 'Expand/Collapse' 1 1 nil nil nil 1362 nil true 50 5 1410 1 1442 #newKey 8 '&Key' 1 5 nil nil nil 1490 4097 1410 1 1442 #newStringValue 8 '&String Value' 1 1 nil nil nil 1410 1 1442 #newBinaryValue 8 '&Binary Value' 1 1 nil nil nil 1410 1 1442 #newDWORDValue 8 '&DWORD Value' 1 1 nil nil nil 8 '&New' nil 1 nil nil nil nil nil 1410 1 1442 #findItem 8 '&Find…' 1 5 nil nil nil 1490 4097 1410 1 1442 #deleteSelectedKey 8 '&Delete' 1 1 nil nil nil 1410 1 1442 #renameSelectedKey 8 '&Rename' 1 1 nil nil nil 1490 4097 1410 1 1442 #exportRegistryFile 8 '&Export' 1 1 nil nil nil 1410 1 1442 #permissions 8 '&Permissions…' 1 1 nil nil nil 1490 4097 1410 1 1442 #copyKeyName 8 '&Copy Key Name' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 2624 nil nil 418 #name 8 #() 1666 0 nil 1698 4 1 1664 8 'doIt' 8 '[:k | UI.Examples.RegEdit keyIcon imageIndex]' 8 #[32 105 45 159 160 106] 1792 #keyIcon #imageIndex 3504 7 257 nil 1824 nil nil nil nil nil 550 #{Core.LookupTable} 0 9 #smallIcons 1 2754 0 530 50 1 578 #createAt:extent: 50 2 210 1 1 210 447 631 2624 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 223 0 0 0 59 1 0 0] 8 #() 720 nil 27 8 'keys' 1200 8 'values' nil 530 50 1 578 #createAt:extent: 50 2 210 1 1 210 1349 631 736 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 162 2 0 0 59 1 0 0] 50 3 2624 912 1200 720 nil 27 338 2752 50 2 272 8 'status' nil 2886 4 #{UI.MenuBar} nil true 50 4 1362 nil true 50 12 1410 1 1442 #importRegistryFile 8 'Import…' 1 1 nil nil nil 1410 1 1442 #exportRegistryFile 8 '&Export…' 1 1 nil nil nil 1490 4097 1410 1 1442 #loadHive 8 '&Load Hive' 1 1 nil nil nil 1410 1 1442 #unloadHive 8 '&Unload Hive' 1 1 nil nil nil 1490 4097 1410 1 1442 #connectNetworkRegistry 8 '&Connect Network Registry' 1 1 nil nil nil 1410 1 1442 #disconnectNetworkRegistry 8 '&Disconnect Network Registry' 1 1 nil nil nil 1490 4097 1410 1 1442 #print 8 '&Print' 8353 1 nil nil nil 1490 4097 1410 1 1442 #exit 8 'E&xit' 1 1 nil nil nil 8 '&Registry' nil 1 nil nil nil nil nil 1362 nil true 50 11 1362 nil true 50 7 1410 1 1442 #newKey 8 '&Key' 1 1 nil nil nil 1490 4097 1410 1 1442 #newStringValue 8 '&String Value' 1 1 nil nil nil 1410 1 1442 #newBinaryValue 8 '&Binary Value' 1 1 nil nil nil 1410 1 1442 #newDWORDValue 8 '&DWORD Value' 1 1 nil nil nil 1410 1 1442 #newMultiStringValue 8 '&Multi-String Value' 1 1 nil nil nil 1410 1 1442 #newExpandableStringValue 8 '&Expandable String Value' 1 1 nil nil nil 8 '&New' nil 1 nil nil nil nil nil 1490 4097 1410 1 1442 #permissions 8 '&Permissions…' 1 1 nil nil nil 1490 4097 1410 1 1442 #delete 8 '&Delete' 605 1 nil nil nil 1410 1 1442 #rename 8 '&Rename' 1 1 nil nil nil 1490 4097 1410 1 1442 #copyKeyName 8 '&Copy Key Name' 1 1 nil nil nil 1490 4097 1410 1 1442 #find 8 '&Find…' 8333 1 nil nil nil 1410 1 1442 #findNext 8 'Find Ne&xt' 229 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil 1362 nil true 50 8 1410 1 1442 #toggleStatusBar 8 '&Status Bar' 1 1 nil nil nil 1490 4097 1410 1 1442 #viewSplit 8 'Sp&lit' 1 1 nil nil nil 1490 4097 1410 1 1442 #viewDisplayBinary 8 '&Display Binary Data' 1 1 nil nil nil 1490 4097 1410 1 1442 #refresh 8 '&Refresh' 233 1 nil nil nil 1410 1 1442 #chooseFont 8 '&Font' 1 1 nil nil nil 8 '&View' nil 1 nil nil nil nil nil 1362 nil true 50 1 1410 1 1442 #aboutRegistryEditor 8 '&About Registry Editor' 1 1 nil nil nil 8 '&Help' nil 1 nil nil nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 530 50 2 578 #createAt:extent: 50 2 210 6143 21 210 1381 791 32 578 #text: 50 1 8 'Dolphin Registry Editor' 32 658 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 177 14 0 0 149 1 0 0] 50 2 736 272 720 nil 27)!

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

