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

	aValueHolder value: self promptForChanges not!

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
				beEnabled;
				isChecked: hexEnabled.
			^true].
	#removeCr == aCommandQuery command
		ifTrue: 
			[aCommandQuery
				beEnabled;
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

release
	"Remove references to objects that may refer back to the receiver. "

	super release.
	SessionManager current removeEventsTriggeredFor: self.!

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
release!dependency!public! !
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

displayOn: aPuttableStream
	aPuttableStream nextPutAll: 'File Browser'!

hexEnabled
	"Answer whether the hex display is enabled"

	self ensureOptionsLoaded.
	^HexEnabled!

hexEnabled: aBoolean 
	"Set whether the hex display is enabled"

	self hexEnabled = aBoolean ifTrue: [^self].
	HexEnabled := aBoolean.
	self persistOptions!

hexFont
	"Answer the font used for the hex view"

	self ensureOptionsLoaded.
	^HexFont!

hexFont: aFont 
	"Set the font used for the hex view"

	self hexFont = aFont ifTrue: [^self].
	HexFont := aFont.
	self persistOptions!

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
		add: ((Aspect font: #textFont)
					defaultValue: [Font name: 'Times New Roman' pointSize: 12];
					yourself);
		add: ((Aspect font: #hexFont)
					defaultValue: [Font name: 'Courier New' pointSize: 10];
					yourself);
		add: (Aspect folder: #rootFolder);
		add: (Aspect boolean: #hexEnabled);
		add: (Aspect boolean: #removeCr);
		add: ((Aspect boolean: #warnings)
					defaultValue: true;
					yourself).
	^aspects!

removeCr
	"Answer whether we reove Crs before saving"

	self ensureOptionsLoaded.
	^RemoveCr!

removeCr: aBoolean 
	"Set whether we remove Crs when saving"

	self removeCr = aBoolean ifTrue: [^self].
	RemoveCr := aBoolean.
	self persistOptions!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #face3d nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1140853548 131073 528 nil 466 #default nil 517 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 528 592 nil 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 720 nil nil nil 5 nil nil nil 720 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Edit_tools nil 983302 ##(Smalltalk.MessageSequence) 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[77 0 0 0 0 0 0 0 200 0 0 0 25 0 0 0] 193 752 8 '' 720 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'editTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1072 nil nil nil 5 nil nil nil 1072 786 ##(Smalltalk.Toolbar) #resource_File_tools nil 818 34 1 866 #createWindow: 34 1 914 946 8 #[0 0 0 0 0 0 0 0 77 0 0 0 25 0 0 0] 193 1104 8 '' 1072 3 1008 1026 193 193 nil 27 8 'fileTools' nil nil nil nil 138 144 1008 nil nil 9 509 #smallIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 818 34 1 866 #createWindow: 34 1 914 946 8 #[0 0 0 0 0 0 0 0 240 2 0 0 25 0 0 0] 193 560 8 '' 528 3 34 3 1072 720 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1504 nil nil nil 5 nil nil nil 1504 786 ##(Smalltalk.Toolbar) #resource_Find_tools nil 818 34 1 866 #createWindow: 34 1 914 946 8 #[200 0 0 0 0 0 0 0 254 0 0 0 25 0 0 0] 193 1536 8 '' 1504 3 1008 1026 193 193 nil 27 1026 193 193 nil 31 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1140850956 1 1744 nil 480 nil 5 nil 610 nil true 642 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 1744 nil nil 170 192 1008 nil nil nil 138 144 34 1 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 1744 nil 1920 nil 818 34 1 866 #createWindow: 34 1 914 946 8 #[0 0 0 0 199 1 0 0 240 2 0 0 221 1 0 0] 193 1776 8 '' 1744 3 8 #() 1026 193 193 nil 29 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2096 nil 480 nil 5 nil nil nil 2096 1180166 ##(Smalltalk.ProportionalLayout) 138 176 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 2096 34 2 8 1140850688 1 2256 nil 592 nil 5 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2256 nil 1 #left nil nil nil 1026 1 1 1026 9 9 nil 2352 nil 818 34 1 866 #createWindow: 34 1 914 946 8 #[0 0 0 0 213 0 0 0 240 2 0 0 217 0 0 0] 193 2288 8 '' 2256 3 8 #() 1026 193 193 nil 27 1 true 170 192 1008 nil 818 34 1 866 #createWindow: 34 1 914 946 8 #[0 0 0 0 25 0 0 0 240 2 0 0 199 1 0 0] 193 2128 8 '' 2096 3 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2096 34 2 8 1140850688 131073 2704 nil 480 nil 5 nil nil nil 2704 2162 138 176 34 1 2226 410 ##(Smalltalk.Splitter) 34 12 nil 2704 34 2 8 1140850688 1 2832 nil 592 nil 5 nil nil nil 2322 2832 nil 1 #left nil nil nil 2352 2368 nil 2352 nil 818 34 1 866 #createWindow: 34 1 914 946 8 #[118 1 0 0 0 0 0 0 122 1 0 0 211 0 0 0] 193 2864 8 '' 2832 3 8 #() 1026 193 193 nil 27 1 false 170 192 1008 590342 ##(Smalltalk.Rectangle) 1026 9 1 1026 9 5 818 34 1 866 #createWindow: 34 1 914 946 8 #[0 0 0 0 0 0 0 0 240 2 0 0 213 0 0 0] 193 2736 8 '' 2704 3 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 2704 34 2 8 1140850688 131073 3296 nil 592 nil 5 nil nil nil 3296 498 1 1 nil nil nil nil 410 ##(Smalltalk.TreeView) 34 35 nil 3296 34 2 8 1140916775 1025 3376 590918 3 ##(Smalltalk.TreeModel) 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 1008 592 nil 5 nil nil nil 3376 nil nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil 170 176 1008 nil #noIcons 1 170 192 1008 1 1638662 ##(Smalltalk.TreeViewDynamicUpdateMode) 3376 nil nil nil nil nil nil 818 34 1 866 #createWindow: 34 1 914 946 8 #[0 0 0 0 0 0 0 0 114 1 0 0 211 0 0 0] 193 3408 8 '' 3376 3 8 #() 1026 193 193 nil 29 170 192 34 2 3376 8 'folders' nil 818 34 1 866 #createWindow: 34 1 914 946 8 #[4 0 0 0 0 0 0 0 118 1 0 0 211 0 0 0] 193 3328 8 '' 3296 3 34 1 3376 1026 193 193 nil 27 2832 410 ##(Smalltalk.ContainerView) 34 15 nil 2704 34 2 8 1140850688 131073 4016 nil 592 nil 5 nil nil nil 4016 498 1 1 nil nil nil nil 410 ##(Smalltalk.ListView) 34 45 nil 4016 34 2 8 1140920397 1025 4096 590662 2 ##(Smalltalk.ListModel) 138 144 1008 0 3488 592 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 5 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileSave 8 '&Save file' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4258 1 4290 #fileIn 8 '&File in' 1 1 nil nil nil 4338 4097 4258 1 4290 #fileDelete 8 '&Delete file' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 4096 nil nil ##(Smalltalk.BasicListAbstract) nil 3568 nil nil nil nil nil nil 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Name' 313 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() 4578 #name 8 #() nil 4096 nil 3 nil nil 4530 8 'Type' 101 #right ##(Smalltalk.BasicListAbstract) 4578 #<= 8 #() 4578 #type 4640 nil 4096 nil 1 nil nil 4530 8 'Size' 161 #right ##(Smalltalk.BasicListAbstract) 4578 #<= 8 #() 4578 #size 4640 nil 4096 nil 1 nil nil 4530 8 'Date' 161 #right ##(Smalltalk.BasicListAbstract) 4578 #<= 8 #() 4578 #timeStamp 4640 nil 4096 nil 1 nil nil #report 8 #() nil 131169 nil 1 nil nil nil nil 1 1638662 ##(Smalltalk.ListViewVirtualUpdateMode) 4096 nil nil nil nil nil nil nil nil nil 818 34 2 866 #createWindow: 34 1 914 946 8 #[0 0 0 0 0 0 0 0 114 1 0 0 211 0 0 0] 193 4128 8 'Name' 4096 866 #contextMenu: 34 1 4224 4096 3 8 #() 1026 193 193 nil 35 170 192 34 2 4096 8 'files' nil 818 34 1 866 #createWindow: 34 1 914 946 8 #[122 1 0 0 0 0 0 0 236 2 0 0 211 0 0 0] 193 4048 8 '' 4016 3 34 1 4096 1026 193 193 nil 27 1026 193 193 nil 27 2256 410 ##(Smalltalk.ContainerView) 34 15 nil 2096 34 2 8 1140850688 131073 5360 nil 480 nil 5 nil nil nil 5360 498 1 1 nil nil nil nil 410 ##(Smalltalk.CardContainer) 34 16 nil 5360 34 2 8 1140850688 131073 5440 nil 480 nil 5 nil nil nil 5440 656710 1 ##(Smalltalk.CardLayout) 138 144 34 4 2226 590662 1 ##(Smalltalk.CardLabel) 8 'Images' 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[Image icon]' 8 #[31 105 45 159 106] 983558 ##(Smalltalk.VariableBinding) #Image ##(Smalltalk.Image) #icon 5648 7 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 5440 34 2 8 1140850944 1 5776 721990 2 ##(Smalltalk.ValueHolder) 0 nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 4578 #= 8 #() 4578 #hash 8 #() nil 466 #white nil 5 4210 nil true 34 4 4258 1 4290 4578 #showImageAs: 8 #(#normal) 8 'Normal' 1 1 nil nil nil 4258 1 4290 4578 #showImageAs: 8 #(#centered) 8 'Centered' 1 1 nil nil nil 4258 1 4290 4578 #showImageAs: 8 #(#scale) 8 'Scale' 1 1 nil nil nil 4258 1 4290 4578 #showImageAs: 8 #(#scaleToFit) 8 'Scale To Fit' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 5776 nil nil 852486 ##(Smalltalk.NullConverter) nil nil nil nil #centered 3 nil nil 818 34 2 866 #createWindow: 34 1 914 946 8 #[4 0 0 0 24 0 0 0 228 2 0 0 207 0 0 0] 193 5808 nil 5776 866 #contextMenu: 34 1 5984 5776 1 8 #() 1026 193 193 nil 27 2226 5586 8 'HTML' 5634 0 nil 5666 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[WebView2View icon]' 8 #[31 105 45 159 106] 5746 #WebView2View ##(Smalltalk.WebView2View) #icon 6608 7 1 nil nil 410 ##(Smalltalk.WebView2View) 34 26 nil 5440 34 2 8 1140916224 1 6704 5842 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 5 nil nil nil 6704 nil nil 6354 nil nil 1 nil nil nil nil nil 1706054 1 ##(Smalltalk.WebView2EnvironmentOptions) nil 7 nil 8 '115.0.1901.177' 5 1 3 1 nil nil nil nil 818 34 1 866 #createWindow: 34 1 914 946 8 #[4 0 0 0 24 0 0 0 228 2 0 0 207 0 0 0] 193 6736 8 '' 6704 1 1008 1026 193 193 nil 29 2226 5586 8 'Hex' 5634 0 nil 5666 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[Integer icon]' 8 #[31 105 45 159 106] 5746 #Integer ##(Smalltalk.Integer) #icon 7072 7 1 nil nil 410 ##(Smalltalk.ScintillaView) 34 56 nil 5440 34 2 8 1174475012 1 7168 5842 0 false 6800 nil 592 nil 21 4210 nil true 34 11 4258 1 4290 #saveFile 8 '&Save' 1 1 nil nil nil 4258 1 4290 #saveFileAs 8 'Save &as' 1 1 nil nil nil 4338 4097 4258 1 4290 #cutSelection 8 'Cu&t' 1 1 nil nil nil 4258 1 4290 #copySelection 8 '&Copy' 1 1 nil nil nil 4258 1 4290 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 4258 1 4290 #clearSelection 8 'De&lete' 1 1 nil nil nil 4338 4097 4258 1 4290 #cloneNew 8 'Clo&ne' 1 1 nil nil nil 4338 4097 4258 1 4290 #clear 8 'Clea&r workspace' 1 1 nil nil nil 8 '&Workspace' nil 1 nil nil nil nil nil nil nil 7168 nil nil 6354 nil nil 11 #focusLost nil nil nil nil 170 192 34 8 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 466 #gray 5968 1 nil nil nil nil #callTip nil nil nil #normal 7778 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 7778 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 7778 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) nil nil nil nil 7168 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1008 nil 170 176 1008 9215 nil nil 170 176 34 2 81 466 #windowText nil nil 1310982 ##(Smalltalk.NullScintillaLibrary) nil 65 nil nil nil nil 1 170 192 1008 nil nil nil nil 16 nil 170 192 34 6 8 'indicator2' 1510470 5 ##(Smalltalk.ScintillaIndicatorStyle) 5 7168 466 #red 1 1 nil nil nil nil nil nil nil 8 'indicator1' 8146 3 7168 466 #blue 5 1 nil nil nil nil nil nil nil 8 'indicator0' 8146 1 7168 466 #commonGreen 3 1 nil nil nil nil nil nil nil nil nil 170 192 1008 nil nil nil 818 34 4 866 #createWindow: 34 1 914 946 8 #[4 0 0 0 24 0 0 0 228 2 0 0 207 0 0 0] 193 7200 nil 7168 866 #contextMenu: 34 1 7248 7168 866 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 7168 nil 3 nil nil nil nil 8498 3 7168 nil nil nil 67108863 nil nil 8498 5 7168 nil nil nil nil nil nil 7168 866 #maxCompletionListHeight: 8 #(9) 7168 1 8 #() 1026 193 193 nil 45 2226 5586 8 'Text' 5634 0 nil 5666 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 ' [String icon]' 8 #[31 105 45 159 106] 5746 #String ##(Smalltalk.String) #icon 8672 7 1 nil nil 410 ##(Smalltalk.ScintillaView) 34 56 nil 5440 34 2 8 1174475012 1 8768 5842 0 false 6800 nil 592 nil 21 4210 nil true 34 10 4258 1 4290 #fileSave 8 '&Save file' 1 1 nil nil nil 4338 4097 4258 1 4290 #cutSelection 8 'Cu&t' 1 1 nil nil nil 4258 1 4290 #copySelection 8 '&Copy' 1 1 nil nil nil 4258 1 4290 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 4258 1 4290 #clearSelection 8 'De&lete' 1 1 nil nil nil 4338 4097 4258 1 4290 #cloneNew 8 'Clo&ne' 1 1 nil nil nil 9136 4258 1 4290 #clear 8 'Clea&r workspace' 1 1 nil nil nil 8 '&Workspace' nil 1 nil nil nil nil nil nil nil 8768 nil nil 6354 nil nil 9 #focusLost nil nil nil nil 170 192 34 8 #callTip 7778 77 7808 5968 1 nil nil nil nil #callTip nil nil nil #normal 7778 1 nil nil 1 nil nil nil nil #normal nil nil nil #indentGuide 7778 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineNumber 7778 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil nil 7874 #normal 170 192 34 2 #default 7938 nil nil nil nil 8768 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1008 nil 170 176 1008 9215 nil nil 170 176 34 2 81 8032 nil nil 8064 nil 65 nil nil nil nil 1 170 192 1008 nil nil nil nil 16 nil 170 192 34 6 8 'indicator0' 8146 1 8768 8272 3 1 nil nil nil nil nil nil nil 8 'indicator2' 8146 5 8768 8176 1 1 nil nil nil nil nil nil nil 8 'indicator1' 8146 3 8768 8224 5 1 nil nil nil nil nil nil nil nil nil 170 192 34 6 #Error 7778 1031 466 #firebrick 466 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 7778 1029 nil 466 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 7778 1027 466 #darkGoldenrod 466 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 818 34 4 866 #createWindow: 34 1 914 946 8 #[4 0 0 0 24 0 0 0 228 2 0 0 207 0 0 0] 193 8800 nil 8768 866 #contextMenu: 34 1 8848 8768 866 #margins: 34 1 34 3 8498 1 8768 nil 3 nil nil nil nil 8498 3 8768 nil nil nil 67108863 nil nil 8498 5 8768 nil nil nil nil nil nil 8768 866 #maxCompletionListHeight: 8 #(9) 8768 3 8 #() 1026 193 193 nil 45 8768 0 nil nil 170 192 34 8 7168 8 'hex' 6704 8 'html' 5776 8 'image' 8768 8 'text' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 5440 34 2 8 1140916736 1 10208 4162 138 144 34 4 8640 7040 5600 6576 0 3488 480 nil 1 nil nil nil 10208 nil nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 3568 nil nil nil nil nil #smallIcons nil nil nil nil nil 818 34 3 866 #createWindow: 34 1 914 946 8 #[0 0 0 0 0 0 0 0 232 2 0 0 211 0 0 0] 193 10240 8 '' 10208 866 #setSingleSelection: 8 #(1) 10208 866 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 10208 3 8 #() 1026 193 193 nil 27 818 34 1 866 #createWindow: 34 1 914 946 8 #[4 0 0 0 2 0 0 0 236 2 0 0 213 0 0 0] 193 5472 8 '' 5440 3 34 5 8768 7168 5776 6704 10208 1026 193 193 nil 27 170 192 34 2 5440 8 'cards' 3090 1026 9 5 1026 9 1 818 34 1 866 #createWindow: 34 1 914 946 8 #[0 0 0 0 217 0 0 0 240 2 0 0 174 1 0 0] 193 5392 8 '' 5360 3 34 1 5440 1026 193 193 nil 27 1026 193 193 nil 27 170 192 34 2 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 4210 nil true 34 12 4258 1 4290 #fileNew 8 '&New file' 1 1 nil nil nil 4258 1 4290 #fileOpen 8 'Root folder' 1 1 nil nil nil 4258 1 4290 #fileSave 8 '&Save file' 1 1 nil nil nil 4258 1 4290 #fileSaveAs 8 'Save file &as' 1 1 nil nil nil 4338 4097 4258 1 4290 #enableHex 8 'Enable Hex' 1 1 nil nil nil 4258 1 4290 #removeCr 8 'Remove Cr' 1 1 nil nil nil 4338 4097 4258 1 4290 #pageSetup 8 'Page Setup...' 1 1 nil nil nil 4258 1 4290 #print 8 'Print...' 1 1 nil nil nil 4338 4097 4258 1 4290 #exit 8 'Close' 16615 1 nil nil nil 8 '&File' nil 1 nil nil nil nil nil 4210 nil true 34 11 4258 1 4290 #undo 8 '&Undo' 9397 1 nil nil nil 4338 4097 4258 1 4290 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 4258 1 4290 #copySelection 8 '&Copy' 9351 1 nil nil nil 4258 1 4290 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 4258 1 4290 #clearSelection 8 '&Delete' 1 1 nil nil nil 4258 1 4290 #selectAll 8 'Select &All' 9347 1 nil nil nil 4338 4097 4258 1 4290 #find 8 '&Find...' 9357 1 nil nil nil 4258 1 4290 #findNext 8 'Find &Next' 1253 1 nil nil nil 4258 1 4290 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil 4210 nil true 8 #() 8 '&Tools' #toolsMenu 1 nil nil nil nil nil 4210 nil true 34 15 4258 1 4290 #helpContents 8 '&Contents' 1025 1 262982 4 ##(Smalltalk.Icon) nil true 2229254 ##(Smalltalk.ImageFromStringResourceInitializer) 8 'Help.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil 65541 nil nil nil 4258 1 4290 #help 8 'On this &Tool' 1249 1 nil nil nil 4258 1 4290 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4338 4097 4258 1 4290 #learnSmalltalk 8 'Learn Smalltalk' 1 1 788806 2 ##(Smalltalk.TextTileIcon) $\x1F393 nil 466 #orchid 5968 nil nil 1 nil nil nil nil 4338 4097 4258 1 4290 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4258 1 4290 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4258 1 4290 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4338 4097 4258 1 4290 #dolphinHomePage 8 'Dolphin Homepage' 1 1 12242 nil true 12274 8 '!!APPLICATION' 12336 65541 nil nil nil 4258 1 4290 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4258 1 4290 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4338 4097 4258 1 4290 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 12530 $\x1F42C nil nil 466 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil nil nil 193 818 34 1 866 #createWindow: 34 1 914 3090 1026 7679 21 1026 9215 1093 193 448 8 'File Browser' 416 1 34 3 528 2096 1744 1026 193 193 nil 27 )!

rootFolder
	"Answer the name of the root folder in the tree"

	RootFolder isNil ifTrue: [^self defaultFolder].
	^RootFolder!

rootFolder: aString 
	"Set the name of the root folder in the tree"

	RootFolder := aString!

textFont
	"Answer the font used for the text view"

	self ensureOptionsLoaded.
	^TextFont!

textFont: aFont 
	"Set the font used for the text view"

	self textFont = aFont ifTrue: [^self].
	TextFont := aFont.
	self persistOptions!

warnings
	"Answer whether warnings are enabled"

	self ensureOptionsLoaded.
	^Warnings!

warnings: aBoolean 
	"Set whether warnings are enabled"

	self warnings = aBoolean ifTrue: [^self].
	Warnings := aBoolean.
	self persistOptions! !

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

