"Filed out from Dolphin Smalltalk 7"!

Kernel.StProgramNode subclass: #'Kernel.StTagNode'
	instanceVariableNames: 'start stop'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StTagNode guid: (Core.GUID fromString: '{eb694d50-0176-4a1d-a468-8f7a306f573b}')!
Kernel.StTagNode isNonInstantiable: true!
Kernel.StTagNode comment: ''!
!Kernel.StTagNode categoriesForClass!System-Compiler! !
!Kernel.StTagNode methodsFor!

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
!Kernel.StTagNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StTagNode categoriesFor: #isExternalCall!public!testing! !
!Kernel.StTagNode categoriesFor: #primitiveIndex!accessing!public! !
!Kernel.StTagNode categoriesFor: #start!accessing!public! !
!Kernel.StTagNode categoriesFor: #start:!accessing!private! !
!Kernel.StTagNode categoriesFor: #stop!accessing!public! !
!Kernel.StTagNode categoriesFor: #stop:!accessing!private! !

