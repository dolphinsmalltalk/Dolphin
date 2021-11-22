"Filed out from Dolphin Smalltalk"!

Kernel.VariableBinding subclass: #'Refactory.Browser.RBVariableBinding'
	instanceVariableNames: 'realBinding'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBVariableBinding guid: (Core.GUID fromString: '{b10f55e8-e21f-4755-aedd-e3bb1ac9850a}')!
Refactory.Browser.RBVariableBinding comment: ''!
!Refactory.Browser.RBVariableBinding categoriesForClass!Collections-Support! !
!Refactory.Browser.RBVariableBinding methodsFor!

model
	^environment model!

name: aString class: aRBClass
	key := aString.
	environment := aRBClass.
	flags := ClassMask.
	^self!

realBinding
	^realBinding!

realBinding: aVariableBinding class: aRBClass
	key := aVariableBinding key.
	value := aVariableBinding value.
	environment := aRBClass.
	realBinding := aVariableBinding.
	flags := aVariableBinding flags.
	self isImmutable: aVariableBinding isImmutable.
	^self!

targetVariable
	^realBinding ?? self! !
!Refactory.Browser.RBVariableBinding categoriesForMethods!
model!accessing!public! !
name:class:!initializing!private! !
realBinding!accessing!public! !
realBinding:class:!initializing!private! !
targetVariable!accessing!public! !
!

!Refactory.Browser.RBVariableBinding class methodsFor!

name: aString class: aRBClass
	^self new name: aString class: aRBClass!

realBinding: aVariableBinding class: aRBClass
	^self new realBinding: aVariableBinding class: aRBClass! !
!Refactory.Browser.RBVariableBinding class categoriesForMethods!
name:class:!instance creation!public! !
realBinding:class:!instance creation!public! !
!

