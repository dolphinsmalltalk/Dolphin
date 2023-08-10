"Filed out from Dolphin Smalltalk"!

Kernel.STxOutFiler
	subclass: #'Kernel.STLOutFiler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLOutFiler guid: (Core.GUID fromString: '{72dee7e2-3402-4813-99f6-379ffc717b86}')!
Kernel.STLOutFiler comment: ''!
!Kernel.STLOutFiler categoriesForClass!System-Binary storage! !
!Kernel.STLOutFiler class methodsFor!

newStream
	^WriteStream on: (Array new: 64)!

policyClass
	^STLVersion6Policy! !
!Kernel.STLOutFiler class categoriesForMethods!
newStream!helpers!private! !
policyClass!constants!private! !
!

