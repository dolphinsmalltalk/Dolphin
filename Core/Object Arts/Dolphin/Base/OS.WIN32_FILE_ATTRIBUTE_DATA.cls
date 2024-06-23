"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.WIN32_FILE_ATTRIBUTE_DATA'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_dwFileAttributes' -> 16r0.
			'_OffsetOf_ftCreationTime' -> 16r4.
			'_OffsetOf_ftLastAccessTime' -> 16rC.
			'_OffsetOf_ftLastWriteTime' -> 16r14.
			'_OffsetOf_nFileSizeHigh' -> 16r1C.
			'_OffsetOf_nFileSizeLow' -> 16r20.
			'_WIN32_FILE_ATTRIBUTE_DATA_Size' -> 16r24
		}!

OS.WIN32_FILE_ATTRIBUTE_DATA guid: (Core.GUID fromString: '{93f205f7-0707-40b3-813b-cad835330f3e}')!

OS.WIN32_FILE_ATTRIBUTE_DATA comment: '`WIN32_FILE_ATTRIBUTE_DATA` is an `ExternalStructure` class to wrap the struct ''Win32.WIN32_FILE_ATTRIBUTE_DATA'' from type information in the ''Win32 API'' library.

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

!OS.WIN32_FILE_ATTRIBUTE_DATA categoriesForClass!Win32-Structs! !

!OS.WIN32_FILE_ATTRIBUTE_DATA methodsFor!

dwFileAttributes
	"Answer the <Integer> value of the receiver's 'dwFileAttributes' field."

	^bytes uint32AtOffset: _OffsetOf_dwFileAttributes!

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

	^self dwFileAttributes allMask: OS.Win32Constants.FILE_ATTRIBUTE_DIRECTORY!

isReadOnly
	"Answer whether the receiver describes a read only file."

	^self dwFileAttributes allMask: OS.Win32Constants.FILE_ATTRIBUTE_READONLY
!

nFileSizeHigh
	"Answer the <Integer> value of the receiver's 'nFileSizeHigh' field."

	^bytes uint32AtOffset: _OffsetOf_nFileSizeHigh!

nFileSizeLow
	"Answer the <Integer> value of the receiver's 'nFileSizeLow' field."

	^bytes uint32AtOffset: _OffsetOf_nFileSizeLow! !

!OS.WIN32_FILE_ATTRIBUTE_DATA categoriesForMethods!
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

!OS.WIN32_FILE_ATTRIBUTE_DATA class methodsFor!

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
		defineField: #dwFileAttributes type: UInt32Field new beReadOnly offset: 0;
		defineField: #ftCreationTime type: (StructureField type: FILETIME) beReadOnly offset: 4;
		defineField: #ftLastAccessTime type: (StructureField type: FILETIME) beReadOnly offset: 12;
		defineField: #ftLastWriteTime type: (StructureField type: FILETIME) beReadOnly offset: 20;
		defineField: #nFileSizeHigh type: UInt32Field new beReadOnly offset: 28;
		defineField: #nFileSizeLow type: UInt32Field new beReadOnly offset: 32.
	self byteSize: 36!

getFieldNames
	^#(#dwFileAttributes #ftCreationTime #ftLastAccessTime #ftLastWriteTime #nFileSizeHigh #nFileSizeLow)! !

!OS.WIN32_FILE_ATTRIBUTE_DATA class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

