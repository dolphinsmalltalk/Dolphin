"Filed out from Dolphin Smalltalk"!

OS.WIN32_FILE_ATTRIBUTE_DATA
	subclass: #'OS.WIN32_FIND_DATAW'
	instanceVariableNames: 'directory'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_cAlternateFileName' -> 16r234.
			'_OffsetOf_cFileName' -> 16r2C.
			'_OffsetOf_dwReserved0' -> 16r24.
			'_OffsetOf_dwReserved1' -> 16r28.
			'_WIN32_FIND_DATAW_Size' -> 16r250
		}!

OS.WIN32_FIND_DATAW guid: (Core.GUID fromString: '{87b4c61a-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.WIN32_FIND_DATAW comment: 'WIN32_FIND_DATA is an <ExternalStructure> to wrap the Win32 structure of the same name. WIN32_FIND_DATA is used in conjunction with the kernel library API functions FindFirstFile() and FindNextFile().

See File class for example usage.'!

!OS.WIN32_FIND_DATAW categoriesForClass!External-Data-Structured-Win32! !

!OS.WIN32_FIND_DATAW methodsFor!

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

!OS.WIN32_FIND_DATAW categoriesForMethods!
cAlternateFileName!**compiled accessors**!public! !
cFileName!**compiled accessors**!public! !
directory!accessing!public! !
directory:!accessing!private! !
fileName!accessing!public! !
path!accessing!public! !
shortFileName!accessing!public! !
stem!accessing!public! !
!

!OS.WIN32_FIND_DATAW class methodsFor!

byteSize
	^_WIN32_FIND_DATAW_Size!

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
		defineField: #dwReserved0 type: UInt32Field filler;
		defineField: #dwReserved1 type: UInt32Field filler;
		defineField: #cFileName type: (StringField type: Utf16String length: OS.Win32Constants.MAX_PATH) beReadOnly;
		defineField: #cAlternateFileName type: (StringField type: Utf16String length: 14) beReadOnly!

getFieldNames
	^#(#dwFileAttributes #ftCreationTime #ftLastAccessTime #ftLastWriteTime #nFileSizeHigh #nFileSizeLow #cFileName #cAlternateFileName)! !

!OS.WIN32_FIND_DATAW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

