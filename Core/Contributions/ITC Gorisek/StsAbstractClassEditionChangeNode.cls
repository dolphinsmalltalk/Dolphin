"Filed out from Dolphin Smalltalk X6.2"!

StsChangeNode subclass: #StsAbstractClassEditionChangeNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsAbstractClassEditionChangeNode guid: (GUID fromString: '{4668C4F6-134F-4428-A064-2D22761BD9CE}')!
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

