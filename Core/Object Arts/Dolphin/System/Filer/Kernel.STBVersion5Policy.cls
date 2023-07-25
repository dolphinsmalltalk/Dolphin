"Filed out from Dolphin Smalltalk"!

Kernel.STBVersionPolicyForNamespaces
	subclass: #'Kernel.STBVersion5Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBVersion5Policy guid: (Core.GUID fromString: '{5514d6ae-d32f-459b-8eb4-79c07ca815a1}')!
Kernel.STBVersion5Policy comment: ''!
!Kernel.STBVersion5Policy methodsFor!

predefinedClasses
	"Answer a <sequencedReadableCollection> of the classes that are pre-registered in every STB
	file. These make it possible to binary file the classes STBClassProxy and String. Also these
	clases are almost always needed, so we can save space pre-registering them so that they
	don't need to be written into the filer."

	"Note that pre-registering classes does not inflate the size of the binary file, it just
	pre-allocates a range of indices for fixed uses. Changing the order of these (or deleting
	registrations) will break existing binary files. Lastly a consequence of pre-registering
	these classes is that normal STB versioning will have no effect - the #stbVersion is only
	checked when a class is first read from the file. In order to version these classes it is
	necessary to increment the global STB version number."

	^STBVersion1Policy.PredefinedClasses! !
!Kernel.STBVersion5Policy categoriesForMethods!
predefinedClasses!public! !
!

!Kernel.STBVersion5Policy class methodsFor!

initialize
	"
	self initialize
	"

	Versions at: 5+1 put: self!

uninitialize
	Versions at: 5+1 put: nil! !
!Kernel.STBVersion5Policy class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
!

