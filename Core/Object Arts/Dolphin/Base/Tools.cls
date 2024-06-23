"Filed out from Dolphin Smalltalk"!

Kernel.Namespace
	subclass: #Tools
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Core} #{UI private} #{Kernel private})
	classInstanceVariableNames: ''
	classConstants: {}!

Tools guid: (Core.GUID fromString: '{035db428-db96-4aa5-b679-c26cdf4b8bce}')!

Tools isNonInstantiable: true!

Tools comment: ''!

!Tools categoriesForClass!Kernel-Objects! !

!Tools class methodsFor!

uninitialize
	"We must remove the receiver from the imports of Smalltalk when uninstalled to workaround a bug in binding resolution, which can go into an infinite loop trying to resolve Smalltalk's imports when looking up an imported binding."

	Smalltalk removeImport: self fullyQualifiedReference private! !

!Tools class categoriesForMethods!
uninitialize!class hierarchy-removing!private! !
!

