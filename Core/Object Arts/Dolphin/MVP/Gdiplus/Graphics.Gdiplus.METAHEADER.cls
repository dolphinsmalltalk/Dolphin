"Filed out from Dolphin Smalltalk"!

External.Structure subclass: #'Graphics.Gdiplus.METAHEADER'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_METAHEADER_Size' -> 16r18.
		'_OffsetOf_mtHeaderSize' -> 16r2.
		'_OffsetOf_mtMaxRecord' -> 16r10.
		'_OffsetOf_mtNoObjects' -> 16rC.
		'_OffsetOf_mtNoParameters' -> 16r14.
		'_OffsetOf_mtSize' -> 16r8.
		'_OffsetOf_mtType' -> 16r0.
		'_OffsetOf_mtVersion' -> 16r4
	}!
Graphics.Gdiplus.METAHEADER guid: (Core.GUID fromString: '{0252c31a-1d28-4418-90fa-3243aff6de01}')!
Graphics.Gdiplus.METAHEADER comment: '<METAHEADER> is an <ExternalStructure> class to wrap the struct ''Gdiplus.METAHEADER'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(0252C31A-1D28-4418-90FA-3243AFF6DE01)]
struct tagMETAHEADER {
	unsigned short mtType;
	unsigned short mtHeaderSize;
	unsigned short mtVersion;
	unsigned long mtSize;
	unsigned short mtNoObjects;
	unsigned long mtMaxRecord;
	unsigned short mtNoParameters;
} METAHEADER;
'!
!Graphics.Gdiplus.METAHEADER categoriesForClass!Unclassified! !
!Graphics.Gdiplus.METAHEADER methodsFor!

mtHeaderSize
	"Answer the <Integer> value of the receiver's 'mtHeaderSize' field."

	^bytes wordAtOffset: _OffsetOf_mtHeaderSize!

mtHeaderSize: anInteger
	"Set the receiver's 'mtHeaderSize' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_mtHeaderSize put: anInteger!

mtMaxRecord
	"Answer the <Integer> value of the receiver's 'mtMaxRecord' field."

	^bytes dwordAtOffset: _OffsetOf_mtMaxRecord!

mtMaxRecord: anInteger
	"Set the receiver's 'mtMaxRecord' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_mtMaxRecord put: anInteger!

mtNoObjects
	"Answer the <Integer> value of the receiver's 'mtNoObjects' field."

	^bytes wordAtOffset: _OffsetOf_mtNoObjects!

mtNoObjects: anInteger
	"Set the receiver's 'mtNoObjects' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_mtNoObjects put: anInteger!

mtNoParameters
	"Answer the <Integer> value of the receiver's 'mtNoParameters' field."

	^bytes wordAtOffset: _OffsetOf_mtNoParameters!

mtNoParameters: anInteger
	"Set the receiver's 'mtNoParameters' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_mtNoParameters put: anInteger!

mtSize
	"Answer the <Integer> value of the receiver's 'mtSize' field."

	^bytes dwordAtOffset: _OffsetOf_mtSize!

mtSize: anInteger
	"Set the receiver's 'mtSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_mtSize put: anInteger!

mtType
	"Answer the <Integer> value of the receiver's 'mtType' field."

	^bytes wordAtOffset: _OffsetOf_mtType!

mtType: anInteger
	"Set the receiver's 'mtType' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_mtType put: anInteger!

mtVersion
	"Answer the <Integer> value of the receiver's 'mtVersion' field."

	^bytes wordAtOffset: _OffsetOf_mtVersion!

mtVersion: anInteger
	"Set the receiver's 'mtVersion' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_mtVersion put: anInteger! !
!Graphics.Gdiplus.METAHEADER categoriesForMethods!
mtHeaderSize!**compiled accessors**!public! !
mtHeaderSize:!**compiled accessors**!public! !
mtMaxRecord!**compiled accessors**!public! !
mtMaxRecord:!**compiled accessors**!public! !
mtNoObjects!**compiled accessors**!public! !
mtNoObjects:!**compiled accessors**!public! !
mtNoParameters!**compiled accessors**!public! !
mtNoParameters:!**compiled accessors**!public! !
mtSize!**compiled accessors**!public! !
mtSize:!**compiled accessors**!public! !
mtType!**compiled accessors**!public! !
mtType:!**compiled accessors**!public! !
mtVersion!**compiled accessors**!public! !
mtVersion:!**compiled accessors**!public! !
!

!Graphics.Gdiplus.METAHEADER class methodsFor!

byteSize
	^_METAHEADER_Size!

defineFields
	"Define the fields of the METAHEADER structure.
		METAHEADER compileDefinition
	
		typedef [uuid(0252C31A-1D28-4418-90FA-3243AFF6DE01)]
		struct tagMETAHEADER {
			unsigned short mtType;
			unsigned short mtHeaderSize;
			unsigned short mtVersion;
			unsigned long mtSize;
			unsigned short mtNoObjects;
			unsigned long mtMaxRecord;
			unsigned short mtNoParameters;
		} METAHEADER;
"

	self
		defineField: #mtType
			type: WORDField new
			offset: 0;
		defineField: #mtHeaderSize
			type: WORDField new
			offset: 2;
		defineField: #mtVersion
			type: WORDField new
			offset: 4;
		defineField: #mtSize
			type: DWORDField new
			offset: 8;
		defineField: #mtNoObjects
			type: WORDField new
			offset: 12;
		defineField: #mtMaxRecord
			type: DWORDField new
			offset: 16;
		defineField: #mtNoParameters
			type: WORDField new
			offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#mtType #mtHeaderSize #mtVersion #mtSize #mtNoObjects #mtMaxRecord #mtNoParameters)! !
!Graphics.Gdiplus.METAHEADER class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

