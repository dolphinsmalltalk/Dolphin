"Filed out from Dolphin Smalltalk 7"!

StsAbstractClassEditionChangeNode subclass: #StsChangedClassDefinitionNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangedClassDefinitionNode guid: (GUID fromString: '{661ce4c6-289a-11d4-b0d0-000000000000}')!
StsChangedClassDefinitionNode comment: ''!
!StsChangedClassDefinitionNode categoriesForClass!Unclassified! !
!StsChangedClassDefinitionNode methodsFor!

elementDescription
	^self elementName , ' definition'!

fileOutChangeForSmalltalkXOn: aStream 
	leftEdition isNil 
		ifFalse: 
			["Export just class definition."
			leftEdition basicExportDefinitionAsSmalltalkXChangeSetOn: aStream
				packageName: self owningPackageName]!

fileOutChangeForSqueakOn: aStream 
	leftEdition isNil 
		ifFalse: 
			["Export just class definition."
			leftEdition basicExportDefinitionAsSqueakFileOutOn: aStream packageName: self owningPackageName]!

fileOutChangeForVastOn: aStream 
	aStream nextPutAll: '"--- changed class definition"

'.
	leftEdition basicExportDefinitionForVastOn: aStream.
	aStream nextPutAll: '.
'!

fileOutChangeForVwUsing: xmlWriter 
	leftEdition isNil 
		ifFalse: 
			["Export just class definition."
			leftEdition basicExportDefinitionAsVWChangeSetOn: xmlWriter parcelName: self owningPackageName]!

icon
	^Boolean icon!

leftSource
	^leftEdition isNil 
		ifTrue: 
			[rightEdition isNil 
				ifTrue: ['']
				ifFalse: [(rightEdition name asString , ' does not exist') asRichText]]
		ifFalse: [leftEdition definition]!

loadLeft
	^leftEdition loadDefinition!

loadRight
	^rightEdition loadDefinition!

rightSource
	^rightEdition isNil 
		ifTrue: 
			[leftEdition isNil ifTrue: [''] ifFalse: [(leftEdition name asString , ' does not exist') asRichText]]
		ifFalse: [rightEdition definition]! !
!StsChangedClassDefinitionNode categoriesFor: #elementDescription!public! !
!StsChangedClassDefinitionNode categoriesFor: #fileOutChangeForSmalltalkXOn:!public! !
!StsChangedClassDefinitionNode categoriesFor: #fileOutChangeForSqueakOn:!public! !
!StsChangedClassDefinitionNode categoriesFor: #fileOutChangeForVastOn:!public! !
!StsChangedClassDefinitionNode categoriesFor: #fileOutChangeForVwUsing:!public! !
!StsChangedClassDefinitionNode categoriesFor: #icon!public! !
!StsChangedClassDefinitionNode categoriesFor: #leftSource!public! !
!StsChangedClassDefinitionNode categoriesFor: #loadLeft!public! !
!StsChangedClassDefinitionNode categoriesFor: #loadRight!public! !
!StsChangedClassDefinitionNode categoriesFor: #rightSource!public! !

