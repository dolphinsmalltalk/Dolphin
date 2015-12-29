"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #LVFINDINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ListViewConstants'
	classInstanceVariableNames: ''!
LVFINDINFO guid: (GUID fromString: '{87B4C5FD-026E-11D3-9FD7-00A0CC3E4A32}')!
LVFINDINFO comment: 'LVFINDINFO is an <ExternalStructure> class which represents the Windows common control structure of the same name.

LVFINDINFO is used to contain information to search for items in a List View.

Instance Variables:
	None'!
!LVFINDINFO categoriesForClass!External-Data-Structured-Win32! !
!LVFINDINFO methodsFor!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

flags: anObject 
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

lParam
	"Answer the receiver's lParam field as a Smalltalk object."

	^bytes uintPtrAtOffset: ##(self offsetOf: #lParam)!

lParam: anObject 
	"Set the receiver's lParam field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lParam) put: anObject!

maskIn: anInteger
	"OR in to contents' mask member the bit flags represented by anInteger"

	self flags: (self flags bitOr: anInteger)!

param: findId
	"Set the param field of the receiver to findId."

	self lParam: findId.
	self maskIn: LVFI_PARAM!

psz
	"Answer the receiver's psz field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #psz))!

psz: anObject 
	"Set the receiver's psz field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #psz) put: anObject yourAddress!

pt
	"Answer the receiver's pt field as a Smalltalk object."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #pt)!

pt: anObject 
	"Set the receiver's pt field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #pt) + 1)
		to: ##((self offsetOf: #pt) + POINTL basicByteSize)
		startingAt: 1!

vkDirection
	"Answer the receiver's vkDirection field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #vkDirection)!

vkDirection: anObject 
	"Set the receiver's vkDirection field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #vkDirection) put: anObject! !
!LVFINDINFO categoriesFor: #flags!**compiled accessors**!public! !
!LVFINDINFO categoriesFor: #flags:!**compiled accessors**!public! !
!LVFINDINFO categoriesFor: #lParam!**compiled accessors**!public! !
!LVFINDINFO categoriesFor: #lParam:!**compiled accessors**!public! !
!LVFINDINFO categoriesFor: #maskIn:!accessing!public! !
!LVFINDINFO categoriesFor: #param:!accessing!public! !
!LVFINDINFO categoriesFor: #psz!**compiled accessors**!public! !
!LVFINDINFO categoriesFor: #psz:!**compiled accessors**!public! !
!LVFINDINFO categoriesFor: #pt!**compiled accessors**!public! !
!LVFINDINFO categoriesFor: #pt:!**compiled accessors**!public! !
!LVFINDINFO categoriesFor: #vkDirection!**compiled accessors**!public! !
!LVFINDINFO categoriesFor: #vkDirection:!**compiled accessors**!public! !

!LVFINDINFO class methodsFor!

defineFields
	"Define the fields of the Win32 LVFINDINFO structure.
		LVFINDINFO compileDefinition
	"

	self
		defineField: #flags type: DWORDField new;
		defineField: #psz type: (PointerField type: String);
		defineField: #lParam type: UINT_PTRField new;
		defineField: #pt type: (StructureField type: POINTL);
		defineField: #vkDirection type: DWORDField new! !
!LVFINDINFO class categoriesFor: #defineFields!initializing!public! !

