"Filed out from Dolphin Smalltalk"!

Kernel.STLVersionPolicy
	subclass: #'Kernel.STLVersion3Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLVersion3Policy guid: (Core.GUID fromString: '{d443c598-bf59-48b8-83ff-9cce6e8ca411}')!
Kernel.STLVersion3Policy comment: ''!
!Kernel.STLVersion3Policy methodsFor!

literalPrinterClass
	^LegacySTLPrinter! !
!Kernel.STLVersion3Policy categoriesForMethods!
literalPrinterClass!public! !
!

!Kernel.STLVersion3Policy class methodsFor!

initialize
	"
	self initialize
	"

	Versions at: 3+1
		put: (self new
				version: 3;
				yourself)! !
!Kernel.STLVersion3Policy class categoriesForMethods!
initialize!class initialization!public! !
!

