"Filed out from Dolphin Smalltalk"!

Kernel.StProgramNode
	subclass: #'Kernel.StTagNode'
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

isAnnotationNode
	^false!

isExternalCall
	^false!

isTag
	^true!

selector
	^self subclassResponsibility!

start
	^start!

start: anInteger
	start := anInteger!

stop
	^stop!

stop: anInteger
	stop := anInteger! !
!Kernel.StTagNode categoriesForMethods!
isAnnotationNode!public!testing! !
isExternalCall!public!testing! !
isTag!public!testing! !
selector!accessing!public! !
start!accessing!public! !
start:!accessing!private! !
stop!accessing!public! !
stop:!accessing!private! !
!

