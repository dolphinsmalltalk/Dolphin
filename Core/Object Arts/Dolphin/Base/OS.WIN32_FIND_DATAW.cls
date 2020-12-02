"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #WIN32_FIND_DATAW
	instanceVariableNames: 'directory'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cAlternateFileName' -> 16r234.
		'_OffsetOf_cFileName' -> 16r2C.
		'_OffsetOf_dwFileAttributes' -> 16r0.
		'_OffsetOf_dwReserved0' -> 16r24.
		'_OffsetOf_dwReserved1' -> 16r28.
		'_OffsetOf_ftCreationTime' -> 16r4.
		'_OffsetOf_ftLastAccessTime' -> 16rC.
		'_OffsetOf_ftLastWriteTime' -> 16r14.
		'_OffsetOf_nFileSizeHigh' -> 16r1C.
		'_OffsetOf_nFileSizeLow' -> 16r20
	}!
WIN32_FIND_DATAW guid: (GUID fromString: '{87b4c61a-026e-11d3-9fd7-00a0cc3e4a32}')!
WIN32_FIND_DATAW comment: 'WIN32_FIND_DATA is an <ExternalStructure> to wrap the Win32 structure of the same name. WIN32_FIND_DATA is used in conjunction with the kernel library API functions FindFirstFile() and FindNextFile().

See File class for example usage.'!
!WIN32_FIND_DATAW categoriesForClass!External-Data-Structured-Win32! !
!WIN32_FIND_DATAW methodsFor!

cAlternateFileName
	"Answer the <Utf16String> value of the receiver's 'cAlternateFileName' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_cAlternateFileName!

cFileName
	"Answer the <Utf16String> value of the receiver's 'cFileName' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_cFileName!

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
!WIN32_FIND_DATAW categoriesFor: #cAlternateFileName!**compiled accessors**!public! !
!WIN32_FIND_DATAW categoriesFor: #cFileName!**compiled accessors**!public! !
!WIN32_FIND_DATAW categoriesFor: #directory!accessing!public! !
!WIN32_FIND_DATAW categoriesFor: #directory:!accessing!private! !
!WIN32_FIND_DATAW categoriesFor: #dwFileAttributes!**compiled accessors**!public! !
!WIN32_FIND_DATAW categoriesFor: #fileName!accessing!public! !
!WIN32_FIND_DATAW categoriesFor: #fileSize!accessing!public! !
!WIN32_FIND_DATAW categoriesFor: #ftCreationTime!**compiled accessors**!public! !
!WIN32_FIND_DATAW categoriesFor: #ftLastAccessTime!**compiled accessors**!public! !
!WIN32_FIND_DATAW categoriesFor: #ftLastWriteTime!**compiled accessors**!public! !
!WIN32_FIND_DATAW categoriesFor: #isDirectory!public!testing! !
!WIN32_FIND_DATAW categoriesFor: #isReadOnly!public!testing! !
!WIN32_FIND_DATAW categoriesFor: #nFileSizeHigh!**compiled accessors**!public! !
!WIN32_FIND_DATAW categoriesFor: #nFileSizeLow!**compiled accessors**!public! !
!WIN32_FIND_DATAW categoriesFor: #path!accessing!public! !
!WIN32_FIND_DATAW categoriesFor: #shortFileName!accessing!public! !
!WIN32_FIND_DATAW categoriesFor: #stem!accessing!public! !

!WIN32_FIND_DATAW class methodsFor!

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
			WCHAR    cFileName[ MAX_PATH ]; 
			WCHAR    cAlternateFileName[ 14 ]; 
		} WIN32_FIND_DATAw;"

	self 
		defineField: #dwFileAttributes type: DWORDField readOnly;
		defineField: #ftCreationTime type: (StructureField type: FILETIME) beReadOnly;
		defineField: #ftLastAccessTime type: (StructureField type: FILETIME) beReadOnly;
		defineField: #ftLastWriteTime type: (StructureField type: FILETIME) beReadOnly;
		defineField: #nFileSizeHigh type: DWORDField readOnly;
		defineField: #nFileSizeLow type: DWORDField readOnly;
		defineField: #dwReserved0 type: DWORDField filler;
		defineField: #dwReserved1 type: DWORDField filler;
		defineField: #cFileName type: (StringField type: Utf16String length: File maxPath) beReadOnly;
		defineField: #cAlternateFileName type: (StringField type: Utf16String length: 14) beReadOnly!

getFieldNames
	^#(#dwFileAttributes #ftCreationTime #ftLastAccessTime #ftLastWriteTime #nFileSizeHigh #nFileSizeLow #cFileName #cAlternateFileName)! !
!WIN32_FIND_DATAW class categoriesFor: #defineFields!public!template definition! !
!WIN32_FIND_DATAW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

