"Filed out from Dolphin Smalltalk"!

WIN32_FILE_ATTRIBUTE_DATA subclass: #WIN32_FIND_DATAW
	instanceVariableNames: 'directory'
	classVariableNames: '_OffsetOf_cAlternateFileName _OffsetOf_cFileName _OffsetOf_dwReserved0 _OffsetOf_dwReserved1'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

WIN32_FIND_DATAW guid: (GUID fromString: '{87b4c61a-026e-11d3-9fd7-00a0cc3e4a32}')!

WIN32_FIND_DATAW addClassConstant: '_OffsetOf_cAlternateFileName' value: 16r234!
WIN32_FIND_DATAW addClassConstant: '_OffsetOf_cFileName' value: 16r2C!
WIN32_FIND_DATAW addClassConstant: '_OffsetOf_dwReserved0' value: 16r24!
WIN32_FIND_DATAW addClassConstant: '_OffsetOf_dwReserved1' value: 16r28!

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

fileName
	"Answer the full filename from the receiver."

	^self cFileName!

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

!WIN32_FIND_DATAW categoriesForMethods!
cAlternateFileName!**compiled accessors**!public! !
cFileName!**compiled accessors**!public! !
directory!accessing!public! !
directory:!accessing!private! !
fileName!accessing!public! !
path!accessing!public! !
shortFileName!accessing!public! !
stem!accessing!public! !
!

!WIN32_FIND_DATAW class methodsFor!

defineFields
	"Define the layout of the Win32 WIN32_FIND_DATAW structure. 

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

	super defineFields.
	self
		defineField: #dwReserved0 type: DWORDField filler;
		defineField: #dwReserved1 type: DWORDField filler;
		defineField: #cFileName type: (StringField type: Utf16String length: MAX_PATH) beReadOnly;
		defineField: #cAlternateFileName type: (StringField type: Utf16String length: 14) beReadOnly!

getFieldNames
	^#(#dwFileAttributes #ftCreationTime #ftLastAccessTime #ftLastWriteTime #nFileSizeHigh #nFileSizeLow #cFileName #cAlternateFileName)! !

!WIN32_FIND_DATAW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

