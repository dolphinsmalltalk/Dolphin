"Filed out from Dolphin Smalltalk"!

OS.EMREXTTEXTOUT subclass: #'OS.EMREXTTEXTOUTA'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EMREXTTEXTOUTA_Size' -> 16r50.
		'_OffsetOf_text' -> 16r4C
	}!
OS.EMREXTTEXTOUTA guid: (Core.GUID fromString: '{897dbf3a-44ad-4594-ae7e-957cb1e28374}')!
OS.EMREXTTEXTOUTA comment: '<EMREXTTEXTOUTA> is an <ExternalStructure> class to wrap the struct ''Win32.EMREXTTEXTOUTA'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(897DBF3A-44AD-4594-AE7E-957CB1E28374)]
struct tagEMREXTTEXTOUTA {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	[helpstring("Current graphics mode")] DWORD iGraphicsMode;
	[helpstring("X and Y scales from Page units to .01mm units")] float exScale;
	[helpstring("if graphics mode is GM_COMPATIBLE.")] float eyScale;
	[helpstring("This is followed by the string and spacing array")] EMRTEXT EMRTEXT;
} EMREXTTEXTOUTA;
'!
!OS.EMREXTTEXTOUTA categoriesForClass!Win32-Structs! !
!OS.EMREXTTEXTOUTA methodsFor!

text
	"Answer the receiver's text field as a Smalltalk object."

	^String fromAddress: bytes yourAddress + _OffsetOf_text length: self EMRTEXT nChars!

text: anObject 
	"Set the receiver's text field to the value of anObject."

	| size |
	size := anObject byteSize - 1 min: self EMRTEXT nChars.
	anObject 
		replaceBytesOf: bytes
		from: ##(_OffsetOf_text + 1)
		to: _OffsetOf_text + size
		startingAt: 1.
	bytes byteAtOffset: _OffsetOf_text + size put: 0! !
!OS.EMREXTTEXTOUTA categoriesForMethods!
text!accessing!public! !
text:!accessing!public! !
!

!OS.EMREXTTEXTOUTA class methodsFor!

byteSize
	^_EMREXTTEXTOUTA_Size!

defineFields
	"Define the fields of the EMREXTTEXTOUTA structure.

	EMREXTTEXTOUTA  compileDefinition
	"

	super defineFields.
	self defineField: #text type: (StringField type: AnsiString length: 1)!

getFieldNames
	^#(#iType #nSize #rclBounds #iGraphicsMode #exScale #eyScale #EMRTEXT #text)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_EXTTEXTOUTA}! !
!OS.EMREXTTEXTOUTA class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

