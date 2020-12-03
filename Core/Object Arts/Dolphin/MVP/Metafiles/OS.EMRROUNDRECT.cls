"Filed out from Dolphin Smalltalk 7"!

OS.ENHMETARECORD subclass: #'OS.EMRROUNDRECT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_rclBox' -> 16r8.
		'_OffsetOf_szlCorner' -> 16r18
	}!
OS.EMRROUNDRECT guid: (Core.GUID fromString: '{31c4124d-eff4-4b42-adfd-7ed8d589eade}')!
OS.EMRROUNDRECT comment: '<EMRROUNDRECT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRROUNDRECT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(31C4124D-EFF4-4B42-ADFD-7ED8D589EADE)]
struct tagEMRROUNDRECT {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounding rectangle")] RECTL rclBox;
	SIZEL szlCorner;
} EMRROUNDRECT;
'!
!OS.EMRROUNDRECT categoriesForClass!Win32-Structs! !
!OS.EMRROUNDRECT methodsFor!

rclBox
	"Answer the <RECTL> value of the receiver's 'rclBox' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rclBox!

rclBox: aRECT
	"Set the receiver's 'rclBox' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBox + 1)
		to: ##(_OffsetOf_rclBox + RECTL basicByteSize)
		startingAt: 1!

szlCorner
	"Answer the <SIZE> value of the receiver's 'szlCorner' field."

	^SIZEL fromAddress: bytes yourAddress + _OffsetOf_szlCorner!

szlCorner: aSIZE
	"Set the receiver's 'szlCorner' field to the value of the argument, aSIZE"

	aSIZE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_szlCorner + 1)
		to: ##(_OffsetOf_szlCorner + SIZEL basicByteSize)
		startingAt: 1! !
!OS.EMRROUNDRECT categoriesFor: #rclBox!**compiled accessors**!public! !
!OS.EMRROUNDRECT categoriesFor: #rclBox:!**compiled accessors**!public! !
!OS.EMRROUNDRECT categoriesFor: #szlCorner!**compiled accessors**!public! !
!OS.EMRROUNDRECT categoriesFor: #szlCorner:!**compiled accessors**!public! !

!OS.EMRROUNDRECT class methodsFor!

defineFields
	"Define the fields of the EMRROUNDRECT structure.

	EMRROUNDRECT  compileDefinition

		typedef [uuid(31C4124D-EFF4-4B42-ADFD-7ED8D589EADE)]
		struct tagEMRROUNDRECT {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounding rectangle')] RECTL rclBox;
			SIZEL szlCorner;
		} EMRROUNDRECT;
"

	super defineFields.
	self
		defineField: #rclBox
			type: (StructureField type: RECTL)
			offset: 8;
		defineField: #szlCorner
			type: (StructureField type: SIZEL)
			offset: 24.
	self byteSize: 32!

getFieldNames
	^#(#iType #nSize #rclBox #szlCorner)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_ROUNDRECT}! !
!OS.EMRROUNDRECT class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.EMRROUNDRECT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.EMRROUNDRECT class categoriesFor: #iTypes!constants!public! !

