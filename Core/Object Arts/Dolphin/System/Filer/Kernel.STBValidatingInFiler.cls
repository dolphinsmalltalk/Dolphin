"Filed out from Dolphin Smalltalk"!

Kernel.STxInFilerWrapper
	subclass: #'Kernel.STBValidatingInFiler'
	instanceVariableNames: 'version classLocator context'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBValidatingInFiler guid: (Core.GUID fromString: '{5f22eb11-9eed-40df-b02f-fe697b4cbe7e}')!
Kernel.STBValidatingInFiler comment: '`STBValidatingInFiler` is a `STBInFiler` decorator that is capable of validating the classes of objects appearing in a STB input stream before the objects are actually allowed to be loaded.  This is important since STB is generally considered to be an insecure storage mechanism as it allows arbitrary classes and blocks of code to be imported. Hence `STBValidatingInFiler`s are useful in situations where it is important to guarantee that only "safe" objects can be loaded (e.g. DolphinSure certificates need to be secure and yet are often stored using STB streams).

After instantiating an instance of `STBValidatingInFiler`, it can be configured to include or exclude classes (by default not even the basic predefined classes are included), or with a validation block (using `#validationBlock:`) that takes a symbolic class name as a single parameter.  The block can be used to indicate whether instances of this class should be considered to be safe in the context of the input stream.  If the block evaluates to true the object load will be allowed whereas if it evaluates to false the load will be denied by signalling a `STBError`.'!
!Kernel.STBValidatingInFiler categoriesForClass!System-Binary storage! !
!Kernel.STBValidatingInFiler methodsFor!

classLocator
	^classLocator!

classLocator: aRestrictedClassLocator
	decorated ifNotNil: [
		"The locator should not be changed after the STBInFiler has been instantiated, because it is at that point that any pre-defined classes are validated. Any pre-defined classes excluded by the locator will not be registered, preventing instances of them from being loaded. It might lead to inconsistent validation to change the locator after pre-registration. Obviously the locator configuration should not be changed in a way that would affect the inclusion/exclusion of predefined classes after this point either, although it is acceptable to modify the validation for other classes. See STBInFiler for details of the predefined classes, but note that this does vary by STB filer version. Where possible, the safest and most secure approach is to pre-configure the class validation before any attempt is made to read from the stream."
		self error: 'classLocator cannot be changed after reading from the STB stream'].
	classLocator := aRestrictedClassLocator!

context: anObject
	context := anObject.
	decorated ifNotNil: [super context: anObject]!

inFiler
	"Private - Answer the <STBInFiler> used by the receiver to do the actual deserialisation. This must be lazily instantiated so that any pre-defined classes are also run through the class validation. By default even pre-registered classes are excluded, although some objects are implicitly included because they are encoded in the metadata of the stream, i.e. in the prefix integers (nil, SmallIntegers, Characters), or they are one of the predefined objects (true, false, Smalltalk and Processor). The locator should be configured with the desired exclusions/inclusions before the STBInFiler is initialized, although changes to the class validation that don't affect the choice of predefined classes are acceptable."

	^decorated
		ifNil: 
			[decorated := (self inFilerClass classForVersion: self version) basicNew
						classLocator: classLocator;
						context: context;
						decorator: self;
						stream: stream;
						yourself]!

inFilerClass
	^STBInFiler!

predefinedClasses
	"Answer the predefined (pre-registered) classes for the receiver's STBInFiler version. Note that this is the raw set. It may include classes that the class locator will not resolve, and if so those classes will be excluded and an error will be raised if any instances of them are encountered in the STB stream."

	^self inFiler predefinedClasses!

stream: aReadStream classLocator: aClassLocator
	stream := aReadStream.
	classLocator := aClassLocator!

validationBlock: aMonadicValuable
	"Set the monadic valuable (usually a block) that when passed a class name, will answer true if objects of that class are valid for loading from the receiver."

	self classLocator: (ValidatingClassLocator validationBlock: aMonadicValuable)!

validClasses: aCollection
	"Restrict the set of classes that can be loaded to those in the collection argument. The collection can contain Class objects, class names, or binding references to classes, in any mixture."

	self classLocator: (RestrictedClassLocator forClasses: aCollection)!

version
	^version ifNil: [version := self inFilerClass readSignatureAndVersion: stream]! !
!Kernel.STBValidatingInFiler categoriesForMethods!
classLocator!public! !
classLocator:!public! !
context:!public! !
inFiler!initializing!private! !
inFilerClass!constants!private! !
predefinedClasses!public! !
stream:classLocator:!initializing!private! !
validationBlock:!accessing!public! !
validClasses:!public! !
version!public! !
!

!Kernel.STBValidatingInFiler class methodsFor!

defaultClassLocatorClass
	"Answer the class of Class Locator to use by default for finding and validating classes in the receiver's input stream. By default we use the locator that only resolves classes that are on its explicit inclusion list."

	^RestrictedClassLocator!

on: aStream
	"Answer a new instance attached to the binary stream aStream."

	^self on: aStream classLocator: self defaultClassLocatorClass new!

on: aStream classLocator: aClassLocator
	"Answer a new instance attached to the binary stream aStream."

	^self new stream: aStream classLocator: aClassLocator!

on: aStream validClasses: aCollection
	"Answer a new instance attached to the binary stream aStream."

	^self new stream: aStream classLocator: (RestrictedClassLocator forClasses: aCollection)! !
!Kernel.STBValidatingInFiler class categoriesForMethods!
defaultClassLocatorClass!constants!private! !
on:!instance creation!public! !
on:classLocator:!instance creation!public! !
on:validClasses:!instance creation!public! !
!

