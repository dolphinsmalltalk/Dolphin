"Filed out from Dolphin Smalltalk"!

Kernel.VariableBinding
	subclass: #'Refactory.Browser.RBVariableBinding'
	instanceVariableNames: 'realBinding'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBVariableBinding guid: (Core.GUID fromString: '{b10f55e8-e21f-4755-aedd-e3bb1ac9850a}')!
Refactory.Browser.RBVariableBinding comment: ''!
!Refactory.Browser.RBVariableBinding categoriesForClass!Collections-Support! !
!Refactory.Browser.RBVariableBinding methodsFor!

isClassBinding
	^(value isKindOf: RBClass)
		and: [key == value unqualifiedName and: [environment == value basicEnvironment]]!

model
	^environment model!

name: aString environment: aRBClass
	key := aString.
	environment := aRBClass.
	flags := ClassMask.
	^self!

realBinding
	^realBinding!

realBinding: aVariableBinding environment: aRBClass
	key := aVariableBinding key.
	value := aVariableBinding value.
	environment := aRBClass.
	flags := (realBinding := aVariableBinding) flags.
	self isImmutable: aVariableBinding isImmutable.
	^self! !
!Refactory.Browser.RBVariableBinding categoriesForMethods!
isClassBinding!public!testing! !
model!accessing!public! !
name:environment:!initializing!private! !
realBinding!accessing!public! !
realBinding:environment:!initializing!private! !
!

!Refactory.Browser.RBVariableBinding class methodsFor!

name: aString environment: aRBClass
	^self new name: aString environment: aRBClass! !
!Refactory.Browser.RBVariableBinding class categoriesForMethods!
name:environment:!instance creation!public! !
!

