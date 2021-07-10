"Filed out from Dolphin Smalltalk"!

ILImportBitmapProxy subclass: #ILImportIconProxy
	instanceVariableNames: 'useMaskBytes maskBytes colorBytes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ILImportIconProxy guid: (GUID fromString: '{85330084-1365-4af7-8325-adcedf79d38f}')!
ILImportIconProxy comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ILImportIconProxy categoriesForClass!IDB Goodies! !
!ILImportIconProxy methodsFor!

colorBytes
	colorBytes isNil 
		ifTrue: 
			[colorBytes := imageBytes copyFrom: 1
						to: imageBytes size - (((self width - 1) // 32 + 1) * 4 * self height)].
	^colorBytes!

colorDepth
	useMaskBytes ifTrue: [^1].
	^super colorDepth!

colorTable
	useMaskBytes ifTrue: [^DeviceIndependentBitmap colorTableForDepth: 1].
	^super colorTable!

height
	^super height // 2!

imageBytes
	^useMaskBytes ifTrue: [self maskBytes] ifFalse: [self colorBytes]!

maskBytes
	maskBytes isNil 
		ifTrue: 
			[maskBytes := imageBytes 
						copyFrom: imageBytes size - (((self width - 1) // 32 + 1) * 4 * self height) + 1
						to: imageBytes size].
	^maskBytes!

setBitmapInfoHeader: aBITMAPINFOHEADER colorTable: aStructureArray imageBytes: aByteArray
	super 
		setBitmapInfoHeader: aBITMAPINFOHEADER
		colorTable: aStructureArray
		imageBytes: aByteArray.
	useMaskBytes := false!

useColorBytes
	useMaskBytes := false!

useMaskBytes
	useMaskBytes := true! !
!ILImportIconProxy categoriesForMethods!
colorBytes!accessing!public! !
colorDepth!accessing!public! !
colorTable!accessing!public! !
height!accessing!public! !
imageBytes!accessing!public! !
maskBytes!accessing!public! !
setBitmapInfoHeader:colorTable:imageBytes:!initializing!public! !
useColorBytes!accessing!public! !
useMaskBytes!accessing!public! !
!

