"Filed out from Dolphin Smalltalk"!

CollectionTest subclass: #SequencedReadableCollectionTest
	instanceVariableNames: 'canonicalObjects'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SequencedReadableCollectionTest guid: (GUID fromString: '{80a590e8-57fd-459f-bfdd-3055f38fecee}')!
SequencedReadableCollectionTest isAbstract: true!
SequencedReadableCollectionTest comment: ''!
!SequencedReadableCollectionTest categoriesForClass!Unclassified! !
!SequencedReadableCollectionTest methodsFor!

canonicalObjects
	| helper |
	canonicalObjects isNil ifFalse: [ ^canonicalObjects ].
	helper := helpers detect: [ :each | each class == SequencedReadableCollectionHelper ].
	canonicalObjects := helper canonicalObjects.
	^canonicalObjects! !
!SequencedReadableCollectionTest categoriesForMethods!
canonicalObjects!public! !
!

