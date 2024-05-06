"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #FILE_NOTIFY_INFORMATION
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_Action _OffsetOf_FileName _OffsetOf_FileNameLength _OffsetOf_NextEntryOffset'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FILE_NOTIFY_INFORMATION guid: (GUID fromString: '{59c5b86e-902b-4194-ab8b-ef10d1cf539d}')!

FILE_NOTIFY_INFORMATION addClassConstant: '_OffsetOf_Action' value: 16r4!
FILE_NOTIFY_INFORMATION addClassConstant: '_OffsetOf_FileName' value: 16rC!
FILE_NOTIFY_INFORMATION addClassConstant: '_OffsetOf_FileNameLength' value: 16r8!
FILE_NOTIFY_INFORMATION addClassConstant: '_OffsetOf_NextEntryOffset' value: 16r0!

FILE_NOTIFY_INFORMATION comment: '<FILE_NOTIFY_INFORMATION> is an <ExternalStructure> class to wrap the struct ''Win32.FILE_NOTIFY_INFORMATION'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"This structure is used in conjunction with the ReadDirectoryChangesW API. It is a variable length structure, in that the unicode file name may contain a variable number of characters. The structures are then packed together into an irregular array."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(59c5b86e-902b-4194-ab8b-ef10d1cf539d), helpstring("This structure is used in conjunction with the ReadDirectoryChangesW API. It is a variable length structure, in that the unicode file name may contain a variable number of characters. The structures are then packed together into an irregular array.")]
struct tagFILE_NOTIFY_INFORMATION {
	[readonly] DWORD NextEntryOffset;
	[readonly] DWORD Action;
	[readonly] DWORD FileNameLength;
	[readonly, size_is("FileNameLength>>1"), string] unsigned short FileName[1];
} FILE_NOTIFY_INFORMATION;
'!

!FILE_NOTIFY_INFORMATION categoriesForClass!Win32-Structs! !

!FILE_NOTIFY_INFORMATION methodsFor!

Action
	"Answer the <Integer> value of the receiver's 'Action' field."

	^bytes dwordAtOffset: _OffsetOf_Action!

FileName
	"Answer the <Utf16String> value of the receiver's 'FileName' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_FileName length: self FileNameLength >> 1!

FileNameLength
	"Answer the <Integer> value of the receiver's 'FileNameLength' field."

	^bytes dwordAtOffset: _OffsetOf_FileNameLength!

NextEntryOffset
	"Answer the <Integer> value of the receiver's 'NextEntryOffset' field."

	^bytes dwordAtOffset: _OffsetOf_NextEntryOffset! !

!FILE_NOTIFY_INFORMATION categoriesForMethods!
Action!**compiled accessors**!public! !
FileName!**compiled accessors**!public! !
FileNameLength!**compiled accessors**!public! !
NextEntryOffset!**compiled accessors**!public! !
!

!FILE_NOTIFY_INFORMATION class methodsFor!

defineFields
	"Define the fields of the FILE_NOTIFY_INFORMATION structure.

	FILE_NOTIFY_INFORMATION compileDefinition

		typedef [uuid(59c5b86e-902b-4194-ab8b-ef10d1cf539d), helpstring('This structure is used in conjunction with the ReadDirectoryChangesW API. It is a variable length structure, in that the unicode file name may contain a variable number of characters. The structures are then packed together into an irregular array.')]
		struct tagFILE_NOTIFY_INFORMATION {
			[readonly] DWORD NextEntryOffset;
			[readonly] DWORD Action;
			[readonly] DWORD FileNameLength;
			[readonly, size_is('FileNameLength>>1'), string] unsigned short FileName[1];
		} FILE_NOTIFY_INFORMATION;
"

	self
		defineField: #NextEntryOffset type: DWORDField new beReadOnly offset: 0;
		defineField: #Action type: DWORDField new beReadOnly offset: 4;
		defineField: #FileNameLength type: DWORDField new beReadOnly offset: 8;
		defineField: #FileName type: (StringField type: Utf16String arrayLength: (SizeIsArrayFieldLength sizeIs: 'FileNameLength >> 1')) beReadOnly offset: 12.
	self byteSize: 16!

getFieldNames
	^#(#NextEntryOffset #Action #FileNameLength #FileName)!

new
	^self new: ##(_OffsetOf_FileName + ((CRTConstants._MAX_PATH + 1) * 2))! !

!FILE_NOTIFY_INFORMATION class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
new!public! !
!

