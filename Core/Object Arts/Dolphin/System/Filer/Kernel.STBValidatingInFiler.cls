"Filed out from Dolphin Smalltalk"!

Kernel.STBInFiler
	subclass: #'Kernel.STBValidatingInFiler'
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

defaultClassLocatorClass
	"Answer the class of Class Locator to use by default for finding and validating
	classes in the receiver's input stream."

	^RestrictedClassLocator!

initializeObjectMap
	"We defer initializing the object map so that we can run the predefined classes through the validator"

	readMap := nil!

next
	"Answer the next object from the receiver's stream."

	readMap ifNil: [self initializeReadMap].
	^super next!

objectAt: anInteger
	"Pre-registered classes in the serialised graph are written as direct references, so we need to look out for these implicit class references."

	^(anInteger > policy predefinedClassOffset and: [anInteger <= policy lastPredefined])
		ifTrue: [self classAt: anInteger]
		ifFalse: [readMap at: anInteger]!

registerAllClasses: anArrayOfClass
	anArrayOfClass do: [:each | readMap addLast: ((classLocator includesClass: each) ifTrue: [each])]!

validationBlock: aMonadicValuable
	"Set the monadic valuable (usually a block) that when passed a class name, will answer true if objects of that class are valid for loading from the receiver."

	classLocator := ValidatingClassLocator validationBlock: aMonadicValuable!

validClasses: aCollection
	"Restrict the set of classes that can be loaded to those in the collection argument. The collection can contain Class objects, class names, or binding references to classes, in any mixture."

	classLocator := RestrictedClassLocator forClasses: aCollection! !
!Kernel.STBValidatingInFiler categoriesForMethods!
defaultClassLocatorClass!constants!private! !
initializeObjectMap!initializing!private! !
next!operations!public! !
objectAt:!accessing!private! !
registerAllClasses:!private! !
validationBlock:!accessing!public! !
validClasses:!public! !
!

