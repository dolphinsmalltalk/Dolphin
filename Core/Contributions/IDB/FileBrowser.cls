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
	"Answers an Icon that can be used to represent this class"

	^##(TextTileIcon
		text: $\x1F5C3
		fontName: 'Segoe UI Emoji'
		color: Color red)!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853548 131137 528 nil 466 #default nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 100 197 66 49 15 1 0 0 196 53 15 1 5 0 144 39 0 0 0 0 199 0 253 85 63 1] 328198 ##(Smalltalk.Point) 193 193 nil 528 592 8 1903898080 170 192 34 2 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1140853580 131137 768 nil 592 nil 519 nil nil nil 768 592 8 1903898080 170 192 8 #() 170 192 34 12 40869 1246790 1 ##(Smalltalk.ToolbarSystemButton) 768 1 1180998 4 ##(Smalltalk.CommandDescription) #cutSelection 8 'Cut' 1 1 nil 40869 1 1 40879 914 768 1 946 #print 8 'Print' 1 1 nil 40879 1 29 40875 914 768 1 946 #clearSelection 8 'Delete' 1 1 nil 40875 1 11 40871 914 768 1 946 #copySelection 8 'Copy' 1 1 nil 40871 1 3 40877 914 768 1 946 #undo 8 'Undo' 1 1 nil 40877 1 7 40873 914 768 1 946 #pasteClipboard 8 'Paste' 1 1 nil 40873 1 5 34 8 928 1088 1184 1040 1136 1049158 1 ##(Smalltalk.ToolbarSeparator) 768 1 992 1250 768 1 nil nil 1 nil 690 33 33 nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 690 155 1 690 309 51 768 1378 #updateSizePosted 864 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 0 0 0 0 231 0 0 0 25 0 0 0] 8 #() 690 193 193 nil 27 8 'editTools' 170 192 864 138 144 864 nil nil 1 nil 690 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1314 138 144 34 2 1378 #createAt:extent: 34 2 690 1 1 690 1505 51 528 1378 #updateSizePosted 864 528 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 240 2 0 0 25 0 0 0] 34 3 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1824 nil nil nil 7 nil nil nil 1824 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_File_tools nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 690 1 1 690 155 51 1824 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 77 0 0 0 25 0 0 0] 864 1536 nil 27 768 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 2064 nil nil nil 7 nil nil nil 2064 1890 ##(Smalltalk.Toolbar) #resource_Find_tools nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 690 463 1 690 109 51 2064 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 231 0 0 0 0 0 0 0 29 1 0 0 25 0 0 0] 864 1536 nil 27 1536 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2288 nil 480 nil 7 nil 610 nil true 642 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 100 197 66 49 15 1 0 0 196 53 15 1 5 0 144 39 0 0 0 0 199 0 253 85 63 1] 690 193 193 nil 2288 nil 8 1903688272 170 192 864 138 144 34 1 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2288 nil 2496 nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 690 1 911 690 1505 45 2288 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 199 1 0 0 240 2 0 0 221 1 0 0] 8 #() 1536 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2672 nil 480 nil 7 nil nil nil 2672 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 nil 2672 34 2 8 1140850688 1 2800 nil 592 nil 7 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2800 nil 1 #left nil nil nil 690 1 1 690 9 9 nil 2896 nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 690 1 427 690 1505 9 2800 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 213 0 0 0 240 2 0 0 217 0 0 0] 8 #() 1536 nil 27 1 true 170 192 864 nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 690 1 51 690 1505 861 2672 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 240 2 0 0 199 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2672 34 2 8 1140850688 131073 3264 nil 480 nil 7 nil nil nil 3264 2738 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 nil 3264 34 2 8 1140850688 1 3376 nil 592 nil 7 nil nil nil 2866 3376 nil 1 #left nil nil nil 2896 2912 nil 2896 nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 690 749 1 690 9 423 3376 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 118 1 0 0 0 0 0 0 122 1 0 0 211 0 0 0] 8 #() 1536 nil 27 1 false 170 192 864 590342 ##(Smalltalk.Rectangle) 690 9 1 690 9 5 1314 138 144 34 1 1378 #createAt:extent: 34 2 690 1 1 690 1505 427 3264 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 240 2 0 0 213 0 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3264 34 2 8 1140850688 131073 3856 nil 592 nil 7 nil nil nil 3856 498 1 1 nil nil nil nil 410 ##(Smalltalk.TreeView) 34 27 nil 3856 34 2 8 1140916775 1025 3936 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 864 592 nil 7 nil nil nil 3936 nil 8 1903706176 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil 170 176 864 nil #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 864 1314 138 144 34 1 1378 #createAt:extent: 34 2 690 1 1 690 741 423 3936 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 114 1 0 0 211 0 0 0] 8 #() 1536 nil 27 170 192 34 2 3936 8 'folders' nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 690 9 1 690 741 423 3856 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 0 0 0 0 118 1 0 0 211 0 0 0] 34 1 3936 1536 nil 27 3376 410 ##(Smalltalk.ContainerView) 34 15 nil 3264 34 2 8 1140850688 131073 4560 nil 592 nil 7 nil nil nil 4560 498 1 1 nil nil nil nil 410 ##(Smalltalk.ListView) 34 30 nil 4560 34 2 8 1140920397 1025 4640 590662 2 ##(Smalltalk.ListModel) 138 144 864 nil 4048 592 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 946 #fileSave 8 '&Save file' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4802 1 946 #fileIn 8 '&File in' 1 1 nil nil nil 4866 4097 4802 1 946 #fileDelete 8 '&Delete file' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 4640 nil 8 1903904528 ##(Smalltalk.BasicListAbstract) nil 4144 nil nil nil nil nil nil 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Name' 313 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() 5122 #name 8 #() nil 4640 nil 3 nil nil 5074 8 'Type' 101 #right ##(Smalltalk.BasicListAbstract) 5122 #<= 8 #() 5122 #type 5184 nil 4640 nil 1 nil nil 5074 8 'Size' 161 #right ##(Smalltalk.BasicListAbstract) 5122 #<= 8 #() 5122 #size 5184 nil 4640 nil 1 nil nil 5074 8 'Date' 161 #right ##(Smalltalk.BasicListAbstract) 5122 #<= 8 #() 5122 #timeStamp 5184 nil 4640 nil 1 nil nil #report 864 nil 131169 nil 34 4 nil nil 690 1 1 nil 1314 138 144 34 3 1378 #createAt:extent: 34 2 690 1 1 690 741 423 4640 1378 #contextMenu: 34 1 4768 4640 1378 #text: 34 1 8 'Name' 4640 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 114 1 0 0 211 0 0 0] 8 #() 1536 nil 27 170 192 34 2 4640 8 'files' nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 690 757 1 690 741 423 4560 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 1 0 0 0 0 0 0 236 2 0 0 211 0 0 0] 34 1 4640 1536 nil 27 1536 nil 27 2800 410 ##(Smalltalk.ContainerView) 34 15 nil 2672 34 2 8 1140850688 131073 5920 nil 480 nil 7 nil nil nil 5920 498 1 1 nil nil nil nil 410 ##(Smalltalk.CardContainer) 34 16 nil 5920 34 2 8 1140850688 131073 6000 nil 480 nil 7 nil nil nil 6000 655878 ##(Smalltalk.CardLayout) 138 144 34 4 721414 ##(Smalltalk.Association) 8 'Images' 410 ##(Smalltalk.ImageView) 34 21 nil 6000 34 2 8 1140850944 1 6176 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 5122 #= 8 #() 5122 #hash 8 #() nil 466 #white nil 5 4754 nil true 34 4 4802 1 946 5122 #showImageAs: 8 #(#normal) 8 'Normal' 1 1 nil nil nil 4802 1 946 5122 #showImageAs: 8 #(#centered) 8 'Centered' 1 1 nil nil nil 4802 1 946 5122 #showImageAs: 8 #(#scale) 8 'Scale' 1 1 nil nil nil 4802 1 946 5122 #showImageAs: 8 #(#scaleToFit) 8 'Scale To Fit' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 6176 nil 8 4294903085 852486 ##(Smalltalk.NullConverter) nil nil nil nil #centered 1 nil nil 1314 138 144 34 2 1378 #createAt:extent: 34 2 690 9 53 690 1473 363 6176 1378 #contextMenu: 34 1 6384 6176 1474 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 228 2 0 0 207 0 0 0] 8 #() 1536 nil 27 6130 8 'HTML' 410 ##(Smalltalk.AXValueConvertingControlSite) 34 26 nil 6000 34 2 8 1140916224 1 7024 6242 nil false 6274 5122 #= 8 #() 5122 #hash 6352 nil 592 nil 5 nil nil nil 7024 nil 537169509 8 'Shell.Explorer' 787462 ##(Smalltalk.IWebBrowser2) nil nil 1444166 1 ##(Smalltalk.TKindInterfaceAnalyzer) 590598 ##(Smalltalk.ITypeInfo) nil nil 525062 ##(Smalltalk.TYPEATTR) nil 7264 7232 nil 1378630 2 ##(Smalltalk.AXTypeLibraryAnalyzer) 590342 ##(Smalltalk.ITypeLib2) nil nil 257 524550 ##(Smalltalk.TLIBATTR) 8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 8 '' 8 'Internet Explorer' #SHDocVwLib #SHDocVwConstants 170 176 8 #(#GUID #GUID) nil nil nil 11 nil nil nil nil 918022 ##(Smalltalk.IDolphinAxHost) nil nil 722438 ##(Smalltalk.AXEventSink) 170 176 8 #(268 #ClientToHostWindow:CY: 227 #UpdatePageStatus:nPage:fDone: 106 #DownloadBegin 253 #OnQuit 266 #WindowSetWidth: 225 #PrintTemplateInstantiation: 104 #DownloadComplete 251 #NewWindow2:Cancel: 264 #WindowSetLeft: 290 #BeforeScriptExecute: 102 #StatusTextChange: 262 #WindowSetResizable: 288 #WebWorkerStarted:bstrWorkerLabel: 113 #TitleChange: 260 #OnTheaterMode: 273 #NewWindow3:Cancel:dwFlags:bstrUrlContext:bstrUrl: 286 #RedirectXDomainBlocked:StartURL:RedirectURL:Frame:StatusCode: 258 #OnFullScreen: 271 #NavigateError:URL:Frame:StatusCode:Cancel: 284 #NewProcess:pWB2:Cancel: 256 #OnMenuBar: 269 #SetSecureLockIcon: 282 #SetPhishingFilterStatus: 254 #OnVisible: 267 #WindowSetHeight: 226 #PrintTemplateTeardown: 105 #CommandStateChange:Enable: 252 #NavigateComplete2:URL: 265 #WindowSetTop: 250 #BeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel: 263 #WindowClosing:Cancel: 289 #WebWorkerFinsihed: 112 #PropertyChange: 259 #DocumentComplete:URL: 272 #PrivacyImpactedStateChange: 285 #ThirdPartyUrlBlocked:dwCount: 257 #OnStatusBar: 270 #FileDownload:Cancel: 283 #WindowStateChanged:dwValidFlagsMask: 108 #ProgressChange:ProgressMax: 255 #OnToolBar:) 7024 1049094 ##(Smalltalk.IConnectionPoint) nil nil 3 1378630 1 ##(Smalltalk.TKindDispatchAnalyzer) 656134 ##(Smalltalk.ITypeInfo2) nil nil 7282 nil 7632 7664 nil 7314 7346 nil nil 257 7378 8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 8 '' 8 'Internet Explorer' #SHDocVwLib #SHDocVwConstants 170 176 8 #(#GUID #GUID) nil nil 262198 ##(Smalltalk.GUID) 16 160 21 167 52 135 101 208 17 146 74 0 32 175 199 172 77 25 nil nil nil 1 3787 170 176 864 1508358 ##(Smalltalk.IAxWinAmbientDispatchEx) nil nil nil nil 524806 ##(Smalltalk.IUnknown) nil nil nil nil nil 6770 nil nil 1314 138 144 34 4 1378 #createAt:extent: 34 2 690 9 53 690 1473 363 7024 1378 #restoreAmbientProperties 864 7024 1378 #docHostFlags: 8 #(4) 7024 1378 #controlBinaryStoreBytes: 34 1 8 #[97 249 86 136 10 52 208 17 169 107 0 192 79 215 5 162 76 0 0 0 17 76 0 0 181 18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 76 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 224 208 87 0 115 53 207 17 174 105 8 0 43 46 18 98 8 0 0 0 0 0 0 0 76 0 0 0 1 20 2 0 0 0 0 0 192 0 0 0 0 0 0 70 128 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 7024 1474 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 228 2 0 0 207 0 0 0] 8 #() 1536 nil 27 6130 8 'Text' 410 ##(Smalltalk.ScintillaView) 34 50 nil 6000 34 2 8 1174475012 1 8240 6242 nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 592 nil 23 4754 nil true 34 10 4802 1 946 #fileSave 8 '&Save file' 1 1 nil nil nil 4866 4097 4802 1 946 #cutSelection 8 'Cu&t' 1 1 nil nil nil 4802 1 946 #copySelection 8 '&Copy' 1 1 nil nil nil 4802 1 946 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 4802 1 946 #clearSelection 8 'De&lete' 1 1 nil nil nil 4866 4097 4802 1 946 #cloneNew 8 'Clo&ne' 1 1 nil nil nil 8640 4802 1 946 #clear 8 'Clea&r workspace' 1 1 nil nil nil 8 '&Workspace' nil 1 nil nil nil nil nil nil nil 8240 nil 8 1349308863 6770 nil nil 9 nil 170 192 34 8 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 8834 77 466 #gray 6368 1 nil nil nil nil #callTip nil nil nil #lineNumber 8834 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #indentGuide 8834 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil 34 40 8848 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 8896 nil nil nil 8912 nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) nil nil nil nil 8240 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 864 nil 170 176 864 9215 nil nil nil nil 466 #silver nil nil 65 nil nil nil 8 '' 1 170 192 864 nil nil nil nil 1 nil 170 192 34 6 8 'indicator0' 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 1 8240 466 #commonGreen 3 false nil nil nil nil nil nil nil 8 'indicator1' 9170 3 8240 466 #blue 5 false nil nil nil nil nil nil nil 8 'indicator2' 9170 5 8240 466 #red 1 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 8834 1027 466 #darkGoldenrod 466 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 8834 1031 466 #firebrick 466 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 8834 1029 nil 466 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil 1314 138 144 34 7 1378 #createAt:extent: 34 2 690 9 53 690 1473 363 8240 1378 #contextMenu: 34 1 8352 8240 1378 #textLimit: 8 #(1073741823) 8240 1378 #caretPeriod: 8 #(530) 8240 1378 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 8240 1 3 nil nil nil nil 9730 3 8240 1 nil nil 67108863 nil nil 9730 5 8240 1 nil nil nil nil nil 8240 1378 #maxCompletionListHeight: 8 #(9) 8240 1378 #edgeColumn: 8 #(1) 8240 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 228 2 0 0 207 0 0 0] 8 #() 1536 nil 29 6130 8 'Hex' 410 ##(Smalltalk.ScintillaView) 34 50 nil 6000 34 2 8 1174475012 1 9936 6242 nil false 8336 nil 592 nil 21 4754 nil true 34 11 4802 1 946 #saveFile 8 '&Save' 1 1 nil nil nil 4802 1 946 #saveFileAs 8 'Save &as' 1 1 nil nil nil 4866 4097 4802 1 946 #cutSelection 8 'Cu&t' 1 1 nil nil nil 4802 1 946 #copySelection 8 '&Copy' 1 1 nil nil nil 4802 1 946 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 4802 1 946 #clearSelection 8 'De&lete' 1 1 nil nil nil 4866 4097 4802 1 946 #cloneNew 8 'Clo&ne' 1 1 nil nil nil 4866 4097 4802 1 946 #clear 8 'Clea&r workspace' 1 1 nil nil nil 8 '&Workspace' nil 1 nil nil nil nil nil nil nil 9936 nil 8 1349308863 6770 nil nil 11 nil 170 192 34 8 #normal 8834 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 8834 77 8880 6368 1 nil nil nil nil #callTip nil nil nil #lineNumber 8834 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #indentGuide 8834 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil 34 40 10560 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 10592 nil nil nil 10608 nil nil 8946 #normal 170 192 34 2 #default 9010 nil nil nil nil 9936 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 864 nil 170 176 864 9215 nil nil nil nil 9072 nil nil 65 nil nil nil 9088 1 170 192 864 nil nil nil nil 1 nil 170 192 34 6 8 'indicator1' 9170 3 9936 9248 5 false nil nil nil nil nil nil nil 8 'indicator2' 9170 5 9936 9296 1 false nil nil nil nil nil nil nil 8 'indicator0' 9170 1 9936 466 #commonGreen 3 false nil nil nil nil nil nil nil nil nil 170 192 864 nil 1314 138 144 34 7 1378 #createAt:extent: 34 2 690 9 53 690 1473 363 9936 1378 #contextMenu: 34 1 10016 9936 1378 #textLimit: 8 #(1073741823) 9936 1378 #caretPeriod: 8 #(530) 9936 1378 #margins: 34 1 34 3 9730 1 9936 1 3 nil nil nil nil 9730 3 9936 1 nil nil 67108863 nil nil 9730 5 9936 1 nil nil nil nil nil 9936 1378 #maxCompletionListHeight: 8 #(9) 9936 1378 #edgeColumn: 8 #(1) 9936 1474 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 228 2 0 0 207 0 0 0] 8 #() 1536 nil 29 8240 170 192 34 8 6176 8 'image' 7024 8 'html' 9936 8 'hex' 8240 8 'text' 3634 690 1 1 690 1 1 410 ##(Smalltalk.TabViewXP) 34 28 nil 6000 34 2 8 1140916736 1 11472 4706 138 144 34 4 8224 9920 6160 7008 nil 4048 480 nil 1 nil nil nil 11472 nil 8 1904010400 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 4144 nil nil nil nil nil #noIcons nil nil nil nil nil 1314 138 144 34 3 1378 #createAt:extent: 34 2 690 1 1 690 1489 423 11472 1378 #basicSelectionsByIndex: 34 1 8 #(1) 11472 1378 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 11472 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 232 2 0 0 211 0 0 0] 8 #() 1536 nil 27 1314 138 144 34 1 1378 #createAt:extent: 34 2 690 9 5 690 1489 423 6000 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 2 0 0 0 236 2 0 0 213 0 0 0] 34 5 8240 9936 6176 7024 11472 1536 nil 27 170 192 34 2 6000 8 'cards' 3634 690 9 5 690 9 1 1314 138 144 34 1 1378 #createAt:extent: 34 2 690 1 435 690 1505 427 5920 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 217 0 0 0 240 2 0 0 174 1 0 0] 34 1 6000 1536 nil 27 1536 nil 27 170 192 34 2 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 4754 nil true 34 12 4802 1 946 #fileNew 8 '&New file' 1 1 nil nil nil 4802 1 946 #fileOpen 8 'Root folder' 1 1 nil nil nil 4802 1 946 #fileSave 8 '&Save file' 1 1 nil nil nil 4802 1 946 #fileSaveAs 8 'Save file &as' 1 1 nil nil nil 4866 4097 4802 1 946 #enableHex 8 'Enable Hex' 1 1 nil nil nil 4802 1 946 #removeCr 8 'Remove Cr' 1 1 nil nil nil 4866 4097 4802 1 946 #pageSetup 8 'Page Setup...' 1 1 nil nil nil 4802 1 946 #print 8 'Print...' 1 1 nil nil nil 4866 4097 4802 1 946 #exit 8 'Close' 16615 1 nil nil nil 8 '&File' nil 1 nil nil 40811 nil nil 4754 nil true 34 11 4802 1 946 #undo 8 '&Undo' 9397 1 nil nil nil 4866 4097 4802 1 946 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 4802 1 946 #copySelection 8 '&Copy' 9351 1 nil nil nil 4802 1 946 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 4802 1 946 #clearSelection 8 '&Delete' 1 1 nil nil nil 4802 1 946 #selectAll 8 'Select &All' 9347 1 nil nil nil 4866 4097 4802 1 946 #find 8 '&Find...' 9357 1 nil nil nil 4802 1 946 #findNext 8 'Find &Next' 1253 1 nil nil nil 4802 1 946 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil 40831 nil nil 4754 nil true 8 #() 8 '&Tools' #toolsMenu 1 nil nil 40833 nil nil 4754 nil true 34 18 4802 1 946 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 49 786694 ##(Smalltalk.ShellLibrary) nil nil 4802 1 946 #help 8 'On this &Tool' 1249 1 nil nil nil 4802 1 946 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4866 4097 4802 1 946 #learnSmalltalk 8 'Learn Smalltalk' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $\x1F393 nil 466 #orchid 6368 nil nil 1 nil nil nil nil 4866 4097 4802 1 946 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4802 1 946 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4802 1 946 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4866 4097 4802 1 946 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 nil nil nil 4802 1 946 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4802 1 946 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4802 1 946 #myDolphinAccount 8 'My Dolphin Account' 1 1 nil nil nil 4866 4097 4802 1 946 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 13522 nil true 13568 8 'LiveUpdate.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 4866 4097 4802 1 946 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 13522 nil true 13568 8 '!!APPLICATION' 14304 nil nil 8 '&Help' nil 134217729 nil nil 40861 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1314 138 144 34 3 1378 #createAt:extent: 34 2 690 3839 21 690 1537 1073 416 1378 #text: 34 1 8 'File Browser' 416 1378 #updateMenuBar 864 416 1474 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 127 10 0 0 34 2 0 0] 34 3 528 2672 2288 1536 nil 27)!

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

