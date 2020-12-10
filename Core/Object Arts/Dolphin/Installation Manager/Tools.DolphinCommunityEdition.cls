"Filed out from Dolphin Smalltalk 7"!

Tools.DolphinBaseProduct subclass: #'Tools.DolphinCommunityEdition'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.DolphinCommunityEdition guid: (Core.GUID fromString: '{97ac6bc9-3516-42c9-845b-a5ed3579f331}')!
Tools.DolphinCommunityEdition comment: ''!
!Tools.DolphinCommunityEdition categoriesForClass!System-Support! !
!Tools.DolphinCommunityEdition methodsFor!

defaultSystemFolderExtent
	^760 @ 355!

fullName
	"Answer the full product name associated with the receiver"

	^'Dolphin Smalltalk Community Edition'!

preShrink
	"Private - Perform any pre-shrinkage actions. "

	"In this case we want to remove any ImageStripper bytes
	because they contain references to Lagoon, which only belongs in DolphinProfessional"

	self packages do: [:each | each imageStripperBytes: nil]! !
!Tools.DolphinCommunityEdition categoriesFor: #defaultSystemFolderExtent!private! !
!Tools.DolphinCommunityEdition categoriesFor: #fullName!accessing!public! !
!Tools.DolphinCommunityEdition categoriesFor: #preShrink!private! !

!Tools.DolphinCommunityEdition class methodsFor!

productLevel
	"Private - Answer the product ID for the receiver"

	^1!

productName
	"Answer the product name"
	
	^'Community Edition'!

shortProductName
	"Answer the abbreviated product name"
	
	^'DCE'! !
!Tools.DolphinCommunityEdition class categoriesFor: #productLevel!constants!private! !
!Tools.DolphinCommunityEdition class categoriesFor: #productName!accessing!public! !
!Tools.DolphinCommunityEdition class categoriesFor: #shortProductName!accessing!public! !

