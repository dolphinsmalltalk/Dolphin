"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #CollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!CollectionTest categoriesFor: #conformanceOfPutElementOnXatAllPutX:!public! !
!CollectionTest categoriesFor: #conformanceOfPutElementOnXatAllXputX:!public! !
!CollectionTest categoriesFor: #conformanceOfPutElementOnXatXputX:!public! !
!CollectionTest categoriesFor: #returnTypeHasLimitedElementTypes!public! !

!CollectionTest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: CollectionHelper! !
!CollectionTest class categoriesFor: #helperClassesDo:!public! !

