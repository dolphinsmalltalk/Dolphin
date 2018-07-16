"Filed out from Dolphin Smalltalk 7"!

IdbToolShell subclass: #FileBrowser
	instanceVariableNames: 'folders files text hex image html hexEnabled removeCr currentRootFolder showImageAs'
	classVariableNames: 'HexEnabled HexFont RemoveCr RootFolder TextFont Warnings'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileBrowser guid: (GUID fromString: '{782ed51c-5423-11d3-998b-bca753d3b065}')!
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 0 0 8 #(13565952 65536) 416 0 721158 ##(Smalltalk.SystemColor) 31 0 519 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 0 416 34 2 8 1140853548 131137 528 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 100 197 66 49 15 1 0 0 196 53 15 1 5 0 144 39 0 0 0 0 199 0 253 85 63 1] 328198 ##(Smalltalk.Point) 193 193 0 528 594 624 8 4294906655 170 192 34 2 410 ##(Smalltalk.Toolbar) 34 25 0 528 34 2 8 1140853580 131137 816 0 594 624 0 519 0 0 0 816 594 624 8 4294906655 170 192 8 #() 170 192 34 12 39809 1246982 ##(Smalltalk.ToolbarSystemButton) 39809 0 816 1 1180998 4 ##(Smalltalk.CommandDescription) #cutSelection 8 'Cut' 1 1 0 1 1 39811 994 39811 0 816 1 1026 #copySelection 8 'Copy' 1 1 0 1 3 39813 994 39813 0 816 1 1026 #pasteClipboard 8 'Paste' 1 1 0 1 5 39815 994 39815 0 816 1 1026 #clearSelection 8 'Delete' 1 1 0 1 11 39817 994 39817 0 816 1 1026 #undo 8 'Undo' 1 1 0 1 7 39819 994 39819 0 816 1 1026 #print 8 'Print' 1 1 0 1 29 34 8 1008 1072 1120 1168 1216 1050118 ##(Smalltalk.ToolbarSeparator) 0 0 816 3 0 1 1264 1330 0 0 816 3 0 1 170 176 8 #(0 0) 0 1 0 722 33 33 722 45 45 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 722 155 1 722 309 51 816 1506 #updateSizePosted 944 816 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 0 0 0 0 231 0 0 0 25 0 0 0] 8 #() 722 193 193 0 27 8 'editTools' 170 192 944 138 144 944 170 176 944 0 1 0 722 33 31 722 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1442 138 144 34 2 1506 #createAt:extent: 34 2 722 1 1 722 1505 51 528 1506 #updateSizePosted 944 528 1602 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 240 2 0 0 25 0 0 0] 34 3 410 ##(Smalltalk.ReferenceView) 34 14 0 528 34 2 8 1140850688 131073 1984 0 0 0 7 0 0 0 1984 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_File_tools 0 1442 138 144 34 1 1506 #createAt:extent: 34 2 722 1 1 722 155 51 1984 1602 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 77 0 0 0 25 0 0 0] 944 1664 0 27 816 410 ##(Smalltalk.ReferenceView) 34 14 0 528 34 2 8 1140850688 131073 2224 0 0 0 7 0 0 0 2224 2050 ##(Smalltalk.Toolbar) #resource_Find_tools 0 1442 138 144 34 1 1506 #createAt:extent: 34 2 722 463 1 722 109 51 2224 1602 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 231 0 0 0 0 0 0 0 29 1 0 0 25 0 0 0] 944 1664 0 27 1664 0 27 410 ##(Smalltalk.StatusBar) 34 18 0 416 34 2 8 1140850956 1 2448 0 466 31 0 7 0 642 0 true 674 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 100 197 66 49 15 1 0 0 196 53 15 1 5 0 144 39 0 0 0 0 199 0 253 85 63 1] 722 193 193 0 2448 0 8 4294903691 170 192 944 138 144 34 1 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2448 0 2672 0 1442 138 144 34 1 1506 #createAt:extent: 34 2 722 1 911 722 1505 45 2448 1602 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 199 1 0 0 240 2 0 0 221 1 0 0] 8 #() 1664 0 27 0 0 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 2848 0 466 31 0 7 0 0 0 2848 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 0 2848 34 2 8 1140850688 1 2992 0 594 624 0 7 0 0 0 2992 1442 138 144 34 1 1506 #createAt:extent: 34 2 722 1 427 722 1505 9 2992 1602 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 213 0 0 0 240 2 0 0 217 0 0 0] 8 #() 1664 0 27 1 true 170 192 944 0 1442 138 144 34 1 1506 #createAt:extent: 34 2 722 1 51 722 1505 861 2848 1602 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 240 2 0 0 199 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 0 2848 34 2 8 1140850688 131073 3408 0 466 31 0 7 0 0 0 3408 2930 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 0 3408 34 2 8 1140850688 1 3536 0 594 624 0 7 0 0 0 3536 1442 138 144 34 1 1506 #createAt:extent: 34 2 722 749 1 722 9 423 3536 1602 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 118 1 0 0 0 0 0 0 122 1 0 0 211 0 0 0] 8 #() 1664 0 27 1 false 170 192 944 590342 ##(Smalltalk.Rectangle) 722 9 1 722 9 5 1442 138 144 34 1 1506 #createAt:extent: 34 2 722 1 1 722 1505 427 3408 1602 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 240 2 0 0 213 0 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 0 3408 34 2 8 1140850688 131073 4016 0 594 624 0 7 0 0 0 4016 498 1 1 0 0 0 0 410 ##(Smalltalk.TreeView) 34 27 0 4016 34 2 8 1140916775 1025 4112 590918 3 ##(Smalltalk.TreeModel) 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) 0 0 0 170 192 944 594 624 0 7 0 0 0 4112 0 8 4294904023 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 0 0 0 0 0 170 176 944 17 #noIcons 1 0 1442 138 144 34 1 1506 #createAt:extent: 34 2 722 1 1 722 741 423 4112 1602 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 114 1 0 0 211 0 0 0] 8 #() 1664 0 27 170 192 34 2 4112 8 'folders' 0 1442 138 144 34 1 1506 #createAt:extent: 34 2 722 9 1 722 741 423 4016 1602 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 0 0 0 0 118 1 0 0 211 0 0 0] 34 1 4112 1664 0 27 3536 410 ##(Smalltalk.ContainerView) 34 15 0 3408 34 2 8 1140850688 131073 4736 0 594 624 0 7 0 0 0 4736 498 1 1 0 0 0 0 410 ##(Smalltalk.ListView) 34 30 0 4736 34 2 8 1140920397 1025 4832 590662 2 ##(Smalltalk.ListModel) 138 144 944 0 4224 594 624 0 7 265030 4 ##(Smalltalk.Menu) 0 true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1026 #fileSave 8 '&Save file' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5010 1 1026 #fileIn 8 '&File in' 1 1 0 0 0 5074 4097 5010 1 1026 #fileDelete 8 '&Delete file' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 4832 0 8 4294905883 ##(Smalltalk.BasicListAbstract) 0 4336 0 0 0 0 0 0 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Name' 313 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 459270 ##(Smalltalk.Message) #name 8 #() 0 4832 0 3 0 0 5282 8 'Type' 101 #right ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 5330 #type 5360 0 4832 0 1 0 0 5282 8 'Size' 161 #right ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 5330 #size 5360 0 4832 0 1 0 0 5282 8 'Date' 161 #right ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 5330 #timeStamp 5360 0 4832 0 1 0 0 #report 944 0 131169 0 8 #(nil) 1442 138 144 34 3 1506 #createAt:extent: 34 2 722 1 1 722 741 423 4832 1506 #contextMenu: 34 1 4976 4832 1506 #text: 34 1 8 'Name' 4832 1602 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 114 1 0 0 211 0 0 0] 8 #() 1664 0 27 170 192 34 2 4832 8 'files' 0 1442 138 144 34 1 1506 #createAt:extent: 34 2 722 757 1 722 741 423 4736 1602 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 1 0 0 0 0 0 0 236 2 0 0 211 0 0 0] 34 1 4832 1664 0 27 1664 0 27 2992 410 ##(Smalltalk.ContainerView) 34 15 0 2848 34 2 8 1140850688 131073 5984 0 466 31 0 7 0 0 0 5984 498 1 1 0 0 0 0 410 ##(Smalltalk.CardContainer) 34 16 0 5984 34 2 8 1140850688 131073 6080 0 466 31 0 7 0 0 0 6080 655878 ##(Smalltalk.CardLayout) 138 144 34 4 721414 ##(Smalltalk.Association) 8 'Images' 410 ##(Smalltalk.ImageView) 34 21 0 6080 34 2 8 1140850944 1 6272 721990 2 ##(Smalltalk.ValueHolder) 0 0 1376774 ##(Smalltalk.PluggableSearchPolicy) 5330 #= 8 #() 5330 #hash 8 #() 0 196934 1 ##(Smalltalk.RGB) 33554431 0 5 4962 0 true 34 4 5010 1 1026 5330 #showImageAs: 8 #(#normal) 8 'Normal' 1 1 0 0 0 5010 1 1026 5330 #showImageAs: 8 #(#centered) 8 'Centered' 1 1 0 0 0 5010 1 1026 5330 #showImageAs: 8 #(#scale) 8 'Scale' 1 1 0 0 0 5010 1 1026 5330 #showImageAs: 8 #(#scaleToFit) 8 'Scale To Fit' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 6272 0 8 4294903085 852486 ##(Smalltalk.NullConverter) 0 0 0 0 #centered 1 0 0 1442 138 144 34 2 1506 #createAt:extent: 34 2 722 9 55 722 1473 361 6272 1506 #contextMenu: 34 1 6496 6272 1602 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 228 2 0 0 207 0 0 0] 8 #() 1664 0 27 6226 8 'HTML' 410 ##(Smalltalk.AXValueConvertingControlSite) 34 26 0 6080 34 2 8 1140916224 1 7136 6338 0 false 6370 5330 #= 8 #() 5330 #hash 6448 0 594 624 0 5 0 0 0 7136 0 537187261 8 'Shell.Explorer' 787462 ##(Smalltalk.IWebBrowser2) 0 0 1444166 1 ##(Smalltalk.TKindInterfaceAnalyzer) 590598 ##(Smalltalk.ITypeInfo) 0 0 525062 ##(Smalltalk.TYPEATTR) 0 7392 7360 0 1378630 2 ##(Smalltalk.AXTypeLibraryAnalyzer) 590342 ##(Smalltalk.ITypeLib2) 0 0 257 524550 ##(Smalltalk.TLIBATTR) 8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 8 '' 8 'Internet Explorer' #SHDocVwLib #SHDocVwConstants 170 176 8 #(#GUID #GUID) 0 0 0 11 0 0 0 0 918022 ##(Smalltalk.IDolphinAxHost) 0 0 722438 ##(Smalltalk.AXEventSink) 170 176 8 #(268 #ClientToHostWindow:CY: 269 #SetSecureLockIcon: 270 #FileDownload:Cancel: 271 #NavigateError:URL:Frame:StatusCode:Cancel: 272 #PrivacyImpactedStateChange: 273 #NewWindow3:Cancel:dwFlags:bstrUrlContext:bstrUrl: 282 #SetPhishingFilterStatus: 283 #WindowStateChanged:dwValidFlagsMask: 284 #NewProcess:pWB2:Cancel: 285 #ThirdPartyUrlBlocked:dwCount: 286 #RedirectXDomainBlocked:StartURL:RedirectURL:Frame:StatusCode: 288 #WebWorkerStarted:bstrWorkerLabel: 289 #WebWorkerFinsihed: 290 #BeforeScriptExecute: 225 #PrintTemplateInstantiation: 226 #PrintTemplateTeardown: 227 #UpdatePageStatus:nPage:fDone: 102 #StatusTextChange: 104 #DownloadComplete 105 #CommandStateChange:Enable: 106 #DownloadBegin 108 #ProgressChange:ProgressMax: 112 #PropertyChange: 113 #TitleChange: 250 #BeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel: 251 #NewWindow2:Cancel: 252 #NavigateComplete2:URL: 253 #OnQuit 254 #OnVisible: 255 #OnToolBar: 256 #OnMenuBar: 257 #OnStatusBar: 258 #OnFullScreen: 259 #DocumentComplete:URL: 260 #OnTheaterMode: 262 #WindowSetResizable: 263 #WindowClosing:Cancel: 264 #WindowSetLeft: 265 #WindowSetTop: 266 #WindowSetWidth: 267 #WindowSetHeight:) 7136 1049094 ##(Smalltalk.IConnectionPoint) 0 0 3 1378630 1 ##(Smalltalk.TKindDispatchAnalyzer) 656134 ##(Smalltalk.ITypeInfo2) 0 0 7410 0 7760 7792 0 7442 7474 0 0 257 7506 8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 8 '' 8 'Internet Explorer' #SHDocVwLib #SHDocVwConstants 170 176 8 #(#GUID #GUID) 0 0 262198 ##(Smalltalk.GUID) 16 160 21 167 52 135 101 208 17 146 74 0 32 175 199 172 77 25 0 0 0 1 3787 170 176 944 1508358 ##(Smalltalk.IAxWinAmbientDispatchEx) 0 0 0 0 524806 ##(Smalltalk.IUnknown) 0 0 0 0 0 6882 0 0 1442 138 144 34 4 1506 #createAt:extent: 34 2 722 9 55 722 1473 361 7136 1506 #restoreAmbientProperties 944 7136 1506 #docHostFlags: 8 #(4) 7136 1506 #controlBinaryStoreBytes: 34 1 8 #[97 249 86 136 10 52 208 17 169 107 0 192 79 215 5 162 76 0 0 0 17 76 0 0 155 18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 76 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 224 208 87 0 115 53 207 17 174 105 8 0 43 46 18 98 8 0 0 0 0 0 0 0 76 0 0 0 1 20 2 0 0 0 0 0 192 0 0 0 0 0 0 70 128 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 7136 1602 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 228 2 0 0 207 0 0 0] 8 #() 1664 0 27 6226 8 'Text' 410 ##(Smalltalk.ScintillaView) 34 50 0 6080 34 2 8 1174475012 1 8368 6338 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 594 8 4278190080 0 23 4962 0 true 34 10 5010 1 1026 #fileSave 8 '&Save file' 1 1 0 0 0 5074 4097 5010 1 1026 #cutSelection 8 'Cu&t' 1 1 0 0 0 5010 1 1026 #copySelection 8 '&Copy' 1 1 0 0 0 5010 1 1026 #pasteClipboard 8 '&Paste' 1 1 0 0 0 5010 1 1026 #clearSelection 8 'De&lete' 1 1 0 0 0 5074 4097 5010 1 1026 #cloneNew 8 'Clo&ne' 1 1 0 0 0 8800 5010 1 1026 #clear 8 'Clea&r workspace' 1 1 0 0 0 8 '&Workspace' 0 1 0 0 0 0 0 0 0 8368 0 8 4294906539 6882 0 0 9 0 170 192 34 8 #indentGuide 1182790 1 ##(Smalltalk.ScintillaTextStyle) 75 0 0 1 0 0 0 0 #indentGuide 0 0 0 #callTip 8994 77 786694 ##(Smalltalk.IndexedColor) 33554457 9042 33554471 1 0 0 0 0 #callTip 0 0 0 #lineNumber 8994 67 0 0 1 0 0 0 0 #lineNumber 0 0 0 #normal 8994 1 0 0 1 0 0 0 0 #normal 0 0 0 34 40 9104 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 9088 0 0 0 9008 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 0 0 0 0 8368 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 944 0 170 176 944 9215 0 0 0 0 9042 33554447 0 0 65 0 0 0 8 '' 1 170 192 944 0 0 0 0 1 0 170 192 34 6 8 'indicator0' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 1 8368 65025 3 false 0 0 0 0 0 0 0 8 'indicator2' 9362 5 8368 511 1 false 0 0 0 0 0 0 0 8 'indicator1' 9362 3 8368 33423361 5 false 0 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 8994 1029 0 6466 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 8994 1027 6466 60239 6466 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 8994 1031 6466 335 6466 31317503 1 0 0 0 0 #Error 0 0 0 0 1442 138 144 34 5 1506 #createAt:extent: 34 2 722 9 55 722 1473 361 8368 1506 #contextMenu: 34 1 8512 8368 1506 #modificationEventMask: 8 #(4607) 8368 1506 #caretPeriod: 8 #(530) 8368 1506 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 8368 1 3 0 0 0 0 9874 3 8368 1 0 0 67108863 0 0 9874 5 8368 1 0 0 0 0 0 8368 1602 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 228 2 0 0 207 0 0 0] 8 #() 1664 0 29 6226 8 'Hex' 410 ##(Smalltalk.ScintillaView) 34 50 0 6080 34 2 8 1174475012 1 10016 6338 0 false 8464 0 594 8496 0 21 4962 0 true 34 11 5010 1 1026 #saveFile 8 '&Save' 1 1 0 0 0 5010 1 1026 #saveFileAs 8 'Save &as' 1 1 0 0 0 5074 4097 5010 1 1026 #cutSelection 8 'Cu&t' 1 1 0 0 0 5010 1 1026 #copySelection 8 '&Copy' 1 1 0 0 0 5010 1 1026 #pasteClipboard 8 '&Paste' 1 1 0 0 0 5010 1 1026 #clearSelection 8 'De&lete' 1 1 0 0 0 5074 4097 5010 1 1026 #cloneNew 8 'Clo&ne' 1 1 0 0 0 5074 4097 5010 1 1026 #clear 8 'Clea&r workspace' 1 1 0 0 0 8 '&Workspace' 0 1 0 0 0 0 0 0 0 10016 0 8 4294906539 6882 0 0 11 0 170 192 34 8 #indentGuide 8994 75 0 0 1 0 0 0 0 #indentGuide 0 0 0 #callTip 8994 77 9056 9072 1 0 0 0 0 #callTip 0 0 0 #lineNumber 8994 67 0 0 1 0 0 0 0 #lineNumber 0 0 0 #normal 8994 1 0 0 1 0 0 0 0 #normal 0 0 0 34 40 10704 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10688 0 0 0 10656 0 0 9138 #normal 170 192 34 2 #default 9202 0 0 0 0 10016 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 944 0 170 176 944 9215 0 0 0 0 9264 0 0 65 0 0 0 9280 1 170 192 944 0 0 0 0 1 0 170 192 34 6 8 'indicator1' 9362 3 10016 33423361 5 false 0 0 0 0 0 0 0 8 'indicator2' 9362 5 10016 511 1 false 0 0 0 0 0 0 0 8 'indicator0' 9362 1 10016 65025 3 false 0 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 8994 1029 0 6466 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 8994 1027 6466 60239 6466 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 8994 1031 6466 335 6466 31317503 1 0 0 0 0 #Error 0 0 0 0 1442 138 144 34 5 1506 #createAt:extent: 34 2 722 9 55 722 1473 361 10016 1506 #contextMenu: 34 1 10112 10016 1506 #modificationEventMask: 8 #(4607) 10016 1506 #caretPeriod: 8 #(530) 10016 1506 #margins: 34 1 34 3 9874 1 10016 1 3 0 0 0 0 9874 3 10016 1 0 0 67108863 0 0 9874 5 10016 1 0 0 0 0 0 10016 1602 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 27 0 0 0 228 2 0 0 207 0 0 0] 8 #() 1664 0 29 8368 170 192 34 8 10016 8 'hex' 8368 8 'text' 6272 8 'image' 7136 8 'html' 3794 722 1 1 722 1 1 410 ##(Smalltalk.TabViewXP) 34 23 0 6080 34 2 8 1140916736 1 11632 4898 138 144 34 4 8352 10000 6256 7120 0 4224 466 31 0 1 0 0 0 11632 0 8 4294903993 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 4336 0 0 0 0 0 #noIcons 1442 138 144 34 3 1506 #createAt:extent: 34 2 722 1 1 722 1489 423 11632 1506 #basicSelectionsByIndex: 34 1 8 #(1) 11632 1506 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 11632 1602 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 232 2 0 0 211 0 0 0] 8 #() 1664 0 27 1442 138 144 34 1 1506 #createAt:extent: 34 2 722 9 5 722 1489 423 6080 1602 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 2 0 0 0 236 2 0 0 213 0 0 0] 34 5 8368 10016 6272 7136 11632 1664 0 27 170 192 34 2 6080 8 'cards' 3794 722 9 5 722 9 1 1442 138 144 34 1 1506 #createAt:extent: 34 2 722 1 435 722 1505 427 5984 1602 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 217 0 0 0 240 2 0 0 174 1 0 0] 34 1 6080 1664 0 27 1664 0 27 170 192 34 2 528 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 true 34 4 4962 0 true 34 12 5010 1 1026 #fileNew 8 '&New file' 1 1 0 0 0 5010 1 1026 #fileOpen 8 'Root folder' 1 1 0 0 0 5010 1 1026 #fileSave 8 '&Save file' 1 1 0 0 0 5010 1 1026 #fileSaveAs 8 'Save file &as' 1 1 0 0 0 5074 4097 5010 1 1026 #enableHex 8 'Enable Hex' 1 1 0 0 0 5010 1 1026 #removeCr 8 'Remove Cr' 1 1 0 0 0 5074 4097 5010 1 1026 #pageSetup 8 'Page Setup...' 1 1 0 0 0 5010 1 1026 #print 8 'Print...' 1 1 0 0 0 5074 4097 5010 1 1026 #exit 8 'Close' 16615 1 0 0 0 8 '&File' 0 1 0 0 39751 0 0 4962 0 true 34 11 5010 1 1026 #undo 8 '&Undo' 9397 1 0 0 0 5074 4097 5010 1 1026 #cutSelection 8 'Cu&t' 9393 1 0 0 0 5010 1 1026 #copySelection 8 '&Copy' 9351 1 0 0 0 5010 1 1026 #pasteClipboard 8 '&Paste' 9389 1 0 0 0 5010 1 1026 #clearSelection 8 '&Delete' 1 1 0 0 0 5010 1 1026 #selectAll 8 'Select &All' 9347 1 0 0 0 5074 4097 5010 1 1026 #find 8 '&Find...' 9357 1 0 0 0 5010 1 1026 #findNext 8 'Find &Next' 1253 1 0 0 0 5010 1 1026 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 1 0 0 39771 0 0 4962 0 true 8 #() 8 '&Tools' #toolsMenu 1 0 0 39773 0 0 4962 0 true 34 18 5010 1 1026 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) 0 true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 49 786694 ##(Smalltalk.ShellLibrary) 0 0 5010 1 1026 #help 8 'On this &Tool' 1249 1 0 0 0 5010 1 1026 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 5074 4097 5010 1 1026 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 5074 4097 5010 1 1026 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 5010 1 1026 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 5010 1 1026 #helpTutorials 8 'Tutorials' 1 1 0 0 0 5074 4097 5010 1 1026 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 5010 1 1026 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 5010 1 1026 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 5010 1 1026 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 5074 4097 5010 1 1026 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 13698 0 true 13744 8 'LiveUpdate.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 5074 4097 5010 1 1026 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 13698 0 true 13744 8 '!!APPLICATION' 14432 0 0 8 '&Help' 0 134217729 0 0 39801 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 1442 138 144 34 3 1506 #createAt:extent: 34 2 722 3839 21 722 1537 1073 416 1506 #text: 34 1 8 'File Browser' 416 1506 #updateMenuBar 944 416 1602 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 127 10 0 0 34 2 0 0] 34 3 528 2848 2448 1664 0 27 )!

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

