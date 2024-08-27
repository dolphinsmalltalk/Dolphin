"Filed out from Dolphin Smalltalk"!

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
	image value: (GdiplusImage fromFile: aFileBrowserFile path).
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

	^##((TextTileIcon
		text: $\xEC50
		fontName: 'Segoe Fluent Icons'
		color: Color red)
		margin: 1;
		yourself)!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1140853548 131073 528 nil 466 #default nil 519 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 528 592 8 1795812352 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 736 nil nil nil 7 nil nil nil 736 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_File_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 0 0 0 0 77 0 0 0 25 0 0 0] 193 768 8 '' 736 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'fileTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1104 nil nil nil 7 nil nil nil 1104 802 ##(Smalltalk.Toolbar) #resource_Edit_tools nil 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[77 0 0 0 0 0 0 0 200 0 0 0 25 0 0 0] 193 1136 8 '' 1104 3 1040 1058 193 193 nil 27 8 'editTools' nil nil nil 170 192 1040 138 144 1040 nil nil 9 509 #smallIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[0 0 0 0 0 0 0 0 240 2 0 0 25 0 0 0] 193 560 8 '' 528 3 34 3 736 1104 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1584 nil nil nil 7 nil nil nil 1584 802 ##(Smalltalk.Toolbar) #resource_Find_tools nil 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[200 0 0 0 0 0 0 0 254 0 0 0 25 0 0 0] 193 1616 8 '' 1584 3 1040 1058 193 193 nil 27 1058 193 193 nil 31 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1140850956 1 1840 nil 480 nil 7 nil 610 nil true 642 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1840 nil 8 1795505344 170 192 1040 nil nil nil 138 144 34 1 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 1840 nil 2032 nil 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[0 0 0 0 199 1 0 0 240 2 0 0 221 1 0 0] 193 1872 8 '' 1840 3 8 #() 1058 193 193 nil 29 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2224 nil 480 nil 7 nil nil nil 2224 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 nil 2224 34 2 8 1140850688 1 2352 nil 592 nil 7 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2352 nil 1 #left nil nil nil 1058 1 1 1058 9 9 nil 2448 nil 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[0 0 0 0 213 0 0 0 240 2 0 0 217 0 0 0] 193 2384 8 '' 2352 3 8 #() 1058 193 193 nil 27 1 true 170 192 1040 nil 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[0 0 0 0 25 0 0 0 240 2 0 0 199 1 0 0] 193 2256 8 '' 2224 3 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2224 34 2 8 1140850688 131073 2832 nil 480 nil 7 nil nil nil 2832 2290 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 nil 2832 34 2 8 1140850688 1 2944 nil 592 nil 7 nil nil nil 2418 2944 nil 1 #left nil nil nil 2448 2464 nil 2448 nil 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[118 1 0 0 0 0 0 0 122 1 0 0 211 0 0 0] 193 2976 8 '' 2944 3 8 #() 1058 193 193 nil 27 1 false 170 192 1040 590342 ##(Smalltalk.Rectangle) 1058 9 1 1058 9 5 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[0 0 0 0 0 0 0 0 240 2 0 0 213 0 0 0] 193 2864 8 '' 2832 3 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2832 34 2 8 1140850688 131073 3440 nil 592 nil 7 nil nil nil 3440 498 1 1 nil nil nil nil 410 ##(Smalltalk.TreeView) 34 27 nil 3440 34 2 8 1140916775 1025 3520 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 1040 592 nil 7 nil nil nil 3520 nil 8 1795466160 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil 170 176 1040 nil #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 1040 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[0 0 0 0 0 0 0 0 114 1 0 0 211 0 0 0] 193 3552 8 '' 3520 3 8 #() 1058 193 193 nil 27 170 192 34 2 3520 8 'folders' nil 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[4 0 0 0 0 0 0 0 118 1 0 0 211 0 0 0] 193 3472 8 '' 3440 3 34 1 3520 1058 193 193 nil 27 2944 410 ##(Smalltalk.ContainerView) 34 15 nil 2832 34 2 8 1140850688 131073 4176 nil 592 nil 7 nil nil nil 4176 498 1 1 nil nil nil nil 410 ##(Smalltalk.ListView) 34 45 nil 4176 34 2 8 1140920397 1025 4256 590662 2 ##(Smalltalk.ListModel) 138 144 1040 nil 3632 592 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileSave 8 '&Save file' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4418 1 4450 #fileIn 8 '&File in' 1 1 nil nil nil 4498 4097 4418 1 4450 #fileDelete 8 '&Delete file' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 4256 nil 8 1795768528 ##(Smalltalk.BasicListAbstract) nil 3728 nil nil nil nil nil nil 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Name' 313 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() 4754 #name 8 #() nil 4256 nil 3 nil nil 4706 8 'Type' 101 #right ##(Smalltalk.BasicListAbstract) 4754 #<= 8 #() 4754 #type 4816 nil 4256 nil 1 nil nil 4706 8 'Size' 161 #right ##(Smalltalk.BasicListAbstract) 4754 #<= 8 #() 4754 #size 4816 nil 4256 nil 1 nil nil 4706 8 'Date' 161 #right ##(Smalltalk.BasicListAbstract) 4754 #<= 8 #() 4754 #timeStamp 4816 nil 4256 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 834 138 144 34 2 898 #createWindow: 34 1 946 978 8 #[0 0 0 0 0 0 0 0 114 1 0 0 211 0 0 0] 193 4288 8 'Name' 4256 898 #contextMenu: 34 1 4384 4256 3 8 #() 1058 193 193 nil 35 170 192 34 2 4256 8 'files' nil 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[122 1 0 0 0 0 0 0 236 2 0 0 211 0 0 0] 193 4208 8 '' 4176 3 34 1 4256 1058 193 193 nil 27 1058 193 193 nil 27 2352 410 ##(Smalltalk.ContainerView) 34 15 nil 2224 34 2 8 1140850688 131073 5536 nil 480 nil 7 nil nil nil 5536 498 1 1 nil nil nil nil 410 ##(Smalltalk.CardContainer) 34 16 nil 5536 34 2 8 1140850688 131073 5616 nil 480 nil 7 nil nil nil 5616 656710 1 ##(Smalltalk.CardLayout) 138 144 34 4 721414 ##(Smalltalk.Association) 590662 1 ##(Smalltalk.CardLabel) 8 'Images' 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[Image icon]' 8 #[31 105 45 159 106] 983558 ##(Smalltalk.VariableBinding) #Image ##(Smalltalk.Image) #icon 5840 7 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 5616 34 2 8 1140850944 1 5968 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 4754 #= 8 #() 4754 #hash 8 #() nil 466 #white nil 7 4370 nil true 34 4 4418 1 4450 4754 #showImageAs: 8 #(#normal) 8 'Normal' 1 1 nil nil nil 4418 1 4450 4754 #showImageAs: 8 #(#centered) 8 'Centered' 1 1 nil nil nil 4418 1 4450 4754 #showImageAs: 8 #(#scale) 8 'Scale' 1 1 nil nil nil 4418 1 4450 4754 #showImageAs: 8 #(#scaleToFit) 8 'Scale To Fit' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 5968 nil 8 4294903085 852486 ##(Smalltalk.NullConverter) nil nil nil nil #centered 1 nil nil 834 138 144 34 3 898 #createWindow: 34 1 946 978 8 #[4 0 0 0 24 0 0 0 228 2 0 0 207 0 0 0] 193 6000 nil 5968 898 #contextMenu: 34 1 6176 5968 898 #text: 34 1 8 '' 5968 3 8 #() 1058 193 193 nil 27 5746 5778 8 'HTML' 5826 0 nil 5858 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[WebView2View icon]' 8 #[31 105 45 159 106] 5938 #WebView2View ##(Smalltalk.WebView2View) #icon 6880 7 1 nil nil 410 ##(Smalltalk.WebView2View) 34 21 nil 5616 34 2 8 1140916224 1 6976 6034 nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 5 nil nil nil 6976 nil nil 6562 nil nil 1 nil nil nil nil nil 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[4 0 0 0 24 0 0 0 228 2 0 0 207 0 0 0] 193 7008 8 '' 6976 1 1040 1058 193 193 nil 27 5746 5778 8 'Hex' 5826 0 nil 5858 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[Integer icon]' 8 #[31 105 45 159 106] 5938 #Integer ##(Smalltalk.Integer) #icon 7312 7 1 nil nil 410 ##(Smalltalk.ScintillaView) 34 65 nil 5616 34 2 8 1174475012 1 7408 6034 nil false 7072 nil 592 nil 21 4370 nil true 34 11 4418 1 4450 #saveFile 8 '&Save' 1 1 nil nil nil 4418 1 4450 #saveFileAs 8 'Save &as' 1 1 nil nil nil 4498 4097 4418 1 4450 #cutSelection 8 'Cu&t' 1 1 nil nil nil 4418 1 4450 #copySelection 8 '&Copy' 1 1 nil nil nil 4418 1 4450 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 4418 1 4450 #clearSelection 8 'De&lete' 1 1 nil nil nil 4498 4097 4418 1 4450 #cloneNew 8 'Clo&ne' 1 1 nil nil nil 4498 4097 4418 1 4450 #clear 8 'Clea&r workspace' 1 1 nil nil nil 8 '&Workspace' nil 1 nil nil nil nil nil nil nil 7408 nil 8 1541291496 6562 nil nil 11 2010006577 170 192 34 8 #lineNumber 1182790 1 ##(Smalltalk.ScintillaTextStyle) 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 8034 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 8034 77 466 #gray 6160 1 nil nil nil nil #callTip nil nil nil #indentGuide 8034 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) nil nil nil nil 7408 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1040 nil 170 176 1040 9215 nil nil nil nil 466 #silver nil nil 65 nil nil nil 8 '' 1 170 192 1040 nil nil nil nil 16 nil 170 192 34 6 8 'indicator0' 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 1 7408 466 #commonGreen 3 false nil nil nil nil nil nil nil 8 'indicator1' 8354 3 7408 466 #blue 5 false nil nil nil nil nil nil nil 8 'indicator2' 8354 5 7408 466 #red 1 false nil nil nil nil nil nil nil nil nil 170 192 1040 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 834 138 144 34 7 898 #createWindow: 34 1 946 978 8 #[4 0 0 0 24 0 0 0 228 2 0 0 207 0 0 0] 193 7440 nil 7408 898 #contextMenu: 34 1 7488 7408 898 #caretPeriod: 8 #(530) 7408 898 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 7408 1 3 nil nil nil nil 8754 3 7408 1 nil nil 67108863 nil nil 8754 5 7408 1 nil nil nil nil nil 7408 898 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 7408 898 #maxCompletionListHeight: 8 #(9) 7408 898 #edgeColumn: 8 #(1) 7408 1 8 #() 1058 193 193 nil 33 5746 5778 8 'Text' 5826 0 nil 5858 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 ' [String icon]' 8 #[31 105 45 159 106] 5938 #String ##(Smalltalk.String) #icon 9024 7 1 nil nil 410 ##(Smalltalk.ScintillaView) 34 65 nil 5616 34 2 8 1174475012 1 9120 6034 nil false 7072 nil 592 nil 21 4370 nil true 34 10 4418 1 4450 #fileSave 8 '&Save file' 1 1 nil nil nil 4498 4097 4418 1 4450 #cutSelection 8 'Cu&t' 1 1 nil nil nil 4418 1 4450 #copySelection 8 '&Copy' 1 1 nil nil nil 4418 1 4450 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 4418 1 4450 #clearSelection 8 'De&lete' 1 1 nil nil nil 4498 4097 4418 1 4450 #cloneNew 8 'Clo&ne' 1 1 nil nil nil 9488 4418 1 4450 #clear 8 'Clea&r workspace' 1 1 nil nil nil 8 '&Workspace' nil 1 nil nil nil nil nil nil nil 9120 nil 8 1541291496 6562 nil nil 9 2013764401 170 192 34 8 #lineNumber 8034 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #normal 8034 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 8034 77 8096 6160 1 nil nil nil nil #callTip nil nil nil #indentGuide 8034 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil nil 8130 #normal 170 192 34 2 #default 8194 nil nil nil nil 9120 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1040 nil 170 176 1040 9215 nil nil nil nil 8256 nil nil 65 nil nil nil 8272 1 170 192 1040 nil nil nil nil 16 nil 170 192 34 6 8 'indicator1' 8354 3 9120 8432 5 false nil nil nil nil nil nil nil 8 'indicator2' 8354 5 9120 8480 1 false nil nil nil nil nil nil nil 8 'indicator0' 8354 1 9120 8384 3 false nil nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 8034 1027 466 #darkGoldenrod 466 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 8034 1031 466 #firebrick 466 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 8034 1029 nil 466 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 834 138 144 34 7 898 #createWindow: 34 1 946 978 8 #[4 0 0 0 24 0 0 0 228 2 0 0 207 0 0 0] 193 9152 nil 9120 898 #contextMenu: 34 1 9200 9120 898 #caretPeriod: 8 #(530) 9120 898 #margins: 34 1 34 3 8754 1 9120 1 3 nil nil nil nil 8754 3 9120 1 nil nil 67108863 nil nil 8754 5 9120 1 nil nil nil nil nil 9120 898 #targetRange: 34 1 8850 1 -1 3 9120 898 #maxCompletionListHeight: 8 #(9) 9120 898 #edgeColumn: 8 #(1) 9120 1 8 #() 1058 193 193 nil 33 5968 nil nil nil 170 192 34 8 9120 8 'text' 7408 8 'hex' 5968 8 'image' 6976 8 'html' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 5616 34 2 8 1140916736 1 10672 4322 138 144 34 4 8992 7280 5792 6848 nil 3632 480 nil 1 nil nil nil 10672 nil 8 1795364496 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 3728 nil nil nil nil nil #smallIcons nil nil nil nil nil 834 138 144 34 3 898 #createWindow: 34 1 946 978 8 #[0 0 0 0 0 0 0 0 232 2 0 0 211 0 0 0] 193 10704 8 '' 10672 898 #setSingleSelection: 8 #(3) 10672 898 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 10672 3 8 #() 1058 193 193 nil 27 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[4 0 0 0 2 0 0 0 236 2 0 0 213 0 0 0] 193 5648 8 '' 5616 3 34 5 9120 7408 5968 6976 10672 1058 193 193 nil 27 170 192 34 2 5616 8 'cards' 3218 1058 9 5 1058 9 1 834 138 144 34 1 898 #createWindow: 34 1 946 978 8 #[0 0 0 0 217 0 0 0 240 2 0 0 174 1 0 0] 193 5568 8 '' 5536 3 34 1 5616 1058 193 193 nil 27 1058 193 193 nil 27 170 192 34 2 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 4370 nil true 34 12 4418 1 4450 #fileNew 8 '&New file' 1 1 nil nil nil 4418 1 4450 #fileOpen 8 'Root folder' 1 1 nil nil nil 4418 1 4450 #fileSave 8 '&Save file' 1 1 nil nil nil 4418 1 4450 #fileSaveAs 8 'Save file &as' 1 1 nil nil nil 4498 4097 4418 1 4450 #enableHex 8 'Enable Hex' 1 1 nil nil nil 4418 1 4450 #removeCr 8 'Remove Cr' 1 1 nil nil nil 4498 4097 4418 1 4450 #pageSetup 8 'Page Setup...' 1 1 nil nil nil 4418 1 4450 #print 8 'Print...' 1 1 nil nil nil 4498 4097 4418 1 4450 #exit 8 'Close' 16615 1 nil nil nil 8 '&File' nil 1 nil nil 16003 nil nil 4370 nil true 34 11 4418 1 4450 #undo 8 '&Undo' 9397 1 nil nil nil 4498 4097 4418 1 4450 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 4418 1 4450 #copySelection 8 '&Copy' 9351 1 nil nil nil 4418 1 4450 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 4418 1 4450 #clearSelection 8 '&Delete' 1 1 nil nil nil 4418 1 4450 #selectAll 8 'Select &All' 9347 1 nil nil nil 4498 4097 4418 1 4450 #find 8 '&Find...' 9357 1 nil nil nil 4418 1 4450 #findNext 8 'Find &Next' 1253 1 nil nil nil 4418 1 4450 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil 16023 nil nil 4370 nil true 8 #() 8 '&Tools' #toolsMenu 1 nil nil 16025 nil nil 4370 nil true 34 15 4418 1 4450 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Help.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 4418 1 4450 #help 8 'On this &Tool' 1249 1 nil nil nil 4418 1 4450 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4498 4097 4418 1 4450 #learnSmalltalk 8 'Learn Smalltalk' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $🎓 nil 466 #orchid 6160 nil nil 1 nil nil nil nil 4498 4097 4418 1 4450 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4418 1 4450 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4418 1 4450 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4498 4097 4418 1 4450 #dolphinHomePage 8 'Dolphin Homepage' 1 1 12770 nil true 12816 8 '!!APPLICATION' 12864 nil nil 4418 1 4450 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4418 1 4450 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4498 4097 4418 1 4450 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 13058 $🐬 nil nil 466 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 16049 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 834 138 144 34 1 898 #createWindow: 34 1 946 3218 1058 6143 21 1058 7679 1093 193 448 8 'File Browser' 416 1 34 3 528 2224 1840 1058 193 193 nil 27 )!

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

