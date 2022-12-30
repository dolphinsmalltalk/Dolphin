"Filed out from Dolphin Smalltalk"!

OS.WIN32_FIND_DATA subclass: #'OS.WIN32_FIND_DATAA'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cAlternateFileName' -> 16r130.
		'_OffsetOf_cFileName' -> 16r2C.
		'_WIN32_FIND_DATAA_Size' -> 16r140.
		'_WIN32_FIND_DATAW_Size' -> 16r250
	}!
OS.WIN32_FIND_DATAA guid: (Core.GUID fromString: '{87b4c61a-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.WIN32_FIND_DATAA comment: 'WIN32_FIND_DATA is an <ExternalStructure> to wrap the Win32 structure of the same name. WIN32_FIND_DATA is used in conjunction with the kernel library API functions FindFirstFile() and FindNextFile().

See File class for example usage.'!
!OS.WIN32_FIND_DATAA methodsFor!

cAlternateFileName
	"Answer the <Utf8String> value of the receiver's 'cAlternateFileName' field."

	^Utf8String fromAddress: bytes yourAddress + _OffsetOf_cAlternateFileName!

cFileName
	"Answer the <Utf8String> value of the receiver's 'cFileName' field."

	^Utf8String fromAddress: bytes yourAddress + _OffsetOf_cFileName! !
!OS.WIN32_FIND_DATAA categoriesForMethods!
cAlternateFileName!**compiled accessors**!public! !
cFileName!**compiled accessors**!public! !
!

!OS.WIN32_FIND_DATAA class methodsFor!

byteSize
	^_WIN32_FIND_DATAA_Size!

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
		defineField: #cFileName type: (StringField type: Utf8String length: MAX_PATH) beReadOnly;
		defineField: #cAlternateFileName type: (StringField type: Utf8String length: 14) beReadOnly! !
!OS.WIN32_FIND_DATAA class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
!

