"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #CollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CollectionTest guid: (GUID fromString: '{92c1298a-2628-4867-8fbf-2c7f1d613a62}')!
CollectionTest isAbstract: true!
CollectionTest comment: ''!
!CollectionTest categoriesForClass!Unclassified! !
!CollectionTest methodsFor!

conformanceOfPutElementOnXatAllPutX: aString
	"Do Nothing, Has no conformance issue"!

conformanceOfPutElementOnXatAllXputX: aString
	"Do Nothing, Has no conformance issue"!

conformanceOfPutElementOnXatXputX: aString
	"Do Nothing, Has no conformance issue"!

returnTypeHasLimitedElementTypes

	^false! !
!CollectionTest categoriesForMethods!
conformanceOfPutElementOnXatAllPutX:!public! !
conformanceOfPutElementOnXatAllXputX:!public! !
conformanceOfPutElementOnXatXputX:!public! !
returnTypeHasLimitedElementTypes!public! !
!

!CollectionTest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: CollectionHelper! !
!CollectionTest class categoriesForMethods!
helperClassesDo:!public! !
!

