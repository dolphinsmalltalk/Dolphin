"Filed out from Dolphin Smalltalk"!

StProgramNode subclass: #StTagNode
	instanceVariableNames: 'start stop'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
!StTagNode categoriesForMethods!
acceptVisitor:!public!visitor! !
isExternalCall!public!testing! !
primitiveIndex!accessing!public! !
start!accessing!public! !
start:!accessing!private! !
stop!accessing!public! !
stop:!accessing!private! !
!

