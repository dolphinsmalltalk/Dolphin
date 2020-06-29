"Filed out from Dolphin Smalltalk 7"!

ILImportIcon subclass: #ILImportExe
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ILImportExe guid: (GUID fromString: '{460509a0-67d1-48c8-81e9-4356077f5e96}')!
ILImportExe comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ILImportExe categoriesForClass!IDB Goodies! !
!ILImportExe methodsFor!

initializeFrom: aStream
	| offset |
	icons := OrderedCollection new.
	offset := self class iconsStartAddress.
	self class iconsSizes do: 
			[:size | 
			icons add: (self getBitmapFrom: (aStream
								position: offset;
								next: size)).
			offset := offset + size].
	self assert: [aStream position = self class iconsEndAddress]! !
!ILImportExe categoriesFor: #initializeFrom:!initializing!public! !

!ILImportExe class methodsFor!

iconsCheck: aStream
	"The bytes that must be found to make sure there is an icon in the correct place"

	"Check for a 32x32@16 BITMAPINFOHEADER"

	aStream position: self iconsStartAddress.
	(aStream next: BITMAPINFOHEADER byteSize) = ((BITMAPINFOHEADER new)
				biWidth: 32;
				biHeight: 64;
				biPlanes: 1;
				biBitCount: 4;
				biSizeImage: 640;
				bytes) 
		ifFalse: [^false].

	"Check for a following 32x32@256 BITMAPINFOHEADER"
	aStream position: self iconsStartAddress + self iconsSizes first.
	^(aStream next: BITMAPINFOHEADER byteSize) = ((BITMAPINFOHEADER new)
				biWidth: 32;
				biHeight: 64;
				biPlanes: 1;
				biBitCount: 8;
				biSizeImage: 1152;
				bytes)!

iconsEndAddress
	self subclassResponsibility!

iconsSizes
	"The size of the 2 icons in the correct order -
	32x32@16  32x32@256"

	^#(744 2216)!

iconsStartAddress
	self subclassResponsibility!

isResponsibleFor: aStream
	^(aStream next: 2) = 'MZ' asByteArray 
		and: [aStream size > self iconsEndAddress and: [self iconsCheck: aStream]]! !
!ILImportExe class categoriesFor: #iconsCheck:!constants!public! !
!ILImportExe class categoriesFor: #iconsEndAddress!constants!public! !
!ILImportExe class categoriesFor: #iconsSizes!constants!public! !
!ILImportExe class categoriesFor: #iconsStartAddress!constants!public! !
!ILImportExe class categoriesFor: #isResponsibleFor:!public!testing! !

