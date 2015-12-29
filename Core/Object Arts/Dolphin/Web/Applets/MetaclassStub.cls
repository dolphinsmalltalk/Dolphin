"Filed out from Dolphin Smalltalk X6"!

ClassStub subclass: #MetaclassStub
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MetaclassStub guid: (GUID fromString: '{9B335A77-6B86-11D3-97BB-0080C8D59432}')!
MetaclassStub comment: 'A MetaClassStub represents a reference to an, as yet, unresolved Metaclass object when a binary class is being loaded from an STB filer. As a class being loaded is fixed up, any metaclasses that it refers to are replaced by MetaClassStubs.  These stubs respond to #doesNotUnderstand: by resolving to a real metaclass.  The use of such stubs enables the binary loading system to only load classes and metaclasses on demand rather than by loading an entire net at once.
'!
!MetaclassStub categoriesForClass!System-Binary class loading! !
!MetaclassStub methodsFor!

resolveLocator
	"Private - Answer the object represented by our classLocator inst var."

	| class |
	(class := super resolveLocator) isNil
		ifTrue: [^nil].
	^class class! !
!MetaclassStub categoriesFor: #resolveLocator!helpers!private! !

