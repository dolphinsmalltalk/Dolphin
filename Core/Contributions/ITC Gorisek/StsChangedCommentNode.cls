"Filed out from Dolphin Smalltalk 7"!

StsChangeNode subclass: #StsChangedCommentNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangedCommentNode guid: (GUID fromString: '{661ce4cb-289a-11d4-b0d0-000000000000}')!
StsChangedCommentNode comment: ''!
!StsChangedCommentNode categoriesForClass!Unclassified! !
!StsChangedCommentNode methodsFor!

elementDescription
	^self elementName , ' class comment'!

icon
	^Boolean icon!

isComment
	^true!

leftComment
	^leftEdition comment isNil ifTrue: [''] ifFalse: [leftEdition comment]!

rightComment
	^rightEdition comment isNil ifTrue: [''] ifFalse: [rightEdition comment]! !
!StsChangedCommentNode categoriesFor: #elementDescription!public! !
!StsChangedCommentNode categoriesFor: #icon!public! !
!StsChangedCommentNode categoriesFor: #isComment!public! !
!StsChangedCommentNode categoriesFor: #leftComment!public! !
!StsChangedCommentNode categoriesFor: #rightComment!public! !

