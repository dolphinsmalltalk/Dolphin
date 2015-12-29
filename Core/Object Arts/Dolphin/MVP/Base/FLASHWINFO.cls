"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #FLASHWINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FLASHWINFO guid: (GUID fromString: '{2A5E4594-F531-486B-A082-17686B820CD4}')!
FLASHWINFO comment: 'FLASHWINFO is the class of <ExternalStructure> which represent the Win32 structure of the same name.

FLASHWINFO is used to pass parameters to the FlashWindowEx() API call.

Instance Variables:
	None'!
!FLASHWINFO categoriesForClass!External-Data-Structured-Win32! !
!FLASHWINFO methodsFor!

dwFlags
	"Answer the receiver's dwFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFlags)!

dwFlags: anObject 
	"Set the receiver's dwFlags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwFlags) put: anObject!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

dwTimeout: anObject 
	"Set the receiver's dwTimeout field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwTimeout) put: anObject!

hwnd: anObject 
	"Set the receiver's hwnd field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hwnd) put: anObject!

uCount: anObject 
	"Set the receiver's uCount field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #uCount) put: anObject! !
!FLASHWINFO categoriesFor: #dwFlags!**compiled accessors**!public! !
!FLASHWINFO categoriesFor: #dwFlags:!**compiled accessors**!public! !
!FLASHWINFO categoriesFor: #dwSize:!**compiled accessors**!public! !
!FLASHWINFO categoriesFor: #dwTimeout:!**compiled accessors**!public! !
!FLASHWINFO categoriesFor: #hwnd:!**compiled accessors**!public! !
!FLASHWINFO categoriesFor: #uCount:!**compiled accessors**!public! !

!FLASHWINFO class methodsFor!

defineFields
	"Define the fields of the Win32 FLASHWINFO structure.

		self compileDefinition

		typedef struct {
			UINT  cbSize;
			HWND  hwnd;
			DWORD dwFlags;
			UINT  uCount;
			DWORD dwTimeout;
		} FLASHWINFO;
	"

	self 
		defineField: #dwSize		type: DWORDField writeOnly beOverride;
		defineField: #hwnd		type: HANDLEField writeOnly;
		defineField: #dwFlags		type: DWORDField new;
		defineField: #uCount		type: DWORDField writeOnly;
		defineField: #dwTimeout	type: DWORDField writeOnly! !
!FLASHWINFO class categoriesFor: #defineFields!initializing!public! !

