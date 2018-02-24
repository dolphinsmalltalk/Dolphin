"Filed out from Dolphin Smalltalk 7"!

NMLVFINDITEMW subclass: #NMLVFINDITEMA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMLVFINDITEMA guid: (GUID fromString: '{577fdefb-1d8a-454b-a565-25889006828c}')!
NMLVFINDITEMA comment: ''!
!NMLVFINDITEMA categoriesForClass!External-Data-Structured-Win32! !
!NMLVFINDITEMA methodsFor!

lvfi
	"Answer the <LVFINDINFOA> value of the receiver's 'lvfi' field."

	^LVFINDINFOA fromAddress: bytes yourAddress + ##(self offsetOf: #lvfi)! !
!NMLVFINDITEMA categoriesFor: #lvfi!public! !

