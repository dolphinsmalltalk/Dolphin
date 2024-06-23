"Filed out from Dolphin Smalltalk"!

Tools.MethodSearch
	subclass: #'Tools.ThisContextSearch'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.ThisContextSearch guid: (Core.GUID fromString: '{02019e30-be33-4796-a47f-8957b9f5fbfc}')!

Tools.ThisContextSearch comment: ''!

!Tools.ThisContextSearch methodsFor!

initialize
	super initialize.
	self pattern: 'thisContext'!

referencesLabelTag
	^#thisContext!

simpleReferenceFilter
	^
	[:each |
	each byteCodeSegments
		anySatisfy: [:eachInstruction | eachInstruction first == Kernel.OpcodePool.PushActiveFrame]]! !

!Tools.ThisContextSearch categoriesForMethods!
initialize!initializing!public! !
referencesLabelTag!constants!public! !
simpleReferenceFilter!helpers!private! !
!

