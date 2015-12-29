"Filed out from Dolphin Smalltalk X6"!

StProgramNode subclass: #StTagNode
	instanceVariableNames: 'start stop'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StTagNode guid: (GUID fromString: '{EB694D50-0176-4A1D-A468-8F7A306F573B}')!
StTagNode comment: ''!
!StTagNode categoriesForClass!System-Compiler! !
!StTagNode methodsFor!

acceptVisitor: aProgramNodeVisitor 
	^self subclassResponsibility!

isExternalCall
	^false!

primitiveIndex
	^self subclassResponsibility!

start
	^start!

start: anInteger
	start := anInteger!

stop
	^stop!

stop: anInteger
	stop := anInteger! !
!StTagNode categoriesFor: #acceptVisitor:!public!visitor! !
!StTagNode categoriesFor: #isExternalCall!public!testing! !
!StTagNode categoriesFor: #primitiveIndex!accessing!public! !
!StTagNode categoriesFor: #start!accessing!public! !
!StTagNode categoriesFor: #start:!accessing!private! !
!StTagNode categoriesFor: #stop!accessing!public! !
!StTagNode categoriesFor: #stop:!accessing!private! !

