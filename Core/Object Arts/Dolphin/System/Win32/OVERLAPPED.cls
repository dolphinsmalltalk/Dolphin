"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #OVERLAPPED
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OVERLAPPED guid: (GUID fromString: '{301C9A7A-D4B4-42D5-895D-E658D212DF5B}')!
OVERLAPPED comment: '<OVERLAPPED> is an <ExternalStructure> class to wrap the struct ''Win32.OVERLAPPED'' from type information in the ''Win32 API'' library.

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
!OVERLAPPED categoriesForClass!Win32-Structs! !
!OVERLAPPED methodsFor!

hEvent
	"Answer the receiver's hEvent field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hEvent)) asExternalHandle!

hEvent: anObject
	"Set the receiver's hEvent field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hEvent) put: anObject!

Internal
	"Answer the receiver's Internal field as a Smalltalk object."

	^bytes uintPtrAtOffset: 0!

InternalHigh
	"Answer the receiver's InternalHigh field as a Smalltalk object."

	^bytes uintPtrAtOffset: ##(self offsetOf: #InternalHigh)!

Offset
	"Answer the receiver's Offset field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #Offset)!

Offset: anObject
	"Set the receiver's Offset field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #Offset) put: anObject!

OffsetHigh
	"Answer the receiver's OffsetHigh field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #OffsetHigh)!

OffsetHigh: anObject
	"Set the receiver's OffsetHigh field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #OffsetHigh) put: anObject! !
!OVERLAPPED categoriesFor: #hEvent!**compiled accessors**!public! !
!OVERLAPPED categoriesFor: #hEvent:!**compiled accessors**!public! !
!OVERLAPPED categoriesFor: #Internal!**compiled accessors**!public! !
!OVERLAPPED categoriesFor: #InternalHigh!**compiled accessors**!public! !
!OVERLAPPED categoriesFor: #Offset!**compiled accessors**!public! !
!OVERLAPPED categoriesFor: #Offset:!**compiled accessors**!public! !
!OVERLAPPED categoriesFor: #OffsetHigh!**compiled accessors**!public! !
!OVERLAPPED categoriesFor: #OffsetHigh:!**compiled accessors**!public! !

!OVERLAPPED class methodsFor!

defineFields
	"Define the fields of the OVERLAPPED structure.

	OVERLAPPED  compileDefinition

		typedef [uuid(301C9A7A-D4B4-42D5-895D-E658D212DF5B), helpstring('Contains information used in asynchronous (or overlapped) input and output (I/O).')]
		struct tagOVERLAPPED {
			[helpstring('The status code for the I/O request.')] ULONG_PTR Internal;
			[helpstring('The number of bytes transferred for the I/O request.')] ULONG_PTR InternalHigh;
			union {
				struct {
					[helpstring('The low - order portion of the file position at which to start the I / O request, as specified by the user.')] unsigned long Offset;
					[helpstring('The high-order portion of the file position at which to start the I/O request, as specified by the user.')] unsigned long OffsetHigh;
				};
				[helpstring('Reserved for system use; do not use after initialization to zero.')] void* Pointer;
			};
			[helpstring('A handle to the event that will be set to a signaled state by the system when the operation has completed.')] HANDLE hEvent;
		} OVERLAPPED;
"

	self
		defineField: #Internal type: UINT_PTRField new beReadOnly;
		defineField: #InternalHigh type: UINT_PTRField new beReadOnly;
		defineField: #Offset type: DWORDField new;
		defineField: #OffsetHigh type: DWORDField new;
		defineField: #Pointer type: LPVOIDField filler;
		defineField: #hEvent type: HANDLEField new! !
!OVERLAPPED class categoriesFor: #defineFields!initializing!public! !

