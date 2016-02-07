"Filed out from Dolphin Smalltalk 7"!

IdbToolShell subclass: #FileBrowser
	instanceVariableNames: 'folders files text hex image html hexEnabled removeCr currentRootFolder showImageAs'
	classVariableNames: 'HexEnabled HexFont RemoveCr RootFolder TextFont Warnings'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileBrowser guid: (GUID fromString: '{782ED51C-5423-11D3-998B-BCA753D3B065}')!
FileBrowser comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!FileBrowser categoriesForClass!IDB Goodies! !
!FileBrowser methodsFor!

about
	"Display the about view"

	self 
		idbAbout: '
File Browser
for
Dolphin Smalltalk 6.x

Version 6a
© 2005 Ian Bartholomew
http://www.idb.me.uk'!

askAboutHex: anInteger 
	"Give the chance to turn off hex if the option is on and the file size greater than 50000"

	anInteger < 50000 ifTrue: [^true].
	(MessageBox 
		confirm: 'The hex option is on and the selected file is ' , (anInteger // 1024) printString 
				, ' KB in size.
This may take a little time to render.
Do you want to turn the hex option off before continuing?') 
			ifTrue: [hexEnabled := false].
	^hexEnabled!

canFileIn
	"Answers true if a file is selected and it's extension is st or cls"

	^files hasSelection and: [files selection isChunkFile]!

canPrint
	^super respondsTo: #print:!

clearTabs
	"Empty all the tab pages"

	text value: String new.
	hex value: String new.
	image value: nil.
	html value: 'about:blank'!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	folders := self add: TreePresenter new name: 'folders'.
	files := self add: ListPresenter new name: 'files'.
	text := self add: TextPresenter new name: 'text'.
	hex := self add: TextPresenter new name: 'hex'.
	image := self add: ImagePresenter new name: 'image'.
	html := self add: URLPresenter new name: 'html'!

createSchematicWiring
	"Private - Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self 
		when: #closeRequested:
		send: #onCloseRequested:
		to: self.
	folders 
		when: #selectionChanged
		send: #onFolderSelectionChanged
		to: self.
	folders 
		when: #selectionChanging:
		send: #onSelectionChanging:
		to: self.
	files 
		when: #selectionChanged
		send: #onFileSelectionChanged
		to: self.
	files 
		when: #selectionChanging:
		send: #onSelectionChanging:
		to: self.
	text 
		when: #keyEvent:
		send: #onKeyEvent:
		to: self.
	SessionManager current 
		when: #sessionStarted
		send: #onSessionStarted
		to: self!

enableHex
	"Enable the creation of the Hex text. This can be quite slow for larger files"

	hexEnabled := hexEnabled not.
	self updateFilesKeepingSelection!

fileDelete
	"Delete the selected file. If warnings are enable we have to confirm this operation"

	files hasSelection ifFalse: [^self].
	self class warnings 
		ifTrue: 
			[(MessageBox confirm: files selection path , ' will be deleted.
OK to continue?') ifFalse: [^self]].
	File delete: files selection path.
	self onFolderSelectionChanged!

fileIn
	"Only enabled for chunk (st and cls) files. Loads the file into the image"

	self class sourceManager fileIn: files selection path!

fileNew
	"Just clear any selected file and make sure the text views are cleared 
	to allow a new file to be created. Check for a modified text view first"

	self promptForChanges ifTrue: [^self].
	files selectionOrNil: nil.
	self clearTabs!

fileOpen
	"Change the root folder displayed in the tree - nothing to do with files really.
	Check for modified files first as if we allow the normal check on a folder changing
	the tree seems to get confused. It's best to do it before the folder dialog anyway.
	Make the root folder sticky across image saves"

	| root rootName |
	self promptForChanges ifTrue: [^self].
	(rootName := BrowseFolderDialog showModal) isNil ifTrue: [^self].	"Can't just add this as the path may already end in \ e.g. c:\"
	rootName last = $\ ifFalse: [rootName := rootName , '\'].
	folders model roots: (Array with: (root := FileBrowserFolder name: rootName parent: nil)).
	folders selection: root.
	currentRootFolder := rootName!

fileSave
	"Save any changes to the file"

	files hasSelection ifFalse: [^self fileSaveAs].
	self saveFile: files selection path.
	self updateFilesKeepingSelection!

fileSaveAs
	"Save any changes to the text view in a new file"

	| pathname |
	pathname := folders hasSelection 
				ifTrue: [FileSaveDialog showModalOn: folders selection searchPath]
				ifFalse: [FileSaveDialog showModal].
	pathname isNil ifTrue: [^self].
	self saveFile: pathname.
	self updateFilesKeepingSelection!

onCloseRequested: aValueHolder 
	"The shell is about to be closed. Check for any changes before allowing this"

	self promptForChanges 
		ifFalse: 
			[SessionManager current removeEventsTriggeredFor: self.
			^self].
	aValueHolder value: false!

onFileSelectionChanged
	"The file selection has changed so update the text views and the caption"

	| newCaption rawText |
	files hasSelection 
		ifTrue: 
			[| fileStream |
			fileStream := FileStream read: files selection path.
			[rawText := fileStream contents] ensure: [fileStream close].
			text value: rawText.
			self setImage: files selection.
			self setHTML: files selection.
			newCaption := files selection path]
		ifFalse: 
			[self clearTabs.
			newCaption := String new].
	(hexEnabled and: [rawText notNil and: [rawText notEmpty]]) 
		ifTrue: 
			[(self askAboutHex: rawText size) 
				ifTrue: [Cursor wait showWhile: [hex value: rawText asHexText]]
				ifFalse: [hex value: String new]]
		ifFalse: [hex value: String new].
	self caption: 'File Browser - ' , newCaption!

onFolderSelectionChanged
	"The folder selection has changed so update the file list. We have to make sure that
	the text views are cleared as well as the #onFileSelectionChanged method is not 
	automatically called"

	files 
		list: (folders hasSelection ifTrue: [folders selection files] ifFalse: [OrderedCollection new]).
	files view layout.
	self clearTabs!

onSelectionChanging: aValueHolder 
	"A selection, either the folder or the file, is changing so check to see if there have been any 
	modifications to the text view before allowing the change"

	self promptForChanges ifFalse: [^self].
	aValueHolder value: false!

onSessionStarted
	"A new session has been started with the FileBrowser open so make sure it is consistent"

	currentRootFolder isNil ifTrue: [currentRootFolder := self class rootFolder].
	(File exists: currentRootFolder) ifFalse: [currentRootFolder := self class defaultFolder].
	folders model: (VirtualTreeModel 
				withRoots: (Array with: (FileBrowserFolder name: currentRootFolder parent: nil)))!

onViewOpened
	"The view has opened. Get the initial values from the class variables. These can be
	set in the DolphinOptions folder"

	super onViewOpened.
	hexEnabled := self class hexEnabled.
	removeCr := self class removeCr.
	text view font: self class textFont.
	hex view font: self class hexFont.
	folders model: (VirtualTreeModel 
				withRoots: (Array with: (FileBrowserFolder name: self class rootFolder parent: nil))).
	showImageAs := #scaleToFit!

print
	super print: (self view viewNamed: 'cards') currentCard view!

promptForChanges
	"If warnings are enabled and if the text view has been modified ask for confirmation.
	Answer false if we can continue, possibly losing changed text or true if we want to allow
	the text to be saved. We have to reset the isModified flag to prevent multiple prompts and
	we might as well clear the text pane to prevent confusion"

	| answer |
	self class warnings ifFalse: [^false].
	text isModified ifFalse: [^false].
	(answer := MessageBox confirm: 'There are unsaved changes.
Do you want to retain them?') 
		ifFalse: 
			[text
				text: String new;
				isModified: false].
	^answer!

queryCommand: aCommandQuery 
	"Enters details about a potential command for the receiver into aCommandQuery"

	(#(#fileSave #fileDelete) includes: aCommandQuery command) 
		ifTrue: 
			[aCommandQuery isEnabled: files hasSelection.
			^true].
	#enableHex == aCommandQuery command 
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: hexEnabled.
			^true].
	#removeCr == aCommandQuery command 
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: removeCr.
			^true].
	#fileIn == aCommandQuery command 
		ifTrue: 
			[aCommandQuery isEnabled: self canFileIn.
			^true].
	(#(#print #printPreview) identityIncludes: aCommandQuery command) 
		ifTrue: 
			[aCommandQuery isEnabled: self canPrint.
			^true].
	^super queryCommand: aCommandQuery!

removeCr
	"Toggle whether we remove Crs on saving"

	removeCr := removeCr not!

saveFile: pathname 
	"Save the file after stripping crs if required"

	| fileStream rawText |
	rawText := text plainText.
	removeCr ifTrue: [rawText := rawText copyWithout: Character cr].
	fileStream := FileStream write: pathname.
	[fileStream nextPutAll: rawText] ensure: [fileStream close].
	text isModified: false!

setHTML: aFileBrowserFile 
	"If the selected file is a html file then diplay it on the html tab"

	aFileBrowserFile isHTMLFile ifFalse: [^html value: 'about:blank'].
	html value: aFileBrowserFile path!

setImage: aFileBrowserFile 
	"If the selected file is an image file then diplay it on the image tab"

	aFileBrowserFile isImageFile ifFalse: [^image value: nil].
	image value: (OLEPicture fromFile: aFileBrowserFile path).
	(image view)
		viewMode: showImageAs;
		layout!

showImageAs: aSymbol 
	showImageAs := aSymbol.
	files hasSelection ifTrue: [self setImage: files selection]!

updateFilesKeepingSelection
	"Update the files list but keep the current selection. We can't just use the same selection
	as the actual items in the list will have been recreated so the actual old selection will have
	gone. We have to reselect the item representing the same file"

	| selection |
	files hasSelection ifTrue: [selection := files selection name].
	self onFolderSelectionChanged.
	selection notNil 
		ifTrue: [files selectionOrNil: (files list detect: [:each | each name = selection] ifNone: [])]! !
!FileBrowser categoriesFor: #about!commands!public! !
!FileBrowser categoriesFor: #askAboutHex:!helpers!public! !
!FileBrowser categoriesFor: #canFileIn!commands!public!testing! !
!FileBrowser categoriesFor: #canPrint!printing!public!testing! !
!FileBrowser categoriesFor: #clearTabs!helpers!public! !
!FileBrowser categoriesFor: #createComponents!initializing!public! !
!FileBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!FileBrowser categoriesFor: #enableHex!commands!public! !
!FileBrowser categoriesFor: #fileDelete!commands!public! !
!FileBrowser categoriesFor: #fileIn!commands!public! !
!FileBrowser categoriesFor: #fileNew!commands!public! !
!FileBrowser categoriesFor: #fileOpen!commands!public! !
!FileBrowser categoriesFor: #fileSave!commands!public! !
!FileBrowser categoriesFor: #fileSaveAs!commands!public! !
!FileBrowser categoriesFor: #onCloseRequested:!event handling!public! !
!FileBrowser categoriesFor: #onFileSelectionChanged!event handling!public! !
!FileBrowser categoriesFor: #onFolderSelectionChanged!event handling!public! !
!FileBrowser categoriesFor: #onSelectionChanging:!event handling!public! !
!FileBrowser categoriesFor: #onSessionStarted!event handling!public! !
!FileBrowser categoriesFor: #onViewOpened!event handling!public! !
!FileBrowser categoriesFor: #print!accessing!printing!public! !
!FileBrowser categoriesFor: #promptForChanges!helpers!public! !
!FileBrowser categoriesFor: #queryCommand:!commands!public! !
!FileBrowser categoriesFor: #removeCr!commands!public! !
!FileBrowser categoriesFor: #saveFile:!helpers!public! !
!FileBrowser categoriesFor: #setHTML:!helpers!public! !
!FileBrowser categoriesFor: #setImage:!helpers!public! !
!FileBrowser categoriesFor: #showImageAs:!commands!public! !
!FileBrowser categoriesFor: #updateFilesKeepingSelection!helpers!public! !

!FileBrowser class methodsFor!

defaultFolder
	^SessionManager current imageBase!

displayOn: aStream 
	aStream nextPutAll: 'File Browser'!

hexEnabled
	"Answer whether the hex display is enabled"

	HexEnabled isNil ifTrue: [^false].
	^HexEnabled!

hexEnabled: aBoolean 
	"Set whether the hex display is enabled"

	HexEnabled := aBoolean!

hexFont
	"Answer the font used for the hex view"

	HexFont isNil ifTrue: [^Font name: 'Courier New' pointSize: 10].
	^HexFont!

hexFont: aFont 
	"Set the font used for the hex view"

	HexFont := aFont!

icon

	"Generated from:
	self createIconMethod: #icon ofSize: 48@48 fromFile: 'C:\Users\bower\Documents\Dolphin\Core\Contributions\IDB\Resources\IDB File Browser.png'.
	"
	^InternalIcon fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 2 21 73 68 65 84 104 67 237 152 79 79 19 65 20 192 253 68 150 210 168 7 8 92 52 81 129 234 165 144 96 140 7 61 152 54 77 252 12 132 11 169 23 74 61 24 141 64 8 65 138 95 128 155 127 130 245 162 23 241 15 1 14 28 219 67 147 182 219 109 119 187 59 143 206 35 133 116 251 216 238 180 187 59 18 231 37 191 116 39 111 250 222 254 186 59 179 155 94 171 93 143 192 85 70 9 200 70 9 200 70 9 200 70 9 200 70 9 88 31 63 193 192 209 108 146 53 69 248 191 175 128 249 250 13 216 7 135 67 97 237 21 200 218 94 25 72 160 126 111 26 106 145 17 104 46 44 130 185 181 61 28 111 223 97 173 70 50 69 246 234 199 64 2 172 101 65 35 253 2 234 241 7 254 48 53 131 75 66 155 152 36 251 185 33 44 160 63 126 130 205 140 236 43 252 244 35 236 163 99 92 208 252 138 80 61 221 16 22 96 39 39 208 218 249 208 22 200 1 251 123 64 206 17 193 92 201 161 128 118 251 14 202 80 115 220 16 18 208 198 198 177 137 22 187 225 187 0 63 102 213 42 24 75 153 158 57 110 8 9 216 223 127 0 251 253 7 143 131 16 48 50 47 1 42 149 158 57 110 120 23 136 198 240 215 175 199 31 226 56 8 1 14 246 184 123 191 107 142 27 158 5 140 229 44 176 154 118 49 14 72 192 204 239 0 43 151 187 230 184 225 89 0 24 131 198 243 228 249 56 40 1 190 149 242 240 186 165 122 18 208 19 115 88 52 204 104 189 207 147 231 226 196 147 0 191 239 121 80 185 32 96 197 34 152 27 155 100 206 137 18 232 160 39 102 193 92 93 7 115 173 63 141 84 154 172 209 33 116 1 235 243 23 204 219 251 191 192 254 185 223 23 48 12 96 165 18 89 139 19 174 192 72 244 44 119 243 22 157 191 4 176 44 168 181 159 232 84 46 92 129 246 171 48 223 98 245 167 207 232 60 1 190 146 180 191 195 229 169 124 232 183 16 127 127 17 13 171 240 141 172 197 145 178 136 253 68 9 56 81 2 130 40 1 39 74 64 144 192 4 90 187 187 161 128 255 80 248 41 160 141 198 192 218 251 138 15 159 176 208 231 31 145 231 226 196 147 192 191 140 18 144 141 18 144 141 18 144 141 18 144 75 4 78 1 141 150 91 169 173 241 26 153 0 0 0 0 73 69 78 68 174 66 96 130]!

publishedAspects
	"Answer a Set of the aspects published by  instances of the receiver"

	| aspects |
	aspects := super publishedAspects.
	aspects
		add: (Aspect font: #textFont);
		add: (Aspect font: #hexFont);
		add: (Aspect folder: #rootFolder);
		add: (Aspect boolean: #hexEnabled);
		add: (Aspect boolean: #removeCr);
		add: (Aspect boolean: #warnings).
	^aspects!

removeCr
	"Answer whether we reove Crs before saving"

	RemoveCr isNil ifTrue: [^false].
	^RemoveCr!

removeCr: aBoolean 
	"Set whether we remove Crs when saving"

	RemoveCr := aBoolean!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 721158 ##(Smalltalk.SystemColor) 31 0 519 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140853548 131137 544 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 100 197 66 49 15 1 0 0 196 53 15 1 5 0 144 39 0 0 0 0 199 0 253 85 63 1] 328198 ##(Smalltalk.Point) 193 193 0 544 626 656 8 4294903819 234 256 98 2 410 560 98 25 0 544 98 2 8 1140853580 131137 848 0 626 656 0 519 0 0 0 848 626 656 8 4294903819 234 256 98 0 234 256 98 12 20025 1246982 ##(Smalltalk.ToolbarSystemButton) 20025 0 848 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #cutSelection 8 'Cut' 1 1 0 1 1 20027 1026 20027 0 848 1 1058 8 #copySelection 8 'Copy' 1 1 0 1 3 20029 1026 20029 0 848 1 1058 8 #pasteClipboard 8 'Paste' 1 1 0 1 5 20031 1026 20031 0 848 1 1058 8 #clearSelection 8 'Delete' 1 1 0 1 11 20033 1026 20033 0 848 1 1058 8 #undo 8 'Undo' 1 1 0 1 7 20035 1026 20035 0 848 1 1058 8 #print 8 'Print' 1 1 0 1 29 98 8 1040 1120 1184 1248 1312 1050118 ##(Smalltalk.ToolbarSeparator) 0 0 848 3 0 1 1376 1458 0 0 848 3 0 1 234 240 98 2 1 1 0 1 0 754 33 33 754 45 45 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 2 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 754 155 1 754 309 51 848 1634 8 #updateSize 976 848 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 0 0 0 0 231 0 0 0 25 0 0 0] 98 0 754 193 193 0 27 8 'editTools' 234 256 976 202 208 976 234 240 976 0 1 0 754 33 31 754 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1570 202 208 98 2 1634 1664 98 2 754 1 1 754 1521 51 544 1634 1744 976 544 1762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 248 2 0 0 25 0 0 0] 98 3 410 8 ##(Smalltalk.ReferenceView) 98 14 0 544 98 2 8 1140850688 131073 2144 0 0 0 7 0 0 0 2144 1180166 ##(Smalltalk.ResourceIdentifier) 560 8 #resource_File_tools 0 1570 202 208 98 1 1634 1664 98 2 754 1 1 754 155 51 2144 1762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 77 0 0 0 25 0 0 0] 976 1824 0 27 848 410 2160 98 14 0 544 98 2 8 1140850688 131073 2416 0 0 0 7 0 0 0 2416 2226 560 8 #resource_Find_tools 0 1570 202 208 98 1 1634 1664 98 2 754 463 1 754 109 51 2416 1762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 231 0 0 0 0 0 0 0 29 1 0 0 25 0 0 0] 976 1824 0 27 1824 0 27 410 8 ##(Smalltalk.StatusBar) 98 18 0 416 98 2 8 1140850956 1 2656 0 482 31 0 7 0 674 0 16 706 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 100 197 66 49 15 1 0 0 196 53 15 1 5 0 144 39 0 0 0 0 199 0 253 85 63 1] 754 193 193 0 2656 0 8 4294904209 234 256 976 202 208 98 1 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2656 0 2896 0 1570 202 208 98 1 1634 1664 98 2 754 1 921 754 1521 45 2656 1762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 204 1 0 0 248 2 0 0 226 1 0 0] 98 0 1824 0 27 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 3072 0 482 31 0 7 0 0 0 3072 1180166 ##(Smalltalk.ProportionalLayout) 234 240 98 2 410 8 ##(Smalltalk.Splitter) 98 12 0 3072 98 2 8 1140850688 1 3232 0 626 656 0 7 0 0 0 3232 1570 202 208 98 1 1634 1664 98 2 754 1 431 754 1521 9 3232 1762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 215 0 0 0 248 2 0 0 219 0 0 0] 98 0 1824 0 27 1 16 234 256 976 0 1570 202 208 98 1 1634 1664 98 2 754 1 51 754 1521 871 3072 1762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 248 2 0 0 204 1 0 0] 98 3 410 3088 98 15 0 3072 98 2 8 1140850688 131073 3664 0 482 31 0 7 0 0 0 3664 3170 234 240 98 2 410 3248 98 12 0 3664 98 2 8 1140850688 1 3792 0 626 656 0 7 0 0 0 3792 1570 202 208 98 1 1634 1664 98 2 754 757 1 754 9 427 3792 1762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 1 0 0 0 0 0 0 126 1 0 0 213 0 0 0] 98 0 1824 0 27 1 32 234 256 976 590342 ##(Smalltalk.Rectangle) 754 9 1 754 9 5 1570 202 208 98 1 1634 1664 98 2 754 1 1 754 1521 431 3664 1762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 248 2 0 0 215 0 0 0] 98 3 410 3088 98 15 0 3664 98 2 8 1140850688 131073 4272 0 626 656 0 7 0 0 0 4272 514 1 1 0 0 0 0 410 8 ##(Smalltalk.TreeView) 98 27 0 4272 98 2 8 1140916263 1025 4368 590918 3 ##(Smalltalk.TreeModel) 0 1114638 ##(Smalltalk.STBSingletonProxy) 8 ##(Smalltalk.SearchPolicy) 8 #identity 525062 ##(Smalltalk.TreeNode) 0 0 0 234 256 976 626 656 0 7 0 0 0 4368 0 8 4294904169 8 ##(Smalltalk.BasicListAbstract) 8 ##(Smalltalk.IconicListAbstract) 4490 8 ##(Smalltalk.IconImageManager) 8 #current 0 0 0 0 0 234 240 976 17 8 #noIcons 1 0 1570 202 208 98 1 1634 1664 98 2 754 1 1 754 749 427 4368 1762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 118 1 0 0 213 0 0 0] 98 0 1824 0 27 234 256 98 2 4368 8 'folders' 0 1570 202 208 98 1 1634 1664 98 2 754 9 1 754 749 427 4272 1762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 0 0 0 0 122 1 0 0 213 0 0 0] 98 1 4368 1824 0 27 3792 410 3088 98 15 0 3664 98 2 8 1140850688 131073 5104 0 626 656 0 7 0 0 0 5104 514 1 1 0 0 0 0 410 8 ##(Smalltalk.ListView) 98 30 0 5104 98 2 8 1140920397 1025 5200 590662 2 ##(Smalltalk.ListModel) 202 208 976 0 4496 626 656 0 7 265030 4 ##(Smalltalk.Menu) 0 16 98 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1058 8 #fileSave 8 '&Save file' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5394 1 1058 8 #fileIn 8 '&File in' 1 1 0 0 0 5474 4097 5394 1 1058 8 #fileDelete 8 '&Delete file' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 5200 0 8 4294904165 4624 0 4656 0 0 0 0 0 0 202 208 98 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Name' 321 8 #left 4624 8 ##(Smalltalk.SortedCollection) 459270 ##(Smalltalk.Message) 8 #name 98 0 0 5200 0 3 0 0 5714 8 'Type' 101 8 #right 4624 5776 5794 8 #type 5840 0 5200 0 1 0 0 5714 8 'Size' 161 5888 4624 5776 5794 8 #size 5840 0 5200 0 1 0 0 5714 8 'Date' 161 5888 4624 5776 5794 8 #timeStamp 5840 0 5200 0 1 0 0 8 #report 976 0 131169 0 0 1570 202 208 98 3 1634 1664 98 2 754 1 1 754 749 427 5200 1634 8 #contextMenu: 98 1 5360 5200 1634 8 #text: 98 1 8 'Name' 5200 1762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 118 1 0 0 213 0 0 0] 98 0 1824 0 27 234 256 98 2 5200 8 'files' 0 1570 202 208 98 1 1634 1664 98 2 754 765 1 754 749 427 5104 1762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 126 1 0 0 0 0 0 0 244 2 0 0 213 0 0 0] 98 1 5200 1824 0 27 1824 0 27 3232 410 3088 98 15 0 3072 98 2 8 1140850688 131073 6560 0 482 31 0 7 0 0 0 6560 514 1 1 0 0 0 0 410 8 ##(Smalltalk.CardContainer) 98 16 0 6560 98 2 8 1140850688 131073 6656 0 482 31 0 7 0 0 0 6656 655878 ##(Smalltalk.CardLayout) 202 208 98 4 721414 ##(Smalltalk.Association) 8 'Images' 410 8 ##(Smalltalk.ImageView) 98 21 0 6656 98 2 8 1140850944 1 6864 721990 2 ##(Smalltalk.ValueHolder) 0 0 1376774 ##(Smalltalk.PluggableSearchPolicy) 5794 8 #= 98 0 5794 8 #hash 98 0 0 196934 1 ##(Smalltalk.RGB) 33554431 0 5 5346 0 16 98 4 5394 1 1058 5794 8 #showImageAs: 98 1 8 #normal 8 'Normal' 1 1 0 0 0 5394 1 1058 5794 7216 98 1 8 #centered 8 'Centered' 1 1 0 0 0 5394 1 1058 5794 7216 98 1 8 #scale 8 'Scale' 1 1 0 0 0 5394 1 1058 5794 7216 98 1 8 #scaleToFit 8 'Scale To Fit' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 6864 0 8 4294903085 852486 ##(Smalltalk.NullConverter) 0 0 0 0 7344 1 0 0 1570 202 208 98 2 1634 1664 98 2 754 9 45 754 1489 377 6864 1634 6208 98 1 7136 6864 1762 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 22 0 0 0 236 2 0 0 210 0 0 0] 98 0 1824 0 27 6818 8 'HTML' 410 8 ##(Smalltalk.AXValueConvertingControlSite) 98 26 0 6656 98 2 8 1140916224 1 7856 6946 0 32 6978 5794 7024 98 0 5794 7072 7088 0 626 656 0 5 0 0 0 7856 0 87958305 8 'Shell.Explorer' 787462 ##(Smalltalk.IWebBrowser2) 0 0 1444166 1 ##(Smalltalk.TKindInterfaceAnalyzer) 590598 ##(Smalltalk.ITypeInfo) 0 0 525062 ##(Smalltalk.TYPEATTR) 0 8128 8096 0 1378630 2 ##(Smalltalk.AXTypeLibraryAnalyzer) 590342 ##(Smalltalk.ITypeLib2) 0 0 257 524550 ##(Smalltalk.TLIBATTR) 8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 8 '' 8 'Internet Explorer' 8 #SHDocVwLib 8 #SHDocVwConstants 234 240 98 2 8 #GUID 8384 0 0 0 11 0 0 0 0 918022 ##(Smalltalk.IDolphinAxHost) 0 0 722438 ##(Smalltalk.AXEventSink) 234 240 98 66 205 8 #StatusTextChange: 209 8 #DownloadComplete 211 8 #CommandStateChange:Enable: 213 8 #DownloadBegin 217 8 #ProgressChange:ProgressMax: 501 8 #BeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel: 503 8 #NewWindow2:Cancel: 505 8 #NavigateComplete2:URL: 225 8 #PropertyChange: 227 8 #TitleChange: 507 8 #OnQuit 509 8 #OnVisible: 511 8 #OnToolBar: 513 8 #OnMenuBar: 519 8 #DocumentComplete:URL: 515 8 #OnStatusBar: 517 8 #OnFullScreen: 521 8 #OnTheaterMode: 525 8 #WindowSetResizable: 529 8 #WindowSetLeft: 531 8 #WindowSetTop: 533 8 #WindowSetWidth: 535 8 #WindowSetHeight: 527 8 #WindowClosing:Cancel: 537 8 #ClientToHostWindow:CY: 539 8 #SetSecureLockIcon: 541 8 #FileDownload: 543 8 #NavigateError:URL:Frame:StatusCode:Cancel: 451 8 #PrintTemplateInstantiation: 453 8 #PrintTemplateTeardown: 455 8 #UpdatePageStatus:nPage:fDone: 545 8 #PrivacyImpactedStateChange: 547 8 #NewWindow3:Cancel:dwFlags:bstrUrlContext:bstrUrl: 7856 1049094 ##(Smalltalk.IConnectionPoint) 0 0 3 1378630 1 ##(Smalltalk.TKindDispatchAnalyzer) 8114 0 0 8146 0 9088 9072 0 8178 8210 0 0 257 8242 8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 8 '' 8 'Internet Explorer' 8320 8336 234 240 98 2 8384 8384 0 0 262198 ##(Smalltalk.GUID) 16 160 21 167 52 135 101 208 17 146 74 0 32 175 199 172 77 23 0 0 0 1 3787 234 240 976 1508358 ##(Smalltalk.IAxWinAmbientDispatchEx) 0 0 0 0 524806 ##(Smalltalk.IUnknown) 0 0 0 0 0 7602 0 0 1570 202 208 98 4 1634 1664 98 2 754 9 45 754 1489 377 7856 1634 8 #restoreAmbientProperties 976 7856 1634 8 #docHostFlags: 98 1 9 7856 1634 8 #controlBinaryStoreBytes: 98 1 8 #[97 249 86 136 10 52 208 17 169 107 0 192 79 215 5 162 76 0 0 0 229 76 0 0 110 19 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 76 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 224 208 87 0 115 53 207 17 174 105 8 0 43 46 18 98 8 0 0 0 0 0 0 0 76 0 0 0 1 20 2 0 0 0 0 0 192 0 0 0 0 0 0 70 128 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 7856 1762 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 22 0 0 0 236 2 0 0 210 0 0 0] 98 0 1824 0 27 6818 8 'Text' 410 8 ##(Smalltalk.ScintillaView) 98 46 0 6656 98 2 8 1174475012 1 9712 6946 0 32 4490 4512 8 #equality 0 626 8 4278190080 0 23 5346 0 16 98 10 5394 1 1058 5440 8 '&Save file' 1 1 0 0 0 5474 4097 5394 1 1058 1088 8 'Cu&t' 1 1 0 0 0 5394 1 1058 1152 8 '&Copy' 1 1 0 0 0 5394 1 1058 1216 8 '&Paste' 1 1 0 0 0 5394 1 1058 1280 8 'De&lete' 1 1 0 0 0 5474 4097 5394 1 1058 8 #cloneNew 8 'Clo&ne' 1 1 0 0 0 10160 5394 1 1058 8 #clear 8 'Clea&r workspace' 1 1 0 0 0 8 '&Workspace' 0 1 0 0 0 0 0 0 0 9712 0 403526399 7602 0 0 9 0 234 256 98 6 8 #lineNumber 1182726 ##(Smalltalk.ScintillaTextStyle) 67 0 0 1 0 0 0 0 10368 0 0 0 8 #indentGuide 10386 75 0 0 1 0 0 0 0 10416 0 0 0 7248 10386 1 0 0 1 0 0 0 0 7248 0 0 0 98 40 10448 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10400 0 0 0 10432 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler) 7248 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition) 0 1 786694 ##(Smalltalk.IndexedColor) 33554433 10594 33554471 9712 8 #circle 202 208 976 0 63 0 0 0 0 0 10594 33554447 0 0 0 0 0 0 8 '' 1 234 256 976 0 0 0 0 1 0 0 1570 202 208 98 9 1634 1664 98 2 754 9 45 754 1489 377 9712 1634 6208 98 1 9872 9712 1634 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval) 3 1 3 9712 1634 8 #isTextModified: 98 1 32 9712 1634 8 #modificationEventMask: 98 1 9215 9712 1634 8 #indicatorDefinitions: 98 1 98 3 1836038 ##(Smalltalk.ScintillaIndicatorDefinition) 1 9712 65025 3 11106 3 9712 33423361 5 11106 5 9712 511 1 9712 1634 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin) 1 9712 1 3 32 1 11234 3 9712 1 1 32 67108863 11234 5 9712 1 1 32 1 9712 1634 8 #markers: 98 1 10656 9712 1634 8 #tabIndents: 98 1 16 9712 1762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 22 0 0 0 236 2 0 0 210 0 0 0] 98 0 1824 0 27 6818 8 'Hex' 410 9728 98 46 0 6656 98 2 8 1174475012 1 11472 6946 0 32 9808 0 626 9856 0 21 5346 0 16 98 11 5394 1 1058 8 #saveFile 8 '&Save' 1 1 0 0 0 5394 1 1058 8 #saveFileAs 8 'Save &as' 1 1 0 0 0 5474 4097 5394 1 1058 1088 8 'Cu&t' 1 1 0 0 0 5394 1 1058 1152 8 '&Copy' 1 1 0 0 0 5394 1 1058 1216 8 '&Paste' 1 1 0 0 0 5394 1 1058 1280 8 'De&lete' 1 1 0 0 0 5474 4097 5394 1 1058 10208 8 'Clo&ne' 1 1 0 0 0 5474 4097 5394 1 1058 10272 8 'Clea&r workspace' 1 1 0 0 0 8 '&Workspace' 0 1 0 0 0 0 0 0 0 11472 0 403526399 7602 0 0 11 0 234 256 98 6 10368 10386 67 0 0 1 0 0 0 0 10368 0 0 0 10416 10386 75 0 0 1 0 0 0 0 10416 0 0 0 7248 10386 1 0 0 1 0 0 0 0 7248 0 0 0 98 40 12160 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 12128 0 0 0 12144 0 0 10482 7248 234 256 98 2 10544 10562 0 1 10608 10624 11472 10640 202 208 976 0 63 0 0 0 0 0 10672 0 0 0 0 0 0 10688 1 234 256 976 0 0 0 0 1 0 0 1570 202 208 98 9 1634 1664 98 2 754 9 45 754 1489 377 11472 1634 6208 98 1 11568 11472 1634 10880 98 1 10914 3 1 3 11472 1634 10960 98 1 32 11472 1634 11008 98 1 9215 11472 1634 11056 98 1 98 3 11106 1 11472 65025 3 11106 3 11472 33423361 5 11106 5 11472 511 1 11472 1634 11184 98 1 98 3 11234 1 11472 1 3 32 1 11234 3 11472 1 1 32 67108863 11234 5 11472 1 1 32 1 11472 1634 11312 98 1 12256 11472 1634 11360 98 1 16 11472 1762 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 22 0 0 0 236 2 0 0 210 0 0 0] 98 0 1824 0 27 9712 234 256 98 8 9712 8 'text' 7856 8 'html' 11472 8 'hex' 6864 8 'image' 4050 754 1 1 754 1 1 410 8 ##(Smalltalk.TabView) 98 23 0 6656 98 2 8 1140916736 1 12992 5282 202 208 98 4 9696 11456 6848 7840 0 4496 482 31 0 1 0 0 0 12992 0 8 4294904153 4624 4640 4656 0 0 0 0 0 4720 1570 202 208 98 3 1634 1664 98 2 754 1 1 754 1505 429 12992 1634 8 #selectionByIndex:ifAbsent: 98 2 3 1634 8 #yourself 976 0 12992 1634 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 12992 1762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 240 2 0 0 214 0 0 0] 98 0 1824 0 27 1570 202 208 98 1 1634 1664 98 2 754 9 5 754 1505 429 6656 1762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 2 0 0 0 244 2 0 0 216 0 0 0] 98 5 9712 11472 6864 7856 12992 1824 0 27 234 256 98 2 6656 8 'cards' 4050 754 9 5 754 9 1 1570 202 208 98 1 1634 1664 98 2 754 1 439 754 1521 433 6560 1762 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 219 0 0 0 248 2 0 0 179 1 0 0] 98 1 6656 1824 0 27 1824 0 27 234 256 98 2 544 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 4 5346 0 16 98 12 5394 1 1058 8 #fileNew 8 '&New file' 1 1 0 0 0 5394 1 1058 8 #fileOpen 8 'Root folder' 1 1 0 0 0 5394 1 1058 5440 8 '&Save file' 1 1 0 0 0 5394 1 1058 8 #fileSaveAs 8 'Save file &as' 1 1 0 0 0 5474 4097 5394 1 1058 8 #enableHex 8 'Enable Hex' 1 1 0 0 0 5394 1 1058 8 #removeCr 8 'Remove Cr' 1 1 0 0 0 5474 4097 5394 1 1058 8 #pageSetup 8 'Page Setup...' 1 1 0 0 0 5394 1 1058 1408 8 'Print...' 1 1 0 0 0 5474 4097 5394 1 1058 8 #exit 8 'Close' 16615 1 0 0 0 8 '&File' 0 1 0 0 19959 0 0 5346 0 16 98 11 5394 1 1058 1344 8 '&Undo' 9397 1 0 0 0 5474 4097 5394 1 1058 1088 8 'Cu&t' 9393 1 0 0 0 5394 1 1058 1152 8 '&Copy' 9351 1 0 0 0 5394 1 1058 1216 8 '&Paste' 9389 1 0 0 0 5394 1 1058 1280 8 '&Delete' 1 1 0 0 0 5394 1 1058 8 #selectAll 8 'Select &All' 9347 1 0 0 0 5474 4097 5394 1 1058 8 #find 8 '&Find...' 9357 1 0 0 0 5394 1 1058 8 #findNext 8 'Find &Next' 1253 1 0 0 0 5394 1 1058 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 1 0 0 19979 0 0 5346 0 16 98 0 8 '&Tools' 8 #toolsMenu 1 0 0 19981 0 0 5346 0 16 98 19 5394 1 1058 8 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) 0 16 4490 8 ##(Smalltalk.ImageRelativeFileLocator) 4688 49 4490 8 ##(Smalltalk.ShellLibrary) 10544 0 0 5394 1 1058 8 #help 8 'On this &Tool' 1249 1 0 0 0 5394 1 1058 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 5474 4097 5394 1 1058 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 5474 4097 5394 1 1058 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 5394 1 1058 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 5394 1 1058 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 5346 0 16 98 4 5394 2097153 1058 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 15330 0 16 15360 8 'TipOfTheDay.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr006.dll' 0 0 0 5394 1 1058 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 15330 0 16 15360 8 'TipOfTheDay.ico' 15984 0 0 5474 4097 5394 1 1058 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 0 0 0 5474 4097 5394 1 1058 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 5394 1 1058 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 5394 1 1058 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 5394 1 1058 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 5474 4097 5394 1 1058 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 15330 0 16 15360 8 'LiveUpdate.ico' 15984 0 0 5474 4097 5394 1 1058 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 15330 0 16 15360 8 '!!APPLICATION' 15984 0 0 8 '&Help' 0 134217729 0 0 0 0 0 8 '' 0 1 0 0 0 0 0 0 1049350 ##(Smalltalk.AcceleratorTable) 0 16 98 14 6818 16615 14528 6818 9397 14640 6818 9393 14704 6818 9351 14752 6818 9389 14800 6818 9347 14896 6818 9357 14976 6818 1253 15040 6818 9361 15104 6818 1025 1058 15296 8 '&Contents' 1025 1 15330 0 16 15360 49 15392 6818 1249 1058 15456 8 'On this &Tool' 1249 1 0 6818 5345 1058 15520 8 'What''s This?' 5345 1 0 6818 9441 1058 15904 8 '&Next Tip of the Day' 9441 1 15330 0 16 15360 8 'TipOfTheDay.ico' 15984 6818 13537 1058 16048 8 '&Previous Tip of the Day' 13537 1 15330 0 16 15360 8 'TipOfTheDay.ico' 15984 0 1 0 0 0 0 1 0 0 1570 202 208 98 3 1634 1664 98 2 754 6399 21 754 1537 1073 416 1634 6256 98 1 8 'File Browser' 416 1634 8 #menuBar: 98 1 13920 416 1762 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 12 0 0 10 0 0 0 127 15 0 0 34 2 0 0] 98 3 544 3072 2656 1824 0 27)!

rootFolder
	"Answer the name of the root folder in the tree"

	RootFolder isNil ifTrue: [^self defaultFolder].
	^RootFolder!

rootFolder: aString 
	"Set the name of the root folder in the tree"

	RootFolder := aString!

textFont
	"Answer the font used for the text view"

	TextFont isNil ifTrue: [^Font name: 'Times New Roman' pointSize: 12].
	^TextFont!

textFont: aFont 
	"Set the font used for the text view"

	TextFont := aFont!

warnings
	"Answer whether warnings are enabled"

	Warnings isNil ifTrue: [^true].
	^Warnings!

warnings: aBoolean 
	"Set whether warnings are enabled"

	Warnings := aBoolean! !
!FileBrowser class categoriesFor: #defaultFolder!accessing!public! !
!FileBrowser class categoriesFor: #displayOn:!operations!public! !
!FileBrowser class categoriesFor: #hexEnabled!accessing!public! !
!FileBrowser class categoriesFor: #hexEnabled:!accessing!public! !
!FileBrowser class categoriesFor: #hexFont!accessing!public! !
!FileBrowser class categoriesFor: #hexFont:!accessing!public! !
!FileBrowser class categoriesFor: #icon!constants!public! !
!FileBrowser class categoriesFor: #publishedAspects!initializing!public! !
!FileBrowser class categoriesFor: #removeCr!accessing!public! !
!FileBrowser class categoriesFor: #removeCr:!accessing!public! !
!FileBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!FileBrowser class categoriesFor: #rootFolder!accessing!public! !
!FileBrowser class categoriesFor: #rootFolder:!accessing!public! !
!FileBrowser class categoriesFor: #textFont!accessing!public! !
!FileBrowser class categoriesFor: #textFont:!accessing!public! !
!FileBrowser class categoriesFor: #warnings!accessing!public! !
!FileBrowser class categoriesFor: #warnings:!accessing!public! !

