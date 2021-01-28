"Filed out from Dolphin Smalltalk 7"!

Kernel.STBInFiler subclass: #'Kernel.STBValidatingInFiler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBValidatingInFiler guid: (Core.GUID fromString: '{5f22eb11-9eed-40df-b02f-fe697b4cbe7e}')!
Kernel.STBValidatingInFiler comment: 'STBValidatingInFiler is a specialisation of STBInFiler that is capable of validating the classes of objects appearing in a STB input stream before the objects are actually allowed to be loaded.  This is important since STB is generally considered to be an insecure storage mechanism as it can allow arbitrary classes and blocks of code to be imported. Hence the STBValidatingInFiler is useful in situations where it is important to guarantee that only "safe" objects can be loaded (e.g. DolphinSure certificates need to be secure and yet are often stored using STB streams).  

After instantiating an instance of STBValidatingInFiler, it can be configured with a validation block (using #validationBlock:) that takes a symbolic class name as a single parameter.  The block can be used to indicate whether instances of this class should be considered to be safe in the context of the input stream.  If the block evaluates to true the object load will be allowed whereas if it evaluates to false the load will be denied by signalling a STBError.'!
!Kernel.STBValidatingInFiler categoriesForClass!System-Binary storage! !
!Kernel.STBValidatingInFiler methodsFor!

classAt: anInteger
	"Private - Answer the map value for a class at anInteger. If anInteger is zero then answer nil.
	Signal an exception if there is no such entry."

	| class |
	class := super classAt: anInteger.
	(self validationBlock value: class fullName)
		ifFalse: [STBValidatingInFiler errorInvalidClass: class fullName].
	^class!

defaultClassLocatorClass
	"Answer the class of Class Locator to use by default for finding and validating
	classes in the receiver's input stream."

	^ValidatingClassLocator!

validationBlock
	"Private - Answer the monadic valuable (usually a block) that when passed a class name symbol will answer true if objects
	of this class are valid for loading from the receiver."

	^self classLocator validationBlock
!

validationBlock: aMonadicValuable 
	"Set the monadic valuable (usually a block) that when passed a class name symbol will answer true if objects
	of this class are valid for loading from the receiver."

	self classLocator validationBlock: aMonadicValuable.! !
!Kernel.STBValidatingInFiler categoriesFor: #classAt:!accessing!private! !
!Kernel.STBValidatingInFiler categoriesFor: #defaultClassLocatorClass!constants!private! !
!Kernel.STBValidatingInFiler categoriesFor: #validationBlock!accessing!private! !
!Kernel.STBValidatingInFiler categoriesFor: #validationBlock:!accessing!public! !

!Kernel.STBValidatingInFiler class methodsFor!

errorInvalidClass: aClassName
	"Private - Signal an exception to warn that an input stream contains an invalid class."

	STBError signal: ('Input stream contains an invalid class (<1s>)' expandMacrosWith: aClassName)! !
!Kernel.STBValidatingInFiler class categoriesFor: #errorInvalidClass:!exceptions!private! !

