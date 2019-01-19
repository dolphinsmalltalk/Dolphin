"Filed out from Dolphin Smalltalk 7"!

IdbToolShell subclass: #ILLibraryShell
	instanceVariableNames: 'libraryWorkspace libraryFilename libraryStatus imageStatus modifiedStatus'
	classVariableNames: ''
	poolDictionaries: 'CommonDialogConstants'
	classInstanceVariableNames: ''!
ILLibraryShell guid: (GUID fromString: '{1c83fb20-739d-43f4-89f6-026860979f42}')!
ILLibraryShell comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ILLibraryShell categoriesForClass!IDB Goodies! !
!ILLibraryShell methodsFor!

about
	"Display the about view"

	self 
		idbAbout: '
Image Library and Editor
for
Dolphin Smalltalk 6.x

Version 6a
© 2005 Ian Bartholomew
http://www.idb.me.uk'!

addImage
	| imageExtent |
	imageExtent := (ILExtentDialog create)
				options: self model imageSizes;
				showModal.
	imageExtent isNil ifTrue: [^self].
	self model addImage: imageExtent!

allowLoss
	^self model isModified not 
		or: [MessageBox confirm: 'Continue and lose all changes made to the library?']!

checkMarker: aFileStream
	(aFileStream next: 3) = 'LIB' asByteArray ifTrue: [^true].
	MessageBox notify: 'Not a valid library'.
	^false!

createComponents
	super createComponents.
	libraryWorkspace := self add: ILLibraryWorkspacePresenter new name: 'libraryWorkspace'.
	libraryStatus := self add: TextPresenter new name: 'libraryStatus'.
	imageStatus := self add: TextPresenter new name: 'imageStatus'.
	modifiedStatus := self add: TextPresenter new name: 'modifiedStatus'!

createSchematicWiring
	super createSchematicWiring.
	self 
		when: #closeRequested:
		send: #onCloseRequested:
		to: self.
	self 
		when: #viewOpened
		send: #onLibraryChanged
		to: self.
	libraryWorkspace 
		when: #mouseOver:
		send: #onMouseOver:
		to: self.
	libraryWorkspace 
		when: #editImage
		send: #onEditImage
		to: self!

deleteImage
	(MessageBox confirm: 'This will permanately delete the selected image(s). Continue?') 
		ifFalse: [^self].
	self model deleteImage!

editImage
	self model editImageWithBackcolor: libraryWorkspace view backcolor!

exportBitmap
	| filename |
	filename := (FileSaveDialog new)
				fileTypes: self class bitmapFileTypes;
				defaultExtension: self class bitmapFileExtension;
				showModal.
	filename isNil ifTrue: [^self].
	Cursor wait showWhile: 
			[| fileStream |
			fileStream := FileStream write: filename text: false.
			[self model exportBitmapTo: fileStream] ensure: [fileStream close]]!

exportCursor
	| filename |
	filename := (FileSaveDialog new)
				fileTypes: self class cursorFileTypes;
				defaultExtension: self class cursorFileExtension;
				showModal.
	filename isNil ifTrue: [^self].
	Cursor wait showWhile: 
			[| fileStream |
			fileStream := FileStream write: filename text: false.
			[self model exportCursorTo: fileStream] ensure: [fileStream close]]!

exportExe
	| filename |
	filename := (FileOpenDialog new)
				fileTypes: self class exeFileTypes;
				showModal.
	filename isNil ifTrue: [^self].
	Cursor wait showWhile: 
			[| fileStream |
			fileStream := (FileStream readWrite: filename text: false).
			[self model exportExeTo: fileStream] ensure: [fileStream close]]!

exportIcon
	| filename |
	filename := (FileSaveDialog new)
				fileTypes: self class iconFileTypes;
				defaultExtension: self class iconFileExtension;
				showModal.
	filename isNil ifTrue: [^self].
	Cursor wait showWhile: 
			[| fileStream |
			fileStream := FileStream write: filename text: false.
			[self model exportIconTo: fileStream] ensure: [fileStream close]]!

import
	| filenames |
	filenames := (MultipleFileOpenDialog new)
				fileTypes: self class allFileTypes;
				showModal.
	filenames isNil ifTrue: [^self].
	Cursor wait showWhile: 
			[filenames do: 
					[:each | 
					| fileStream |
					fileStream := FileStream read: each text: false.
					[self model import: fileStream] ensure: [fileStream close]]].
	self model resetAfterImport!

