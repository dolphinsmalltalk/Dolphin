"Filed out from Dolphin Smalltalk"!

Tools.DolphinBaseProduct
	subclass: #'Tools.DolphinCommunityEdition'
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

!Tools.DolphinCommunityEdition categoriesForMethods!
defaultSystemFolderExtent!private! !
fullName!accessing!public! !
preShrink!private! !
!

!Tools.DolphinCommunityEdition class methodsFor!

productName
	"Answer the product name"
	
	^'Community Edition'!

shortProductName
	"Answer the abbreviated product name"
	
	^'DCE'! !

!Tools.DolphinCommunityEdition class categoriesForMethods!
productName!accessing!public! !
shortProductName!accessing!public! !
!

