"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.BCRYPT_ALGORITHM_IDENTIFIER'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_BCRYPT_ALGORITHM_IDENTIFIER_Size' -> 16rC.
			'_OffsetOf_dwClass' -> 16r4.
			'_OffsetOf_dwFlags' -> 16r8.
			'_OffsetOf_pszName' -> 16r0
		}!

OS.BCRYPT_ALGORITHM_IDENTIFIER guid: (Core.GUID fromString: '{4dbc2424-026f-4137-9b03-71b25c8a8d72}')!

OS.BCRYPT_ALGORITHM_IDENTIFIER comment: '`BCRYPT_ALGORITHM_IDENTIFIER` is an `External.Structure` class to wrap the struct ''Win32.BCRYPT_ALGORITHM_IDENTIFIER'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagBCRYPT_ALGORITHM_IDENTIFIER {
	LPWSTR pszName;
	ULONG dwClass;
	ULONG dwFlags;
} BCRYPT_ALGORITHM_IDENTIFIER;
```
'!

!OS.BCRYPT_ALGORITHM_IDENTIFIER categoriesForClass!Win32-Structs! !

!OS.BCRYPT_ALGORITHM_IDENTIFIER methodsFor!

dwClass
	"Answer the <Integer> value of the receiver's 'dwClass' field."

	^bytes uint32AtOffset: _OffsetOf_dwClass!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes uint32AtOffset: _OffsetOf_dwFlags!

pszName
	"Answer the <Utf16String> value of the receiver's 'pszName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszName)! !

!OS.BCRYPT_ALGORITHM_IDENTIFIER categoriesForMethods!
dwClass!**compiled accessors**!public! !
dwFlags!**compiled accessors**!public! !
pszName!**compiled accessors**!public! !
!

!OS.BCRYPT_ALGORITHM_IDENTIFIER class methodsFor!

byteSize
	^_BCRYPT_ALGORITHM_IDENTIFIER_Size!

defineFields
	"Define the fields of the BCRYPT_ALGORITHM_IDENTIFIER structure.

	BCRYPT_ALGORITHM_IDENTIFIER compileDefinition

		typedef 
		struct tagBCRYPT_ALGORITHM_IDENTIFIER {
			LPWSTR pszName;
			ULONG dwClass;
			ULONG dwFlags;
		} BCRYPT_ALGORITHM_IDENTIFIER;
"

	self
		defineField: #pszName type: (PointerField type: Utf16String) beReadOnly offset: 0;
		defineField: #dwClass type: UInt32Field readOnly offset: 4;
		defineField: #dwFlags type: UInt32Field readOnly offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#pszName #dwClass #dwFlags)! !

!OS.BCRYPT_ALGORITHM_IDENTIFIER class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

