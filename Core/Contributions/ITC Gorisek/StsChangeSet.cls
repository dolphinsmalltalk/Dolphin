"Filed out from Dolphin Smalltalk 7"!

StsEdition subclass: #StsChangeSet
	instanceVariableNames: 'changeNodes comment browserTitle blessing'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangeSet guid: (GUID fromString: '{815e49d8-69da-4fe5-a085-bae6e7fe7564}')!
StsChangeSet comment: ''!
!StsChangeSet categoriesForClass!Unclassified! !
!StsChangeSet methodsFor!

blessing
	^blessing!

blessing: aSymbolOrNil 
	(blessing isNil or: [self possibleBlessingLevels includes: aSymbolOrNil]) 
		ifFalse: [self error: 'Invalid blessing level'].
	blessing := aSymbolOrNil!

browserTitle
	^browserTitle!

browserTitle: aString 
	browserTitle := (aString beginsWith: 'Changes Browser - ') 
				ifTrue: [aString copyFrom: 'Changes Browser - ' size + 1 to: aString size]
				ifFalse: [aString]!

changeNodes
	^changeNodes!

changeNodes: anObject
	changeNodes := anObject!

comment
	^comment!

comment: anObject
	comment := anObject!

resolveProxies
	super resolveProxies.
	(self changeNodes ifNil: [^nil]) do: [:each | each resolveProxies]! !
!StsChangeSet categoriesFor: #blessing!accessing!public! !
!StsChangeSet categoriesFor: #blessing:!accessing!public! !
!StsChangeSet categoriesFor: #browserTitle!accessing!public! !
!StsChangeSet categoriesFor: #browserTitle:!accessing!public! !
!StsChangeSet categoriesFor: #changeNodes!accessing!public! !
!StsChangeSet categoriesFor: #changeNodes:!accessing!public! !
!StsChangeSet categoriesFor: #comment!accessing!public! !
!StsChangeSet categoriesFor: #comment:!accessing!public! !
!StsChangeSet categoriesFor: #resolveProxies!OmniBase!public! !

