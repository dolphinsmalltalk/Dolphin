"Filed out from Dolphin Smalltalk XP 2002 release 6.00"!

Object subclass: #SUnitNameResolver
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitNameResolver guid: (GUID fromString: '{786377A2-4134-11D4-907E-00E09803ABEF}')!
SUnitNameResolver comment: ''!
!SUnitNameResolver categoriesForClass!SUnitPreload! !
!SUnitNameResolver class methodsFor!

classNamed: aSymbol
	^Smalltalk 
		at: aSymbol 
		ifAbsent: [nil].! !
!SUnitNameResolver class categoriesFor: #classNamed:!Camp Smalltalk!public! !

