"Filed out from Dolphin Smalltalk 7"!

Kernel.STBClassProxy subclass: #'Kernel.STBMetaclassProxy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBMetaclassProxy guid: (Core.GUID fromString: '{87b4c6f5-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STBMetaclassProxy comment: ''!
!Kernel.STBMetaclassProxy categoriesForClass!System-Binary storage! !
!Kernel.STBMetaclassProxy methodsFor!

resolveWithClassLocator: aClassLocator 
	"Private - If the class represented by the <ClassLocator> argument is a resident class or a
	loaded imported class then answer the class' metaclass. Otherwise answer a <MetaclassStub>
	representing the Metaclass which will be resolved when it is first used."

	^aClassLocator findAvailableClass 
		ifNotNil: [:availableClass | availableClass class]
		ifNil: [self withClassLocator: aClassLocator]!

withClassLocator: aClassLocator
	^#{MetaclassStub} ifDefined: [:classStub | classStub withClassLocator: aClassLocator]! !
!Kernel.STBMetaclassProxy categoriesFor: #resolveWithClassLocator:!converting!private! !
!Kernel.STBMetaclassProxy categoriesFor: #withClassLocator:!converting!private! !

!Kernel.STBMetaclassProxy class methodsFor!

forClass: aMetaclass
	"Answer a new instance representing aMetaclass."

	^super forClass: aMetaclass instanceClass! !
!Kernel.STBMetaclassProxy class categoriesFor: #forClass:!instance creation!public! !

