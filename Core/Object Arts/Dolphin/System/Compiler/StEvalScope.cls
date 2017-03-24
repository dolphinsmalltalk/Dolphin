"Filed out from Dolphin Smalltalk 7"!

StSemanticScope subclass: #StEvalScope
	instanceVariableNames: 'pools'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StEvalScope guid: (GUID fromString: '{c90dad3d-8211-445e-aa23-907eee35e6b8}')!
StEvalScope comment: ''!
!StEvalScope categoriesForClass!Kernel-Objects! !
!StEvalScope methodsFor!

lookupVariable: aString
	pools
		do: [:each | (each bindingFor: aString) ifNotNil: [:binding | ^StStaticVariable scope: self binding: binding]].
	^nil!

setPools: anArray
	pools := anArray! !
!StEvalScope categoriesFor: #lookupVariable:!operations!public! !
!StEvalScope categoriesFor: #setPools:!initializing!private! !

!StEvalScope class methodsFor!

pools: pools
	^self new setPools: pools! !
!StEvalScope class categoriesFor: #pools:!instance creation!public! !

