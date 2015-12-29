"Filed out from Dolphin Smalltalk X6.1"!

NMHDR subclass: #NMLISTVIEW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMLISTVIEW guid: (GUID fromString: '{87B4C624-026E-11D3-9FD7-00A0CC3E4A32}')!
NMLISTVIEW comment: ''!
!NMLISTVIEW categoriesForClass!External-Data-Structured-Win32! !
!NMLISTVIEW methodsFor!

iItem
	"Answer the receiver's iItem field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iItem)!

iSubItem
	"Answer the receiver's iSubItem field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iSubItem)!

itemHandle
	"Answer the 'handle' of the receiver's item."

	^self iItem + 1!

lParam
	"Answer the receiver's lParam field as a Smalltalk object."

	^bytes uintPtrAtOffset: ##(self offsetOf: #lParam)!

ptAction
	"Answer the receiver's ptAction field as a Smalltalk object."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #ptAction)!

uChanged
	"Answer the receiver's uChanged field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #uChanged)!

uNewState
	"Answer the receiver's uNewState field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #uNewState)!

uOldState
	"Answer the receiver's uOldState field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #uOldState)! !
!NMLISTVIEW categoriesFor: #iItem!**compiled accessors**!public! !
!NMLISTVIEW categoriesFor: #iSubItem!**compiled accessors**!public! !
!NMLISTVIEW categoriesFor: #itemHandle!accessing!public! !
!NMLISTVIEW categoriesFor: #lParam!**compiled accessors**!public! !
!NMLISTVIEW categoriesFor: #ptAction!**compiled accessors**!public! !
!NMLISTVIEW categoriesFor: #uChanged!**compiled accessors**!public! !
!NMLISTVIEW categoriesFor: #uNewState!**compiled accessors**!public! !
!NMLISTVIEW categoriesFor: #uOldState!**compiled accessors**!public! !

!NMLISTVIEW class methodsFor!

defineFields
	"Define the structure template for Win32 NMLISTVIEW structure.
		NMLISTVIEW compileDefinition
	"

	super defineFields.
	self
		defineField: #iItem type: SDWORDField readOnly;
		defineField: #iSubItem type: SDWORDField readOnly;
		defineField: #uNewState type: DWORDField readOnly;
		defineField: #uOldState type: DWORDField readOnly;
		defineField: #uChanged type: DWORDField readOnly;
		defineField: #ptAction type: (StructureField type: POINTL) beReadOnly;
		defineField: #lParam type: UINT_PTRField readOnly! !
!NMLISTVIEW class categoriesFor: #defineFields!initializing!public! !

