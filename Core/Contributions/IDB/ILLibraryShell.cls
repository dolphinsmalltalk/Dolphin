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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 328198 ##(Smalltalk.Point) 801 601 551 265030 4 ##(Smalltalk.Menu) 0 16 98 9 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #addImage 8 'New Image' 1 1 0 0 0 610 1 642 8 #editImage 8 'Edit Image' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 610 1 642 8 #deleteImage 8 'Delete selected Image(s)' 1 1 0 0 0 770 4097 610 1 642 8 #moveToStart 8 'Move to Start' 1 1 0 0 0 610 1 642 8 #moveUp 8 'Move Up' 1 1 0 0 0 610 1 642 8 #moveDown 8 'Move Down' 1 1 0 0 0 610 1 642 8 #moveToEnd 8 'Move to End' 1 1 0 0 0 8 'Image' 0 1 0 0 0 0 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140853548 131137 1184 0 0 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 530 193 193 0 1184 482 8 4278190080 8 4294903529 234 256 98 0 234 256 98 18 44393 1246982 ##(Smalltalk.ToolbarSystemButton) 44393 0 1184 1 642 8 #openLibrary 8 'Open Library' 1 1 0 1 15 44395 1474 44395 0 1184 1 642 8 #saveLibrary 8 'Save Library' 1 1 0 1 17 44397 853766 ##(Smalltalk.ToolbarButton) 44397 0 1184 1 642 672 8 'New Image' 1 1 0 657990 3 ##(Smalltalk.DIBSection) 1 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Idb\Resources\ImageLibrary.bmp' 0 0 7 530 1 1 1 0 1 44399 1618 44399 0 1184 1 642 736 8 'Edit Image' 1 1 0 1696 3 44401 1618 44401 0 1184 1 642 832 8 'Delete Image' 1 1 0 1696 13 44403 1618 44403 0 1184 1 642 912 8 'Move to Start' 1 1 0 1696 5 44405 1618 44405 0 1184 1 642 976 8 'Move Up' 1 1 0 1696 7 44407 1618 44407 0 1184 1 642 1040 8 'Move Down' 1 1 0 1696 9 44409 1618 44409 0 1184 1 642 1104 8 'Move to End' 1 1 0 1696 11 98 11 1488 1552 1050118 ##(Smalltalk.ToolbarSeparator) 0 0 1184 3 0 1 1632 1776 1824 2082 0 0 1184 3 0 1 1872 1920 1968 2016 234 240 98 4 1 1 1696 31 0 1 0 530 33 33 530 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 202 208 98 2 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 530 1 1 530 769 51 1184 2290 8 #updateSizePosted 1424 1184 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 128 1 0 0 25 0 0 0] 98 0 530 193 193 0 27 410 8 ##(Smalltalk.StatusBar) 98 18 0 416 98 2 8 1140853004 1 2496 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 1266 0 16 1298 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 530 193 193 0 2496 0 8 4294905391 234 256 98 10 853766 ##(Smalltalk.StatusBarItem) 1 121 2496 0 8 ##(Smalltalk.BasicListAbstract) 0 0 8 'imageExtent' 2722 1 161 2496 0 2752 0 0 8 'statusModified' 2722 1 341 2496 0 2752 0 0 8 'imageStatus' 2722 1 -1 2496 0 2752 0 0 8 'modifiedStatus' 2722 1 201 2496 0 2752 0 1049926 1 ##(Smalltalk.IconImageManager) 8 'libraryStatus' 98 3 2880 2816 2848 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2496 0 0 2226 202 208 98 1 2290 2320 98 2 530 1 439 530 769 45 2496 2418 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 219 0 0 0 128 1 0 0 241 0 0 0] 98 0 2480 0 27 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 3152 0 2578 31 0 7 0 0 0 3152 1154 1 1 0 0 0 0 410 8 ##(Smalltalk.ScrollingDecorator) 98 18 0 3152 98 2 8 1152385024 131073 3264 0 482 512 0 7 0 0 0 3264 1573190 1 ##(Smalltalk.ScrollingDecoratorLayout) 16 234 256 98 2 410 8 ##(Smalltalk.ReferenceView) 98 14 0 3264 98 2 8 1140916224 131073 3424 0 0 0 7 0 0 0 3424 1180166 ##(Smalltalk.ResourceIdentifier) 8 ##(Smalltalk.ILLibraryWorkspacePresenter) 8 #resource_Default_view 0 2226 202 208 98 1 2290 2320 98 2 530 1 1 530 749 385 3424 2418 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 118 1 0 0 192 0 0 0] 1424 2480 0 27 8 'libraryWorkspace' 590342 ##(Smalltalk.Rectangle) 530 9 9 530 9 9 530 1 1 16 530 17 17 2226 202 208 98 1 2290 2320 98 2 530 9 1 530 753 389 3264 2418 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 0 0 0 0 124 1 0 0 194 0 0 0] 98 1 3424 2480 0 27 234 256 98 2 3264 8 'scroller' 3730 530 9 1 530 9 1 2226 202 208 98 1 2290 2320 98 2 530 1 51 530 769 389 3152 2418 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 128 1 0 0 219 0 0 0] 98 1 3264 2480 0 27 234 256 1424 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 4 562 0 16 98 15 610 1 642 8 #newLibrary 8 '&New Library' 1 1 0 0 0 610 1 642 1520 8 '&Open Library' 1 1 0 0 0 610 1 642 1584 8 '&Save Library' 1 1 0 0 0 610 1 642 8 #saveLibraryAs 8 'Save Library &As' 1 1 0 0 0 770 4097 610 1 642 8 #import 8 'Im&port' 1 1 0 0 0 770 4097 610 1 642 8 #exportBitmap 8 'Export as &Bitmap' 1 1 0 0 0 610 1 642 8 #exportIcon 8 'Export as &Icon' 1 1 0 0 0 610 1 642 8 #exportCursor 8 'Export as &Cursor' 1 1 0 0 0 610 1 642 8 #exportExe 8 'Export to &Exe' 1 1 0 0 0 770 4097 562 0 16 98 5 610 1 642 459270 ##(Smalltalk.Message) 8 #setBackgroundColor: 98 1 8 #black 8 '&Black' 1 1 0 0 0 610 1 642 4994 5024 98 1 8 #caption 8 '&Caption' 1 1 0 0 0 610 1 642 4994 5024 98 1 8 #dolphinYellow 8 '&Transparent' 1 1 0 0 0 610 1 642 4994 5024 98 1 8 #face3d 8 'Toolbar &Grey' 1 1 0 0 0 610 1 642 4994 5024 98 1 8 #white 8 '&White' 1 1 0 0 0 8 'Select Back&ground Colour' 0 1 0 0 44459 0 0 770 4097 610 1 642 8 #exit 8 'E&xit' 1 1 0 0 0 8 '&Library' 0 1 0 0 44463 0 0 562 0 16 98 9 610 1 642 672 8 '&New Image' 1 1 0 0 0 610 1 642 736 8 '&Edit Image' 1 1 0 0 0 770 4097 610 1 642 832 8 '&Delete selected Image(s)' 1 1 0 0 0 770 4097 610 1 642 912 8 'Move to &Start' 1 1 0 0 0 610 1 642 976 8 'Move Up' 8363 1 0 0 0 610 1 642 1040 8 'Move Down' 8329 1 0 0 0 610 1 642 1104 8 'Mo&ve to End' 1 1 0 0 0 8 '&Image' 0 1 0 0 44479 0 0 562 0 16 98 0 8 '&Tools' 8 #toolsMenu 1 0 0 44481 0 0 562 0 16 98 18 610 1 642 8 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon) 0 16 1728 49 786694 ##(Smalltalk.ShellLibrary) 0 0 610 1 642 8 #help 8 'On this &Tool' 1249 1 0 0 0 610 1 642 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 770 4097 610 1 642 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 770 4097 610 1 642 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 610 1 642 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 610 1 642 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 770 4097 610 1 642 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 610 1 642 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 610 1 642 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 610 1 642 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 770 4097 610 1 642 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 6162 0 16 1728 8 'LiveUpdate.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 770 4097 610 1 642 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6162 0 16 1728 8 '!!APPLICATION' 7040 0 0 8 '&Help' 0 134217729 0 0 44509 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 2226 202 208 98 3 2290 2320 98 2 530 3839 21 530 801 601 416 2290 8 #contextMenu: 98 1 576 416 2290 8 #updateMenuBar 1424 416 2418 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 15 9 0 0 54 1 0 0] 98 3 1184 3152 2496 2480 0 27 )! !
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

