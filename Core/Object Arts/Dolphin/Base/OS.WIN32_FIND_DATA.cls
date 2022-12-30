"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.WIN32_FIND_DATA'
	instanceVariableNames: 'directory'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwFileAttributes' -> 16r0.
		'_OffsetOf_dwReserved0' -> 16r24.
		'_OffsetOf_dwReserved1' -> 16r28.
		'_OffsetOf_ftCreationTime' -> 16r4.
		'_OffsetOf_ftLastAccessTime' -> 16rC.
		'_OffsetOf_ftLastWriteTime' -> 16r14.
		'_OffsetOf_nFileSizeHigh' -> 16r1C.
		'_OffsetOf_nFileSizeLow' -> 16r20.
		'_WIN32_FIND_DATA_Size' -> 16r2C.
		'_WIN32_FIND_DATAW_Size' -> 16r250
	}!
OS.WIN32_FIND_DATA guid: (Core.GUID fromString: '{f1a07065-78d0-4d93-8d64-68d6792a2528}')!
OS.WIN32_FIND_DATA isNonInstantiable: true!
OS.WIN32_FIND_DATA comment: ''!
!OS.WIN32_FIND_DATA methodsFor!

cFileName
	"Answer the <Utf8String> value of the receiver's 'cFileName' field."

	^self subclassResponsibility!

directory
	^directory!

directory: aString
	directory := aString!

dwFileAttributes
	"Answer the <Integer> value of the receiver's 'dwFileAttributes' field."

	^bytes dwordAtOffset: _OffsetOf_dwFileAttributes!

fileName
	"Answer the full filename from the receiver."

	^self cFileName!

fileSize
	"Answer the <integer> size of the file."

	^(self nFileSizeHigh bitShift: 32) + self nFileSizeLow!

ftCreationTime
	"Answer the <FILETIME> value of the receiver's 'ftCreationTime' field."

	^FILETIME fromAddress: bytes yourAddress + _OffsetOf_ftCreationTime!

ftLastAccessTime
	"Answer the <FILETIME> value of the receiver's 'ftLastAccessTime' field."

	^FILETIME fromAddress: bytes yourAddress + _OffsetOf_ftLastAccessTime!

ftLastWriteTime
	"Answer the <FILETIME> value of the receiver's 'ftLastWriteTime' field."

	^FILETIME fromAddress: bytes yourAddress + _OffsetOf_ftLastWriteTime!

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

	^bytes dwordAtOffset: _OffsetOf_nFileSizeLow!

path
	"Answer the path of the file described by the receiver (assuming the 
	directory has been set correctly)."

	^File composePath: self directory subPath: self fileName!

shortFileName
	"Answer the 8.3 filename from the receiver."

	| answer |
	answer := self cAlternateFileName.
	answer isEmpty ifTrue: [answer := self cFileName].
	^answer!

stem
	"Answer the stem (name sans extension) of the file described by the receiver."

	^File splitStemFrom: self fileName! !
!OS.WIN32_FIND_DATA categoriesForMethods!
cFileName!**compiled accessors**!public! !
directory!accessing!public! !
directory:!accessing!private! !
dwFileAttributes!**compiled accessors**!public! !
fileName!accessing!public! !
fileSize!accessing!public! !
ftCreationTime!**compiled accessors**!public! !
ftLastAccessTime!**compiled accessors**!public! !
ftLastWriteTime!**compiled accessors**!public! !
isDirectory!public!testing! !
isReadOnly!public!testing! !
nFileSizeHigh!**compiled accessors**!public! !
nFileSizeLow!**compiled accessors**!public! !
path!accessing!public! !
shortFileName!accessing!public! !
stem!accessing!public! !
!

!OS.WIN32_FIND_DATA class methodsFor!

byteSize
	^_WIN32_FIND_DATA_Size!

defineFields
	"Define the layout of the Win32 WIN32_FIND_DATAW structure. 
	Currently to avoid wasting space, the structure is defined as mostly filler 
	fields.

		self compileDefinition

		struct {
			DWORD dwFileAttributes; 
			FILETIME ftCreationTime; 
			FILETIME ftLastAccessTime; 
			FILETIME ftLastWriteTime; 
			DWORD    nFileSizeHigh; 
			DWORD    nFileSizeLow; 
			DWORD    dwReserved0; 
			DWORD    dwReserved1; 
			TCHAR    cFileName[ MAX_PATH ]; 
			TCHAR    cAlternateFileName[ 14 ]; 
		} WIN32_FIND_DATA;"

	self
		defineField: #dwFileAttributes type: DWORDField readOnly;
		defineField: #ftCreationTime type: (StructureField type: FILETIME) beReadOnly;
		defineField: #ftLastAccessTime type: (StructureField type: FILETIME) beReadOnly;
		defineField: #ftLastWriteTime type: (StructureField type: FILETIME) beReadOnly;
		defineField: #nFileSizeHigh type: DWORDField readOnly;
		defineField: #nFileSizeLow type: DWORDField readOnly;
		defineField: #dwReserved0 type: DWORDField filler;
		defineField: #dwReserved1 type: DWORDField filler! !
!OS.WIN32_FIND_DATA class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
!

