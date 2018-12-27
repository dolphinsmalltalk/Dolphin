"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #EMRTEXT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMRTEXT guid: (GUID fromString: '{b8857668-f891-426b-8df0-ccc12b909e4d}')!
EMRTEXT comment: '<EMRTEXT> is an <ExternalStructure> class to wrap the struct ''Win32.EMRTEXT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(B8857668-F891-426B-8DF0-CCC12B909E4D)]
struct tagEMRTEXT {
	POINTL ptlReference;
	DWORD nChars;
	[helpstring("Offset to the string")] DWORD offString;
	DWORD fOptions;
	RECTL rcl;
	[helpstring("Offset to the inter-character spacing array. This is always given.")] DWORD offDx;
} EMRTEXT;
'!
!EMRTEXT categoriesForClass!Win32-Structs! !
!EMRTEXT methodsFor!

fOptions
	"Answer the <Integer> value of the receiver's 'fOptions' field."

	^bytes dwordAtOffset: ##(self offsetOf: #fOptions)!

fOptions: anInteger
	"Set the receiver's 'fOptions' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #fOptions) put: anInteger!

nChars
	"Answer the <Integer> value of the receiver's 'nChars' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nChars)!

nChars: anInteger
	"Set the receiver's 'nChars' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nChars) put: anInteger!

offDx
	"Answer the <Integer> value of the receiver's 'offDx' field."

	^bytes dwordAtOffset: ##(self offsetOf: #offDx)!

offDx: anInteger
	"Set the receiver's 'offDx' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #offDx) put: anInteger!

offString
	"Answer the <Integer> value of the receiver's 'offString' field."

	^bytes dwordAtOffset: ##(self offsetOf: #offString)!

offString: anInteger
	"Set the receiver's 'offString' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #offString) put: anInteger!

ptlReference
	"Answer the <POINTL> value of the receiver's 'ptlReference' field."

	^POINTL fromAddress: bytes yourAddress!

ptlReference: aPOINTL
	"Set the receiver's 'ptlReference' field to the value of the argument, aPOINTL"

	aPOINTL
		replaceBytesOf: bytes
		from: 1
		to: ##(POINTL basicByteSize)
		startingAt: 1!

rcl
	"Answer the <RECT> value of the receiver's 'rcl' field."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rcl)!

rcl: aRECT
	"Set the receiver's 'rcl' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rcl) + 1)
		to: ##((self offsetOf: #rcl) + RECT basicByteSize)
		startingAt: 1! !
!EMRTEXT categoriesFor: #fOptions!**compiled accessors**!public! !
!EMRTEXT categoriesFor: #fOptions:!**compiled accessors**!public! !
!EMRTEXT categoriesFor: #nChars!**compiled accessors**!public! !
!EMRTEXT categoriesFor: #nChars:!**compiled accessors**!public! !
!EMRTEXT categoriesFor: #offDx!**compiled accessors**!public! !
!EMRTEXT categoriesFor: #offDx:!**compiled accessors**!public! !
!EMRTEXT categoriesFor: #offString!**compiled accessors**!public! !
!EMRTEXT categoriesFor: #offString:!**compiled accessors**!public! !
!EMRTEXT categoriesFor: #ptlReference!**compiled accessors**!public! !
!EMRTEXT categoriesFor: #ptlReference:!**compiled accessors**!public! !
!EMRTEXT categoriesFor: #rcl!**compiled accessors**!public! !
!EMRTEXT categoriesFor: #rcl:!**compiled accessors**!public! !

!EMRTEXT class methodsFor!

defineFields
	"Define the fields of the EMRTEXT structure.

	EMRTEXT  compileDefinition

		typedef [uuid(B8857668-F891-426B-8DF0-CCC12B909E4D)]
		struct tagEMRTEXT {
			POINTL ptlReference;
			DWORD nChars;
			[helpstring('Offset to the string')] DWORD offString;
			DWORD fOptions;
			RECTL rcl;
			[helpstring('Offset to the inter-character spacing array. This is always given.')] DWORD offDx;
		} EMRTEXT;
"

	self
		defineField: #ptlReference type: (StructureField type: POINTL) offset: 0;
		defineField: #nChars type: DWORDField new offset: 8;
		defineField: #offString type: DWORDField new offset: 12;
		defineField: #fOptions type: DWORDField new offset: 16;
		defineField: #rcl type: (StructureField type: RECT) offset: 20;
		defineField: #offDx type: DWORDField new offset: 36.
	self byteSize: 40!

getFieldNames
	^#(#ptlReference #nChars #offString #fOptions #rcl #offDx)! !
!EMRTEXT class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!EMRTEXT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

