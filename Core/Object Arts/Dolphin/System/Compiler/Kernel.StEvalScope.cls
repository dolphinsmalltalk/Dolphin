﻿"Filed out from Dolphin Smalltalk"!

Kernel.StSemanticScope
	subclass: #'Kernel.StEvalScope'
	instanceVariableNames: 'pools outer'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.StEvalScope guid: (Core.GUID fromString: '{c90dad3d-8211-445e-aa23-907eee35e6b8}')!

Kernel.StEvalScope comment: ''!

!Kernel.StEvalScope categoriesForClass!Kernel-Objects! !

!Kernel.StEvalScope methodsFor!

outer
	^outer!

outer: aStSemanticScope
	outer := aStSemanticScope!

pools: anArray
	pools := anArray!

resolveIdentifier: aString
	"Private - Lookup and return an <StVariable> describing the variable definition in this scope matching the variable identified by the <String> argument."

	pools do: 
			[:each |
			(each bindingFor: aString) ifNotNil: [:binding | ^StWorkspaceVariable scope: self binding: binding]].
	^outer resolveIdentifier: aString!

visibleVariablesDo: aMonadicValuable visited: aSet
	outer visibleVariablesDo: aMonadicValuable visited: aSet! !

!Kernel.StEvalScope categoriesForMethods!
outer!accessing!public! !
outer:!initializing!private! !
pools:!initializing!private! !
resolveIdentifier:!operations!private! !
visibleVariablesDo:visited:!operations!public! !
!

!Kernel.StEvalScope class methodsFor!

pools: pools outer: aStSemanticScope
	<primitive: 157>
	^self new
		pools: pools;
		outer: aStSemanticScope;
		yourself! !

!Kernel.StEvalScope class categoriesForMethods!
pools:outer:!instance creation!public! !
!

