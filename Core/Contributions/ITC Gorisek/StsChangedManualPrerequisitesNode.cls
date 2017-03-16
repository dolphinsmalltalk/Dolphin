"Filed out from Dolphin Smalltalk 7"!

StsChangedPrerequisitesNode subclass: #StsChangedManualPrerequisitesNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangedManualPrerequisitesNode guid: (GUID fromString: '{9b55ceeb-f145-48ff-a61c-a0eb72035f54}')!
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

