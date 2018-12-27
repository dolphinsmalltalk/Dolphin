"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #WINDOWPLACEMENT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WINDOWPLACEMENT guid: (GUID fromString: '{87b4c61b-026e-11d3-9fd7-00a0cc3e4a32}')!
WINDOWPLACEMENT comment: ''!
!WINDOWPLACEMENT categoriesForClass!External-Data-Structured-Win32! !
!WINDOWPLACEMENT methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

rcNormalPosition
	"Answer the <RECT> value of the receiver's 'rcNormalPosition' field."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rcNormalPosition)!

rcNormalPosition: aRECT
	"Set the receiver's 'rcNormalPosition' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rcNormalPosition) + 1)
		to: ##((self offsetOf: #rcNormalPosition) + RECT basicByteSize)
		startingAt: 1!

showCmd
	"Answer the <Integer> value of the receiver's 'showCmd' field."

	^bytes dwordAtOffset: ##(self offsetOf: #showCmd)!

showCmd: anInteger
	"Set the receiver's 'showCmd' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #showCmd) put: anInteger! !
!WINDOWPLACEMENT categoriesFor: #dwSize:!**compiled accessors**!public! !
!WINDOWPLACEMENT categoriesFor: #rcNormalPosition!**compiled accessors**!public! !
!WINDOWPLACEMENT categoriesFor: #rcNormalPosition:!**compiled accessors**!public! !
!WINDOWPLACEMENT categoriesFor: #showCmd!**compiled accessors**!public! !
!WINDOWPLACEMENT categoriesFor: #showCmd:!**compiled accessors**!public! !

!WINDOWPLACEMENT class methodsFor!

defineFields
	"Define the layout of the Win32 WINDOWPLACEMENT structure. 
	Currently to avoid wasting space, the structure is defined as mostly filler 
	fields.

		WINDOWPLACEMENT compileDefinition

		typedef struct tagWINDOWPLACEMENT {
			UINT  length;
			UINT  flags;
			UINT  showCmd;
			POINT ptMinPosition;
			POINT ptMaxPosition;
			RECT  rcNormalPosition;
		} WINDOWPLACEMENT;"

	self 
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #flags type: DWORDField filler;
		defineField: #showCmd type: DWORDField new;
		defineField: #ptMinPosition type: (StructureField type: POINTL) beFiller;
		defineField: #ptMaxPosition type: (StructureField type: POINTL) beFiller;
		defineField: #rcNormalPosition type: (StructureField type: RECT)
!

getFieldNames
	^#(#dwSize #showCmd #rcNormalPosition)! !
!WINDOWPLACEMENT class categoriesFor: #defineFields!initializing!public! !
!WINDOWPLACEMENT class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

