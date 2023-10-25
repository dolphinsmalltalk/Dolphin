"Filed out from Dolphin Smalltalk"!

Kernel.ClassLocator
	subclass: #'Kernel.ValidatingClassLocator'
	instanceVariableNames: 'validationBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.ValidatingClassLocator guid: (Core.GUID fromString: '{17f80ce1-69c5-4a27-bdaa-e9fcc7b8949b}')!
Kernel.ValidatingClassLocator comment: 'A ValidatingClassLocator is an extension to the standard ClassLocator which can be used to validate classes of objects being read from an external serial stream (such as STB).  STB is inherently an insecure format since it can contain any objects, including blocks of code which may be malicious in nature.  By plugging a ValidatingClassLocator into an STBInFiler then one is able to check the classes of objects in the input stream before they are allowed into the image.

The validation is controlled by a #validationBlock which is passed the symbolic class names of objects being loaded.  The block should return true if the load is to be permitted.  If the block returns false then an STBError exception is signalled.

Typically, ValidatingClassLocator can be considered a private class only instantiated as part of an STBValidatingInFiler.'!
!Kernel.ValidatingClassLocator categoriesForClass!System-Binary class loading! !
!Kernel.ValidatingClassLocator methodsFor!

copyWithCodeBase
	"Private - Answer a instance of the same class as the receiver with the same codeBase.
	This allows both the codeBase and the mechanism for using it to be propagated."

	^super copyWithCodeBase validationBlock: validationBlock!

findResidentClass: aBindingReference
	"Answer the class referred to by the receiver if it is fully resident in the image. 
	First see if the requested class is valid."

	(validationBlock value: aBindingReference pathString) ifFalse: [STxInFiler errorInvalidClass: aBindingReference].
	^super findResidentClass: aBindingReference!

includesClass: aClass
	"Answer whether the <Class> argument is within the allowed set."

	^validationBlock value: aClass fullName!

initialize
	"Private - Initialize the receiver"

	super initialize.
	validationBlock := [:className | true]!

validationBlock
	"Answer the monadic valuable (usually a block) that when passed a class name symbol will answer true if objects
	of this class are valid for loading into the image from the input stream associated with the receiver."

	^validationBlock!

validationBlock: aMonadicValuable 
	"Private - Set the monadic valuable (usually a block) that when passed a class name symbol will answer true if objects
	of this class are valid for loading into the image from the input stream associated with the receiver."

	super initialize.
	validationBlock := aMonadicValuable.
	^self
! !
!Kernel.ValidatingClassLocator categoriesForMethods!
copyWithCodeBase!copying!private! !
findResidentClass:!operations!public! !
includesClass:!operations!public! !
initialize!initializing!private! !
validationBlock!accessing!public! !
validationBlock:!initializing!private! !
!

!Kernel.ValidatingClassLocator class methodsFor!

new
	"This will not be very useful, but it is secure by default as it effectively refuses to load anything."

	^self validationBlock: [:className | false]!

validationBlock: aMonadicValuable
	^self basicNew validationBlock: aMonadicValuable! !
!Kernel.ValidatingClassLocator class categoriesForMethods!
new!public! !
validationBlock:!accessing!public! !
!

