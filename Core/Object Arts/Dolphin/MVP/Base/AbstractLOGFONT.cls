"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #AbstractLOGFONT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractLOGFONT guid: (GUID fromString: '{8f358ad9-379c-415d-a076-730db113b289}')!
AbstractLOGFONT isAbstract: true!
AbstractLOGFONT comment: ''!
!AbstractLOGFONT categoriesForClass!DxVBLibA-Structs! !
!AbstractLOGFONT methodsFor!

createFont
	^self subclassResponsibility!

faceName
	"Answer the receiver's lfFaceName field as a String, having trimmed any extra nulls."
	
	^self subclassResponsibility!

faceName: aString
	"Set the receiver's lfFaceName field."
	
	self subclassResponsibility!

getData: hFont
	self subclassResponsibility!

isFixedWidth
	^(self lfPitchAndFamily bitAnd: 16r3) == 1!

lfCharSet
	"Answer the <Integer> value of the receiver's 'lfCharSet' field."

	^bytes byteAtOffset: ##(self offsetOf: #lfCharSet)!

lfCharSet: anInteger
	"Set the receiver's 'lfCharSet' field to the value of the argument, anInteger"

	bytes byteAtOffset: ##(self offsetOf: #lfCharSet) put: anInteger!

lfEscapement
	"Answer the <Integer> value of the receiver's 'lfEscapement' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #lfEscapement)!

lfEscapement: anInteger
	"Set the receiver's 'lfEscapement' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #lfEscapement) put: anInteger!

lfFaceName
	"Answer the receiver's lfFaceName field as a Smalltalk object."

	^self subclassResponsibility!

lfFaceName: anObject 
	"Set the receiver's lfFaceName field to the value of anObject."

	^self subclassResponsibility!

lfHeight
	"Answer the <Integer> value of the receiver's 'lfHeight' field."

	^bytes sdwordAtOffset: 0!

lfHeight: anInteger
	"Set the receiver's 'lfHeight' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: 0 put: anInteger!

lfItalic
	"Answer the <Integer> value of the receiver's 'lfItalic' field."

	^bytes byteAtOffset: ##(self offsetOf: #lfItalic)!

lfItalic: anInteger
	"Set the receiver's 'lfItalic' field to the value of the argument, anInteger"

	bytes byteAtOffset: ##(self offsetOf: #lfItalic) put: anInteger!

lfPitchAndFamily
	"Answer the <Integer> value of the receiver's 'lfPitchAndFamily' field."

	^bytes byteAtOffset: ##(self offsetOf: #lfPitchAndFamily)!

lfPitchAndFamily: anInteger
	"Set the receiver's 'lfPitchAndFamily' field to the value of the argument, anInteger"

	bytes byteAtOffset: ##(self offsetOf: #lfPitchAndFamily) put: anInteger!

lfQuality
	"Answer the <Integer> value of the receiver's 'lfQuality' field."

	^bytes byteAtOffset: ##(self offsetOf: #lfQuality)!

lfQuality: anInteger
	"Set the receiver's 'lfQuality' field to the value of the argument, anInteger"

	bytes byteAtOffset: ##(self offsetOf: #lfQuality) put: anInteger!

lfStrikeOut
	"Answer the <Integer> value of the receiver's 'lfStrikeOut' field."

	^bytes byteAtOffset: ##(self offsetOf: #lfStrikeOut)!

lfStrikeOut: anInteger
	"Set the receiver's 'lfStrikeOut' field to the value of the argument, anInteger"

	bytes byteAtOffset: ##(self offsetOf: #lfStrikeOut) put: anInteger!

lfUnderline
	"Answer the <Integer> value of the receiver's 'lfUnderline' field."

	^bytes byteAtOffset: ##(self offsetOf: #lfUnderline)!

lfUnderline: anInteger
	"Set the receiver's 'lfUnderline' field to the value of the argument, anInteger"

	bytes byteAtOffset: ##(self offsetOf: #lfUnderline) put: anInteger!

lfWeight
	"Answer the <Integer> value of the receiver's 'lfWeight' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #lfWeight)!

lfWeight: anInteger
	"Set the receiver's 'lfWeight' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #lfWeight) put: anInteger!

lfWidth
	"Answer the <Integer> value of the receiver's 'lfWidth' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #lfWidth)!

lfWidth: anInteger
	"Set the receiver's 'lfWidth' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #lfWidth) put: anInteger! !
!AbstractLOGFONT categoriesFor: #createFont!private!realizing/unrealizing! !
!AbstractLOGFONT categoriesFor: #faceName!accessing!public! !
!AbstractLOGFONT categoriesFor: #faceName:!accessing!public! !
!AbstractLOGFONT categoriesFor: #getData:!accessing!public! !
!AbstractLOGFONT categoriesFor: #isFixedWidth!public! !
!AbstractLOGFONT categoriesFor: #lfCharSet!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfCharSet:!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfEscapement!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfEscapement:!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfFaceName!public! !
!AbstractLOGFONT categoriesFor: #lfFaceName:!accessing!public! !
!AbstractLOGFONT categoriesFor: #lfHeight!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfHeight:!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfItalic!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfItalic:!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfPitchAndFamily!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfPitchAndFamily:!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfQuality!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfQuality:!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfStrikeOut!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfStrikeOut:!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfUnderline!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfUnderline:!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfWeight!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfWeight:!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfWidth!**compiled accessors**!public! !
!AbstractLOGFONT categoriesFor: #lfWidth:!**compiled accessors**!public! !

!AbstractLOGFONT class methodsFor!

defineFields
	"Define the Win32 LOGFONT structure.
		AbstractLOGFONT compileDefinition.
	"

	self
		defineField: #lfHeight type: SDWORDField new;
		defineField: #lfWidth type: SDWORDField new;
		defineField: #lfEscapement type: SDWORDField new;
		defineField: #lfOrientation type: SDWORDField new beUncompiled;
		defineField: #lfWeight type: SDWORDField new;
		defineField: #lfItalic type: BYTEField new;
		defineField: #lfUnderline type: BYTEField new;
		defineField: #lfStrikeOut type: BYTEField new;
		defineField: #lfCharSet type: BYTEField new;
		defineField: #lfOutPrecision type: BYTEField new beUncompiled;
		defineField: #lfClipPrecision type: BYTEField new beUncompiled;
		defineField: #lfQuality type: BYTEField new;
		defineField: #lfPitchAndFamily type: BYTEField new!

getFieldNames
	^#(#lfHeight #lfWidth #lfEscapement #lfOrientation #lfWeight #lfItalic #lfUnderline #lfStrikeOut #lfCharSet #lfOutPrecision #lfClipPrecision #lfQuality #lfPitchAndFamily #lfFaceName)! !
!AbstractLOGFONT class categoriesFor: #defineFields!initializing!public! !
!AbstractLOGFONT class categoriesFor: #getFieldNames!constants!private! !

