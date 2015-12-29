"Filed out from Dolphin Smalltalk X6"!

ProtoObject subclass: #ClassStub
	instanceVariableNames: 'classLocator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassStub guid: (GUID fromString: '{90A6120E-6B86-11D3-97BB-0080C8D59432}')!
ClassStub comment: 'A ClassStub represents a reference to an, as yet, unresolved class object when a binary class is being loaded from an STB filer. As a class being loaded is fixed up, any other classes that it refers to are replaced by ClassStubs.  These stubs respond to #doesNotUnderstand: by resolving to a real class themselves.  The use of such stubs enables the binary loading system to only load classes on demand rather than by loading an entire net of classes at once.

Instance Variables:
	classLocator		<ClassLocator> indicating how the stub should eventually locate the binary class file associated with its class.

'!
!ClassStub categoriesForClass!System-Binary class loading! !
!ClassStub methodsFor!

classLocator
	"Private - Answer set the receiver's classLocator inst var."

	^classLocator!

classLocator: aClassLocator
	"Private - Set the receiver's classLocator inst var. Answer self"

	classLocator := aClassLocator.
	^self!

doesNotUnderstand: aMessage
	"Private - The receiver has received a message which it doesn't understand - hardly surprising,
	we dont understand much!! We resolve our classLocator, #oneWayBecome: it, then pass the message
	on to that instead."

	#todo "I reckon the stub needs a mutex of its own to prevent more than one attempt to resolve it".
	ClassLocator importedClassesMutex critical: [
		(self isKindOf: ClassStub) ifTrue: [
			self oneWayBecome: self resolveLocator ]].
	^aMessage value: self.!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver."

	| name |
	 name := [self class name] on: Error do: [:ex | 'invalid ClassStub'].
	aStream 
		nextPutAll: (name first isVowel ifTrue: ['an '] ifFalse: ['a ']);
		nextPutAll: name;
		nextPut: $(;
		print: classLocator;
		nextPut: $)!

resolveLocator
	"Private - Answer the object represented by our classLocator inst var."

	^classLocator locateClass! !
!ClassStub categoriesFor: #classLocator!accessing!private! !
!ClassStub categoriesFor: #classLocator:!accessing!private! !
!ClassStub categoriesFor: #doesNotUnderstand:!exceptions!private! !
!ClassStub categoriesFor: #printOn:!printing!public! !
!ClassStub categoriesFor: #resolveLocator!helpers!private! !

!ClassStub class methodsFor!

forClass: classSpecString
	"Answer a new instance of the receiver containing a ClassLocator with key classSpecString."

	^self withClassLocator: (ClassLocator key: classSpecString)!

withClassLocator: aClassLocator
	"Private - Answer a new instance of the receiver containing aClassLocator."

	^self new classLocator: aClassLocator! !
!ClassStub class categoriesFor: #forClass:!instance creation!public! !
!ClassStub class categoriesFor: #withClassLocator:!instance creation!private! !

