Kernel.ProtoObject subclass: #'External.DynamicLinkLibraryStub'
	instanceVariableNames: 'libraryClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
	
!External.DynamicLinkLibraryStub methodsFor!

doesNotUnderstand: failedMessage
	^failedMessage forwardTo: libraryClass default!

libraryClass: aClass
	libraryClass := aClass! !
	
!External.DynamicLinkLibraryStub class methodsFor!

libraryClass: aClass
	^self new libraryClass: aClass; yourself! !

Kernel at: #VM put: VMLibrary default!
| systemPackage |
systemPackage := Object owningPackage.
DynamicLinkLibraryStub owningPackage: systemPackage.
#(#{Kernel.VM}) do: [:each |
	each binding owningPackage: systemPackage]!
