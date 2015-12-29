"Filed out from Dolphin Smalltalk X6"!

STBClassProxy subclass: #STBMetaclassProxy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBMetaclassProxy guid: (GUID fromString: '{87B4C6F5-026E-11D3-9FD7-00A0CC3E4A32}')!
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
	^(Smalltalk at: #MetaclassStub ifAbsent: []) 
		ifNotNil: [:classStub | classStub withClassLocator: aClassLocator]! !
!STBMetaclassProxy categoriesFor: #resolveWithClassLocator:!converting!private! !
!STBMetaclassProxy categoriesFor: #withClassLocator:!converting!private! !

!STBMetaclassProxy class methodsFor!

forClass: aMetaclass
	"Answer a new instance representing aMetaclass."

	^super forClass: aMetaclass instanceClass! !
!STBMetaclassProxy class categoriesFor: #forClass:!instance creation!public! !

