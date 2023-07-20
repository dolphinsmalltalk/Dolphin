"Filed out from Dolphin Smalltalk"!

Kernel.AbstractSTBOutFiler
	subclass: #'Kernel.STLOutFiler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLOutFiler guid: (Core.GUID fromString: '{72dee7e2-3402-4813-99f6-379ffc717b86}')!
Kernel.STLOutFiler comment: ''!
!Kernel.STLOutFiler categoriesForClass!System-Binary storage! !
!Kernel.STLOutFiler class methodsFor!

version
	"Private - Answer the version number of the format produced by the receiver.
		Version 5 - Literal filer saves class locators as BindingReferences"

	^STLFilerVersion
!

versionPolicyClass
	^STLVersionPolicy! !
!Kernel.STLOutFiler class categoriesForMethods!
version!public! !
versionPolicyClass!constants!private! !
!

