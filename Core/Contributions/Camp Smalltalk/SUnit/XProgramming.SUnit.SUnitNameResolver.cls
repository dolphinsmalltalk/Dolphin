"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SUnitNameResolver
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SUnitNameResolver guid: (GUID fromString: '{786377a2-4134-11d4-907e-00e09803abef}')!
SUnitNameResolver comment: ''!
!SUnitNameResolver categoriesForClass!SUnitPreload! !
!SUnitNameResolver class methodsFor!

classNamed: aSymbol
	^aSymbol asQualifiedReference valueOrNil! !
!SUnitNameResolver class categoriesFor: #classNamed:!Camp Smalltalk!public! !

