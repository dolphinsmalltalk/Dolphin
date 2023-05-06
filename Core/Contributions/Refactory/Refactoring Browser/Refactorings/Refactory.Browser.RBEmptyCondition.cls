"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBAbstractCondition
	subclass: #'Refactory.Browser.RBEmptyCondition'
	instanceVariableNames: ''
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBEmptyCondition guid: (Core.GUID fromString: '{2bf72058-23f5-41b2-864e-7e0b03ac54f0}')!
Refactory.Browser.RBEmptyCondition comment: ''!
!Refactory.Browser.RBEmptyCondition categoriesForClass!Refactory-Conditions! !
!Refactory.Browser.RBEmptyCondition methodsFor!

check
	^true!

errorMacro
	^'Empty'!

printOn: aStream 
	#empty printOn: aStream! !
!Refactory.Browser.RBEmptyCondition categoriesForMethods!
check!checking!public! !
errorMacro!private! !
printOn:!printing!public! !
!

!Refactory.Browser.RBEmptyCondition class methodsFor!

current
	^Current!

initialize
	Current := self new
				beReadOnlyObject;
				yourself! !
!Refactory.Browser.RBEmptyCondition class categoriesForMethods!
current!public! !
initialize!public! !
!

