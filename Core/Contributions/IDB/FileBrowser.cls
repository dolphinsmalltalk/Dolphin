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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 721158 ##(Smalltalk.SystemColor) 31 nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853548 131137 528 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 100 197 66 49 15 1 0 0 196 53 15 1 5 0 144 39 0 0 0 0 199 0 253 85 63 1] 328198 ##(Smalltalk.Point) 193 193 nil 528 608 8 1903553904 170 192 34 2 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1140853580 131137 800 nil 608 nil 519 nil nil nil 800 608 8 1903553904 170 192 8 #() 170 192 34 12 58719 1246790 1 ##(Smalltalk.ToolbarSystemButton) 800 1 1180998 4 ##(Smalltalk.CommandDescription) #cutSelection 8 'Cut' 1 1 nil 58719 1 1 58721 946 800 1 978 #copySelection 8 'Copy' 1 1 nil 58721 1 3 58723 946 800 1 978 #pasteClipboard 8 'Paste' 1 1 nil 58723 1 5 58725 946 800 1 978 #clearSelection 8 'Delete' 1 1 nil 58725 1 11 58727 946 800 1 978 #undo 8 'Undo' 1 1 nil 58727 1 7 58729 946 800 1 978 #print 8 'Print' 1 1 nil 58729 1 29 34 8 960 1024 1072 1120 1168 1049158 1 ##(Smalltalk.ToolbarSeparator) 800 1 1216 1282 800 1 nil nil 1 nil 722 33 33 nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 722 155 1 722 309 51 800 1410 #updateSizePosted 896 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 0 0 0 0 231 0 0 0 25 0 0 0] 8 #() 722 193 193 nil 27 8 'editTools' 170 192 896 138 144 896 nil nil 1 nil 722 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1346 138 144 34 2 1410 #createAt:extent: 34 2 722 1 1 722 1505 51 528 1410 #updateSizePosted 896 528 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 240 2 0 0 25 0 0 0] 34 3 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1856 nil nil nil 7 nil nil nil 1856 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_File_tools nil 1346 138 144 34 1 1410 #createAt:extent: 34 2 722 1 1 722 155 51 1856 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 77 0 0 0 25 0 0 0] 896 1568 nil 27 800 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 2096 nil nil nil 7 nil nil nil 2096 1922 ##(Smalltalk.Toolbar) #resource_Find_tools nil 1346 138 144 34 1 1410 #createAt:extent: 34 2 722 463 1 722 109 51 2096 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 231 0 0 0 0 0 0 0 29 1 0 0 25 0 0 0] 896 1568 nil 27 1568 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2320 nil 480 nil 7 nil 642 nil true 674 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 100 197 66 49 15 1 0 0 196 53 15 1 5 0 144 39 0 0 0 0 199 0 253 85 63 1] 722 193 193 nil 2320 nil 8 1903286208 170 192 896 138 144 34 1 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2320 nil 2528 nil 1346 138 144 34 1 1410 #createAt:extent: 34 2 722 1 911 722 1505 45 2320 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 199 1 0 0 240 2 0 0 221 1 0 0] 8 #() 1568 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2704 nil 480 nil 7 nil nil nil 2704 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 nil 2704 34 2 8 1140850688 1 2832 nil 608 nil 7 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2832 nil 1 #left nil nil nil 722 1 1 722 9 9 nil 2928 nil 1346 138 144 34 1 1410 #createAt:extent: 34 2 722 1 427 722 1505 9 2832 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 213 0 0 0 240 2 0 0 217 0 0 0] 8 #() 1568 nil 27 1 true 170 192 896 nil 1346 138 144 34 1 1410 #createAt:extent: 34 2 722 1 51 722 1505 861 2704 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 240 2 0 0 199 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2704 34 2 8 1140850688 131073 3296 nil 480 nil 7 nil nil nil 3296 2770 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 nil 3296 34 2 8 1140850688 1 3408 nil 608 nil 7 nil nil nil 2898 3408 nil 1 #left nil nil nil 2928 2944 nil 2928 nil 1346 138 144 34 1 1410 #createAt:extent: 34 2 722 749 1 722 9 423 3408 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 118 1 0 0 0 0 0 0 122 1 0 0 211 0 0 0] 8 #() 1568 nil 27 1 false 170 192 896 590342 ##(Smalltalk.Rectangle) 722 9 1 722 9 5 1346 138 144 34 1 1410 #createAt:extent: 34 2 722 1 1 722 1505 427 3296 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 240 2 0 0 213 0 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3296 34 2 8 1140850688 131073 3888 nil 608 nil 7 nil nil nil 3888 498 1 1 nil nil nil nil 410 ##(Smalltalk.TreeView) 34 27 nil 3888 34 2 8 1140916775 1025 3968 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 896 608 nil 7 nil nil nil 3968 nil 8 1903418384 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil 170 176 896 nil #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 896 1346 138 144 34 1 1410 #createAt:extent: 34 2 722 1 1 722 741 423 3968 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 114 1 0 0 211 0 0 0] 8 #() 1568 nil 27 170 192 34 2 3968 8 'folders' nil 1346 138 144 34 1 1410 #createAt:extent: 34 2 722 9 1 722 741 423 3888 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 0 0 0 0 118 1 0 0 211 0 0 0] 34 1 3968 1568 nil 27 3408 410 ##(Smalltalk.ContainerView) 34 15 nil 3296 34 2 8 1140850688 131073 4592 nil 608 nil 7 nil nil nil 4592 498 1 1 nil nil nil nil 410 ##(Smalltalk.ListView) 34 30 nil 4592 34 2 8 1140920397 1025 4672 590662 2 ##(Smalltalk.ListModel) 138 144 896 nil 4080 608 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 978 #fileSave 8 '&Save file' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4834 1 978 #fileIn 8 '&File in' 1 1 nil nil nil 4898 4097 4834 1 978 #fileDelete 8 '&Delete file' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 4672 nil 8 1903559696 ##(Smalltalk.BasicListAbstract) nil 4176 nil nil nil nil nil nil 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Name' 313 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 459270 ##(Smalltalk.Message) #name 8 #() nil 4672 nil 3 nil nil 5106 8 'Type' 101 #right ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 5154 #type 5184 nil 4672 nil 1 nil nil 5106 8 'Size' 161 #right ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 5154 #size 5184 nil 4672 nil 1 nil nil 5106 8 'Date' 161 #right ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 5154 #timeStamp 5184 nil 4672 nil 1 nil nil #report 896 nil 131169 nil 8 #(nil) 1346 138 144 34 3 1410 #createAt:extent: 34 2 722 1 1 722 741 423 4672 1410 #contextMenu: 34 1 4800 4672 1410 #text: 34 1 8 'Name' 4672 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 114 1 0 0 211 0 0 0] 8 #() 1568 nil 27 170 192 34 2 4672 8 'files' nil 1346 138 144 34 1 1410 #createAt:extent: 34 2 722 757 1 722 741 423 4592 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 1 0 0 0 0 0 0 236 2 0 0 211 0 0 0] 34 1 4672 1568 nil 27 1568 nil 27 2832 410 ##(Smalltalk.ContainerView) 34 15 nil 2704 34 2 8 1140850688 131073 5808 nil 480 nil 7 nil nil nil 5808 498 1 1 nil nil nil nil 410 ##(Smalltalk.CardContainer) 34 16 nil 5808 34 2 8 1140850688 131073 5888 nil 480 nil 7 nil nil nil 5888 655878 ##(Smalltalk.CardLayout) 138 144 34 4 721414 ##(Smalltalk.Association) 8 'Images' 410 ##(Smalltalk.ImageView) 34 21 nil 5888 34 2 8 1140850944 1 6064 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 5154 #= 8 #() 5154 #hash 8 #() nil 196934 1 ##(Smalltalk.RGB) 33554431 nil 5 4786 nil true 34 4 4834 1 978 5154 #showImageAs: 8 #(#normal) 8 'Normal' 1 1 nil nil nil 4834 1 978 5154 #showImageAs: 8 #(#centered) 8 'Centered' 1 1 nil nil nil 4834 1 978 5154 #showImageAs: 8 #(#scale) 8 'Scale' 1 1 nil nil nil 4834 1 978 5154 #showImageAs: 8 #(#scaleToFit) 8 'Scale To Fit' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 6064 nil 8 4294903085 852486 ##(Smalltalk.NullConverter) nil nil nil nil #centered 1 nil nil 1346 138 144 34 2 1410 #createAt:extent: 34 2 722 9 53 722 1473 363 6064 1410 #contextMenu: 34 1 6288 6064 1506 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 228 2 0 0 207 0 0 0] 8 #() 1568 nil 27 6018 8 'HTML' 410 ##(Smalltalk.AXValueConvertingControlSite) 34 26 nil 5888 34 2 8 1140916224 1 6928 6130 nil false 6162 5154 #= 8 #() 5154 #hash 6240 nil 608 nil 5 nil nil nil 6928 nil 537169293 8 'Shell.Explorer' 787462 ##(Smalltalk.IWebBrowser2) nil nil 1444166 1 ##(Smalltalk.TKindInterfaceAnalyzer) 590598 ##(Smalltalk.ITypeInfo) nil nil 525062 ##(Smalltalk.TYPEATTR) nil 7168 7136 nil 1378630 2 ##(Smalltalk.AXTypeLibraryAnalyzer) 590342 ##(Smalltalk.ITypeLib2) nil nil 257 524550 ##(Smalltalk.TLIBATTR) 8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 8 '' 8 'Internet Explorer' #SHDocVwLib #SHDocVwConstants 170 176 8 #(#GUID #GUID) nil nil nil 11 nil nil nil nil 918022 ##(Smalltalk.IDolphinAxHost) nil nil 722438 ##(Smalltalk.AXEventSink) 170 176 8 #(268 #ClientToHostWindow:CY: 269 #SetSecureLockIcon: 270 #FileDownload:Cancel: 271 #NavigateError:URL:Frame:StatusCode:Cancel: 272 #PrivacyImpactedStateChange: 273 #NewWindow3:Cancel:dwFlags:bstrUrlContext:bstrUrl: 282 #SetPhishingFilterStatus: 283 #WindowStateChanged:dwValidFlagsMask: 284 #NewProcess:pWB2:Cancel: 285 #ThirdPartyUrlBlocked:dwCount: 286 #RedirectXDomainBlocked:StartURL:RedirectURL:Frame:StatusCode: 288 #WebWorkerStarted:bstrWorkerLabel: 289 #WebWorkerFinsihed: 290 #BeforeScriptExecute: 225 #PrintTemplateInstantiation: 226 #PrintTemplateTeardown: 227 #UpdatePageStatus:nPage:fDone: 102 #StatusTextChange: 104 #DownloadComplete 105 #CommandStateChange:Enable: 106 #DownloadBegin 108 #ProgressChange:ProgressMax: 112 #PropertyChange: 113 #TitleChange: 250 #BeforeNavigate2:URL:Flags:TargetFrameName:PostData:Headers:Cancel: 251 #NewWindow2:Cancel: 252 #NavigateComplete2:URL: 253 #OnQuit 254 #OnVisible: 255 #OnToolBar: 256 #OnMenuBar: 257 #OnStatusBar: 258 #OnFullScreen: 259 #DocumentComplete:URL: 260 #OnTheaterMode: 262 #WindowSetResizable: 263 #WindowClosing:Cancel: 264 #WindowSetLeft: 265 #WindowSetTop: 266 #WindowSetWidth: 267 #WindowSetHeight:) 6928 1049094 ##(Smalltalk.IConnectionPoint) nil nil 3 1378630 1 ##(Smalltalk.TKindDispatchAnalyzer) 656134 ##(Smalltalk.ITypeInfo2) nil nil 7186 nil 7536 7568 nil 7218 7250 nil nil 257 7282 8 #[192 42 178 234 193 48 207 17 167 235 0 0 192 91 174 11 0 0 0 0 1 0 0 0 1 0 1 0 8 0 0 0] 8 '' 8 'Internet Explorer' #SHDocVwLib #SHDocVwConstants 170 176 8 #(#GUID #GUID) nil nil 262198 ##(Smalltalk.GUID) 16 160 21 167 52 135 101 208 17 146 74 0 32 175 199 172 77 25 nil nil nil 1 3787 170 176 896 1508358 ##(Smalltalk.IAxWinAmbientDispatchEx) nil nil nil nil 524806 ##(Smalltalk.IUnknown) nil nil nil nil nil 6674 nil nil 1346 138 144 34 4 1410 #createAt:extent: 34 2 722 9 53 722 1473 363 6928 1410 #restoreAmbientProperties 896 6928 1410 #docHostFlags: 8 #(4) 6928 1410 #controlBinaryStoreBytes: 34 1 8 #[97 249 86 136 10 52 208 17 169 107 0 192 79 215 5 162 76 0 0 0 17 76 0 0 181 18 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 76 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 224 208 87 0 115 53 207 17 174 105 8 0 43 46 18 98 8 0 0 0 0 0 0 0 76 0 0 0 1 20 2 0 0 0 0 0 192 0 0 0 0 0 0 70 128 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 6928 1506 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 228 2 0 0 207 0 0 0] 8 #() 1568 nil 27 6018 8 'Text' 410 ##(Smalltalk.ScintillaView) 34 50 nil 5888 34 2 8 1174475012 1 8144 6130 nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 608 nil 23 4786 nil true 34 10 4834 1 978 #fileSave 8 '&Save file' 1 1 nil nil nil 4898 4097 4834 1 978 #cutSelection 8 'Cu&t' 1 1 nil nil nil 4834 1 978 #copySelection 8 '&Copy' 1 1 nil nil nil 4834 1 978 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 4834 1 978 #clearSelection 8 'De&lete' 1 1 nil nil nil 4898 4097 4834 1 978 #cloneNew 8 'Clo&ne' 1 1 nil nil nil 8544 4834 1 978 #clear 8 'Clea&r workspace' 1 1 nil nil nil 8 '&Workspace' nil 1 nil nil nil nil nil nil nil 8144 nil 8 1758514793 6674 nil nil 9 nil 170 192 34 8 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 8738 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 8738 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #callTip 8738 77 786694 ##(Smalltalk.IndexedColor) 33554457 8818 33554471 1 nil nil nil nil #callTip nil nil nil 34 40 8752 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 8784 nil nil nil 8768 nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) nil nil nil nil 8144 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 896 nil 170 176 896 9215 nil nil nil nil 8818 33554447 nil nil 65 nil nil nil 8 '' 1 170 192 896 nil nil nil nil 1 nil 170 192 34 6 8 'indicator0' 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 1 8144 65025 3 false nil nil nil nil nil nil nil 8 'indicator2' 9106 5 8144 511 1 false nil nil nil nil nil nil nil 8 'indicator1' 9106 3 8144 33423361 5 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 8738 1029 nil 6258 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 8738 1027 6258 60239 6258 31326207 1 nil nil nil nil #Warning nil nil nil #Error 8738 1031 6258 335 6258 31317503 1 nil nil nil nil #Error nil nil nil nil 1346 138 144 34 7 1410 #createAt:extent: 34 2 722 9 53 722 1473 363 8144 1410 #contextMenu: 34 1 8256 8144 1410 #textLimit: 8 #(1073741823) 8144 1410 #modificationEventMask: 8 #(4607) 8144 1410 #caretPeriod: 8 #(530) 8144 1410 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 8144 1 3 nil nil nil nil 9650 3 8144 1 nil nil 67108863 nil nil 9650 5 8144 1 nil nil nil nil nil 8144 1410 #maxCompletionListHeight: 8 #(9) 8144 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 228 2 0 0 207 0 0 0] 8 #() 1568 nil 29 6018 8 'Hex' 410 ##(Smalltalk.ScintillaView) 34 50 nil 5888 34 2 8 1174475012 1 9824 6130 nil false 8240 nil 608 nil 21 4786 nil true 34 11 4834 1 978 #saveFile 8 '&Save' 1 1 nil nil nil 4834 1 978 #saveFileAs 8 'Save &as' 1 1 nil nil nil 4898 4097 4834 1 978 #cutSelection 8 'Cu&t' 1 1 nil nil nil 4834 1 978 #copySelection 8 '&Copy' 1 1 nil nil nil 4834 1 978 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 4834 1 978 #clearSelection 8 'De&lete' 1 1 nil nil nil 4898 4097 4834 1 978 #cloneNew 8 'Clo&ne' 1 1 nil nil nil 4898 4097 4834 1 978 #clear 8 'Clea&r workspace' 1 1 nil nil nil 8 '&Workspace' nil 1 nil nil nil nil nil nil nil 9824 nil 8 1758514793 6674 nil nil 11 nil 170 192 34 8 #normal 8738 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 8738 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 8738 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #callTip 8738 77 8832 8848 1 nil nil nil nil #callTip nil nil nil 34 40 10448 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 10480 nil nil nil 10464 nil nil 8882 #normal 170 192 34 2 #default 8946 nil nil nil nil 9824 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 896 nil 170 176 896 9215 nil nil nil nil 9008 nil nil 65 nil nil nil 9024 1 170 192 896 nil nil nil nil 1 nil 170 192 34 6 8 'indicator1' 9106 3 9824 33423361 5 false nil nil nil nil nil nil nil 8 'indicator2' 9106 5 9824 511 1 false nil nil nil nil nil nil nil 8 'indicator0' 9106 1 9824 65025 3 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 8738 1029 nil 6258 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 8738 1027 6258 60239 6258 31326207 1 nil nil nil nil #Warning nil nil nil #Error 8738 1031 6258 335 6258 31317503 1 nil nil nil nil #Error nil nil nil nil 1346 138 144 34 7 1410 #createAt:extent: 34 2 722 9 53 722 1473 363 9824 1410 #contextMenu: 34 1 9904 9824 1410 #textLimit: 8 #(1073741823) 9824 1410 #modificationEventMask: 8 #(4607) 9824 1410 #caretPeriod: 8 #(530) 9824 1410 #margins: 34 1 34 3 9650 1 9824 1 3 nil nil nil nil 9650 3 9824 1 nil nil 67108863 nil nil 9650 5 9824 1 nil nil nil nil nil 9824 1410 #maxCompletionListHeight: 8 #(9) 9824 1506 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 228 2 0 0 207 0 0 0] 8 #() 1568 nil 29 8144 170 192 34 8 8144 8 'text' 6064 8 'image' 6928 8 'html' 9824 8 'hex' 3666 722 1 1 722 1 1 410 ##(Smalltalk.TabViewXP) 34 28 nil 5888 34 2 8 1140916736 1 11488 4738 138 144 34 4 8128 9808 6048 6912 nil 4080 480 nil 1 nil nil nil 11488 nil 8 1903376304 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 4176 nil nil nil nil nil #noIcons nil nil nil nil nil 1346 138 144 34 3 1410 #createAt:extent: 34 2 722 1 1 722 1489 423 11488 1410 #basicSelectionsByIndex: 34 1 8 #(1) 11488 1410 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 11488 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 232 2 0 0 211 0 0 0] 8 #() 1568 nil 27 1346 138 144 34 1 1410 #createAt:extent: 34 2 722 9 5 722 1489 423 5888 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 2 0 0 0 236 2 0 0 213 0 0 0] 34 5 8144 9824 6064 6928 11488 1568 nil 27 170 192 34 2 5888 8 'cards' 3666 722 9 5 722 9 1 1346 138 144 34 1 1410 #createAt:extent: 34 2 722 1 435 722 1505 427 5808 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 217 0 0 0 240 2 0 0 174 1 0 0] 34 1 5888 1568 nil 27 1568 nil 27 170 192 34 2 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 4786 nil true 34 12 4834 1 978 #fileNew 8 '&New file' 1 1 nil nil nil 4834 1 978 #fileOpen 8 'Root folder' 1 1 nil nil nil 4834 1 978 #fileSave 8 '&Save file' 1 1 nil nil nil 4834 1 978 #fileSaveAs 8 'Save file &as' 1 1 nil nil nil 4898 4097 4834 1 978 #enableHex 8 'Enable Hex' 1 1 nil nil nil 4834 1 978 #removeCr 8 'Remove Cr' 1 1 nil nil nil 4898 4097 4834 1 978 #pageSetup 8 'Page Setup...' 1 1 nil nil nil 4834 1 978 #print 8 'Print...' 1 1 nil nil nil 4898 4097 4834 1 978 #exit 8 'Close' 16615 1 nil nil nil 8 '&File' nil 1 nil nil 58661 nil nil 4786 nil true 34 11 4834 1 978 #undo 8 '&Undo' 9397 1 nil nil nil 4898 4097 4834 1 978 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 4834 1 978 #copySelection 8 '&Copy' 9351 1 nil nil nil 4834 1 978 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 4834 1 978 #clearSelection 8 '&Delete' 1 1 nil nil nil 4834 1 978 #selectAll 8 'Select &All' 9347 1 nil nil nil 4898 4097 4834 1 978 #find 8 '&Find...' 9357 1 nil nil nil 4834 1 978 #findNext 8 'Find &Next' 1253 1 nil nil nil 4834 1 978 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil 58681 nil nil 4786 nil true 8 #() 8 '&Tools' #toolsMenu 1 nil nil 58683 nil nil 4786 nil true 34 18 4834 1 978 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 49 786694 ##(Smalltalk.ShellLibrary) nil nil 4834 1 978 #help 8 'On this &Tool' 1249 1 nil nil nil 4834 1 978 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4898 4097 4834 1 978 #learnSmalltalk 8 'Learn Smalltalk' 1 1 nil nil nil 4898 4097 4834 1 978 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4834 1 978 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4834 1 978 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4898 4097 4834 1 978 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 nil nil nil 4834 1 978 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4834 1 978 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4834 1 978 #myDolphinAccount 8 'My Dolphin Account' 1 1 nil nil nil 4898 4097 4834 1 978 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 13538 nil true 13584 8 'LiveUpdate.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 4898 4097 4834 1 978 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 13538 nil true 13584 8 '!!APPLICATION' 14272 nil nil 8 '&Help' nil 134217729 nil nil 58711 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1346 138 144 34 3 1410 #createAt:extent: 34 2 722 3839 21 722 1537 1073 416 1410 #text: 34 1 8 'File Browser' 416 1410 #updateMenuBar 896 416 1506 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 127 10 0 0 34 2 0 0] 34 3 528 2704 2320 1568 nil 27 )!

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

