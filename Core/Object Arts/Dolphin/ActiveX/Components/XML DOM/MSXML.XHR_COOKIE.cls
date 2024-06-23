"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'MSXML.XHR_COOKIE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_dwFlags' -> 16r18.
			'_OffsetOf_ftExpires' -> 16r10.
			'_OffsetOf_pwszName' -> 16r4.
			'_OffsetOf_pwszP3PPolicy' -> 16rC.
			'_OffsetOf_pwszUrl' -> 16r0.
			'_OffsetOf_pwszValue' -> 16r8.
			'_XHR_COOKIE_Size' -> 16r1C
		}!

MSXML.XHR_COOKIE guid: (Core.GUID fromString: '{55d440a1-79a9-4f7b-9828-7efa635f6579}')!

MSXML.XHR_COOKIE comment: '`XHR_COOKIE` is an `ExternalStructure` class to wrap the struct ''MSXML2.XHR_COOKIE'' from type information in the ''Microsoft XML, v6.0'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef 
struct tagXHR_COOKIE {
	LPWSTR pwszUrl;
	LPWSTR pwszName;
	LPWSTR pwszValue;
	LPWSTR pwszP3PPolicy;
	FILETIME ftExpires;
	unsigned long dwFlags;
} XHR_COOKIE;
```
'!

!MSXML.XHR_COOKIE categoriesForClass!MSXML2-Structs! !

!MSXML.XHR_COOKIE methodsFor!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes uint32AtOffset: _OffsetOf_dwFlags!

dwFlags: anInteger
	"Set the receiver's 'dwFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwFlags put: anInteger!

ftExpires
	"Answer the <FILETIME> value of the receiver's 'ftExpires' field."

	^FILETIME fromAddress: bytes yourAddress + _OffsetOf_ftExpires!

ftExpires: aFILETIME
	"Set the receiver's 'ftExpires' field to the value of the argument, aFILETIME"

	aFILETIME
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ftExpires + 1)
		to: ##(_OffsetOf_ftExpires + FILETIME._FILETIME_Size)
		startingAt: 1!

pwszName
	"Answer the <Utf16String> value of the receiver's 'pwszName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pwszName)!

pwszName: anUtf16String
	"Set the receiver's 'pwszName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pwszName put: anUtf16String yourAddress!

pwszP3PPolicy
	"Answer the <Utf16String> value of the receiver's 'pwszP3PPolicy' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pwszP3PPolicy)!

pwszP3PPolicy: anUtf16String
	"Set the receiver's 'pwszP3PPolicy' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pwszP3PPolicy put: anUtf16String yourAddress!

pwszUrl
	"Answer the <Utf16String> value of the receiver's 'pwszUrl' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pwszUrl)!

pwszUrl: anUtf16String
	"Set the receiver's 'pwszUrl' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pwszUrl put: anUtf16String yourAddress!

pwszValue
	"Answer the <Utf16String> value of the receiver's 'pwszValue' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pwszValue)!

pwszValue: anUtf16String
	"Set the receiver's 'pwszValue' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pwszValue put: anUtf16String yourAddress! !

!MSXML.XHR_COOKIE categoriesForMethods!
dwFlags!**compiled accessors**!public! !
dwFlags:!**compiled accessors**!public! !
ftExpires!**compiled accessors**!public! !
ftExpires:!**compiled accessors**!public! !
pwszName!**compiled accessors**!public! !
pwszName:!**compiled accessors**!public! !
pwszP3PPolicy!**compiled accessors**!public! !
pwszP3PPolicy:!**compiled accessors**!public! !
pwszUrl!**compiled accessors**!public! !
pwszUrl:!**compiled accessors**!public! !
pwszValue!**compiled accessors**!public! !
pwszValue:!**compiled accessors**!public! !
!

!MSXML.XHR_COOKIE class methodsFor!

byteSize
	^_XHR_COOKIE_Size!

defineFields
	"Define the fields of the XHR_COOKIE structure.

	XHR_COOKIE compileDefinition

		typedef 
		struct tagXHR_COOKIE {
			LPWSTR pwszUrl;
			LPWSTR pwszName;
			LPWSTR pwszValue;
			LPWSTR pwszP3PPolicy;
			FILETIME ftExpires;
			unsigned long dwFlags;
		} XHR_COOKIE;
"

	self
		defineField: #pwszUrl type: (PointerField type: Utf16String) offset: 0;
		defineField: #pwszName type: (PointerField type: Utf16String) offset: 4;
		defineField: #pwszValue type: (PointerField type: Utf16String) offset: 8;
		defineField: #pwszP3PPolicy type: (PointerField type: Utf16String) offset: 12;
		defineField: #ftExpires type: (StructureField type: FILETIME) offset: 16;
		defineField: #dwFlags type: UInt32Field new offset: 24.
	self byteSize: 28!

getFieldNames
	^#(#pwszUrl #pwszName #pwszValue #pwszP3PPolicy #ftExpires #dwFlags)! !

!MSXML.XHR_COOKIE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

