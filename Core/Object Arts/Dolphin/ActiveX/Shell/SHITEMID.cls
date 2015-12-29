"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #SHITEMID
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SHITEMID guid: (GUID fromString: '{A7DE965E-05A0-4E48-A2B0-5DAB55449C53}')!
SHITEMID comment: '<SHITEMID> is an <ExternalStructure> class to wrap the struct ''IShellFolderEx.SHITEMID'' from type information in the ''IShellFolder Extended Type Library v1.0'' library.

The type library contains no documentation for this struct.

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef struct tagSHITEMID {
	short cb;
	BYTE abID[1];
} SHITEMID;
'!
!SHITEMID categoriesForClass!IShellFolderEx_TLB-Structs! !
!SHITEMID methodsFor!

abID
	"Answer the receiver's abID field as a Smalltalk object."

	^StructureArray 
		fromAddress: bytes yourAddress + ##(self offsetOf: #abID)
		length: self cb
		elementClass: BYTE!

cb
	"Answer the receiver's cb field as a Smalltalk object."

	^bytes wordAtOffset: 0! !
!SHITEMID categoriesFor: #abID!**compiled accessors**!public! !
!SHITEMID categoriesFor: #cb!**compiled accessors**!public! !

!SHITEMID class methodsFor!

defineFields
	"Define the fields of the SHITEMID structure.
		SHITEMID compileDefinition
	
		typedef 		struct tagSHITEMID {
			USHORT cb;
			BYTE abID[1]
		} SHITEMID;
	"

	self
		defineField: #cb type: WORDField readOnly;
		defineField: #abID type: (ConformantStructureArrayField type: BYTE length: #cb) beReadOnly!

packing
	"Uses byte packing"

	^1! !
!SHITEMID class categoriesFor: #defineFields!initializing!public! !
!SHITEMID class categoriesFor: #packing!constants!public! !

