"Filed out from Dolphin Smalltalk"!

Kernel.Namespace
	subclass: #Graphics
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Core private} #{OS private} #{External private} #{Kernel private})
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics guid: (Core.GUID fromString: '{b6e7c739-5260-4ddb-a19e-36dbbcfecee3}')!
Graphics isNonInstantiable: true!
Graphics comment: ''!
!Graphics categoriesForClass!Kernel-Objects! !
!Graphics class methodsFor!

uninitialize
	"We must remove the receiver from the imports of Smalltalk when uninstalled to workaround a bug in binding resolution, which can go into an infinite loop trying to resolve Smalltalk's imports when looking up an imported binding. The bug otherwise prevents deployment of console applications."

	Smalltalk removeImport: self fullyQualifiedReference! !
!Graphics class categoriesForMethods!
uninitialize!class hierarchy-removing!private! !
!

