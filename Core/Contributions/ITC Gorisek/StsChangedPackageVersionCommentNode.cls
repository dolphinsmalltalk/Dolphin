"Filed out from Dolphin Smalltalk X6.2"!

StsChangedPackageCommentNode subclass: #StsChangedPackageVersionCommentNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangedPackageVersionCommentNode guid: (GUID fromString: '{B0117150-A355-4FC4-B6A7-86BFE33A49F5}')!
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

