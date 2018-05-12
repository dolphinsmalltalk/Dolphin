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

	^InternalIcon 
		fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 16 0 0 0 16 8 6 0 0 0 31 243 255 97 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 0 228 73 68 65 84 56 79 157 147 61 14 131 48 12 133 57 81 47 211 51 177 177 48 114 13 174 18 88 122 128 174 84 72 45 205 15 184 121 73 29 153 160 74 161 150 158 244 108 147 207 102 112 53 12 3 157 81 219 182 84 201 24 199 209 82 97 204 243 76 125 223 211 14 226 167 23 3 48 7 0 68 130 0 176 109 27 65 151 235 45 41 175 113 31 0 86 128 48 128 31 75 208 47 191 174 43 61 166 41 110 241 47 0 144 186 174 239 1 128 4 146 191 144 215 100 223 185 248 125 216 64 121 128 115 150 206 136 225 95 128 74 0 222 0 48 233 101 142 186 181 54 40 2 148 242 222 248 130 73 143 74 125 2 24 99 8 226 169 165 94 0 180 7 104 1 216 123 217 195 16 228 80 0 116 93 71 44 220 132 214 186 88 135 187 96 144 214 111 15 137 146 3 224 101 239 0 192 145 97 139 124 43 62 62 238 45 203 139 160 166 105 158 187 203 44 73 242 1 31 131 69 242 138 122 147 62 248 0 0 0 0 73 69 78 68 174 66 96 130]!

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

	"Generated from:
	self createIconMethod: #icon ofSize: 48@48 fromFile: 'C:\Object Arts\Dev\Dolphin6\Object Arts\Samples\MVP\RegEdit\RegEdit.png'.
	"
	^InternalIcon fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 16 132 73 68 65 84 104 67 237 152 119 84 148 215 186 135 191 233 125 6 134 222 135 142 128 14 221 130 133 40 168 16 48 64 144 34 162 216 192 70 145 38 34 138 1 19 147 123 77 52 49 138 189 160 216 115 76 140 162 96 247 36 49 193 130 138 34 18 1 193 194 73 140 37 198 72 52 145 223 121 191 15 136 185 103 221 181 228 36 158 123 243 71 88 235 183 246 0 83 158 231 221 239 222 251 251 134 97 254 250 249 171 2 127 238 10 172 57 117 216 108 211 161 67 70 127 110 202 127 161 219 112 234 128 46 253 232 210 140 73 71 223 252 60 225 112 193 47 137 135 10 159 164 86 189 181 175 176 106 117 236 142 29 59 100 127 74 153 182 182 54 197 188 85 75 243 210 142 47 174 141 61 156 143 136 67 153 120 245 80 6 66 171 50 16 70 9 173 76 71 68 85 38 18 15 22 222 155 178 172 112 197 148 180 18 199 255 119 145 239 191 253 222 249 209 195 71 249 143 31 63 174 251 169 189 253 151 178 205 101 120 109 74 12 252 115 71 98 196 158 169 24 81 149 134 225 85 51 185 113 216 246 201 240 203 12 129 179 175 3 18 28 29 112 34 38 225 214 211 172 252 189 143 139 22 141 187 179 246 99 213 255 153 204 181 107 109 166 15 31 62 44 104 111 111 191 240 243 207 79 209 209 209 193 5 120 70 227 51 60 123 246 51 46 92 56 135 156 130 108 248 36 12 196 144 185 145 176 239 239 132 36 87 39 236 14 26 130 31 198 142 5 38 78 2 38 77 6 38 79 1 166 164 224 231 25 233 143 218 179 242 55 127 87 242 94 48 189 17 255 165 203 76 217 88 235 232 187 166 49 223 126 77 107 69 175 217 187 30 45 88 178 22 205 77 77 28 48 27 128 36 56 129 95 240 244 233 79 248 226 243 207 49 119 118 58 38 39 152 224 141 92 5 66 3 12 240 110 255 1 184 149 52 30 72 157 6 164 164 114 224 221 233 160 199 77 9 99 176 57 104 48 182 38 134 52 116 188 151 80 208 177 118 142 231 31 18 153 184 246 178 93 159 53 205 217 86 171 111 84 75 75 111 118 48 165 109 96 195 91 217 6 193 242 235 80 77 223 136 216 204 133 168 60 80 137 31 31 253 128 211 213 213 88 84 156 135 121 179 92 240 209 122 1 30 182 240 128 7 157 233 184 199 67 117 21 31 57 147 164 152 172 119 194 129 87 35 240 211 100 130 142 79 196 218 192 64 124 56 164 23 42 19 92 241 83 81 0 176 176 47 80 226 143 142 146 1 29 29 239 132 86 119 44 142 159 129 242 69 134 61 150 25 157 242 182 198 193 125 192 33 211 236 221 207 152 229 183 56 104 134 160 187 5 186 71 81 233 45 104 10 170 224 230 31 138 201 227 38 96 88 127 55 212 158 84 17 48 243 155 144 192 253 46 17 110 100 208 118 89 130 208 32 43 232 93 245 208 25 27 227 84 138 55 193 250 19 180 239 243 20 251 0 197 222 20 246 111 126 120 92 50 236 241 210 49 81 235 34 34 210 205 94 40 178 123 109 198 224 55 166 241 160 179 18 64 233 58 0 138 105 27 192 91 214 210 41 176 226 54 100 197 95 194 106 236 59 72 74 43 194 206 109 59 241 224 254 61 174 133 238 221 253 14 165 239 47 69 250 68 79 236 45 83 161 189 141 223 37 194 163 217 16 224 111 27 100 36 106 5 231 87 199 65 155 177 21 210 15 154 33 88 240 25 228 161 105 24 234 229 142 45 163 221 240 176 144 133 246 162 232 241 140 198 51 51 124 144 61 200 1 118 90 13 188 92 121 152 158 228 149 255 66 129 171 39 138 2 154 62 97 240 245 30 6 239 231 50 240 116 226 65 101 235 1 251 132 34 244 143 76 193 246 242 29 184 119 239 46 65 255 239 63 79 159 62 193 238 157 219 17 19 49 16 11 103 91 99 114 156 17 220 135 199 193 120 230 70 72 151 94 163 34 60 111 197 238 153 229 127 216 2 65 234 58 216 244 31 133 156 33 206 88 18 229 133 62 150 198 176 183 228 35 99 12 131 227 107 25 220 170 98 208 180 79 87 248 66 129 235 231 62 118 111 249 148 135 235 123 153 206 124 202 96 246 4 30 132 18 33 212 70 106 36 196 198 226 171 83 167 186 22 239 255 148 96 23 116 205 185 179 152 157 151 135 16 79 79 20 248 248 34 196 222 30 70 250 97 208 204 220 4 33 85 157 79 173 199 91 65 41 189 205 133 161 8 62 108 133 56 243 35 40 6 38 65 165 82 195 206 66 132 61 239 49 184 113 128 192 43 25 220 166 180 177 2 21 186 249 47 20 104 173 249 194 170 173 82 140 182 131 244 66 246 13 40 187 222 225 65 108 46 133 104 172 9 228 131 212 144 153 200 48 44 40 8 251 247 126 74 187 206 19 92 173 175 71 73 113 49 94 235 215 15 115 8 188 38 44 12 29 137 137 64 98 18 144 52 14 95 208 239 113 14 14 48 180 116 132 54 122 54 164 111 86 131 191 172 21 146 252 74 72 130 103 64 101 106 139 81 182 124 108 30 200 195 254 16 17 134 248 242 58 161 187 192 255 65 240 255 56 68 197 60 208 131 25 184 223 220 108 112 231 168 1 238 30 101 240 221 17 6 119 14 51 168 88 198 131 212 92 9 38 213 9 188 169 206 16 166 216 67 26 98 4 137 169 20 46 142 206 112 55 183 192 169 224 16 116 176 123 124 114 50 129 19 252 152 174 112 34 244 119 250 95 99 84 20 166 186 186 65 73 85 54 181 115 67 144 5 31 43 251 242 112 35 138 135 239 71 51 20 30 78 12 231 35 200 143 207 85 188 27 252 27 98 248 134 88 90 14 58 188 120 13 224 210 37 241 119 39 172 58 238 31 99 112 143 13 137 124 182 129 129 194 76 13 222 52 55 240 166 187 80 220 32 152 238 65 51 162 3 95 32 0 143 47 132 55 237 40 91 6 12 192 147 152 24 32 102 52 240 58 141 209 93 161 199 223 188 22 133 82 255 190 24 108 105 13 153 84 10 87 3 17 30 196 178 224 157 240 15 99 59 115 60 132 135 161 254 124 174 226 28 56 229 91 130 255 150 56 154 14 184 228 189 176 133 216 39 220 253 204 169 253 193 113 6 15 72 128 21 57 183 141 129 154 21 152 225 65 233 5 222 76 15 240 103 120 66 60 197 19 18 153 18 188 208 247 192 115 141 6 79 98 0 71 165 10 203 245 222 120 20 22 142 31 70 132 98 91 64 63 132 91 217 192 193 218 6 147 198 143 195 174 242 114 20 229 207 69 31 173 176 19 156 242 3 129 63 138 163 112 2 124 12 11 224 63 7 103 187 128 237 6 226 104 58 208 43 183 71 2 199 183 132 28 111 171 18 225 251 19 52 173 36 114 149 118 36 181 137 10 130 52 61 248 105 189 33 76 167 176 99 170 7 164 114 5 120 99 54 129 73 40 3 19 185 10 140 87 50 120 106 27 88 106 12 208 203 206 14 137 113 113 40 91 187 22 53 95 85 227 124 245 25 202 89 44 156 183 0 222 70 98 174 226 44 244 143 4 255 99 60 131 199 148 35 193 60 12 239 39 224 42 222 13 206 194 223 33 142 147 101 222 179 123 36 224 171 15 168 181 53 87 96 113 150 1 245 162 8 45 21 12 12 140 85 144 102 250 210 110 225 5 33 69 156 65 153 78 51 32 149 65 48 150 4 18 203 41 91 72 100 51 152 209 27 33 176 27 128 229 75 150 16 240 105 14 250 252 233 115 184 112 186 134 11 43 224 107 44 225 170 222 13 222 158 192 128 205 209 16 6 161 129 2 220 33 104 22 188 254 99 30 222 201 20 192 167 151 8 125 7 133 37 247 72 224 219 140 128 139 91 131 164 208 27 203 192 138 20 76 54 129 137 177 33 228 36 32 156 229 5 73 150 15 137 120 67 56 179 55 196 212 207 156 64 210 86 48 99 41 172 4 27 215 80 172 93 177 130 131 103 161 47 158 97 115 158 27 75 10 139 224 103 34 193 143 44 52 85 157 205 79 244 152 205 241 225 60 4 234 69 216 254 142 8 145 175 8 33 151 10 160 163 153 204 202 156 133 189 31 239 123 179 71 2 15 115 250 127 133 241 60 60 73 226 97 203 16 41 220 12 196 16 208 98 53 239 109 7 147 9 190 16 101 121 115 17 166 211 44 200 216 237 149 218 39 105 59 101 27 73 176 33 17 247 8 18 40 237 130 63 143 218 179 108 46 112 41 41 156 15 95 18 96 43 222 13 254 132 14 172 198 215 197 152 226 38 131 72 36 132 76 38 195 168 136 8 108 90 183 30 117 23 107 113 245 242 21 54 47 62 200 88 195 239 179 251 29 196 120 186 166 73 166 235 151 100 62 30 141 21 192 222 64 141 87 180 38 80 136 37 48 245 176 133 41 137 176 237 36 81 210 7 142 35 129 241 59 192 140 235 146 96 69 220 71 97 253 202 149 92 197 89 232 75 231 46 114 185 92 115 17 197 115 231 195 155 206 18 22 254 126 188 8 91 131 20 24 105 39 135 152 138 36 146 136 160 82 106 112 242 232 49 14 186 225 114 61 229 42 190 174 107 192 181 250 134 158 173 129 7 185 65 31 113 2 108 38 208 53 77 178 0 129 22 90 156 208 251 98 143 179 43 70 210 2 149 137 197 176 116 183 131 146 118 29 105 18 181 208 248 157 36 192 134 36 40 60 143 72 172 95 181 234 87 120 22 252 114 77 45 39 80 148 95 0 107 67 13 38 122 104 96 162 144 130 47 17 128 239 174 6 63 198 10 242 112 29 44 205 172 81 95 123 249 87 112 22 158 77 99 125 227 172 30 181 208 253 194 208 50 36 179 51 208 53 11 19 132 24 97 163 193 49 47 63 156 247 212 163 198 67 143 93 246 206 24 74 7 18 159 71 215 74 126 163 33 76 88 79 18 187 192 36 147 4 201 240 250 188 142 13 36 208 93 245 78 129 243 216 179 125 7 130 2 7 129 207 231 67 96 46 3 63 216 20 204 52 7 48 153 206 96 50 156 33 139 178 135 157 181 61 87 125 174 234 87 190 126 158 134 107 25 61 18 184 91 20 253 33 38 176 213 239 202 68 1 162 116 10 28 246 246 195 69 79 47 156 247 232 131 243 189 122 227 172 123 111 152 75 100 80 245 177 0 95 169 132 184 79 36 132 241 107 58 69 244 177 220 34 102 161 79 30 58 204 237 253 222 158 125 32 22 138 160 22 137 33 178 162 147 61 157 133 118 36 120 39 48 179 232 49 73 200 95 119 132 147 206 5 13 117 87 127 5 111 172 191 70 213 191 134 230 134 230 233 61 18 248 110 73 118 122 199 36 241 111 4 120 72 116 148 161 210 219 31 151 250 248 144 132 30 23 8 158 21 209 41 84 208 102 246 133 104 102 31 136 6 88 64 168 82 64 210 251 85 146 10 197 184 184 49 8 11 30 1 181 66 9 41 85 124 164 88 138 213 90 51 108 176 176 133 200 78 77 240 4 158 73 2 179 104 204 34 129 44 87 78 192 197 209 157 224 217 150 33 240 171 108 26 209 216 208 136 166 171 77 83 122 36 144 55 111 105 72 168 157 18 95 142 146 208 253 43 45 228 137 12 82 93 101 216 239 29 128 203 122 31 92 234 173 71 45 85 147 149 112 82 168 97 148 17 0 81 30 237 78 57 190 144 210 97 39 26 104 1 129 76 196 237 92 118 180 232 51 52 90 84 154 90 225 43 83 27 84 155 217 96 35 245 184 88 167 233 170 60 193 103 19 60 23 23 200 99 28 225 238 210 155 22 236 215 4 204 66 55 162 182 230 2 150 44 94 130 253 251 143 6 246 72 96 78 217 170 120 93 130 63 84 38 106 68 219 75 81 23 35 195 44 79 57 62 209 251 145 128 55 205 130 23 46 211 44 212 82 220 85 6 48 74 15 128 32 143 182 214 92 31 72 41 146 92 111 72 131 109 209 159 42 255 5 7 110 77 224 182 56 205 133 4 232 111 18 91 18 200 234 130 207 113 1 147 235 10 38 135 102 32 214 9 158 110 122 170 126 3 42 247 87 32 57 41 9 6 6 90 48 22 62 240 140 157 159 214 35 129 162 191 109 9 183 93 24 12 203 249 65 176 8 243 128 74 45 135 185 74 137 69 4 92 231 229 131 58 86 128 194 206 132 167 66 3 163 180 0 8 103 211 185 64 17 145 136 56 207 7 178 48 7 140 84 105 8 222 10 213 230 54 4 110 205 193 159 161 113 131 169 37 164 54 6 157 2 4 205 228 146 64 30 43 224 2 229 104 23 152 26 153 193 207 215 23 124 41 73 210 110 198 196 210 6 145 82 9 199 220 253 217 61 18 88 188 119 207 48 155 55 67 96 181 112 40 180 197 67 96 145 63 16 90 119 43 234 101 25 134 154 89 96 47 193 95 209 123 161 142 102 195 91 173 133 225 12 63 8 231 248 64 152 79 2 249 52 206 166 153 8 119 228 4 170 9 248 140 185 45 129 219 224 44 137 156 163 199 27 76 44 161 176 165 170 114 149 239 132 23 103 120 64 30 108 7 137 161 2 98 181 9 152 192 12 48 19 62 1 51 245 80 103 82 171 224 152 87 153 213 35 129 45 39 143 6 218 190 57 28 166 11 95 129 166 100 8 12 139 7 195 56 162 23 221 23 136 80 56 133 15 173 74 136 88 186 186 60 238 227 135 190 90 83 24 207 240 135 160 128 14 54 146 16 207 161 49 223 23 202 72 23 132 107 140 112 198 194 14 103 41 231 44 237 80 99 173 195 121 43 29 54 144 136 220 90 11 30 181 141 60 217 13 114 189 57 119 128 249 202 85 136 54 177 128 204 101 56 85 188 170 51 169 44 124 103 236 115 122 40 80 81 93 237 111 243 214 8 24 147 128 186 100 48 212 197 131 96 20 237 142 207 215 9 208 113 134 65 107 5 15 19 94 19 64 45 19 67 171 164 91 192 68 154 129 185 126 36 225 3 17 137 136 72 68 21 237 134 112 3 99 14 190 134 160 89 240 11 36 112 209 218 1 171 105 159 87 107 52 80 88 25 66 41 20 34 70 105 128 221 180 51 93 182 115 66 169 141 3 228 206 172 64 23 248 212 195 116 78 28 225 226 152 123 176 103 45 84 123 245 106 47 219 69 225 80 44 28 2 105 201 32 250 38 98 16 180 113 158 56 182 74 0 144 0 27 86 228 244 22 62 28 172 228 220 117 139 133 159 3 140 166 19 124 161 31 68 36 163 136 233 133 215 140 45 81 67 149 103 193 107 109 236 241 153 189 11 230 88 217 194 150 22 183 129 84 142 28 234 245 207 73 168 142 160 235 172 236 113 133 30 175 100 5 28 135 81 197 9 124 42 11 126 20 204 140 99 220 232 154 91 217 179 251 129 198 198 70 141 207 251 19 158 9 74 6 130 95 28 200 69 57 198 19 7 63 124 46 208 45 17 57 68 141 229 65 90 36 59 211 93 27 93 216 89 4 56 208 55 16 126 80 199 122 32 202 196 134 224 237 241 137 163 43 18 205 173 160 145 208 21 46 173 159 196 132 4 12 48 180 64 29 11 111 229 64 224 142 28 60 59 174 162 200 29 135 62 135 159 78 240 108 72 192 61 167 226 197 183 148 221 139 100 197 230 109 155 124 242 227 32 44 26 0 102 65 63 200 198 121 224 211 165 36 112 150 102 128 77 215 76 196 133 168 80 21 161 230 14 189 154 72 30 70 90 243 32 167 25 177 214 217 160 143 137 53 6 25 155 66 77 215 75 163 233 54 115 239 158 143 209 210 216 132 221 219 182 163 175 129 25 174 176 240 230 246 168 103 71 75 154 1 186 233 47 53 215 65 102 31 212 37 64 224 83 217 28 129 124 204 6 68 205 46 31 215 163 69 220 253 164 99 39 107 34 51 255 123 81 139 101 118 48 164 19 60 241 209 226 78 129 142 110 9 26 199 133 170 177 47 84 201 29 118 92 72 228 72 40 143 238 37 4 208 80 159 207 43 44 196 197 115 53 104 109 186 142 27 77 45 92 118 211 245 144 159 218 20 87 44 8 218 148 4 88 120 51 146 48 35 1 83 59 200 116 131 105 13 28 1 111 74 37 84 81 75 224 31 51 183 33 37 125 113 202 177 99 199 132 255 150 0 251 228 134 134 6 201 187 203 202 227 71 79 74 105 222 184 208 26 29 231 72 128 77 151 196 196 8 21 246 140 36 129 73 4 207 166 235 250 233 147 16 41 70 143 138 33 240 230 46 240 86 220 104 166 52 181 98 215 214 237 240 211 152 163 158 170 127 197 200 14 245 166 58 92 209 234 80 103 160 67 169 214 22 74 115 61 140 71 206 71 80 116 246 217 89 121 203 226 127 23 248 191 154 86 84 124 169 94 249 193 218 55 54 46 234 219 126 247 56 237 70 93 34 169 81 74 236 30 174 120 46 192 74 208 76 28 24 33 65 124 100 44 65 183 224 102 243 13 46 55 174 83 104 100 5 124 53 102 168 55 177 195 21 3 27 92 49 180 65 157 198 6 251 204 93 144 21 24 241 48 34 124 210 150 121 111 172 15 41 42 42 122 249 95 181 111 219 118 64 87 156 151 182 245 224 74 199 103 79 171 25 204 136 145 99 219 48 89 103 229 187 219 136 198 131 35 37 72 136 140 235 132 110 185 137 155 148 27 45 183 232 247 155 216 89 190 29 122 53 173 1 2 191 100 104 139 205 150 189 144 222 47 252 209 248 248 172 229 43 86 236 115 248 183 219 228 247 188 160 244 131 45 129 239 206 141 59 19 22 104 143 141 65 212 66 236 189 195 111 36 14 135 145 64 84 60 7 126 179 245 22 229 54 9 220 70 235 245 91 216 90 182 21 246 106 115 188 231 232 139 148 97 113 223 78 75 45 154 191 110 93 133 201 239 225 248 67 175 97 123 243 237 183 214 140 47 78 153 126 245 100 164 5 58 198 179 119 111 157 34 199 195 196 72 136 38 1 2 191 217 218 198 133 157 129 26 186 177 47 204 95 244 132 218 228 68 94 206 146 105 101 101 149 138 63 4 241 50 94 204 174 143 5 5 239 230 46 25 19 117 167 49 193 152 19 248 123 56 173 129 232 4 220 186 193 194 223 198 209 202 99 40 154 251 246 47 201 73 217 187 23 45 46 247 125 25 159 251 210 223 163 188 252 239 134 249 211 230 253 215 166 216 193 237 59 71 154 225 213 224 112 148 111 220 134 172 180 194 31 38 79 44 88 177 108 245 126 151 151 254 161 255 137 55 220 80 186 71 55 33 49 115 117 240 208 184 35 105 105 111 101 237 216 241 133 246 63 241 57 127 189 231 95 21 120 9 21 248 39 211 34 116 52 207 142 72 122 0 0 0 0 73 69 78 68 174 66 96 130]!

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

	^InternalIcon fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 16 0 0 0 16 8 6 0 0 0 31 243 255 97 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 2 87 73 68 65 84 56 79 205 146 191 111 82 81 20 199 49 198 31 131 131 113 49 174 141 255 128 131 78 46 14 198 65 55 83 135 46 117 209 166 134 98 218 52 74 211 2 86 83 36 252 104 161 242 67 232 243 1 22 8 60 124 175 200 143 148 39 5 11 181 208 80 72 33 150 54 148 68 218 80 26 127 196 152 24 141 219 253 122 193 68 83 73 116 113 240 36 159 229 220 239 61 231 220 239 185 18 201 127 17 31 223 239 225 237 238 54 105 238 212 176 93 78 225 247 161 252 150 241 179 49 143 81 187 40 56 74 29 3 123 39 85 93 213 92 24 235 25 158 108 102 67 216 92 158 195 6 165 178 36 180 115 175 211 207 72 57 205 145 242 34 71 74 47 3 164 163 128 201 52 112 164 144 240 33 255 194 67 242 162 7 249 248 44 86 90 204 187 145 141 58 73 54 226 36 203 17 150 188 10 63 33 153 231 51 157 5 90 21 83 188 13 201 160 13 11 65 43 18 156 5 98 192 12 209 63 141 56 37 58 107 192 214 74 4 205 245 20 234 107 9 236 86 87 241 110 247 13 190 125 253 130 220 188 251 83 123 34 129 213 128 103 30 34 56 67 113 168 193 217 39 16 114 234 176 150 244 163 94 140 163 86 16 241 249 67 3 141 90 25 59 213 34 234 149 92 59 7 72 14 180 11 176 134 17 48 122 57 194 46 61 237 22 198 86 219 11 1 27 75 60 42 153 32 154 149 12 26 229 36 90 30 173 45 248 176 42 210 39 198 92 191 204 54 40 111 65 175 232 71 41 233 69 49 225 65 65 116 99 53 238 162 62 56 145 139 50 200 70 102 176 28 114 32 51 103 67 90 176 34 197 91 96 183 223 60 244 211 80 133 172 7 138 129 30 42 176 82 129 5 169 160 25 73 206 132 5 191 17 9 223 20 68 175 30 243 30 29 98 110 45 34 46 13 66 172 122 255 170 101 189 87 240 232 190 140 196 220 26 42 80 35 204 82 15 152 7 16 28 227 132 183 223 35 220 99 37 9 88 20 196 111 30 163 140 66 165 234 61 186 111 157 215 175 94 64 192 50 70 69 163 240 155 71 224 155 150 195 107 186 139 217 169 59 228 233 228 48 113 233 135 137 83 55 68 88 237 16 97 180 131 29 31 77 210 125 233 28 90 2 167 110 16 172 246 54 24 77 11 25 28 234 1 210 194 168 236 35 93 167 142 235 105 215 19 148 131 29 159 233 198 181 139 176 79 72 169 88 74 47 73 33 239 239 222 163 162 203 148 99 148 31 171 250 83 156 63 115 154 163 231 39 41 135 255 166 253 231 231 223 1 239 156 156 182 204 221 139 214 0 0 0 0 73 69 78 68 174 66 96 130]!

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

	^InternalIcon 
		fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 16 0 0 0 16 8 6 0 0 0 31 243 255 97 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 0 220 73 68 65 84 56 79 157 147 219 13 131 48 12 69 153 168 203 116 50 62 89 131 85 18 126 186 4 21 31 133 60 192 205 77 117 145 41 169 20 26 233 40 142 81 142 13 194 141 181 86 174 208 182 173 52 122 13 195 16 164 114 77 211 36 125 223 203 65 146 170 87 11 80 7 2 172 93 2 193 182 109 242 139 199 253 38 128 11 2 146 37 87 5 20 61 199 241 211 133 22 176 26 118 118 164 115 204 175 235 42 96 23 48 193 157 151 112 46 197 49 42 129 73 223 32 198 32 224 187 154 206 233 248 208 129 177 38 11 120 185 38 14 33 8 200 175 96 140 73 177 63 85 135 176 148 71 142 236 2 239 189 252 131 18 184 36 184 78 22 116 93 39 4 51 225 156 171 230 52 23 20 57 183 36 201 146 255 25 93 0 49 159 97 63 9 48 100 232 2 15 8 206 28 62 196 144 204 243 43 83 20 28 70 181 112 160 132 157 189 1 190 52 13 233 65 30 83 35 0 0 0 0 73 69 78 68 174 66 96 130]!

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

