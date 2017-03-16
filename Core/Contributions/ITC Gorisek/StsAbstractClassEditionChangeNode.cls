"Filed out from Dolphin Smalltalk 7"!

StsChangeNode subclass: #StsAbstractClassEditionChangeNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsAbstractClassEditionChangeNode guid: (GUID fromString: '{4668c4f6-134f-4428-a064-2d22761bd9ce}')!
StsAbstractClassEditionChangeNode comment: ''!
!StsAbstractClassEditionChangeNode categoriesForClass!Unclassified! !
!StsAbstractClassEditionChangeNode methodsFor!

browse
	(self anyEdition ifNil: [^nil]) realClass isNil ifFalse: [^self anyEdition realClass browse].
	self leftEdition 
		ifNotNil: [:edition | edition superClassRealClass ifNotNil: [:class | ^class browse]].
	self rightEdition 
		ifNotNil: [:edition | edition superClassRealClass ifNotNil: [:class | ^class browse]].
	^nil!

canDoBrowseReferences
	| anyEdition |
	^(anyEdition := self anyEdition) notNil and: [anyEdition realClass notNil]! !
!StsAbstractClassEditionChangeNode categoriesFor: #browse!public! !
!StsAbstractClassEditionChangeNode categoriesFor: #canDoBrowseReferences!public! !

