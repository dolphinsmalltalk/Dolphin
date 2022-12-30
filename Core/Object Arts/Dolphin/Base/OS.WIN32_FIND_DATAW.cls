"Filed out from Dolphin Smalltalk"!

OS.WIN32_FIND_DATA subclass: #'OS.WIN32_FIND_DATAW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cAlternateFileName' -> 16r234.
		'_OffsetOf_cFileName' -> 16r2C.
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

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_cFileName! !
!OS.WIN32_FIND_DATAW categoriesForMethods!
cAlternateFileName!**compiled accessors**!public! !
cFileName!**compiled accessors**!public! !
!

!OS.WIN32_FIND_DATAW class methodsFor!

byteSize
	^_WIN32_FIND_DATAW_Size!

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

	super defineFields.
	self
		defineField: #cFileName type: (StringField type: Utf16String length: MAX_PATH) beReadOnly;
		defineField: #cAlternateFileName type: (StringField type: Utf16String length: 14) beReadOnly! !
!OS.WIN32_FIND_DATAW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
!

