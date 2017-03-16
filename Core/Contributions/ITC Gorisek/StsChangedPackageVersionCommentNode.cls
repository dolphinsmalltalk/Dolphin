"Filed out from Dolphin Smalltalk 7"!

StsChangedPackageCommentNode subclass: #StsChangedPackageVersionCommentNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangedPackageVersionCommentNode guid: (GUID fromString: '{b0117150-a355-4fc4-b6a7-86bfe33a49f5}')!
StsChangedPackageVersionCommentNode comment: ''!
!StsChangedPackageVersionCommentNode categoriesForClass!Unclassified! !
!StsChangedPackageVersionCommentNode methodsFor!

elementDescription
	^'package version comment'!

leftComment
	^leftEdition versionComment isNil ifTrue: [''] ifFalse: [leftEdition versionComment]!

rightComment
	^rightEdition versionComment isNil ifTrue: [''] ifFalse: [rightEdition versionComment]! !
!StsChangedPackageVersionCommentNode categoriesFor: #elementDescription!public! !
!StsChangedPackageVersionCommentNode categoriesFor: #leftComment!public! !
!StsChangedPackageVersionCommentNode categoriesFor: #rightComment!public! !

