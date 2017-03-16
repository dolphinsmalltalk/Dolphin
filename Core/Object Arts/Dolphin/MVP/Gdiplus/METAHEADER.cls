"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #METAHEADER
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
METAHEADER guid: (GUID fromString: '{0252c31a-1d28-4418-90fa-3243aff6de01}')!
METAHEADER comment: '<METAHEADER> is an <ExternalStructure> class to wrap the struct ''Gdiplus.METAHEADER'' from type information in the ''GDI+ Library 1.0'' library.

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
!METAHEADER categoriesForClass!Unclassified! !
!METAHEADER methodsFor!

mtHeaderSize
	"Answer the receiver's mtHeaderSize field as a Smalltalk object."

	^(bytes wordAtOffset: 2)!

mtHeaderSize: anObject
	"Set the receiver's mtHeaderSize field to the value of anObject."

	bytes wordAtOffset: 2 put: anObject!

mtMaxRecord
	"Answer the receiver's mtMaxRecord field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

mtMaxRecord: anObject
	"Set the receiver's mtMaxRecord field to the value of anObject."

	bytes dwordAtOffset: 16 put: anObject!

mtNoObjects
	"Answer the receiver's mtNoObjects field as a Smalltalk object."

	^(bytes wordAtOffset: 12)!

mtNoObjects: anObject
	"Set the receiver's mtNoObjects field to the value of anObject."

	bytes wordAtOffset: 12 put: anObject!

mtNoParameters
	"Answer the receiver's mtNoParameters field as a Smalltalk object."

	^(bytes wordAtOffset: 20)!

mtNoParameters: anObject
	"Set the receiver's mtNoParameters field to the value of anObject."

	bytes wordAtOffset: 20 put: anObject!

mtSize
	"Answer the receiver's mtSize field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

mtSize: anObject
	"Set the receiver's mtSize field to the value of anObject."

	bytes dwordAtOffset: 8 put: anObject!

mtType
	"Answer the receiver's mtType field as a Smalltalk object."

	^(bytes wordAtOffset: 0)!

mtType: anObject
	"Set the receiver's mtType field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject!

mtVersion
	"Answer the receiver's mtVersion field as a Smalltalk object."

	^(bytes wordAtOffset: 4)!

mtVersion: anObject
	"Set the receiver's mtVersion field to the value of anObject."

	bytes wordAtOffset: 4 put: anObject! !
!METAHEADER categoriesFor: #mtHeaderSize!**compiled accessors**!public! !
!METAHEADER categoriesFor: #mtHeaderSize:!**compiled accessors**!public! !
!METAHEADER categoriesFor: #mtMaxRecord!**compiled accessors**!public! !
!METAHEADER categoriesFor: #mtMaxRecord:!**compiled accessors**!public! !
!METAHEADER categoriesFor: #mtNoObjects!**compiled accessors**!public! !
!METAHEADER categoriesFor: #mtNoObjects:!**compiled accessors**!public! !
!METAHEADER categoriesFor: #mtNoParameters!**compiled accessors**!public! !
!METAHEADER categoriesFor: #mtNoParameters:!**compiled accessors**!public! !
!METAHEADER categoriesFor: #mtSize!**compiled accessors**!public! !
!METAHEADER categoriesFor: #mtSize:!**compiled accessors**!public! !
!METAHEADER categoriesFor: #mtType!**compiled accessors**!public! !
!METAHEADER categoriesFor: #mtType:!**compiled accessors**!public! !
!METAHEADER categoriesFor: #mtVersion!**compiled accessors**!public! !
!METAHEADER categoriesFor: #mtVersion:!**compiled accessors**!public! !

!METAHEADER class methodsFor!

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
		defineField: #mtType type: WORDField new offset: 0;
		defineField: #mtHeaderSize type: WORDField new offset: 2;
		defineField: #mtVersion type: WORDField new offset: 4;
		defineField: #mtSize type: DWORDField new offset: 8;
		defineField: #mtNoObjects type: WORDField new offset: 12;
		defineField: #mtMaxRecord type: DWORDField new offset: 16;
		defineField: #mtNoParameters type: WORDField new offset: 20.
	self byteSize: 24! !
!METAHEADER class categoriesFor: #defineFields!**auto generated**!initializing!public! !

