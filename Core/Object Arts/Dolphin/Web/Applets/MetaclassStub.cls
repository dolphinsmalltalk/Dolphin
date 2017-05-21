"Filed out from Dolphin Smalltalk 7"!

ClassStub subclass: #MetaclassStub
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MetaclassStub guid: (GUID fromString: '{9b335a77-6b86-11d3-97bb-0080c8d59432}')!
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

