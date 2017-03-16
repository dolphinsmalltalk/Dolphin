"Filed out from Dolphin Smalltalk 7"!

StsChangedCommentNode subclass: #StsChangedClassCommentNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangedClassCommentNode guid: (GUID fromString: '{cb3d11af-b200-4882-b6da-d148e8365379}')!
StsChangedClassCommentNode comment: ''!
!StsChangedClassCommentNode categoriesForClass!Unclassified! !
!StsChangedClassCommentNode methodsFor!

browse
	| class |
	(class := (self anyEdition ifNil: [^nil]) realClass) isNil ifTrue: [^nil].
	class browse!

browseEditions
	(leftEdition ifNil: [rightEdition ifNil: [^nil]]) browseEdition!

fileOutChangeForVastOn: aStream 
	leftEdition isNil 
		ifFalse: 
			["Added or changed class comment."
			aStream
				nextPutAll: '"--- changed class comment"

';
				nextPutAll: leftEdition className;
				nextPutAll: ' comment: ';
				nextPutAll: leftEdition comment printString;
				nextPutAll: '.
']!

loadLeft
	^(leftEdition isNil or: [leftEdition realClass isNil]) 
		ifFalse: 
			[leftEdition realClass comment: leftEdition comment.
			true]!

loadRight
	^(rightEdition isNil or: [rightEdition realClass isNil]) 
		ifFalse: 
			[rightEdition realClass comment: rightEdition comment.
			true]! !
!StsChangedClassCommentNode categoriesFor: #browse!public! !
!StsChangedClassCommentNode categoriesFor: #browseEditions!public! !
!StsChangedClassCommentNode categoriesFor: #fileOutChangeForVastOn:!public! !
!StsChangedClassCommentNode categoriesFor: #loadLeft!public! !
!StsChangedClassCommentNode categoriesFor: #loadRight!public! !

