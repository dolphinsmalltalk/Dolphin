"Filed out from Dolphin Smalltalk 7"!

StProgramNode subclass: #StTagNode
	instanceVariableNames: 'start stop'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StTagNode guid: (GUID fromString: '{eb694d50-0176-4a1d-a468-8f7a306f573b}')!
StTagNode isAbstract: true!
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

