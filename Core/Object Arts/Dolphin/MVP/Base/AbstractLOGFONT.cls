"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #AbstractLOGFONT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_lfCharSet _OffsetOf_lfClipPrecision _OffsetOf_lfEscapement _OffsetOf_lfHeight _OffsetOf_lfItalic _OffsetOf_lfOrientation _OffsetOf_lfOutPrecision _OffsetOf_lfPitchAndFamily _OffsetOf_lfQuality _OffsetOf_lfStrikeOut _OffsetOf_lfUnderline _OffsetOf_lfWeight _OffsetOf_lfWidth'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractLOGFONT guid: (GUID fromString: '{8f358ad9-379c-415d-a076-730db113b289}')!
AbstractLOGFONT isAbstract: true!
AbstractLOGFONT addClassConstant: '_OffsetOf_lfCharSet' value: 16r17!
AbstractLOGFONT addClassConstant: '_OffsetOf_lfClipPrecision' value: 16r19!
AbstractLOGFONT addClassConstant: '_OffsetOf_lfEscapement' value: 16r8!
AbstractLOGFONT addClassConstant: '_OffsetOf_lfHeight' value: 16r0!
AbstractLOGFONT addClassConstant: '_OffsetOf_lfItalic' value: 16r14!
AbstractLOGFONT addClassConstant: '_OffsetOf_lfOrientation' value: 16rC!
AbstractLOGFONT addClassConstant: '_OffsetOf_lfOutPrecision' value: 16r18!
AbstractLOGFONT addClassConstant: '_OffsetOf_lfPitchAndFamily' value: 16r1B!
AbstractLOGFONT addClassConstant: '_OffsetOf_lfQuality' value: 16r1A!
AbstractLOGFONT addClassConstant: '_OffsetOf_lfStrikeOut' value: 16r16!
AbstractLOGFONT addClassConstant: '_OffsetOf_lfUnderline' value: 16r15!
AbstractLOGFONT addClassConstant: '_OffsetOf_lfWeight' value: 16r10!
AbstractLOGFONT addClassConstant: '_OffsetOf_lfWidth' value: 16r4!
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

	^bytes byteAtOffset: _OffsetOf_lfCharSet!

lfCharSet: anInteger
	"Set the receiver's 'lfCharSet' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_lfCharSet put: anInteger!

lfEscapement
	"Answer the <Integer> value of the receiver's 'lfEscapement' field."

	^bytes sdwordAtOffset: _OffsetOf_lfEscapement!

lfEscapement: anInteger
	"Set the receiver's 'lfEscapement' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_lfEscapement put: anInteger!

lfFaceName
	"Answer the receiver's lfFaceName field as a Smalltalk object."

	^self subclassResponsibility!

lfFaceName: anObject 
	"Set the receiver's lfFaceName field to the value of anObject."

	^self subclassResponsibility!

lfHeight
	"Answer the <Integer> value of the receiver's 'lfHeight' field."

	^bytes sdwordAtOffset: _OffsetOf_lfHeight!

lfHeight: anInteger
	"Set the receiver's 'lfHeight' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_lfHeight put: anInteger!

lfItalic
	"Answer the <Integer> value of the receiver's 'lfItalic' field."

	^bytes byteAtOffset: _OffsetOf_lfItalic!

lfItalic: anInteger
	"Set the receiver's 'lfItalic' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_lfItalic put: anInteger!

lfPitchAndFamily
	"Answer the <Integer> value of the receiver's 'lfPitchAndFamily' field."

	^bytes byteAtOffset: _OffsetOf_lfPitchAndFamily!

lfPitchAndFamily: anInteger
	"Set the receiver's 'lfPitchAndFamily' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_lfPitchAndFamily put: anInteger!

lfQuality
	"Answer the <Integer> value of the receiver's 'lfQuality' field."

	^bytes byteAtOffset: _OffsetOf_lfQuality!

lfQuality: anInteger
	"Set the receiver's 'lfQuality' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_lfQuality put: anInteger!

lfStrikeOut
	"Answer the <Integer> value of the receiver's 'lfStrikeOut' field."

	^bytes byteAtOffset: _OffsetOf_lfStrikeOut!

lfStrikeOut: anInteger
	"Set the receiver's 'lfStrikeOut' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_lfStrikeOut put: anInteger!

lfUnderline
	"Answer the <Integer> value of the receiver's 'lfUnderline' field."

	^bytes byteAtOffset: _OffsetOf_lfUnderline!

lfUnderline: anInteger
	"Set the receiver's 'lfUnderline' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_lfUnderline put: anInteger!

lfWeight
	"Answer the <Integer> value of the receiver's 'lfWeight' field."

	^bytes sdwordAtOffset: _OffsetOf_lfWeight!

lfWeight: anInteger
	"Set the receiver's 'lfWeight' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_lfWeight put: anInteger!

lfWidth
	"Answer the <Integer> value of the receiver's 'lfWidth' field."

	^bytes sdwordAtOffset: _OffsetOf_lfWidth!

lfWidth: anInteger
	"Set the receiver's 'lfWidth' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_lfWidth put: anInteger! !
!AbstractLOGFONT categoriesForMethods!
createFont!private!realizing/unrealizing! !
faceName!accessing!public! !
faceName:!accessing!public! !
getData:!accessing!public! !
isFixedWidth!public! !
lfCharSet!**compiled accessors**!public! !
lfCharSet:!**compiled accessors**!public! !
lfEscapement!**compiled accessors**!public! !
lfEscapement:!**compiled accessors**!public! !
lfFaceName!public! !
lfFaceName:!accessing!public! !
lfHeight!**compiled accessors**!public! !
lfHeight:!**compiled accessors**!public! !
lfItalic!**compiled accessors**!public! !
lfItalic:!**compiled accessors**!public! !
lfPitchAndFamily!**compiled accessors**!public! !
lfPitchAndFamily:!**compiled accessors**!public! !
lfQuality!**compiled accessors**!public! !
lfQuality:!**compiled accessors**!public! !
lfStrikeOut!**compiled accessors**!public! !
lfStrikeOut:!**compiled accessors**!public! !
lfUnderline!**compiled accessors**!public! !
lfUnderline:!**compiled accessors**!public! !
lfWeight!**compiled accessors**!public! !
lfWeight:!**compiled accessors**!public! !
lfWidth!**compiled accessors**!public! !
lfWidth:!**compiled accessors**!public! !
!

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
!AbstractLOGFONT class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!constants!private! !
!

