"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'XProgramming.SUnit.SUnitNameResolver'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

XProgramming.SUnit.SUnitNameResolver guid: (Core.GUID fromString: '{786377a2-4134-11d4-907e-00e09803abef}')!

XProgramming.SUnit.SUnitNameResolver comment: ''!

!XProgramming.SUnit.SUnitNameResolver categoriesForClass!SUnitPreload! !

!XProgramming.SUnit.SUnitNameResolver class methodsFor!

classNamed: aSymbol
	^aSymbol asQualifiedReference valueOrNil! !

!XProgramming.SUnit.SUnitNameResolver class categoriesForMethods!
classNamed:!Camp Smalltalk!public! !
!

