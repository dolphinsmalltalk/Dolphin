"Filed out from Dolphin Smalltalk"!

Kernel.STxInFilerWrapper
	subclass: #'Kernel.STLClassCollector'
	instanceVariableNames: 'classes resourceIdentifiers'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.STLClassCollector guid: (Core.GUID fromString: '{bf23d8df-102a-469c-90f6-0698b66b6fa6}')!

Kernel.STLClassCollector comment: '`STLClassCollector` is a `STLInFiler` decorator that captures the class of all objects in an STL stream. This is useful for tracking dependencies between classes resulting from STL resources that might otherwise not be visible. This helps, for example, to build a complete picture of package prerequisites, and also when stripping an image for application deployment to retain classes that resources may depend on.'!

!Kernel.STLClassCollector categoriesForClass!System-Binary storage! !

!Kernel.STLClassCollector methodsFor!

basicNext
	| prefixOrLiteral |
	prefixOrLiteral := stream next.
	prefixOrLiteral isInteger ifFalse: [^self collectClassOf: prefixOrLiteral value].
	STxFiler.PrefixLiteralMask == prefixOrLiteral ifFalse: [^decorated readObjectWithPrefix: prefixOrLiteral].
	^self readLiteralData!

characterValue: anInteger
	"Answer the <Character> for the specified <Integer> code from the object stream."

	"Intercede to capture that the STL contains at least one encoded Character. This will only occur when deserializing STL 3 data."

	classes add: Character.
	^decorated characterValue: anInteger!

classAt: anInteger
	"Answer the read map value for a <Class> with the specified reference."

	| class |
	class := decorated classAt: anInteger.
	classes add: class.
	^class!

classes
	^self contents!

collectClassOf: anObject
	classes add: (anObject isBehavior ifTrue: [anObject instanceClass] ifFalse: [anObject basicClass]).
	^anObject!

contents
	[self atEnd] whileFalse: [self basicNext].
	^classes!

elements
	^decorated elements!

findResourceIdentifiers
	| rids mapStream |
	self contents.
	rids := Set new.
	mapStream := decorated readMap asArray readStream.
	[mapStream atEnd] whileFalse: 
			[| next |
			next := mapStream next.
			next == UI.ResourceIdentifier ifTrue: [rids add: mapStream nextAvailable]].
	^rids!

fixup: anInteger to: anObject
	self collectClassOf: anObject.
	^decorated fixup: anInteger to: anObject!

inFilerClass
	^STLInFiler!

objectAt: anInteger
	"Private - Answer the map value at anInteger. Signal an exception if there is no such entry."

	| object |
	object := decorated objectAt: anInteger.
	anInteger <= decorated lastPredefined
		ifTrue: 
			["Record a reference to a pre-registered class so we know it is used in this stream"
			self collectClassOf: object].
	^object!

readLiteralData
	| newObject |
	newObject := stream next.
	"Arrays of atomic objects can appear as literals. We only need to drill into these to collect the classes of the immediately contained objects, as those objects must themselves be atomic, and so cannot be composed of other objects.
	Non-literal arrays will be visited (recursively) and will have their classes collected through #register:, which is called for every non-literal object."
	newObject basicClass == Array
		ifTrue: [1 to: newObject size do: [:i | self collectClassOf: (newObject at: i) value]]
		ifFalse: [self collectClassOf: newObject].
	decorated register: newObject.
	^newObject!

readNil
	"Read a nil from the object stream"

	classes add: UndefinedObject.
	^nil!

register: anObject
	"Private - Add anObject to the readMap, answering the index of the object in the map. This is important for some classes that might want to fixup the reference later."

	self collectClassOf: anObject.
	^decorated register: anObject!

resourceIdentifiers
	^resourceIdentifiers ifNil: [resourceIdentifiers := self findResourceIdentifiers]!

stream: aStream
	classes := DeafObject.Current.
	classes := IdentitySet new: 64.	
	super stream: aStream.
	"Even an empty STL store array will contain the Symbol, #'STL!!', a SmallInteger for the version, and the Array itself). We also have the dependency on the STLInFiler class for the underlying version"
	classes
		add: Array;
		add: Symbol;
		add: SmallInteger;
		add: decorated class

	! !

!Kernel.STLClassCollector categoriesForMethods!
basicNext!accessing!private! !
characterValue:!helpers!public! !
classAt:!public! !
classes!accessing!public! !
collectClassOf:!helpers!private! !
contents!public! !
elements!public! !
findResourceIdentifiers!helpers!private! !
fixup:to:!public! !
inFilerClass!constants!private! !
objectAt:!accessing!private! !
readLiteralData!helpers!private! !
readNil!deserializing!public! !
register:!helpers!private! !
resourceIdentifiers!accessing!public! !
stream:!initializing!private! !
!

!Kernel.STLClassCollector class methodsFor!

classesIn: aLiteralArray
	"Answer a new instance attached to the binary stream aStream."

	^(self on: aLiteralArray readStream) contents! !

!Kernel.STLClassCollector class categoriesForMethods!
classesIn:!instance creation!public! !
!

