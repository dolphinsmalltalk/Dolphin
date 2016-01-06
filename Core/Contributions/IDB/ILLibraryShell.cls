"Filed out from Dolphin Smalltalk 7"!

IdbToolShell subclass: #ILLibraryShell
	instanceVariableNames: 'libraryWorkspace libraryFilename libraryStatus imageStatus modifiedStatus'
	classVariableNames: ''
	poolDictionaries: 'CommonDialogConstants'
	classInstanceVariableNames: ''!
ILLibraryShell guid: (GUID fromString: '{1C83FB20-739D-43F4-89F6-026860979F42}')!
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
			fileStream := (FileStream readWrite: filename) beBinary.
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

	"Generated from:
	self createIconMethod: #icon ofSize: 48@48 fromFile: 'C:\Users\bower\Documents\Dolphin\Core\Contributions\IDB\Resources\IDB Image Library.png'.
	"
	^InternalIcon fromBytes: #[137 80 78 71 13 10 26 10 0 0 0 13 73 72 68 82 0 0 0 48 0 0 0 48 8 6 0 0 0 87 2 249 135 0 0 0 1 115 82 71 66 0 174 206 28 233 0 0 0 4 103 65 77 65 0 0 177 143 11 252 97 5 0 0 0 9 112 72 89 115 0 0 14 195 0 0 14 195 1 199 111 168 100 0 0 3 198 73 68 65 84 104 67 237 152 219 75 20 81 28 199 251 27 204 30 234 193 130 168 30 10 122 17 130 168 40 234 37 130 30 4 137 130 234 33 186 64 248 15 4 245 220 5 233 33 10 50 162 114 189 149 120 105 3 201 181 181 204 138 68 114 211 116 177 13 13 91 195 188 149 101 206 197 185 252 58 51 243 155 221 115 118 142 227 236 65 221 162 253 194 151 221 253 157 223 217 239 126 230 156 153 157 221 85 82 101 1 252 203 206 3 228 218 121 128 92 59 15 144 107 231 1 114 237 255 19 64 31 105 1 185 110 11 104 253 55 64 110 40 102 198 228 71 91 65 139 87 128 158 8 1 232 50 88 50 127 143 130 26 61 14 90 223 117 144 66 133 76 191 218 121 30 212 103 199 64 109 63 9 218 192 45 102 44 136 179 6 80 158 150 218 31 106 121 100 114 51 253 44 180 2 160 205 97 224 210 74 79 212 114 243 252 156 253 10 52 238 194 56 71 230 175 47 196 35 226 150 166 240 157 28 241 50 253 44 180 2 166 52 129 113 36 176 186 136 219 99 89 126 184 137 108 185 67 160 180 30 6 169 102 3 183 71 237 56 133 239 68 22 118 160 130 219 227 103 33 0 227 91 23 70 46 12 0 154 4 166 204 30 93 99 34 230 233 163 1 228 39 7 60 227 139 89 108 5 102 62 97 36 31 0 76 3 204 217 81 144 27 139 201 81 189 131 157 142 180 216 21 166 151 6 80 95 158 99 198 130 120 201 1 148 72 9 1 208 153 154 101 125 52 138 51 216 125 206 2 156 101 198 130 88 112 11 189 197 72 47 128 169 43 228 106 82 195 212 92 187 146 195 251 82 53 102 11 133 247 51 253 65 44 4 48 223 91 142 145 94 0 75 250 199 42 166 70 143 89 210 222 151 167 106 52 0 221 27 212 66 0 250 112 51 70 242 1 140 100 59 83 163 199 44 233 159 27 82 53 102 11 181 29 97 250 131 88 8 128 22 13 32 87 175 183 107 198 216 27 166 223 181 43 61 217 150 170 209 0 214 247 2 221 31 196 98 0 228 36 117 69 3 104 221 23 177 234 221 14 114 221 70 28 33 128 83 189 169 58 13 96 76 246 48 115 130 56 107 0 115 170 15 227 28 49 0 253 55 177 10 160 52 239 100 230 25 19 239 112 132 240 207 141 167 234 52 128 37 169 114 117 106 44 136 179 6 200 20 13 160 118 156 193 170 35 173 231 42 217 46 207 237 231 82 104 141 253 232 42 61 39 3 32 227 156 90 204 89 3 204 119 93 194 40 71 108 96 33 86 29 25 95 95 80 99 25 231 14 214 188 43 144 238 15 98 177 115 128 92 235 93 101 30 49 90 243 177 107 204 152 49 25 195 17 114 197 233 112 190 117 105 0 125 40 125 117 10 106 49 0 74 11 1 40 225 61 76 221 178 57 51 132 163 142 228 166 29 12 128 117 251 145 57 103 49 11 1 168 157 101 24 201 2 24 163 237 118 77 105 57 200 244 187 54 127 14 219 227 174 244 100 148 1 144 170 214 114 231 249 89 8 64 27 110 192 72 4 168 41 194 87 228 40 254 24 228 206 177 156 41 47 192 58 238 60 63 11 1 24 211 31 48 210 1 0 101 26 95 17 145 95 107 188 57 74 120 47 54 164 149 9 176 98 223 196 244 86 176 1 56 50 229 105 251 166 79 75 60 32 183 212 183 177 202 202 3 240 170 140 155 231 103 49 128 239 113 140 92 24 32 136 60 0 209 19 220 60 63 11 1 232 201 8 70 46 45 128 92 187 153 155 231 103 177 21 152 27 195 72 7 128 215 19 212 52 128 54 120 143 219 227 231 172 1 148 166 221 24 183 60 226 101 250 89 104 5 96 126 22 227 150 86 250 224 125 110 158 159 179 95 129 200 81 140 75 75 139 223 5 115 58 78 126 232 60 38 143 3 88 229 203 250 243 202 24 123 77 238 147 58 201 7 14 97 213 213 10 253 51 167 37 170 200 143 151 13 160 197 46 131 92 191 157 219 35 215 111 35 125 33 48 198 187 201 13 224 5 110 143 101 181 227 52 168 145 82 80 91 75 236 247 227 245 248 89 8 224 111 114 30 32 215 206 3 228 218 121 128 92 59 15 144 91 23 192 31 144 63 12 209 236 248 61 179 0 0 0 0 73 69 78 68 174 66 96 130]!

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 328198 ##(Smalltalk.Point)  801 601 519 265030 4 ##(Smalltalk.Menu)  0 16 98 9 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #addImage 8 'New Image' 1 1 0 0 0 610 1 642 8 #editImage 8 'Edit Image' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 610 1 642 8 #deleteImage 8 'Delete selected Image(s)' 1 1 0 0 0 770 4097 610 1 642 8 #moveToStart 8 'Move to Start' 1 1 0 0 0 610 1 642 8 #moveUp 8 'Move Up' 1 1 0 0 0 610 1 642 8 #moveDown 8 'Move Down' 1 1 0 0 0 610 1 642 8 #moveToEnd 8 'Move to End' 1 1 0 0 0 8 'Image' 0 1 0 0 0 0 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1140853548 131137 1184 0 0 0 519 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 530 193 193 0 1184 482 8 4278190080 8 4294903819 234 256 98 0 234 256 98 18 20847 1246982 ##(Smalltalk.ToolbarSystemButton)  20847 0 1184 1 642 8 #openLibrary 8 'Open Library' 1 1 0 1 15 20849 1474 20849 0 1184 1 642 8 #saveLibrary 8 'Save Library' 1 1 0 1 17 20851 853766 ##(Smalltalk.ToolbarButton)  20851 0 1184 1 642 672 8 'New Image' 1 1 0 657990 3 ##(Smalltalk.DIBSection)  0 16 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.ImageRelativeFileLocator)  8 #current 8 'Idb\Resources\ImageLibrary.bmp' 0 0 7 530 225 33 9 0 1 20853 1618 20853 0 1184 1 642 736 8 'Edit Image' 1 1 0 1696 3 20855 1618 20855 0 1184 1 642 832 8 'Delete Image' 1 1 0 1696 13 20857 1618 20857 0 1184 1 642 912 8 'Move to Start' 1 1 0 1696 5 20859 1618 20859 0 1184 1 642 976 8 'Move Up' 1 1 0 1696 7 20861 1618 20861 0 1184 1 642 1040 8 'Move Down' 1 1 0 1696 9 20863 1618 20863 0 1184 1 642 1104 8 'Move to End' 1 1 0 1696 11 98 11 1488 1552 1050118 ##(Smalltalk.ToolbarSeparator)  0 0 1184 3 0 1 1632 1808 1856 2114 0 0 1184 3 0 1 1904 1952 2000 2048 234 240 98 4 1 1 1696 31 0 1 0 530 33 33 530 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 530 1 1 530 785 51 1184 2322 8 #updateSize 1424 1184 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 136 1 0 0 25 0 0 0] 98 0 530 193 193 0 27 410 8 ##(Smalltalk.StatusBar)  98 18 0 416 98 2 8 1140853004 1 2528 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 1266 0 16 1298 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 530 193 193 0 2528 0 8 4294904209 234 256 98 10 853766 ##(Smalltalk.StatusBarItem)  1 161 2528 0 8 ##(Smalltalk.BasicListAbstract)  0 0 8 'statusModified' 2754 1 341 2528 0 2784 0 0 8 'imageStatus' 2754 1 201 2528 0 2784 0 1722 8 ##(Smalltalk.IconImageManager)  1760 8 'libraryStatus' 2754 1 121 2528 0 2784 0 0 8 'imageExtent' 2754 1 -1 2528 0 2784 0 0 8 'modifiedStatus' 98 3 2848 2816 2944 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 2528 0 0 2258 202 208 98 1 2322 2352 98 2 530 1 449 530 785 45 2528 2450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 224 0 0 0 136 1 0 0 246 0 0 0] 98 0 2512 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 3184 0 2610 31 0 7 0 0 0 3184 1154 1 1 0 0 0 0 410 8 ##(Smalltalk.ScrollingDecorator)  98 18 0 3184 98 2 8 1152385024 131073 3296 0 482 512 0 7 0 0 0 3296 1573190 1 ##(Smalltalk.ScrollingDecoratorLayout)  16 234 256 98 2 410 8 ##(Smalltalk.ReferenceView)  98 14 0 3296 98 2 8 1140916224 131073 3456 0 0 0 7 0 0 0 3456 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.ILLibraryWorkspacePresenter)  8 #resource_Default_view 0 2258 202 208 98 1 2322 2352 98 2 530 1 1 530 765 395 3456 2450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 126 1 0 0 197 0 0 0] 1424 2512 0 27 8 'libraryWorkspace' 590342 ##(Smalltalk.Rectangle)  530 9 9 530 9 9 530 1 1 16 530 17 17 2258 202 208 98 1 2322 2352 98 2 530 9 1 530 769 399 3296 2450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 0 0 0 0 132 1 0 0 199 0 0 0] 98 1 3456 2512 0 27 234 256 98 2 3296 8 'scroller' 3762 530 9 1 530 9 1 2258 202 208 98 1 2322 2352 98 2 530 1 51 530 785 399 3184 2450 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 136 1 0 0 224 0 0 0] 98 1 3296 2512 0 27 234 256 1424 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 4 562 0 16 98 15 610 1 642 8 #newLibrary 8 '&New Library' 1 1 0 0 0 610 1 642 1520 8 '&Open Library' 1 1 0 0 0 610 1 642 1584 8 '&Save Library' 1 1 0 0 0 610 1 642 8 #saveLibraryAs 8 'Save Library &As' 1 1 0 0 0 770 4097 610 1 642 8 #import 8 'Im&port' 1 1 0 0 0 770 4097 610 1 642 8 #exportBitmap 8 'Export as &Bitmap' 1 1 0 0 0 610 1 642 8 #exportIcon 8 'Export as &Icon' 1 1 0 0 0 610 1 642 8 #exportCursor 8 'Export as &Cursor' 1 1 0 0 0 610 1 642 8 #exportExe 8 'Export to &Exe' 1 1 0 0 0 770 4097 562 0 16 98 5 610 1 642 459270 ##(Smalltalk.Message)  8 #setBackgroundColor: 98 1 8 #black 8 '&Black' 1 1 0 0 0 610 1 642 5026 5056 98 1 8 #caption 8 '&Caption' 1 1 0 0 0 610 1 642 5026 5056 98 1 8 #dolphinYellow 8 '&Transparent' 1 1 0 0 0 610 1 642 5026 5056 98 1 8 #toolbarGray 8 'Toolbar &Grey' 1 1 0 0 0 610 1 642 5026 5056 98 1 8 #white 8 '&White' 1 1 0 0 0 8 'Select Back&ground Colour' 0 1 0 0 20787 0 0 770 4097 610 1 642 8 #exit 8 'E&xit' 1 1 0 0 0 8 '&Library' 0 1 0 0 20791 0 0 562 0 16 98 9 610 1 642 672 8 '&New Image' 1 1 0 0 0 610 1 642 736 8 '&Edit Image' 1 1 0 0 0 770 4097 610 1 642 832 8 '&Delete selected Image(s)' 1 1 0 0 0 770 4097 610 1 642 912 8 'Move to &Start' 1 1 0 0 0 610 1 642 976 8 'Move Up' 8363 1 0 0 0 610 1 642 1040 8 'Move Down' 8329 1 0 0 0 610 1 642 1104 8 'Mo&ve to End' 1 1 0 0 0 8 '&Image' 0 1 0 0 20807 0 0 562 0 16 98 0 8 '&Tools' 8 #toolsMenu 1 0 0 20809 0 0 562 0 16 98 19 610 1 642 8 #helpContents 8 '&Contents' 1025 1 263494 3 ##(Smalltalk.Icon)  0 16 1728 49 1722 8 ##(Smalltalk.ShellLibrary)  8 #default 0 0 610 1 642 8 #help 8 'On this &Tool' 1249 1 0 0 0 610 1 642 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 770 4097 610 1 642 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 770 4097 610 1 642 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 610 1 642 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 610 1 642 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 562 0 16 98 4 610 2097153 642 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 6194 0 16 1728 8 'TipOfTheDay.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 610 1 642 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 6194 0 16 1728 8 'TipOfTheDay.ico' 6832 0 0 770 4097 610 1 642 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 0 0 0 770 4097 610 1 642 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 610 1 642 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 610 1 642 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 610 1 642 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 770 4097 610 1 642 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 6194 0 16 1728 8 'LiveUpdate.ico' 6832 0 0 770 4097 610 1 642 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 6194 0 16 1728 8 '!!APPLICATION' 6832 0 0 8 '&Help' 0 134217729 0 0 0 0 0 8 '' 0 1 0 0 0 0 0 0 1049350 ##(Smalltalk.AcceleratorTable)  0 16 98 7 721414 ##(Smalltalk.Association)  8363 5888 7634 8329 5936 7634 1025 642 6160 8 '&Contents' 1025 1 6194 0 16 1728 49 6224 7634 1249 642 6304 8 'On this &Tool' 1249 1 0 7634 5345 642 6368 8 'What''s This?' 5345 1 0 7634 9441 642 6752 8 '&Next Tip of the Day' 9441 1 6194 0 16 1728 8 'TipOfTheDay.ico' 6832 7634 13537 642 6896 8 '&Previous Tip of the Day' 13537 1 6194 0 16 1728 8 'TipOfTheDay.ico' 6832 0 1 0 0 0 0 1 0 0 2258 202 208 98 3 2322 2352 98 2 530 6399 21 530 801 601 416 2322 8 #contextMenu: 98 1 576 416 2322 8 #menuBar: 98 1 4304 416 2450 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 12 0 0 10 0 0 0 15 14 0 0 54 1 0 0] 98 3 1184 3184 2528 2512 0 27 )! !
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

