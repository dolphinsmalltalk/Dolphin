"Filed out from Dolphin Smalltalk"!

Icon subclass: #IconWithExtent
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

IconWithExtent guid: (GUID fromString: '{429114bb-12f2-41ab-8fe0-7585364ac305}')!

IconWithExtent comment: '`IconWithExtent` is obsolete, but retained for backwards compatibility with existing references in code and in binary filed view resources.

`Icon` itself now supports the ability to request realization at a particular extent for use in cases where a Windows API is expecting an icon of a particular size.'!

!IconWithExtent categoriesForClass!Graphics-Tools! !

!IconWithExtent class methodsFor!

stbConvertFromVersion3: anArray
	"Version 4 - the superclass supports a preferred extent via it's initializer"

	| vars initializer |
	vars := super stbConvertFromVersion3: anArray.
	initializer := vars at: 3.
	initializer extent: (vars at: 4).
	^vars copyFrom: 1 to: 3! !

!IconWithExtent class categoriesForMethods!
stbConvertFromVersion3:!binary filing!public! !
!

