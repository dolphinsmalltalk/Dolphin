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

formatName
	"Private - Answer the format name."

	^STLFormatName!

version
	"Private - Answer the version number of the format produced by the receiver. After version 5 the STL version advances separately from STB.
		Versions 1 to 5. See superclass.
		Version 6 - No pre-registered classes, so all referenced classes are immediately visible in the literal array"

	^6
!

versionPolicyClass
	^STLVersionPolicy! !
!Kernel.STLOutFiler class categoriesForMethods!
formatName!constants!private! !
version!public! !
versionPolicyClass!constants!private! !
!

