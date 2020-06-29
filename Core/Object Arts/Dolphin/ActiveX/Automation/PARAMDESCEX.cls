"Filed out from Dolphin Smalltalk 7"!

OLEStructure subclass: #PARAMDESCEX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cBytes' -> 16r0.
		'_OffsetOf_varDefaultValue' -> 16r8
	}!
PARAMDESCEX guid: (GUID fromString: '{c06f3b61-0868-11d3-93af-00a024ca708a}')!
PARAMDESCEX comment: 'PARAMDESCEX is an <ExternalStructure> to represent the AX Automation PARAMDESCEX structure.

The PARAMDESCEX structure is used to hold the default value (in a variant) for a particular parameter.

Fields:
	cBytes		<DWORD> size of structure (24).
	varDefaultValue	<VARIANT> default value of parameter described by structure.
'!
!PARAMDESCEX categoriesForClass!External-Data-Structured-COM! !
!PARAMDESCEX methodsFor!

varDefaultValue
	"Answer the <VARIANT> value of the receiver's 'varDefaultValue' field."

	^VARIANT fromAddress: bytes yourAddress + _OffsetOf_varDefaultValue! !
!PARAMDESCEX categoriesFor: #varDefaultValue!**compiled accessors**!public! !

!PARAMDESCEX class methodsFor!

defineFields
	"Define the fields of the PARAMDESCEX structure.
	Note that due to Zp8 packing this is actually a 24 byte structure!!

		PARAMDESCEX compileDefinition.

		struct PARAMDESCEX
		{
			ULONG cBytes;
			VARIANTARG varDefaultValue;
		};
	"

	self
		defineField: #cBytes			type: DWORDField filler;
		defineField: #varDefaultValue	type: (StructureField type: VARIANT) beReadOnly
!

getFieldNames
	^#(#varDefaultValue)! !
!PARAMDESCEX class categoriesFor: #defineFields!public!template definition! !
!PARAMDESCEX class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

