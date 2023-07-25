"Filed out from Dolphin Smalltalk"!

Kernel.STBVersionPolicy
	subclass: #'Kernel.STBVersion0Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBVersion0Policy guid: (Core.GUID fromString: '{645b2749-5dfa-4fc3-afd3-708ede25667b}')!
Kernel.STBVersion0Policy comment: ''!
!Kernel.STBVersion0Policy methodsFor!

readClassWithPrefix: anInteger
	| locatorString |
	locatorString := AnsiString new: (anInteger bitShift: STxFiler.PrefixLocatorLenUnshift).
	1 to: locatorString size do: [:i | locatorString basicAt: i put: stream next].
	^filer classLocator locateClass: (BindingReference
				pathString: locatorString
				private: false
				scope: Smalltalk)! !
!Kernel.STBVersion0Policy categoriesForMethods!
readClassWithPrefix:!operations!private! !
!

!Kernel.STBVersion0Policy class methodsFor!

initialize
	"
	self initialize
	"

	Versions at: 0+1 put: self!

uninitialize
	Versions at: 0+1 put: nil! !
!Kernel.STBVersion0Policy class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
!

