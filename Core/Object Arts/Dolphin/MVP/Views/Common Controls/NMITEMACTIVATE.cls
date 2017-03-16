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
	"Answer the receiver's iItem field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iItem)!

iSubItem
	"Answer the receiver's iSubItem field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iSubItem)!

ptAction
	"Answer the receiver's ptAction field as a Smalltalk object."

	^POINTL fromAddress: bytes yourAddress + ##(self offsetOf: #ptAction)!

uChanged
	"Answer the receiver's uChanged field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #uChanged)!

uKeyFlags
	"Answer the receiver's uKeyFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #uKeyFlags)!

uNewState
	"Answer the receiver's uNewState field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #uNewState)!

uOldState
	"Answer the receiver's uOldState field as a Smalltalk object."

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
		defineField: #uKeyFlags type: DWORDField readOnly! !
!NMITEMACTIVATE class categoriesFor: #defineFields!initializing!public! !

