"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #WIN32_FILE_ATTRIBUTE_DATA
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwFileAttributes _OffsetOf_ftCreationTime _OffsetOf_ftLastAccessTime _OffsetOf_ftLastWriteTime _OffsetOf_nFileSizeHigh _OffsetOf_nFileSizeLow'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

WIN32_FILE_ATTRIBUTE_DATA guid: (GUID fromString: '{93f205f7-0707-40b3-813b-cad835330f3e}')!

WIN32_FILE_ATTRIBUTE_DATA addClassConstant: '_OffsetOf_dwFileAttributes' value: 16r0!
WIN32_FILE_ATTRIBUTE_DATA addClassConstant: '_OffsetOf_ftCreationTime' value: 16r4!
WIN32_FILE_ATTRIBUTE_DATA addClassConstant: '_OffsetOf_ftLastAccessTime' value: 16rC!
WIN32_FILE_ATTRIBUTE_DATA addClassConstant: '_OffsetOf_ftLastWriteTime' value: 16r14!
WIN32_FILE_ATTRIBUTE_DATA addClassConstant: '_OffsetOf_nFileSizeHigh' value: 16r1C!
WIN32_FILE_ATTRIBUTE_DATA addClassConstant: '_OffsetOf_nFileSizeLow' value: 16r20!

WIN32_FILE_ATTRIBUTE_DATA comment: '`WIN32_FILE_ATTRIBUTE_DATA` is an `ExternalStructure` class to wrap the struct ''Win32.WIN32_FILE_ATTRIBUTE_DATA'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Contains attribute information for a file or directory. The GetFileAttributesEx function uses this structure."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(93f205f7-0707-40b3-813b-cad835330f3e), helpstring("Contains attribute information for a file or directory. The GetFileAttributesEx function uses this structure.")]
struct tagWIN32_FILE_ATTRIBUTE_DATA {
	[readonly] DWORD dwFileAttributes;
	[readonly] FILETIME ftCreationTime;
	[readonly] FILETIME ftLastAccessTime;
	[readonly] FILETIME ftLastWriteTime;
	[readonly] DWORD nFileSizeHigh;
	[readonly] DWORD nFileSizeLow;
} WIN32_FILE_ATTRIBUTE_DATA;
```
'!

!WIN32_FILE_ATTRIBUTE_DATA categoriesForClass!Win32-Structs! !

!WIN32_FILE_ATTRIBUTE_DATA methodsFor!

dwFileAttributes
	"Answer the <Integer> value of the receiver's 'dwFileAttributes' field."

	^bytes dwordAtOffset: _OffsetOf_dwFileAttributes!

fileSize
	"Answer the <integer> size of the file."

	^(self nFileSizeHigh bitShift: 32) + self nFileSizeLow!

ftCreationTime
	"Answer the <FILETIME> value of the receiver's 'ftCreationTime' field."

	^FILETIME fromBytes: (bytes yourAddress + _OffsetOf_ftCreationTime) asExternalAddress!

ftLastAccessTime
	"Answer the <FILETIME> value of the receiver's 'ftLastAccessTime' field."

	^FILETIME fromBytes: (bytes yourAddress + _OffsetOf_ftLastAccessTime) asExternalAddress!

ftLastWriteTime
	"Answer the <FILETIME> value of the receiver's 'ftLastWriteTime' field."

	^FILETIME fromBytes: (bytes yourAddress + _OffsetOf_ftLastWriteTime) asExternalAddress!

isDirectory
	"Answer whether the receiver describes a directory (as opposed to a file) 
	in the host file system."

	^self dwFileAttributes allMask: FILE_ATTRIBUTE_DIRECTORY!

isReadOnly
	"Answer whether the receiver describes a read only file."

	^self dwFileAttributes allMask: FILE_ATTRIBUTE_READONLY
!

nFileSizeHigh
	"Answer the <Integer> value of the receiver's 'nFileSizeHigh' field."

	^bytes dwordAtOffset: _OffsetOf_nFileSizeHigh!

nFileSizeLow
	"Answer the <Integer> value of the receiver's 'nFileSizeLow' field."

	^bytes dwordAtOffset: _OffsetOf_nFileSizeLow! !

!WIN32_FILE_ATTRIBUTE_DATA categoriesForMethods!
dwFileAttributes!**compiled accessors**!public! !
fileSize!accessing!public! !
ftCreationTime!public! !
ftLastAccessTime!public! !
ftLastWriteTime!public! !
isDirectory!public!testing! !
isReadOnly!public!testing! !
nFileSizeHigh!**compiled accessors**!public! !
nFileSizeLow!**compiled accessors**!public! !
!

!WIN32_FILE_ATTRIBUTE_DATA class methodsFor!

defineFields
	"Define the fields of the WIN32_FILE_ATTRIBUTE_DATA structure.

	WIN32_FILE_ATTRIBUTE_DATA compileDefinition

		typedef [uuid(93f205f7-0707-40b3-813b-cad835330f3e), helpstring('Contains attribute information for a file or directory. The GetFileAttributesEx function uses this structure.')]
		struct tagWIN32_FILE_ATTRIBUTE_DATA {
			[readonly] DWORD dwFileAttributes;
			[readonly] FILETIME ftCreationTime;
			[readonly] FILETIME ftLastAccessTime;
			[readonly] FILETIME ftLastWriteTime;
			[readonly] DWORD nFileSizeHigh;
			[readonly] DWORD nFileSizeLow;
		} WIN32_FILE_ATTRIBUTE_DATA;
"

	self
		defineField: #dwFileAttributes type: DWORDField new beReadOnly offset: 0;
		defineField: #ftCreationTime type: (StructureField type: FILETIME) beReadOnly offset: 4;
		defineField: #ftLastAccessTime type: (StructureField type: FILETIME) beReadOnly offset: 12;
		defineField: #ftLastWriteTime type: (StructureField type: FILETIME) beReadOnly offset: 20;
		defineField: #nFileSizeHigh type: DWORDField new beReadOnly offset: 28;
		defineField: #nFileSizeLow type: DWORDField new beReadOnly offset: 32.
	self byteSize: 36!

getFieldNames
	^#(#dwFileAttributes #ftCreationTime #ftLastAccessTime #ftLastWriteTime #nFileSizeHigh #nFileSizeLow)! !

!WIN32_FILE_ATTRIBUTE_DATA class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

