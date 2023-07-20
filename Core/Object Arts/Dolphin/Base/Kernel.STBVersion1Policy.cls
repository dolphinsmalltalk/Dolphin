"Filed out from Dolphin Smalltalk"!

Kernel.STBVersion0Policy
	subclass: #'Kernel.STBVersion1Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBVersion1Policy guid: (Core.GUID fromString: '{2e444423-06ca-467d-8a6b-fd12b1d095d1}')!
Kernel.STBVersion1Policy comment: ''!
!Kernel.STBVersion1Policy methodsFor!

lastPredefined
	"Answer the index of the last pre-defined object. The indices of all objects actually present in the stream are offset from this."

	^LastPredefinedClassRef!

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

	^PredefinedClasses! !
!Kernel.STBVersion1Policy categoriesForMethods!
lastPredefined!constants!public! !
predefinedClasses!constants!public! !
!

