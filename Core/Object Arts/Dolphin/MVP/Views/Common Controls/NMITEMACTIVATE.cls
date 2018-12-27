"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMITEMACTIVATE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMITEMACTIVATE guid: (GUID fromString: '{78091823-3756-4d5a-816a-a5981291ae81}')!
NMITEMACTIVATE comment: ''!
!NMITEMACTIVATE categoriesForClass!External-Data-Structured-Win32! !
!NMITEMACTIVATE methodsFor!

iItem
	"Answer the <Integer> value of the receiver's 'iItem' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iItem)!

iSubItem
	"Answer the <Integer> value of the receiver's 'iSubItem' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iSubItem)!

ptAction
	"Answer the <POINTL> value of the receiver's 'ptAction' field."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #ptAction)!

uChanged
	"Answer the <Integer> value of the receiver's 'uChanged' field."

	^bytes dwordAtOffset: ##(self offsetOf: #uChanged)!

uKeyFlags
	"Answer the <Integer> value of the receiver's 'uKeyFlags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #uKeyFlags)!

uNewState
	"Answer the <Integer> value of the receiver's 'uNewState' field."

	^bytes dwordAtOffset: ##(self offsetOf: #uNewState)!

uOldState
	"Answer the <Integer> value of the receiver's 'uOldState' field."

	^bytes dwordAtOffset: ##(self offsetOf: #uOldState)! !
!NMITEMACTIVATE categoriesFor: #iItem!**compiled accessors**!public! !
!NMITEMACTIVATE categoriesFor: #iSubItem!**compiled accessors**!public! !
!NMITEMACTIVATE categoriesFor: #ptAction!**compiled accessors**!public! !
!NMITEMACTIVATE categoriesFor: #uChanged!**compiled accessors**!public! !
!NMITEMACTIVATE categoriesFor: #uKeyFlags!**compiled accessors**!public! !
!NMITEMACTIVATE categoriesFor: #uNewState!**compiled accessors**!public! !
!NMITEMACTIVATE categoriesFor: #uOldState!**compiled accessors**!public! !

!NMITEMACTIVATE class methodsFor!

defineFields
	"
		self compileDefinition

		typedef struct tagNMITEMACTIVATE{ 
			NMHDR hdr; 
			int iItem; 
			int iSubItem; 
			UINT uNewState; 
			UINT uOldState; 
			UINT uChanged; 
			POINT ptAction; 
			LPARAM lParam; 
			UINT uKeyFlags; 
		} NMITEMACTIVATE, *LPNMITEMACTIVATE; "

	super defineFields.
	self
		defineField: #iItem type: SDWORDField readOnly;
		defineField: #iSubItem type: SDWORDField readOnly;
		defineField: #uNewState type: DWORDField readOnly;
		defineField: #uOldState type: DWORDField readOnly;
		defineField: #uChanged type: DWORDField readOnly;
		defineField: #ptAction type: (StructureField type: POINTL) beReadOnly;
		defineField: #lParam type: INT_PTRField filler;
		defineField: #uKeyFlags type: DWORDField readOnly!

getFieldNames
	^#(#hwndFrom #idFrom #code #iItem #iSubItem #uNewState #uOldState #uChanged #ptAction #uKeyFlags)! !
!NMITEMACTIVATE class categoriesFor: #defineFields!initializing!public! !
!NMITEMACTIVATE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

