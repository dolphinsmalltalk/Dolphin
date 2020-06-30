"Filed out from Dolphin Smalltalk 7"!

CollectionTest subclass: #SetANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SetANSITest guid: (GUID fromString: '{3329b13f-02b2-4a1f-a5dd-0bafd43b261a}')!
SetANSITest comment: ''!
!SetANSITest categoriesForClass!Unclassified! !
!SetANSITest methodsFor!

canonicalElement

	^2!

canonicalObject
	^Set with: 1 with: 2 with: 3 with: 4!

emptyCollection

	^self canonicalObject class new!

protocol
	^#Set!

testXaddAllX
	" <Set>#addAll: "
	| co oldSize |
	co := self canonicalObject.
	oldSize := co size.
	self
		value: [co addAll: co copy]
		should: [:r | co size = oldSize]
		conformTo: #Set
		selector: #addAll:!

testXaddX
	" <Set>#add: "
	| co oldSize |
	co := self canonicalObject.
	oldSize := co size.
	self
		value: [co add: co anyOne]
		should: [:r | co size = oldSize]
		conformTo: #Set
		selector: #add:! !
!SetANSITest categoriesFor: #canonicalElement!public! !
!SetANSITest categoriesFor: #canonicalObject!public! !
!SetANSITest categoriesFor: #emptyCollection!public! !
!SetANSITest categoriesFor: #protocol!public! !
!SetANSITest categoriesFor: #testXaddAllX!public! !
!SetANSITest categoriesFor: #testXaddX!public! !

!SetANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: ExtensibleCollectionHelper.! !
!SetANSITest class categoriesFor: #helperClassesDo:!public! !

