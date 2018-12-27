"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMLISTVIEW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMLISTVIEW guid: (GUID fromString: '{87b4c624-026e-11d3-9fd7-00a0cc3e4a32}')!
NMLISTVIEW comment: ''!
!NMLISTVIEW categoriesForClass!External-Data-Structured-Win32! !
!NMLISTVIEW methodsFor!

iItem
	"Answer the <Integer> value of the receiver's 'iItem' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iItem)!

iSubItem
	"Answer the <Integer> value of the receiver's 'iSubItem' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iSubItem)!

itemHandle
	"Answer the 'handle' of the receiver's item."

	^self iItem + 1!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes uintPtrAtOffset: ##(self offsetOf: #lParam)!

ptAction
	"Answer the <POINTL> value of the receiver's 'ptAction' field."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #ptAction)!

uChanged
	"Answer the <Integer> value of the receiver's 'uChanged' field."

	^bytes dwordAtOffset: ##(self offsetOf: #uChanged)!

uNewState
	"Answer the <Integer> value of the receiver's 'uNewState' field."

	^bytes dwordAtOffset: ##(self offsetOf: #uNewState)!

uOldState
	"Answer the <Integer> value of the receiver's 'uOldState' field."

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
		defineField: #lParam type: UINT_PTRField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #iItem #iSubItem #uNewState #uOldState #uChanged #ptAction #lParam)! !
!NMLISTVIEW class categoriesFor: #defineFields!initializing!public! !
!NMLISTVIEW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

