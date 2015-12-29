"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #FILE_NOTIFY_INFORMATION
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FILE_NOTIFY_INFORMATION guid: (GUID fromString: '{59C5B86E-902B-4194-AB8B-EF10D1CF539D}')!
FILE_NOTIFY_INFORMATION comment: '<FILE_NOTIFY_INFORMATION> is an <ExternalStructure> class to wrap the struct ''Win32.FILE_NOTIFY_INFORMATION'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

This structure is used in conjunction with the ReadDirectoryChangesW API. It is a variable length structure, in that the unicode file name may contain a variable number of characters. The structures are then packed together into an irregular array.

IDL definition follows:

typedef 
struct tagFILE_NOTIFY_INFORMATION {
	unsigned long NextEntryOffset;
	unsigned long Action;
	unsigned long FileNameLength;
	unsigned short FileName[1];
} FILE_NOTIFY_INFORMATION;
'!
!FILE_NOTIFY_INFORMATION categoriesForClass!Win32-Structs! !
!FILE_NOTIFY_INFORMATION methodsFor!

Action
	"Answer the receiver's Action field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #Action)!

fileName
	"Implementation Note: The FileNameLength is oddly the size of the FileName string in bytes,
	not including the terminating null, rather than the length in characters (which is what we'd
	normally expect for a conformant array)"

	^UnicodeString fromAddress: bytes yourAddress + 12 length: self FileNameLength // 2!

FileNameLength
	"Answer the receiver's FileNameLength field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #FileNameLength)!

NextEntryOffset
	"Answer the receiver's NextEntryOffset field as a Smalltalk object."

	^bytes dwordAtOffset: 0! !
!FILE_NOTIFY_INFORMATION categoriesFor: #Action!**compiled accessors**!public! !
!FILE_NOTIFY_INFORMATION categoriesFor: #fileName!accessing!public! !
!FILE_NOTIFY_INFORMATION categoriesFor: #FileNameLength!**compiled accessors**!public! !
!FILE_NOTIFY_INFORMATION categoriesFor: #NextEntryOffset!**compiled accessors**!public! !

!FILE_NOTIFY_INFORMATION class methodsFor!

defineFields
	"Define the fields of the FILE_NOTIFY_INFORMATION structure.
		FILE_NOTIFY_INFORMATION compileDefinition
	
		typedef 
		struct tagFILE_NOTIFY_INFORMATION {
			unsigned long NextEntryOffset;
			unsigned long Action;
			unsigned long FileNameLength;
			unsigned short FileName[1];
		} FILE_NOTIFY_INFORMATION;
"

	self
		defineField: #NextEntryOffset type: DWORDField readOnly;
		defineField: #Action type: DWORDField readOnly;
		defineField: #FileNameLength type: DWORDField readOnly;
		defineField: #FileName type: (ConformantArrayField type: UnicodeString length: #FileNameLength) beFiller! !
!FILE_NOTIFY_INFORMATION class categoriesFor: #defineFields!initializing!public! !

