"Filed out from Dolphin Smalltalk"!

Object subclass: #SUnitNameResolver
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitNameResolver guid: (GUID fromString: '{786377a2-4134-11d4-907e-00e09803abef}')!
SUnitNameResolver comment: ''!
!SUnitNameResolver categoriesForClass!SUnitPreload! !
!SUnitNameResolver class methodsFor!

classNamed: aSymbol
	^Smalltalk 
		at: aSymbol 
		ifAbsent: [nil].! !
!SUnitNameResolver class categoriesForMethods!
classNamed:!Camp Smalltalk!public! !
!