insertMarker: aFileStream
	aFileStream nextPutAll: 'LIB' asByteArray!

model: anILLibrary
	super model: anILLibrary.
	libraryWorkspace model: self model.

	"Lose the argument as we don't need it"
	self model 
		when: #libraryChanged:
		send: #onLibraryChanged
		to: self!

moveDown
	self model moveDown!

moveToEnd
	self model moveToEnd!

moveToStart
	self model moveToStart!

moveUp
	self model moveUp!

newLibrary
	self allowLoss ifFalse: [^self].
	self model: ILLibrary new.
	libraryFilename := nil.
	self model resetAfterLoad!

onCloseRequested: aValueHolder
	aValueHolder value: self allowLoss!

onEditImage
	self model hasSingleSelection ifTrue: [self editImage]!

onLibraryChanged
	self 
		caption: 'IDB Image Library - ' , (libraryFilename isNil 
						ifTrue: ['Unsaved Library']
						ifFalse: [File splitFilenameFrom: libraryFilename]).
	libraryStatus value: ((String writeStream)
				space;
				nextPutAll: ' Images: ';
				print: self model imageCount;
				contents).
	modifiedStatus value: (self model isModified ifTrue: [' modified'] ifFalse: [String new])!

onMouseOver: anILImageOrNil
	imageStatus value: (anILImageOrNil isNil 
				ifTrue: [String new]
				ifFalse: [anILImageOrNil imageDescription])!

openLibrary
	| filename |
	self allowLoss ifFalse: [^self].
	filename := (FileOpenDialog new)
				fileTypes: self class libraryFileTypes;
				showModal.
	filename isNil ifTrue: [^self].

	"The deferred action is needed because (I think) Windows starts a redraw when the dialog 
	closes, using the original model. We interrupt it with the actions below, replacing the model
	and forcing a redraw. Windows then trys to restart the interruped original paint and, as
	the model has now changed, has problems"
	SessionManager inputState queueDeferredAction: 
			[libraryFilename := filename.
			Cursor wait showWhile: 
					[| fileStream |
					fileStream := FileStream read: filename text: false.
					[(self checkMarker: fileStream) ifTrue: [self model: (Object binaryReadFrom: fileStream)]] 
						ensure: [fileStream close]].
			self model resetAfterLoad]!

