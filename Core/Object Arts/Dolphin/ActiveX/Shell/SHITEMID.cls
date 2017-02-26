"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #SHITEMID
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SHITEMID guid: (GUID fromString: '{a7de965e-05a0-4e48-a2b0-5dab55449c53}')!
SHITEMID comment: '<SHITEMID> is an <ExternalStructure> class to wrap the struct ''IShellFolderEx.SHITEMID'' from type information in the ''IShellFolder Extended Type Library v1.0'' library.

The type library contains no documentation for this struct.

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef struct tagSHITEMID {
	short cb;
	BYTE abID[1];
} SHITEMID;
'!
!SHITEMID categoriesForClass!Win32-Structs! !
!SHITEMID methodsFor!

abID
	"Answer the <ExternalArray> value of the receiver's 'abID' field."

	^ExternalArray fromAddress: bytes yourAddress + ##(self offsetOf: #abID) length: self cb!

cb
	"Private - Answer the <Integer> value of the receiver's 'cb' field."

	^bytes wordAtOffset: 0! !
!SHITEMID categoriesFor: #abID!**compiled accessors**!public! !
!SHITEMID categoriesFor: #cb!**compiled accessors**!private! !

!SHITEMID class methodsFor!

defineFields
	"Define the fields of the SHITEMID structure.

	SHITEMID compileDefinition

		typedef [uuid(a7de965e-05a0-4e48-a2b0-5dab55449c53)]
		struct tagSHITEMID {
			[nonbrowsable, readonly, helpstring('Size of the ID (including cb itself)')] USHORT cb;
			[readonly, helpstring('The item ID (variable length)'), size_is('cb')] BYTE abID[1];
		} SHITEMID;
"

	self
		defineField: #cb type: WORDField new beReadOnly beNonBrowsable offset: 0;
		defineField: #abID type: (ArrayField type: ExternalArray lengthField: #cb) beReadOnly offset: 2.
	self byteSize: 4!

packing
	"Uses byte packing"

	^1! !
!SHITEMID class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!SHITEMID class categoriesFor: #packing!constants!public! !

