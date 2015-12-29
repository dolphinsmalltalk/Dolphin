"Filed out from Dolphin Smalltalk X6.2"!

StsChangedPrerequisitesNode subclass: #StsChangedManualPrerequisitesNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangedManualPrerequisitesNode guid: (GUID fromString: '{9B55CEEB-F145-48FF-A61C-A0EB72035F54}')!
StsChangedManualPrerequisitesNode comment: ''!
!StsChangedManualPrerequisitesNode categoriesForClass!Unclassified! !
!StsChangedManualPrerequisitesNode methodsFor!

elementDescription
	^'manual package prerequisites'!

leftComment
	^self prerequisiteString: leftEdition manualPrerequisites!

rightComment
	^self prerequisiteString: rightEdition manualPrerequisites! !
!StsChangedManualPrerequisitesNode categoriesFor: #elementDescription!public! !
!StsChangedManualPrerequisitesNode categoriesFor: #leftComment!public! !
!StsChangedManualPrerequisitesNode categoriesFor: #rightComment!public! !

