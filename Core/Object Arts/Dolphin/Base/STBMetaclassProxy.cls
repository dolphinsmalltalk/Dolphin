"Filed out from Dolphin Smalltalk"!

STBClassProxy subclass: #STBMetaclassProxy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBMetaclassProxy guid: (GUID fromString: '{87b4c6f5-026e-11d3-9fd7-00a0cc3e4a32}')!
STBMetaclassProxy comment: ''!
!STBMetaclassProxy categoriesForClass!System-Binary storage! !
!STBMetaclassProxy methodsFor!

resolveWithClassLocator: aClassLocator 
	"Private - If the class represented by the <ClassLocator> argument is a resident class or a
	loaded imported class then answer the class' metaclass. Otherwise answer a <MetaclassStub>
	representing the Metaclass which will be resolved when it is first used."

	^aClassLocator findAvailableClass 
		ifNotNil: [:availableClass | availableClass class]
		ifNil: [self withClassLocator: aClassLocator]!

withClassLocator: aClassLocator
	^(Smalltalk lookup: #MetaclassStub)
		ifNotNil: [:classStub | classStub withClassLocator: aClassLocator]! !
!STBMetaclassProxy categoriesForMethods!
resolveWithClassLocator:!converting!private! !
withClassLocator:!converting!private! !
!

!STBMetaclassProxy class methodsFor!

forClass: aMetaclass
	"Answer a new instance representing aMetaclass."

	^super forClass: aMetaclass instanceClass! !
!STBMetaclassProxy class categoriesForMethods!
forClass:!instance creation!public! !
!

