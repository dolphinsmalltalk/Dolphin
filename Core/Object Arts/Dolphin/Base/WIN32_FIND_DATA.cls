"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #WIN32_FIND_DATA
	instanceVariableNames: 'directory'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
WIN32_FIND_DATA guid: (GUID fromString: '{87b4c61a-026e-11d3-9fd7-00a0cc3e4a32}')!
WIN32_FIND_DATA comment: 'WIN32_FIND_DATA is an <ExternalStructure> to wrap the Win32 structure of the same name. WIN32_FIND_DATA is used in conjunction with the kernel library API functions FindFirstFile() and FindNextFile().

See File class for example usage.'!
!WIN32_FIND_DATA categoriesForClass!External-Data-Structured-Win32! !
!WIN32_FIND_DATA methodsFor!

cAlternateFileName
	"Answer the receiver's cAlternateFileName field as a Smalltalk object."

	^String fromAddress: bytes yourAddress + ##(self offsetOf: #cAlternateFileName)!

cFileName
	"Answer the receiver's cFileName field as a Smalltalk object."

	^String fromAddress: bytes yourAddress + ##(self offsetOf: #cFileName)!

directory
	^directory!

directory: aString
	directory := aString!

dwFileAttributes
	"Answer the receiver's dwFileAttributes field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

fileName
	"Answer the full filename from the receiver."

	^self cFileName!

fileSize
	"Answer the <integer> size of the file."

	^(self nFileSizeHigh bitShift: 32) + self nFileSizeLow!

ftCreationTime
	"Answer the receiver's ftCreationTime field as a Smalltalk object."

	^FILETIME fromAddress: bytes yourAddress + ##(self offsetOf: #ftCreationTime)!

ftLastAccessTime
	"Answer the receiver's ftLastAccessTime field as a Smalltalk object."

	^FILETIME fromAddress: bytes yourAddress + ##(self offsetOf: #ftLastAccessTime)!

ftLastWriteTime
	"Answer the receiver's ftLastWriteTime field as a Smalltalk object."

	^FILETIME fromAddress: bytes yourAddress + ##(self offsetOf: #ftLastWriteTime)!

isDirectory
	"Answer whether the receiver describes a directory (as opposed to a file) 
	in the host file system."

	^self dwFileAttributes allMask: FILE_ATTRIBUTE_DIRECTORY!

isReadOnly
	"Answer whether the receiver describes a read only file."

	^self dwFileAttributes allMask: FILE_ATTRIBUTE_READONLY
!

nFileSizeHigh
	"Answer the receiver's nFileSizeHigh field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nFileSizeHigh)!

nFileSizeLow
	"Answer the receiver's nFileSizeLow field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nFileSizeLow)!

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
!WIN32_FIND_DATA categoriesFor: #cAlternateFileName!**compiled accessors**!public! !
!WIN32_FIND_DATA categoriesFor: #cFileName!**compiled accessors**!public! !
!WIN32_FIND_DATA categoriesFor: #directory!accessing!public! !
!WIN32_FIND_DATA categoriesFor: #directory:!accessing!private! !
!WIN32_FIND_DATA categoriesFor: #dwFileAttributes!**compiled accessors**!public! !
!WIN32_FIND_DATA categoriesFor: #fileName!accessing!public! !
!WIN32_FIND_DATA categoriesFor: #fileSize!accessing!public! !
!WIN32_FIND_DATA categoriesFor: #ftCreationTime!**compiled accessors**!public! !
!WIN32_FIND_DATA categoriesFor: #ftLastAccessTime!**compiled accessors**!public! !
!WIN32_FIND_DATA categoriesFor: #ftLastWriteTime!**compiled accessors**!public! !
!WIN32_FIND_DATA categoriesFor: #isDirectory!public!testing! !
!WIN32_FIND_DATA categoriesFor: #isReadOnly!public!testing! !
!WIN32_FIND_DATA categoriesFor: #nFileSizeHigh!**compiled accessors**!public! !
!WIN32_FIND_DATA categoriesFor: #nFileSizeLow!**compiled accessors**!public! !
!WIN32_FIND_DATA categoriesFor: #path!accessing!public! !
!WIN32_FIND_DATA categoriesFor: #shortFileName!accessing!public! !
!WIN32_FIND_DATA categoriesFor: #stem!accessing!public! !

!WIN32_FIND_DATA class methodsFor!

defineFields
	"Define the layout of the Win32 WIN32_FIND_DATA structure. 
	Currently to avoid wasting space, the structure is defined as mostly filler 
	fields.

		WIN32_FIND_DATA compileDefinition

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
		defineField: #dwReserved1 type: DWORDField filler;
		defineField: #cFileName type: (StringField length: File maxPath) beReadOnly;
		defineField: #cAlternateFileName type: (StringField length: 14) beReadOnly! !
!WIN32_FIND_DATA class categoriesFor: #defineFields!initializing!public! !

