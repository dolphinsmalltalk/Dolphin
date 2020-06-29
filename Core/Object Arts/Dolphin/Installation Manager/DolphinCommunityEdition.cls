"Filed out from Dolphin Smalltalk 7"!

DolphinBaseProduct subclass: #DolphinCommunityEdition
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DolphinCommunityEdition guid: (GUID fromString: '{97ac6bc9-3516-42c9-845b-a5ed3579f331}')!
DolphinCommunityEdition comment: ''!
!DolphinCommunityEdition categoriesForClass!System-Support! !
!DolphinCommunityEdition methodsFor!

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
!DolphinCommunityEdition categoriesFor: #defaultSystemFolderExtent!private! !
!DolphinCommunityEdition categoriesFor: #fullName!accessing!public! !
!DolphinCommunityEdition categoriesFor: #preShrink!private! !

!DolphinCommunityEdition class methodsFor!

productLevel
	"Private - Answer the product ID for the receiver"

	^1!

productName
	"Answer the product name"
	
	^'Community Edition'!

shortProductName
	"Answer the abbreviated product name"
	
	^'DCE'! !
!DolphinCommunityEdition class categoriesFor: #productLevel!constants!private! !
!DolphinCommunityEdition class categoriesFor: #productName!accessing!public! !
!DolphinCommunityEdition class categoriesFor: #shortProductName!accessing!public! !

