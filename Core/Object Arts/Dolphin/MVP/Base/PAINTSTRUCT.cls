"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #PAINTSTRUCT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PAINTSTRUCT guid: (GUID fromString: '{87b4c605-026e-11d3-9fd7-00a0cc3e4a32}')!
PAINTSTRUCT comment: ''!
!PAINTSTRUCT categoriesForClass!External-Data-Structured-Win32! !
!PAINTSTRUCT methodsFor!

fErase
	"Answer the receiver's fErase field as a Smalltalk object."

	^(bytes dwordAtOffset: ##(self offsetOf: #fErase)) asBoolean!

rcPaint
	"Answer the receiver's rcPaint field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rcPaint)! !
!PAINTSTRUCT categoriesFor: #fErase!**compiled accessors**!public! !
!PAINTSTRUCT categoriesFor: #rcPaint!**compiled accessors**!public! !

!PAINTSTRUCT class methodsFor!

defineFields
	"Define the Win32 PAINTSTRUCT structure.
		PAINTSTRUCT compileDefinition
	"

	self
		defineField: #hdc type: DWORDField readOnly beUncompiled;
		defineField: #fErase type: BOOLField readOnly;
		defineField: #rcPaint type: (StructureField type: RECT) beReadOnly;
		defineField: #fRestore type: BOOLField filler;
		defineField: #fIncUpdate type: BOOLField filler;
		"Help file wrongly species 16 bytes, header file says 32"
		defineField: #rgbReserved type: (ArrayField type: ByteArray length: 32) beFiller! !
!PAINTSTRUCT class categoriesFor: #defineFields!initializing!public! !

