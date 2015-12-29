"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #RGNDATA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RGNDATA guid: (GUID fromString: '{87B4C60E-026E-11D3-9FD7-00A0CC3E4A32}')!
RGNDATA comment: ''!
!RGNDATA categoriesForClass!External-Data-Structured-Win32! !
!RGNDATA methodsFor!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

iType
	"Answer the receiver's iType field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #iType)!

iType: anObject 
	"Set the receiver's iType field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #iType) put: anObject!

nCount
	"Answer the receiver's nCount field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nCount)!

nCount: anObject 
	"Set the receiver's nCount field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nCount) put: anObject!

nRgnSize
	"Answer the receiver's nRgnSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nRgnSize)!

nRgnSize: anObject 
	"Set the receiver's nRgnSize field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nRgnSize) put: anObject!

rcBound
	"Answer the receiver's rcBound field as a Smalltalk object."

	^RECT fromAddress: bytes yourAddress + ##(self offsetOf: #rcBound)!

rcBound: anObject 
	"Set the receiver's rcBound field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #rcBound) + 1)
		to: ##((self offsetOf: #rcBound) + RECT basicByteSize)
		startingAt: 1! !
!RGNDATA categoriesFor: #dwSize:!**compiled accessors**!public! !
!RGNDATA categoriesFor: #iType!**compiled accessors**!public! !
!RGNDATA categoriesFor: #iType:!**compiled accessors**!public! !
!RGNDATA categoriesFor: #nCount!**compiled accessors**!public! !
!RGNDATA categoriesFor: #nCount:!**compiled accessors**!public! !
!RGNDATA categoriesFor: #nRgnSize!**compiled accessors**!public! !
!RGNDATA categoriesFor: #nRgnSize:!**compiled accessors**!public! !
!RGNDATA categoriesFor: #rcBound!**compiled accessors**!public! !
!RGNDATA categoriesFor: #rcBound:!**compiled accessors**!public! !

!RGNDATA class methodsFor!

defineFields
	"Define the fields of the RGNDATA 'structure'.
	Note that we cheat a bit here by including the header as members of the RGNDATA
	to avoid defining two structures, and to make using it a bit easier.

		RGNDATA compileDefinition

		struct RGNDATAHEADER 
		{
			DWORD   dwSize;
			DWORD   iType;
			DWORD   nCount;
			DWORD   nRgnSize;
			RECT	rcBound;
		};

		struct RGNDATA 
		{
			RGNDATAHEADER   rdh;
			char			Buffer[1];
		};
	"

	self
		defineField: #dwSize 	type: DWORDField writeOnly beOverride;
		defineField: #iType		type: DWORDField new;
		defineField: #nCount	type: DWORDField new;
		defineField: #nRgnSize	type: DWORDField new;
		defineField: #rcBound	type: (StructureField type: RECT)
! !
!RGNDATA class categoriesFor: #defineFields!initializing!public! !

