"Filed out from Dolphin Smallalk"!

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
	^false!

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
!FileBrowser categoriesForMethods!
about!commands!public! !
askAboutHex:!helpers!public! !
canFileIn!commands!public!testing! !
canPrint!printing!public!testing! !
clearTabs!helpers!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
enableHex!commands!public! !
fileDelete!commands!public! !
fileIn!commands!public! !
fileNew!commands!public! !
fileOpen!commands!public! !
fileSave!commands!public! !
fileSaveAs!commands!public! !
onCloseRequested:!event handling!public! !
onFileSelectionChanged!event handling!public! !
onFolderSelectionChanged!event handling!public! !
onSelectionChanging:!event handling!public! !
onSessionStarted!event handling!public! !
onViewOpened!event handling!public! !
promptForChanges!helpers!public! !
queryCommand:!commands!public! !
removeCr!commands!public! !
saveFile:!helpers!public! !
setHTML:!helpers!public! !
setImage:!helpers!public! !
showImageAs:!commands!public! !
updateFilesKeepingSelection!helpers!public! !
!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853548 131073 528 nil 466 #default nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 100 197 66 49 15 1 0 0 196 53 15 1 5 0 144 39 0 0 0 0 199 0 253 85 63 1] 328198 ##(Smalltalk.Point) 193 193 nil 528 592 8 1808128240 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 768 nil nil nil 7 nil nil nil 768 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Edit_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 690 155 1 690 247 51 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 0 0 0 0 200 0 0 0 25 0 0 0] 8 #() 690 193 193 nil 27 8 'editTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1104 nil nil nil 7 nil nil nil 1104 834 ##(Smalltalk.Toolbar) #resource_File_tools nil 866 138 144 34 1 930 #createAt:extent: 34 2 690 1 1 690 155 51 1104 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 77 0 0 0 25 0 0 0] 1056 1072 nil 27 8 'fileTools' 170 192 1056 138 144 1056 nil nil 1 nil 690 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 866 138 144 34 1 930 #createAt:extent: 34 2 690 1 1 690 1505 51 528 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 240 2 0 0 25 0 0 0] 34 3 1104 768 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1584 nil nil nil 7 nil nil nil 1584 834 ##(Smalltalk.Toolbar) #resource_Find_tools nil 866 138 144 34 1 930 #createAt:extent: 34 2 690 401 1 690 109 51 1584 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 200 0 0 0 0 0 0 0 254 0 0 0 25 0 0 0] 1056 1072 nil 27 1072 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 1808 nil 480 nil 7 nil 610 nil true 642 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 100 197 66 49 15 1 0 0 196 53 15 1 5 0 144 39 0 0 0 0 199 0 253 85 63 1] 690 193 193 nil 1808 nil 8 1807681552 170 192 1056 138 144 34 1 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 1808 nil 2016 nil 866 138 144 34 1 930 #createAt:extent: 34 2 690 1 911 690 1505 45 1808 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 199 1 0 0 240 2 0 0 221 1 0 0] 8 #() 1072 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2192 nil 480 nil 7 nil nil nil 2192 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 nil 2192 34 2 8 1140850688 1 2320 nil 592 nil 7 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2320 nil 1 #left nil nil nil 690 1 1 690 9 9 nil 2416 nil 866 138 144 34 1 930 #createAt:extent: 34 2 690 1 427 690 1505 9 2320 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 213 0 0 0 240 2 0 0 217 0 0 0] 8 #() 1072 nil 27 1 true 170 192 1056 nil 866 138 144 34 1 930 #createAt:extent: 34 2 690 1 51 690 1505 861 2192 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 240 2 0 0 199 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2192 34 2 8 1140850688 131073 2784 nil 480 nil 7 nil nil nil 2784 2258 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 nil 2784 34 2 8 1140850688 1 2896 nil 592 nil 7 nil nil nil 2386 2896 nil 1 #left nil nil nil 2416 2432 nil 2416 nil 866 138 144 34 1 930 #createAt:extent: 34 2 690 749 1 690 9 423 2896 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 118 1 0 0 0 0 0 0 122 1 0 0 211 0 0 0] 8 #() 1072 nil 27 1 false 170 192 1056 590342 ##(Smalltalk.Rectangle) 690 9 1 690 9 5 866 138 144 34 1 930 #createAt:extent: 34 2 690 1 1 690 1505 427 2784 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 240 2 0 0 213 0 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2784 34 2 8 1140850688 131073 3376 nil 592 nil 7 nil nil nil 3376 498 1 1 nil nil nil nil 410 ##(Smalltalk.TreeView) 34 27 nil 3376 34 2 8 1140916775 1025 3456 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 1056 592 nil 7 nil nil nil 3456 nil 8 1807880144 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil 170 176 1056 nil #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 1056 866 138 144 34 1 930 #createAt:extent: 34 2 690 1 1 690 741 423 3456 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 114 1 0 0 211 0 0 0] 8 #() 1072 nil 27 170 192 34 2 3456 8 'folders' nil 866 138 144 34 1 930 #createAt:extent: 34 2 690 9 1 690 741 423 3376 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 0 0 0 0 118 1 0 0 211 0 0 0] 34 1 3456 1072 nil 27 2896 410 ##(Smalltalk.ContainerView) 34 15 nil 2784 34 2 8 1140850688 131073 4080 nil 592 nil 7 nil nil nil 4080 498 1 1 nil nil nil nil 410 ##(Smalltalk.ListView) 34 45 nil 4080 34 2 8 1140920397 1025 4160 590662 2 ##(Smalltalk.ListModel) 138 144 1056 nil 3568 592 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileSave 8 '&Save file' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4322 1 4354 #fileIn 8 '&File in' 1 1 nil nil nil 4402 4097 4322 1 4354 #fileDelete 8 '&Delete file' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 4160 nil 8 1808102576 ##(Smalltalk.BasicListAbstract) nil 3664 nil nil nil nil nil nil 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Name' 313 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() 4658 #name 8 #() nil 4160 nil 3 nil nil 4610 8 'Type' 101 #right ##(Smalltalk.BasicListAbstract) 4658 #<= 8 #() 4658 #type 4720 nil 4160 nil 1 nil nil 4610 8 'Size' 161 #right ##(Smalltalk.BasicListAbstract) 4658 #<= 8 #() 4658 #size 4720 nil 4160 nil 1 nil nil 4610 8 'Date' 161 #right ##(Smalltalk.BasicListAbstract) 4658 #<= 8 #() 4658 #timeStamp 4720 nil 4160 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 866 138 144 34 3 930 #createAt:extent: 34 2 690 1 1 690 741 423 4160 930 #contextMenu: 34 1 4288 4160 930 #text: 34 1 8 'Name' 4160 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 114 1 0 0 211 0 0 0] 8 #() 1072 nil 35 170 192 34 2 4160 8 'files' nil 866 138 144 34 1 930 #createAt:extent: 34 2 690 757 1 690 741 423 4080 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 1 0 0 0 0 0 0 236 2 0 0 211 0 0 0] 34 1 4160 1072 nil 27 1072 nil 27 2320 410 ##(Smalltalk.ContainerView) 34 15 nil 2192 34 2 8 1140850688 131073 5440 nil 480 nil 7 nil nil nil 5440 498 1 1 nil nil nil nil 410 ##(Smalltalk.CardContainer) 34 16 nil 5440 34 2 8 1140850688 131073 5520 nil 480 nil 7 nil nil nil 5520 656710 1 ##(Smalltalk.CardLayout) 138 144 34 4 721414 ##(Smalltalk.Association) 590662 1 ##(Smalltalk.CardLabel) 8 'Images' 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[Image icon]' 8 #[31 105 45 159 106] 983558 ##(Smalltalk.VariableBinding) #Image ##(Smalltalk.Image) #icon 5744 7 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 5520 34 2 8 1140850944 1 5872 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 4658 #= 8 #() 4658 #hash 8 #() nil 466 #white nil 5 4274 nil true 34 4 4322 1 4354 4658 #showImageAs: 8 #(#normal) 8 'Normal' 1 1 nil nil nil 4322 1 4354 4658 #showImageAs: 8 #(#centered) 8 'Centered' 1 1 nil nil nil 4322 1 4354 4658 #showImageAs: 8 #(#scale) 8 'Scale' 1 1 nil nil nil 4322 1 4354 4658 #showImageAs: 8 #(#scaleToFit) 8 'Scale To Fit' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 5872 nil 8 4294903085 852486 ##(Smalltalk.NullConverter) nil nil nil nil #centered 1 nil nil 866 138 144 34 2 930 #createAt:extent: 34 2 690 9 53 690 1473 363 5872 930 #contextMenu: 34 1 6080 5872 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 228 2 0 0 207 0 0 0] 8 #() 1072 nil 27 5650 5682 8 'HTML' 5730 0 nil 5762 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[WebView2View icon]' 8 #[31 105 45 159 106] 5842 #WebView2View ##(Smalltalk.WebView2View) #icon 6736 7 1 nil nil 410 ##(Smalltalk.WebView2View) 34 22 nil 5520 34 2 8 1140916224 1 6832 5938 nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 5 nil nil nil 6832 nil nil 6466 nil nil 1 nil nil nil nil 1442310 ##(Smalltalk.ICoreWebView2Settings5) nil nil nil 866 138 144 34 1 930 #createAt:extent: 34 2 690 9 53 690 1473 363 6832 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 228 2 0 0 207 0 0 0] 1056 1072 nil 27 5650 5682 8 'Hex' 5730 0 nil 5762 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[Integer icon]' 8 #[31 105 45 159 106] 5842 #Integer ##(Smalltalk.Integer) #icon 7184 7 1 nil nil 410 ##(Smalltalk.ScintillaView) 34 65 nil 5520 34 2 8 1174475012 1 7280 5938 nil false 6928 nil 592 nil 21 4274 nil true 34 11 4322 1 4354 #saveFile 8 '&Save' 1 1 nil nil nil 4322 1 4354 #saveFileAs 8 'Save &as' 1 1 nil nil nil 4402 4097 4322 1 4354 #cutSelection 8 'Cu&t' 1 1 nil nil nil 4322 1 4354 #copySelection 8 '&Copy' 1 1 nil nil nil 4322 1 4354 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 4322 1 4354 #clearSelection 8 'De&lete' 1 1 nil nil nil 4402 4097 4322 1 4354 #cloneNew 8 'Clo&ne' 1 1 nil nil nil 4402 4097 4322 1 4354 #clear 8 'Clea&r workspace' 1 1 nil nil nil 8 '&Workspace' nil 1 nil nil nil nil nil nil nil 7280 nil 8 1834434024 6466 nil nil 11 1800510369 170 192 34 8 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 7906 77 466 #gray 6064 1 nil nil nil nil #callTip nil nil nil #lineNumber 7906 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #indentGuide 7906 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) nil nil nil nil 7280 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1056 nil 170 176 1056 9215 nil nil nil nil 466 #silver nil nil 65 nil nil nil 8 '' 1 170 192 1056 nil nil nil nil 16 nil 170 192 34 6 8 'indicator1' 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 3 7280 466 #blue 5 false nil nil nil nil nil nil nil 8 'indicator0' 8226 1 7280 466 #commonGreen 3 false nil nil nil nil nil nil nil 8 'indicator2' 8226 5 7280 466 #red 1 false nil nil nil nil nil nil nil nil nil 170 192 1056 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 866 138 144 34 7 930 #createAt:extent: 34 2 690 9 53 690 1473 363 7280 930 #contextMenu: 34 1 7360 7280 930 #caretPeriod: 8 #(530) 7280 930 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 7280 1 3 nil nil nil nil 8610 3 7280 1 nil nil 67108863 nil nil 8610 5 7280 1 nil nil nil nil nil 7280 930 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 7280 930 #maxCompletionListHeight: 8 #(9) 7280 930 #edgeColumn: 8 #(1) 7280 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 228 2 0 0 207 0 0 0] 8 #() 1072 nil 33 5650 5682 8 'Text' 5730 0 nil 5762 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 ' [String icon]' 8 #[31 105 45 159 106] 5842 #String ##(Smalltalk.String) #icon 8896 7 1 nil nil 410 ##(Smalltalk.ScintillaView) 34 65 nil 5520 34 2 8 1174475012 1 8992 5938 nil false 6928 nil 592 nil 23 4274 nil true 34 10 4322 1 4354 #fileSave 8 '&Save file' 1 1 nil nil nil 4402 4097 4322 1 4354 #cutSelection 8 'Cu&t' 1 1 nil nil nil 4322 1 4354 #copySelection 8 '&Copy' 1 1 nil nil nil 4322 1 4354 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 4322 1 4354 #clearSelection 8 'De&lete' 1 1 nil nil nil 4402 4097 4322 1 4354 #cloneNew 8 'Clo&ne' 1 1 nil nil nil 9360 4322 1 4354 #clear 8 'Clea&r workspace' 1 1 nil nil nil 8 '&Workspace' nil 1 nil nil nil nil nil nil nil 8992 nil 8 1834434024 6466 nil nil 9 1800501633 170 192 34 8 #normal 7906 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 7906 77 7952 6064 1 nil nil nil nil #callTip nil nil nil #lineNumber 7906 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #indentGuide 7906 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil nil 8002 #normal 170 192 34 2 #default 8066 nil nil nil nil 8992 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1056 nil 170 176 1056 9215 nil nil nil nil 8128 nil nil 65 nil nil nil 8144 1 170 192 1056 nil nil nil nil 16 nil 170 192 34 6 8 'indicator0' 8226 1 8992 8304 3 false nil nil nil nil nil nil nil 8 'indicator2' 8226 5 8992 8352 1 false nil nil nil nil nil nil nil 8 'indicator1' 8226 3 8992 8256 5 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 7906 1027 466 #darkGoldenrod 466 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 7906 1031 466 #firebrick 466 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 7906 1029 nil 466 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 866 138 144 34 7 930 #createAt:extent: 34 2 690 9 53 690 1473 363 8992 930 #contextMenu: 34 1 9072 8992 930 #caretPeriod: 8 #(530) 8992 930 #margins: 34 1 34 3 8610 1 8992 1 3 nil nil nil nil 8610 3 8992 1 nil nil 67108863 nil nil 8610 5 8992 1 nil nil nil nil nil 8992 930 #targetRange: 34 1 8706 1 -1 3 8992 930 #maxCompletionListHeight: 8 #(9) 8992 930 #edgeColumn: 8 #(1) 8992 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 228 2 0 0 207 0 0 0] 8 #() 1072 nil 33 8992 nil nil nil 170 192 34 8 6832 8 'html' 5872 8 'image' 8992 8 'text' 7280 8 'hex' 3154 690 1 1 690 1 1 410 ##(Smalltalk.TabViewXP) 34 28 nil 5520 34 2 8 1140916736 1 10592 4226 138 144 34 4 8864 7152 5696 6704 nil 3568 480 nil 1 nil nil nil 10592 nil 8 1807915888 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 3664 nil nil nil nil nil #smallIcons nil nil nil nil nil 866 138 144 34 3 930 #createAt:extent: 34 2 690 1 1 690 1489 423 10592 930 #setSingleSelection: 8 #(1) 10592 930 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 10592 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 232 2 0 0 211 0 0 0] 8 #() 1072 nil 27 866 138 144 34 1 930 #createAt:extent: 34 2 690 9 5 690 1489 423 5520 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 2 0 0 0 236 2 0 0 213 0 0 0] 34 5 8992 7280 5872 6832 10592 1072 nil 27 170 192 34 2 5520 8 'cards' 3154 690 9 5 690 9 1 866 138 144 34 1 930 #createAt:extent: 34 2 690 1 435 690 1505 427 5440 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 217 0 0 0 240 2 0 0 174 1 0 0] 34 1 5520 1072 nil 27 1072 nil 27 170 192 34 2 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 4274 nil true 34 12 4322 1 4354 #fileNew 8 '&New file' 1 1 nil nil nil 4322 1 4354 #fileOpen 8 'Root folder' 1 1 nil nil nil 4322 1 4354 #fileSave 8 '&Save file' 1 1 nil nil nil 4322 1 4354 #fileSaveAs 8 'Save file &as' 1 1 nil nil nil 4402 4097 4322 1 4354 #enableHex 8 'Enable Hex' 1 1 nil nil nil 4322 1 4354 #removeCr 8 'Remove Cr' 1 1 nil nil nil 4402 4097 4322 1 4354 #pageSetup 8 'Page Setup...' 1 1 nil nil nil 4322 1 4354 #print 8 'Print...' 1 1 nil nil nil 4402 4097 4322 1 4354 #exit 8 'Close' 16615 1 nil nil nil 8 '&File' nil 1 nil nil 34067 nil nil 4274 nil true 34 11 4322 1 4354 #undo 8 '&Undo' 9397 1 nil nil nil 4402 4097 4322 1 4354 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 4322 1 4354 #copySelection 8 '&Copy' 9351 1 nil nil nil 4322 1 4354 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 4322 1 4354 #clearSelection 8 '&Delete' 1 1 nil nil nil 4322 1 4354 #selectAll 8 'Select &All' 9347 1 nil nil nil 4402 4097 4322 1 4354 #find 8 '&Find...' 9357 1 nil nil nil 4322 1 4354 #findNext 8 'Find &Next' 1253 1 nil nil nil 4322 1 4354 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil 34087 nil nil 4274 nil true 8 #() 8 '&Tools' #toolsMenu 1 nil nil 34089 nil nil 4274 nil true 34 15 4322 1 4354 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Help.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 4322 1 4354 #help 8 'On this &Tool' 1249 1 nil nil nil 4322 1 4354 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4402 4097 4322 1 4354 #learnSmalltalk 8 'Learn Smalltalk' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $\x1F393 nil 466 #orchid 6064 nil nil 1 nil nil nil nil 4402 4097 4322 1 4354 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4322 1 4354 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4322 1 4354 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4402 4097 4322 1 4354 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 12626 nil true 12672 8 '!!APPLICATION' 12720 nil nil 4322 1 4354 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4322 1 4354 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4402 4097 4322 1 4354 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 12914 $\x1F42C nil nil 466 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 34113 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 866 138 144 34 2 930 #createAt:extent: 34 2 690 12287 21 690 1537 1073 416 930 #text: 34 1 8 'File Browser' 416 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 255 26 0 0 34 2 0 0] 34 3 528 2192 1808 1072 nil 27 )!

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
!FileBrowser class categoriesForMethods!
defaultFolder!accessing!public! !
displayOn:!operations!public! !
hexEnabled!accessing!public! !
hexEnabled:!accessing!public! !
hexFont!accessing!public! !
hexFont:!accessing!public! !
icon!constants!public! !
publishedAspects!initializing!public! !
removeCr!accessing!public! !
removeCr:!accessing!public! !
resource_Default_view!public!resources-views! !
rootFolder!accessing!public! !
rootFolder:!accessing!public! !
textFont!accessing!public! !
textFont:!accessing!public! !
warnings!accessing!public! !
warnings:!accessing!public! !
!

