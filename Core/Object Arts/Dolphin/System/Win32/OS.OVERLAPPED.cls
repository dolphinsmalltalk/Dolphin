"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'OS.OVERLAPPED'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_hEvent' -> 16r10.
		'_OffsetOf_Internal' -> 16r0.
		'_OffsetOf_InternalHigh' -> 16r4.
		'_OffsetOf_Offset' -> 16r8.
		'_OffsetOf_OffsetHigh' -> 16rC.
		'_OffsetOf_Pointer' -> 16r8
	}!
OS.OVERLAPPED guid: (Core.GUID fromString: '{301c9a7a-d4b4-42d5-895d-e658d212df5b}')!
OS.OVERLAPPED comment: '<OVERLAPPED> is an <ExternalStructure> class to wrap the struct ''Win32.OVERLAPPED'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Contains information used in asynchronous (or overlapped) input and output (I/O)."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(301C9A7A-D4B4-42D5-895D-E658D212DF5B), helpstring("Contains information used in asynchronous (or overlapped) input and output (I/O).")]
struct tagOVERLAPPED {
	[helpstring("The status code for the I/O request.")] ULONG_PTR Internal;
	[helpstring("The number of bytes transferred for the I/O request.")] ULONG_PTR InternalHigh;
	union {
		struct {
			[helpstring("The low - order portion of the file position at which to start the I / O request, as specified by the user.")] unsigned long Offset;
			[helpstring("The high-order portion of the file position at which to start the I/O request, as specified by the user.")] unsigned long OffsetHigh;
		};
		[helpstring("Reserved for system use; do not use after initialization to zero.")] void* Pointer;
	};
	[helpstring("A handle to the event that will be set to a signaled state by the system when the operation has completed.")] HANDLE hEvent;
} OVERLAPPED;
'!
!OS.OVERLAPPED categoriesForClass!Win32-Structs! !
!OS.OVERLAPPED methodsFor!

hEvent
	"Answer the <ExternalHandle> value of the receiver's 'hEvent' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hEvent) asExternalHandle!

hEvent: anExternalHandle
	"Set the receiver's 'hEvent' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hEvent put: anExternalHandle!

Internal
	"Answer the <Integer> value of the receiver's 'Internal' field."

	^bytes uintPtrAtOffset: _OffsetOf_Internal!

InternalHigh
	"Answer the <Integer> value of the receiver's 'InternalHigh' field."

	^bytes uintPtrAtOffset: _OffsetOf_InternalHigh!

Offset
	"Answer the <Integer> value of the receiver's 'Offset' field."

	^bytes dwordAtOffset: _OffsetOf_Offset!

Offset: anInteger
	"Set the receiver's 'Offset' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Offset put: anInteger!

OffsetHigh
	"Answer the <Integer> value of the receiver's 'OffsetHigh' field."

	^bytes dwordAtOffset: _OffsetOf_OffsetHigh!

OffsetHigh: anInteger
	"Set the receiver's 'OffsetHigh' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_OffsetHigh put: anInteger! !
!OS.OVERLAPPED categoriesFor: #hEvent!**compiled accessors**!public! !
!OS.OVERLAPPED categoriesFor: #hEvent:!**compiled accessors**!public! !
!OS.OVERLAPPED categoriesFor: #Internal!**compiled accessors**!public! !
!OS.OVERLAPPED categoriesFor: #InternalHigh!**compiled accessors**!public! !
!OS.OVERLAPPED categoriesFor: #Offset!**compiled accessors**!public! !
!OS.OVERLAPPED categoriesFor: #Offset:!**compiled accessors**!public! !
!OS.OVERLAPPED categoriesFor: #OffsetHigh!**compiled accessors**!public! !
!OS.OVERLAPPED categoriesFor: #OffsetHigh:!**compiled accessors**!public! !

!OS.OVERLAPPED class methodsFor!

defineFields
	"Define the fields of the OVERLAPPED structure.

	OVERLAPPED compileDefinition

		typedef [uuid(301c9a7a-d4b4-42d5-895d-e658d212df5b), helpstring('Contains information used in asynchronous (or overlapped) input and output (I/O).')]
		struct tagOVERLAPPED {
			[readonly, helpstring('The status code for the I/O request.')] ULONG_PTR Internal;
			[readonly, helpstring('The number of bytes transferred for the I/O request.')] ULONG_PTR InternalHigh;
			union {
				struct {
					[helpstring('The low - order portion of the file position at which to start the I / O request, as specified by the user.')] DWORD Offset;
					[helpstring('The high-order portion of the file position at which to start the I/O request, as specified by the user.')] DWORD OffsetHigh;
				};
				[hidden, helpstring('Reserved for system use; do not use after initialization to zero.'), custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] void* Pointer;
			};
			[helpstring('A handle to the event that will be set to a signaled state by the system when the operation has completed.')] HANDLE hEvent;
		} OVERLAPPED;
"

	self
		defineField: #Internal
			type: UINT_PTRField new beReadOnly
			offset: 0;
		defineField: #InternalHigh
			type: UINT_PTRField new beReadOnly
			offset: 4;
		defineField: #Offset
			type: DWORDField new
			offset: 8;
		defineField: #OffsetHigh
			type: DWORDField new
			offset: 12;
		defineField: #Pointer
			type: LPVOIDField new beFiller
			offset: 8;
		defineField: #hEvent
			type: HANDLEField new
			offset: 16.
	self byteSize: 20!

getFieldNames
	^#(#Internal #InternalHigh #Offset #OffsetHigh #hEvent)! !
!OS.OVERLAPPED class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.OVERLAPPED class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

