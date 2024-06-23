"Filed out from Dolphin Smalltalk"!

Kernel.Namespace
	subclass: #UI
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Core} #{Graphics} #{OS private} #{Kernel private})
	classInstanceVariableNames: ''
	classConstants: {}!

UI guid: (Core.GUID fromString: '{71ce5ac9-14c0-4ab9-be4e-a7b27681b664}')!

UI isNonInstantiable: true!

UI comment: ''!

!UI categoriesForClass!Kernel-Objects! !

!UI class methodsFor!

uninitialize
	"We must remove the receiver from the imports of Smalltalk when uninstalled to workaround a bug in binding resolution, which can go into an infinite loop trying to resolve Smalltalk's imports when looking up an imported binding. The bug otherwise prevents deployment of console applications."

	Smalltalk removeImport: self fullyQualifiedReference! !

!UI class categoriesForMethods!
uninitialize!class hierarchy-removing!private! !
!

