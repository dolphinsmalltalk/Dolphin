"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #OVERLAPPED
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OVERLAPPED guid: (GUID fromString: '{301C9A7A-D4B4-42D5-895D-E658D212DF5B}')!
OVERLAPPED comment: '<OVERLAPPED> is an <ExternalStructure> class to wrap the Win32 structure of the same name ''.OVERLAPPED''. It was originally generated from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.'!
!OVERLAPPED categoriesForClass!Win32-Structs! !
!OVERLAPPED methodsFor!

hEvent
	"Answer the receiver's hEvent field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hEvent)) asExternalHandle!

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

	bytes dwordAtOffset: ##(self offsetOf: #OffsetHigh) put: anObject!

Pointer
	"Answer the receiver's Pointer field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #Pointer)) asExternalAddress! !
!OVERLAPPED categoriesFor: #hEvent!**compiled accessors**!public! !
!OVERLAPPED categoriesFor: #Offset!**compiled accessors**!public! !
!OVERLAPPED categoriesFor: #Offset:!**compiled accessors**!public! !
!OVERLAPPED categoriesFor: #OffsetHigh!**compiled accessors**!public! !
!OVERLAPPED categoriesFor: #OffsetHigh:!**compiled accessors**!public! !
!OVERLAPPED categoriesFor: #Pointer!**compiled accessors**!public! !

!OVERLAPPED class methodsFor!

defineFields
	"Define the fields of the OVERLAPPED structure.
		OVERLAPPED compileDefinition
	"

	self
		defineField: #Internal type: DWORDField filler;
		defineField: #InternalHigh type: DWORDField filler.
	"There's an Onion here"
	self
		defineField: #Offset type: DWORDField new;
		defineField: #OffsetHigh type: DWORDField new;
		defineField: #hEvent type: HANDLEField readOnly.
	"With this being the other field in the Onion"
	self 
		defineField: #Pointer
		type: LPVOIDField readOnly
		offset: 8! !
!OVERLAPPED class categoriesFor: #defineFields!initializing!public! !

