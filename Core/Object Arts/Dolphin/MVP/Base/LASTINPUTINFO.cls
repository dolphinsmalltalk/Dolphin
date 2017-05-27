"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #LASTINPUTINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LASTINPUTINFO guid: (GUID fromString: '{71c57485-4335-49cf-8a38-99d1c4d2a51b}')!
LASTINPUTINFO comment: 'LASTINPUTINFO is an <ExternalStructure> class to represent the Win32 structure of the same name.

typedef struct tagLASTINPUTINFO {
	UINT  cbSize;		//	The size of the structure, in bytes. This member must be set to sizeof(LASTINPUTINFO)
	DWORD dwTime;	//	The tick count when the last input event was received
} LASTINPUTINFO, *PLASTINPUTINFO;

This function is useful for input idle detection. For more information on tick counts, see GetTickCount.

https://msdn.microsoft.com/en-us/library/windows/desktop/ms646272(v=vs.85).aspx'!
!LASTINPUTINFO categoriesForClass!Unclassified! !
!LASTINPUTINFO methodsFor!

cbSize
	"Answer the <Integer> value of the receiver's 'cbSize' field."

	^bytes dwordAtOffset: 0!

cbSize: anInteger
	"Set the receiver's 'cbSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

dwSize: anInteger
	"Store the size of the structure into itself."

	^self cbSize: anInteger!

dwTime
	"Answer the <Integer> value of the receiver's 'dwTime' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwTime)!

dwTime: anInteger
	"Set the receiver's 'dwTime' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwTime) put: anInteger! !
!LASTINPUTINFO categoriesFor: #cbSize!**compiled accessors**!public! !
!LASTINPUTINFO categoriesFor: #cbSize:!**compiled accessors**!public! !
!LASTINPUTINFO categoriesFor: #dwSize:!initializing!public! !
!LASTINPUTINFO categoriesFor: #dwTime!**compiled accessors**!public! !
!LASTINPUTINFO categoriesFor: #dwTime:!**compiled accessors**!public! !

!LASTINPUTINFO class methodsFor!

defineFields
	"
self compileDefinition.
typedef struct tagLASTINPUTINFO {
	UINT  cbSize;		//	The size of the structure, in bytes. This member must be set to sizeof(LASTINPUTINFO)
	DWORD dwTime;	//	The tick count when the last input event was received
} LASTINPUTINFO, *PLASTINPUTINFO;
"

	self
		defineField: #cbSize type: DWORDField new;
		defineField: #dwTime type: DWORDField new;
		yourself.! !
!LASTINPUTINFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

