"Filed out from Dolphin Smalltalk 7"!

LVFINDINFOW subclass: #LVFINDINFOA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LVFINDINFOA guid: (GUID fromString: '{7b241d34-6fa2-4e96-b966-6d774c017a17}')!
LVFINDINFOA comment: 'Temporary class to represent ANSI find item notification structure. To be removed when all views switched over to Unicode.'!
!LVFINDINFOA categoriesForClass!External-Data-Structured-Win32! !
!LVFINDINFOA methodsFor!

psz
	"Answer the <String> value of the receiver's 'psz' field."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #psz))! !
!LVFINDINFOA categoriesFor: #psz!public! !