queryCommand: aCommandQuery
	(#(#deleteImage #exportBitmap #exportCursor #exportIcon #exportExe) 
		includes: aCommandQuery command) 
			ifTrue: 
				[aCommandQuery isEnabled: self model hasSelection.
				^true].
	(#(#moveToStart #moveToEnd #moveUp #moveDown) includes: aCommandQuery command) 
		ifTrue: 
			[aCommandQuery isEnabled: self model hasMultipleImages & self model hasSelection.
			^true].
	aCommandQuery command == #editImage 
		ifTrue: 
			[aCommandQuery isEnabled: self model hasSingleSelection.
			^true].
	(#(#saveLibrary #saveLibraryAs) includes: aCommandQuery command) 
		ifTrue: 
			[aCommandQuery isEnabled: self model hasImages.
			^true].
	^super queryCommand: aCommandQuery!

save
	| fileStream |
	self model resetBeforeSave.
	fileStream := FileStream write: libraryFilename text: false.
	Cursor wait showWhile: 
			[
			[self insertMarker: fileStream.
			self model binaryStoreOn: fileStream] 
					ensure: [fileStream close]].
	self model resetAfterSave: libraryWorkspace view backcolor!

saveLibrary
	libraryFilename isNil ifTrue: [self saveLibraryAs] ifFalse: [self save]!

saveLibraryAs
	| filename dialog |
	dialog := FileSaveDialog new.
	filename := dialog
				style: (dialog style bitOr: OFN_OVERWRITEPROMPT);
				fileTypes: self class libraryFileTypes;
				defaultExtension: self class libraryFileExtension;
				showModal.
	filename isNil ifTrue: [^self].
	libraryFilename := filename.
	self save!

setBackgroundColor: aSymbol 
	libraryWorkspace view backcolor: (RGB perform: aSymbol).
	ILImage transparentRGB: libraryWorkspace view backcolor.
	self model clearBitmapCache! !
!ILLibraryShell categoriesFor: #about!commands!public! !
!ILLibraryShell categoriesFor: #addImage!commands!public! !
!ILLibraryShell categoriesFor: #allowLoss!helpers!public! !
!ILLibraryShell categoriesFor: #checkMarker:!helpers!public! !
!ILLibraryShell categoriesFor: #createComponents!initializing!public! !
!ILLibraryShell categoriesFor: #createSchematicWiring!initializing!public! !
!ILLibraryShell categoriesFor: #deleteImage!commands!public! !
!ILLibraryShell categoriesFor: #editImage!commands!public! !
!ILLibraryShell categoriesFor: #exportBitmap!commands!public! !
!ILLibraryShell categoriesFor: #exportCursor!commands!public! !
!ILLibraryShell categoriesFor: #exportExe!commands!public! !
!ILLibraryShell categoriesFor: #exportIcon!commands!public! !
!ILLibraryShell categoriesFor: #import!commands!public! !
!ILLibraryShell categoriesFor: #insertMarker:!helpers!public! !
!ILLibraryShell categoriesFor: #model:!models!public! !
!ILLibraryShell categoriesFor: #moveDown!commands!public! !
!ILLibraryShell categoriesFor: #moveToEnd!commands!public! !
!ILLibraryShell categoriesFor: #moveToStart!commands!public! !
!ILLibraryShell categoriesFor: #moveUp!commands!public! !
!ILLibraryShell categoriesFor: #newLibrary!commands!public! !
!ILLibraryShell categoriesFor: #onCloseRequested:!event handling!public! !
!ILLibraryShell categoriesFor: #onEditImage!event handling!public! !
!ILLibraryShell categoriesFor: #onLibraryChanged!event handling!public! !
!ILLibraryShell categoriesFor: #onMouseOver:!event handling!public! !
!ILLibraryShell categoriesFor: #openLibrary!commands!public! !
!ILLibraryShell categoriesFor: #queryCommand:!commands!public! !
!ILLibraryShell categoriesFor: #save!commands!public! !
!ILLibraryShell categoriesFor: #saveLibrary!commands!public! !
!ILLibraryShell categoriesFor: #saveLibraryAs!commands!public! !
!ILLibraryShell categoriesFor: #setBackgroundColor:!commands!public! !

!ILLibraryShell class methodsFor!

allFileTypes
	^#(#('All files (*.*)' '*.*') #('Bitmap files (*.bmp)' '*.bmp') #('Icon files (*.ico)' '*.ico') #('Cursor files (*.cur)' '*.cur') #('Library Files (*.lib)' '*.lib') #('Application Files (*.exe)' '*.exe'))!

bitmapFileExtension
	^'bmp'!

bitmapFileTypes
	^#(#('Bitmap files (*.bmp)' '*.bmp') #('All files (*.*)' '*.*'))!

cursorFileExtension
	^'cur'!

cursorFileTypes
	^#(#('Cursor files (*.cur)' '*.cur') #('All files (*.*)' '*.*'))!

defaultModel
	^ILLibrary new!

displayOn: aStream
	aStream nextPutAll: 'Image Library'!

exeFileTypes
	^#(#('Application files (*.exe)' '*.exe') #('All files (*.*)' '*.*'))!

icon
	^##(TextTileIcon text: $\x1F5BC
		color: (Color
				r: 246
				g: 162
				b: 17))!

iconFileExtension
	^'ico'!

iconFileTypes
	^#(#('Icon files (*.ico)' '*.ico') #('All files (*.*)' '*.*'))!

libraryFileExtension
	^'lib'!

libraryFileTypes
	^#(#('Library Files (*.lib)' '*.lib') #('All Files (*.*)' '*.*'))!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 328198 ##(Smalltalk.Point) 801 601 549 265030 4 ##(Smalltalk.Menu) nil true 34 9 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #addImage 8 'New Image' 1 1 nil nil nil 594 1 626 #editImage 8 'Edit Image' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 594 1 626 #deleteImage 8 'Delete selected Image(s)' 1 1 nil nil nil 722 4097 594 1 626 #moveToStart 8 'Move to Start' 1 1 nil nil nil 594 1 626 #moveUp 8 'Move Up' 1 1 nil nil nil 594 1 626 #moveDown 8 'Move Down' 1 1 nil nil nil 594 1 626 #moveToEnd 8 'Move to End' 1 1 nil nil nil 8 'Image' nil 1 nil nil nil nil nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853548 131137 1056 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 514 193 193 nil 1056 480 8 1915204752 170 192 8 #() 170 192 34 18 41539 1246790 1 ##(Smalltalk.ToolbarBitmapButton) 1056 1 626 #deleteImage 8 'Delete Image' 1 1 nil 41539 657990 3 ##(Smalltalk.DIBSection) 1 true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Idb\Resources\ImageLibrary.bmp' nil nil 7 514 1 1 1 nil 13 41541 1298 1056 1 626 #moveToStart 8 'Move to Start' 1 1 nil 41541 1376 5 41543 1298 1056 1 626 #moveUp 8 'Move Up' 1 1 nil 41543 1376 7 41545 1298 1056 1 626 #moveDown 8 'Move Down' 1 1 nil 41545 1376 9 41547 1298 1056 1 626 #moveToEnd 8 'Move to End' 1 1 nil 41547 1376 11 41531 1246790 1 ##(Smalltalk.ToolbarSystemButton) 1056 1 626 #openLibrary 8 'Open Library' 1 1 nil 41531 1 15 41533 1650 1056 1 626 #saveLibrary 8 'Save Library' 1 1 nil 41533 1 17 41535 1298 1056 1 626 #addImage 8 'New Image' 1 1 nil 41535 1376 1 41537 1298 1056 1 626 #editImage 8 'Edit Image' 1 1 nil 41537 1376 3 34 11 1664 1712 1049158 1 ##(Smalltalk.ToolbarSeparator) 1056 1 1760 1808 1312 1874 1056 1 1456 1504 1552 1600 nil nil 1 nil 514 33 33 514 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 514 1 1 514 769 51 1056 2050 #updateSizePosted 1248 1056 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 128 1 0 0 25 0 0 0] 8 #() 514 193 193 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140853004 1 2224 nil 721158 ##(Smalltalk.SystemColor) 31 nil 7 nil 1122 nil true 1154 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 514 193 193 nil 2224 nil 8 1914952576 170 192 34 10 853766 ##(Smalltalk.StatusBarItem) 1 121 2224 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'imageExtent' 2434 1 341 2224 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'imageStatus' 2434 1 161 2224 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'statusModified' 2434 1 201 2224 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'libraryStatus' 2434 1 -1 2224 nil ##(Smalltalk.BasicListAbstract) nil nil 8 'modifiedStatus' 34 3 2544 2480 2576 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2224 nil nil 1986 138 144 34 1 2050 #createAt:extent: 34 2 514 1 439 514 769 45 2224 2146 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 219 0 0 0 128 1 0 0 241 0 0 0] 8 #() 2208 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2816 nil 2304 nil 7 nil nil nil 2816 1026 1 1 nil nil nil nil 410 ##(Smalltalk.ScrollingDecorator) 34 18 nil 2816 34 2 8 1152385024 131073 2896 nil 480 nil 7 nil nil nil 2896 1573190 1 ##(Smalltalk.ScrollingDecoratorLayout) true 170 192 34 2 410 ##(Smalltalk.ReferenceView) 34 14 nil 2896 34 2 8 1140916224 131073 3024 nil nil nil 7 nil nil nil 3024 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.ILLibraryWorkspacePresenter) #resource_Default_view nil 1986 138 144 34 1 2050 #createAt:extent: 34 2 514 1 1 514 749 385 3024 2146 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 118 1 0 0 192 0 0 0] 1248 2208 nil 27 8 'libraryWorkspace' 590342 ##(Smalltalk.Rectangle) 514 9 9 514 9 9 514 1 1 true 514 17 17 1986 138 144 34 1 2050 #createAt:extent: 34 2 514 9 1 514 753 389 2896 2146 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 0 0 0 0 124 1 0 0 194 0 0 0] 34 1 3024 2208 nil 27 170 192 34 2 2896 8 'scroller' 3282 514 9 1 514 9 1 1986 138 144 34 1 2050 #createAt:extent: 34 2 514 1 51 514 769 389 2816 2146 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 128 1 0 0 219 0 0 0] 34 1 2896 2208 nil 27 170 192 1248 nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 546 nil true 34 15 594 1 626 #newLibrary 8 '&New Library' 1 1 nil nil nil 594 1 626 #openLibrary 8 '&Open Library' 1 1 nil nil nil 594 1 626 #saveLibrary 8 '&Save Library' 1 1 nil nil nil 594 1 626 #saveLibraryAs 8 'Save Library &As' 1 1 nil nil nil 722 4097 594 1 626 #import 8 'Im&port' 1 1 nil nil nil 722 4097 594 1 626 #exportBitmap 8 'Export as &Bitmap' 1 1 nil nil nil 594 1 626 #exportIcon 8 'Export as &Icon' 1 1 nil nil nil 594 1 626 #exportCursor 8 'Export as &Cursor' 1 1 nil nil nil 594 1 626 #exportExe 8 'Export to &Exe' 1 1 nil nil nil 722 4097 546 nil true 34 5 594 1 626 459270 ##(Smalltalk.Message) #setBackgroundColor: 8 #(#black) 8 '&Black' 1 1 nil nil nil 594 1 626 4434 #setBackgroundColor: 8 #(#caption) 8 '&Caption' 1 1 nil nil nil 594 1 626 4434 #setBackgroundColor: 8 #(#dolphinYellow) 8 '&Transparent' 1 1 nil nil nil 594 1 626 4434 #setBackgroundColor: 8 #(#face3d) 8 'Toolbar &Grey' 1 1 nil nil nil 594 1 626 4434 #setBackgroundColor: 8 #(#white) 8 '&White' 1 1 nil nil nil 8 'Select Back&ground Colour' nil 1 nil nil 41479 nil nil 722 4097 594 1 626 #exit 8 'E&xit' 1 1 nil nil nil 8 '&Library' nil 1 nil nil 41483 nil nil 546 nil true 34 9 594 1 626 #addImage 8 '&New Image' 1 1 nil nil nil 594 1 626 #editImage 8 '&Edit Image' 1 1 nil nil nil 722 4097 594 1 626 #deleteImage 8 '&Delete selected Image(s)' 1 1 nil nil nil 722 4097 594 1 626 #moveToStart 8 'Move to &Start' 1 1 nil nil nil 594 1 626 #moveUp 8 'Move Up' 8363 1 nil nil nil 594 1 626 #moveDown 8 'Move Down' 8329 1 nil nil nil 594 1 626 #moveToEnd 8 'Mo&ve to End' 1 1 nil nil nil 8 '&Image' nil 1 nil nil 41499 nil nil 546 nil true 8 #() 8 '&Tools' #toolsMenu 1 nil nil 41501 nil nil 546 nil true 34 18 594 1 626 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) nil true 1408 49 786694 ##(Smalltalk.ShellLibrary) nil nil 594 1 626 #help 8 'On this &Tool' 1249 1 nil nil nil 594 1 626 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 722 4097 594 1 626 #learnSmalltalk 8 'Learn Smalltalk' 1 1 nil nil nil 722 4097 594 1 626 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 594 1 626 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 594 1 626 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 722 4097 594 1 626 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 nil nil nil 594 1 626 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 594 1 626 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 594 1 626 #myDolphinAccount 8 'My Dolphin Account' 1 1 nil nil nil 722 4097 594 1 626 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 5458 nil true 1408 8 'LiveUpdate.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 722 4097 594 1 626 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5458 nil true 1408 8 '!!APPLICATION' 6160 nil nil 8 '&Help' nil 134217729 nil nil 41529 nil nil 8 '' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1986 138 144 34 3 2050 #createAt:extent: 34 2 514 3839 21 514 801 601 416 2050 #contextMenu: 34 1 560 416 2050 #updateMenuBar 1248 416 2146 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 15 9 0 0 54 1 0 0] 34 3 1056 2816 2224 2208 nil 27 )! !
!ILLibraryShell class categoriesFor: #allFileTypes!constants!public! !
!ILLibraryShell class categoriesFor: #bitmapFileExtension!constants!public! !
!ILLibraryShell class categoriesFor: #bitmapFileTypes!constants!public! !
!ILLibraryShell class categoriesFor: #cursorFileExtension!constants!public! !
!ILLibraryShell class categoriesFor: #cursorFileTypes!constants!public! !
!ILLibraryShell class categoriesFor: #defaultModel!models!public! !
!ILLibraryShell class categoriesFor: #displayOn:!operations!public! !
!ILLibraryShell class categoriesFor: #exeFileTypes!constants!public! !
!ILLibraryShell class categoriesFor: #icon!constants!public! !
!ILLibraryShell class categoriesFor: #iconFileExtension!constants!public! !
!ILLibraryShell class categoriesFor: #iconFileTypes!constants!public! !
!ILLibraryShell class categoriesFor: #libraryFileExtension!constants!public! !
!ILLibraryShell class categoriesFor: #libraryFileTypes!constants!public! !
!ILLibraryShell class categoriesFor: #resource_Default_view!public!resources-views! !

