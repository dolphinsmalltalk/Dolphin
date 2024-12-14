"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.BCRYPT_PROVIDER_NAME'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_BCRYPT_PROVIDER_NAME_Size' -> 16r4. '_OffsetOf_pszProviderName' -> 16r0 }!

OS.BCRYPT_PROVIDER_NAME guid: (Core.GUID fromString: '{4618af33-e61a-4374-bd9f-a35f6b8f46ea}')!

OS.BCRYPT_PROVIDER_NAME comment: '`BCRYPT_PROVIDER_NAME` is an `External.Structure` class to wrap the struct ''Win32.BCRYPT_PROVIDER_NAME'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagBCRYPT_PROVIDER_NAME {
	LPWSTR pszProviderName;
} BCRYPT_PROVIDER_NAME;
```
'!

!OS.BCRYPT_PROVIDER_NAME categoriesForClass!Win32-Structs! !

!OS.BCRYPT_PROVIDER_NAME methodsFor!

pszProviderName
	"Answer the <Utf16String> value of the receiver's 'pszProviderName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszProviderName)! !

!OS.BCRYPT_PROVIDER_NAME categoriesForMethods!
pszProviderName!**compiled accessors**!public! !
!

!OS.BCRYPT_PROVIDER_NAME class methodsFor!

byteSize
	^_BCRYPT_PROVIDER_NAME_Size!

defineFields
	"Define the fields of the BCRYPT_PROVIDER_NAME structure.

	BCRYPT_PROVIDER_NAME compileDefinition

		typedef 
		struct tagBCRYPT_PROVIDER_NAME {
			LPWSTR pszProviderName;
		} BCRYPT_PROVIDER_NAME;
"

	self
		defineField: #pszProviderName type: (PointerField type: Utf16String) beReadOnly offset: 0.
	self byteSize: 4!

getFieldNames
	^#(#pszProviderName)! !

!OS.BCRYPT_PROVIDER_NAME class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

