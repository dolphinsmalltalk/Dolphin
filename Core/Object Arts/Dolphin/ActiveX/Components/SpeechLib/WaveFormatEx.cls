"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #WaveFormatEx
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WaveFormatEx guid: (GUID fromString: '{236aa950-6713-445a-a791-c83ab1c509b9}')!
WaveFormatEx comment: '<WaveFormatEx> is an <ExternalStructure> class to wrap the struct ''SpeechLib.WaveFormatEx'' from type information in the ''Microsoft Speech Object Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [hidden, restricted]
struct tagWaveFormatEx {
	unsigned short wFormatTag;
	unsigned short nChannels;
	unsigned long nSamplesPerSec;
	unsigned long nAvgBytesPerSec;
	unsigned short nBlockAlign;
	unsigned short wBitsPerSample;
	unsigned short cbSize;
} WaveFormatEx;
'!
!WaveFormatEx categoriesForClass!SpeechLib-Structs! !
!WaveFormatEx methodsFor!

cbSize
	"Answer the receiver's cbSize field as a Smalltalk object."

	^(bytes wordAtOffset: 16)!

cbSize: anObject
	"Set the receiver's cbSize field to the value of anObject."

	bytes wordAtOffset: 16 put: anObject!

nAvgBytesPerSec
	"Answer the receiver's nAvgBytesPerSec field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

nAvgBytesPerSec: anObject
	"Set the receiver's nAvgBytesPerSec field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject!

nBlockAlign
	"Answer the receiver's nBlockAlign field as a Smalltalk object."

	^(bytes wordAtOffset: 12)!

nBlockAlign: anObject
	"Set the receiver's nBlockAlign field to the value of anObject."

	bytes wordAtOffset: 12 put: anObject!

nChannels
	"Answer the receiver's nChannels field as a Smalltalk object."

	^(bytes wordAtOffset: 2)!

nChannels: anObject
	"Set the receiver's nChannels field to the value of anObject."

	bytes wordAtOffset: 2 put: anObject!

nSamplesPerSec
	"Answer the receiver's nSamplesPerSec field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

nSamplesPerSec: anObject
	"Set the receiver's nSamplesPerSec field to the value of anObject."

	bytes dwordAtOffset: 4 put: anObject!

wBitsPerSample
	"Answer the receiver's wBitsPerSample field as a Smalltalk object."

	^(bytes wordAtOffset: 14)!

wBitsPerSample: anObject
	"Set the receiver's wBitsPerSample field to the value of anObject."

	bytes wordAtOffset: 14 put: anObject!

wFormatTag
	"Answer the receiver's wFormatTag field as a Smalltalk object."

	^(bytes wordAtOffset: 0)!

wFormatTag: anObject
	"Set the receiver's wFormatTag field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject! !
!WaveFormatEx categoriesFor: #cbSize!**compiled accessors**!public! !
!WaveFormatEx categoriesFor: #cbSize:!**compiled accessors**!public! !
!WaveFormatEx categoriesFor: #nAvgBytesPerSec!**compiled accessors**!public! !
!WaveFormatEx categoriesFor: #nAvgBytesPerSec:!**compiled accessors**!public! !
!WaveFormatEx categoriesFor: #nBlockAlign!**compiled accessors**!public! !
!WaveFormatEx categoriesFor: #nBlockAlign:!**compiled accessors**!public! !
!WaveFormatEx categoriesFor: #nChannels!**compiled accessors**!public! !
!WaveFormatEx categoriesFor: #nChannels:!**compiled accessors**!public! !
!WaveFormatEx categoriesFor: #nSamplesPerSec!**compiled accessors**!public! !
!WaveFormatEx categoriesFor: #nSamplesPerSec:!**compiled accessors**!public! !
!WaveFormatEx categoriesFor: #wBitsPerSample!**compiled accessors**!public! !
!WaveFormatEx categoriesFor: #wBitsPerSample:!**compiled accessors**!public! !
!WaveFormatEx categoriesFor: #wFormatTag!**compiled accessors**!public! !
!WaveFormatEx categoriesFor: #wFormatTag:!**compiled accessors**!public! !

!WaveFormatEx class methodsFor!

defineFields
	"Define the fields of the WaveFormatEx structure.
		WaveFormatEx compileDefinition
	
		typedef [hidden, restricted]
		struct tagWaveFormatEx {
			unsigned short wFormatTag;
			unsigned short nChannels;
			unsigned long nSamplesPerSec;
			unsigned long nAvgBytesPerSec;
			unsigned short nBlockAlign;
			unsigned short wBitsPerSample;
			unsigned short cbSize;
		} WaveFormatEx;
"

	self
		defineField: #wFormatTag type: WORDField new offset: 0;
		defineField: #nChannels type: WORDField new offset: 2;
		defineField: #nSamplesPerSec type: DWORDField new offset: 4;
		defineField: #nAvgBytesPerSec type: DWORDField new offset: 8;
		defineField: #nBlockAlign type: WORDField new offset: 12;
		defineField: #wBitsPerSample type: WORDField new offset: 14;
		defineField: #cbSize type: WORDField new offset: 16.
	self byteSize: 20!

libraryAndIndex
	"Answer an <Asssociation> between an <AXTypeLibraryAnalyzer> on the receiver's type library
	and the index of the receiver's type information in that library"

	^SpeechLib -> 161! !
!WaveFormatEx class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!WaveFormatEx class categoriesFor: #libraryAndIndex!**auto generated**!initializing!public! !

