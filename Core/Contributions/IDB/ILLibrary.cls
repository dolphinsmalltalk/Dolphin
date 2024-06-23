"Filed out from Dolphin Smalltalk"!

Object subclass: #ILLibrary
	instanceVariableNames: 'images selectedImages modified dum4 dum5'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ILLibrary guid: (GUID fromString: '{b60a9a63-5a6e-49a4-9c61-58463387b1d3}')!

ILLibrary comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ILLibrary categoriesForClass!IDB Goodies! !

!ILLibrary methodsFor!

addImage: aPoint
	Cursor wait showWhile: [images add: (ILImage extent: aPoint)].
	self beModified!

beModified
	modified := true.
	self trigger: #libraryChanged: with: nil!

beNotModified
	modified := false.
	self trigger: #libraryChanged: with: nil!

clearBitmapCache
	images do: [:each | each clearBitmapCache]!

deleteImage
	selectedImages do: [:each | images remove: each].
	selectedImages := Set new.
	self beModified!

editImageWithBackcolor: anRGB
	(ILEditorShell createOn: self selectedImage)
		backcolor: anRGB;
		when: #replaceImage:
			send: #onReplaceImage:
			to: self;
		when: #addImage:
			send: #onAddImage:
			to: self;
		show!

exportBitmapTo: aStream
	ILExportBitmap export: (self sortImages: selectedImages) to: aStream!

exportCursorTo: aStream
	ILExportCursor export: (self sortImages: selectedImages) to: aStream!

exportExeTo: aStream
	ILExportExe export: (self sortImages: selectedImages) to: aStream!

exportIconTo: aStream
	ILExportIcon export: (self sortImages: selectedImages) to: aStream!

hasImages
	^images size ~= 0!

hasMultipleImages
	^images size > 1!

hasSelection
	^selectedImages notEmpty!

hasSingleSelection
	^selectedImages size = 1!

imageCount
	^images size!

images
	^images!

imageSizes
	^((images collect: [:each | each extent]) , self class defaultExtents) asSet 
		asSortedCollection!

import: aStream
	| fileClass |
	fileClass := ILImport identifyImportFileClass: aStream.
	fileClass isNil ifTrue: [^self].
	images addAll: (fileClass importFrom: aStream)!

initialize
	super initialize.
	images := OrderedCollection new.
	selectedImages := Set new.
	modified := false!

isModified
	^modified!

isSelected: anILImage
	^selectedImages includes: anILImage!

move: aBoolean
	| oldImages |
	oldImages := images.
	images := OrderedCollection new.
	aBoolean ifFalse: [oldImages := oldImages reverse].
	images add: oldImages removeFirst.
	[oldImages isEmpty] whileFalse: 
			[| flag temp |
			flag := (self isSelected: images last) not and: [self isSelected: oldImages first].
			flag ifTrue: [temp := images removeLast].
			images addLast: oldImages removeFirst.
			flag ifTrue: [images addLast: temp]].
	aBoolean ifFalse: [images := images reverse].
	self beModified!

moveDown
	self move: false!

moveTo: aBoolean
	| movers stayers |
	movers := (self sortImages: selectedImages) asOrderedCollection.
	stayers := (self sortImages: (images copyWithoutAll: movers)) asOrderedCollection.
	images := aBoolean ifTrue: [movers , stayers] ifFalse: [stayers , movers].
	self beModified!

moveToEnd
	self moveTo: false!

moveToStart
	self moveTo: true!

moveUp
	self move: true!

onAddImage: anILImage
	images add: anILImage.
	self beModified!

onReplaceImage: anILImage
	self hasSingleSelection ifFalse: [^self onAddImage: anILImage].
	images at: (images indexOf: self selectedImage) put: anILImage.
	selectedImages := Set with: anILImage.
	self beModified!

resetAfterImport
	selectedImages := Set new.
	self beModified!

resetAfterLoad
	selectedImages := Set new.
	self beNotModified!

resetAfterSave: anRGB
	ILImage transparentRGB: anRGB.
	self beNotModified!

resetBeforeSave
	self clearBitmapCache.
	ILImage transparentRGB: nil!

selectAll
	selectedImages := Set withAll: images.
	self trigger: #libraryChanged: with: selectedImages!

selectBetween: anILImage1 and: anILImage2
	| changed |
	changed := selectedImages.
	selectedImages := Set withAll: (images 
						copyFrom: (images findFirst: [:each | each == anILImage1 | (each == anILImage2)])
						to: (images findLast: [:each | each == anILImage1 | (each == anILImage2)])).
	changed addAll: selectedImages.
	self trigger: #libraryChanged: with: changed!

selectedImage
	^selectedImages asOrderedCollection first!

selectInvert: anILImage
	(selectedImages includes: anILImage) 
		ifTrue: [selectedImages remove: anILImage]
		ifFalse: [selectedImages add: anILImage].
	self trigger: #libraryChanged: with: (Set with: anILImage)!

selectOnly: anILImage
	| changed |
	(selectedImages size = 1 and: [selectedImages includes: anILImage]) ifTrue: [^self].
	changed := selectedImages.
	changed add: anILImage.
	selectedImages := Set with: anILImage.
	self trigger: #libraryChanged: with: changed!

sortImages: aCollection
	^aCollection asSortedCollection: [:a :b | (images indexOf: a) < (images indexOf: b)]! !

!ILLibrary categoriesForMethods!
addImage:!adding!public! !
beModified!accessing!public! !
beNotModified!accessing!public! !
clearBitmapCache!helpers!public! !
deleteImage!commands!operations!public! !
editImageWithBackcolor:!operations!public! !
exportBitmapTo:!operations!public! !
exportCursorTo:!operations!public! !
exportExeTo:!operations!public! !
exportIconTo:!operations!public! !
hasImages!public!testing! !
hasMultipleImages!public!testing! !
hasSelection!public!testing! !
hasSingleSelection!public!testing! !
imageCount!accessing!public! !
images!accessing!public! !
imageSizes!accessing!public! !
import:!operations!public! !
initialize!initializing!public! !
isModified!public!testing! !
isSelected:!public!testing! !
move:!operations!public! !
moveDown!operations!public! !
moveTo:!operations!public! !
moveToEnd!operations!public! !
moveToStart!operations!public! !
moveUp!operations!public! !
onAddImage:!event handling!public! !
onReplaceImage:!event handling!public! !
resetAfterImport!helpers!public! !
resetAfterLoad!helpers!public! !
resetAfterSave:!helpers!public! !
resetBeforeSave!helpers!public! !
selectAll!operations!public! !
selectBetween:and:!operations!public! !
selectedImage!operations!public! !
selectInvert:!operations!public! !
selectOnly:!operations!public! !
sortImages:!helpers!public! !
!

!ILLibrary class methodsFor!

defaultExtents
	^##((OrderedCollection new)
		add: 16 asPoint;
		add: 32 asPoint;
		add: 48 asPoint;
		add: 64 asPoint;
		yourself)!

importIco: icoFilename exportExe: exeFilename
	| library icoStream exeStream |
	library := self new.
	icoStream := FileStream read: icoFilename text: false.
	exeStream := (FileStream readWrite: exeFilename text: false).
	
	[library
		import: icoStream;
		selectAll;
		exportExeTo: exeStream] ensure: 
				[icoStream close.
				exeStream close]!

new
	^super new initialize! !

!ILLibrary class categoriesForMethods!
defaultExtents!constants!public! !
importIco:exportExe:!operations!public! !
new!object creation!public! !
!

