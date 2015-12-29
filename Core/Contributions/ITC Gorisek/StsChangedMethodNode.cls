"Filed out from Dolphin Smalltalk X6.2"!

StsChangeNode subclass: #StsChangedMethodNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangedMethodNode guid: (GUID fromString: '{848904C5-2842-11D4-B0CF-000000000000}')!
StsChangedMethodNode comment: ''!
!StsChangedMethodNode categoriesForClass!Unclassified! !
!StsChangedMethodNode methodsFor!

browse
	| class compiledMethod |
	(class := (self anyEdition ifNil: [^nil]) methodClass) isNil ifTrue: [^nil].
	(compiledMethod := class methodDictionary at: self anyEdition selector ifAbsent: []) notNil 
		ifTrue: [compiledMethod browse]
		ifFalse: [class browse]!

browseEditions
	(leftEdition ifNil: [rightEdition ifNil: [^nil]]) browseEdition!

canDoBrowseReferences
	^true!

canDoRemove
	^(leftEdition isNil and: [rightEdition notNil and: [rightEdition methodClass notNil]]) 
		or: [rightEdition isNil and: [leftEdition notNil and: [leftEdition methodClass notNil]]]!

elementDescription
	^super elementDescription ifNil: [self elementName]!

fileOutChangeForSmalltalkXOn: aStream 
	leftEdition isNil 
		ifFalse: 
			["Added or changed method."
			leftEdition basicExportAsSmalltalkXChangeSetOn: aStream packageName: self owningPackageName]
		ifTrue: 
			["Removed method."
			aStream 
				nextPutAll: '
' , rightEdition className , ' removeSelector: ' , rightEdition selector printString 
						, '!!

']!

fileOutChangeForSqueakOn: aStream 
	leftEdition isNil 
		ifFalse: 
			["Added or changed method."
			leftEdition basicExportAsSqueakFileOutOn: aStream packageName: nil]
		ifTrue: 
			["Removed method."
			aStream 
				nextPutAll: '
' , rightEdition className , ' removeSelector: ' , rightEdition selector printString 
						, '!!

']!

fileOutChangeForVastOn: aStream 
	leftEdition isNil 
		ifFalse: 
			["Added or changed method."
			aStream nextPutAll: '"--- add or change a method"

'.
			leftEdition basicExportAsVastDoItScriptOn: aStream packageName: self owningPackageName]
		ifTrue: 
			["Removed method."
			aStream
				nextPutAll: '"--- remove a method"

(Smalltalk includesKey: #';
				nextPutAll: rightEdition classNameInstanceSide;
				nextPutAll: ') ifTrue: [
';
				nextPutAll: rightEdition vastClassReferenceExpression , ' removeSelector: ' 
							, rightEdition selector printString , ' ifAbsent: []].
']!

fileOutChangeForVwUsing: xmlWriter 
	leftEdition isNil 
		ifFalse: 
			["Added or changed method."
			leftEdition basicExportAsVWChangeSetOn: xmlWriter
				parcelName: ((rightEdition isNil and: [self owningPackageName notEmpty]) 
						ifTrue: [self owningPackageName])]
		ifTrue: 
			["Removed method."
			xmlWriter tag: 'remove-selector'
				do: 
					[xmlWriter
						tag: 'class-id' value: (rightEdition classNameForVisualWorks: rightEdition className);
						tag: 'selector' value: rightEdition selector asString]]!

icon
	^CompiledMethod icon!

isCategoryChangeOnly
	^leftEdition notNil 
		and: [rightEdition notNil and: [leftEdition isSimilarIgnoringCategoriesTo: rightEdition]]!

isWhitespaceChangeOnly
	^leftEdition notNil 
		and: [rightEdition notNil and: [leftEdition isSimilarIgnoringWhitespaceChangesTo: rightEdition]]!

isWhitespaceOrCategoryChangeOnly
	^leftEdition notNil and: 
			[rightEdition notNil 
				and: [leftEdition isSimilarIgnoringWhitespaceAndCategoryChangesTo: rightEdition]]!

leftSource
	^leftEdition isNil 
		ifTrue: 
			[rightEdition isNil 
				ifTrue: ['']
				ifFalse: [(rightEdition selector printString , ' does not exist') asRichText]]
		ifFalse: [leftEdition source]!

loadLeft
	^leftEdition isNil 
		ifTrue: 
			[| method |
			(method := rightEdition methodClass methodDictionary at: rightEdition selector ifAbsent: []) isNil 
				ifFalse: 
					["ce je metoda v drugem package-u je ne sme brisat, ker ne gre za loose metodo"
					(Package manager packageOfMethod: method) isNil 
						ifTrue: [rightEdition methodClass removeSelector: rightEdition selector ifAbsent: []]].
			true]
		ifFalse: 
			[leftEdition load.
			leftEdition isLoaded]!

loadRight
	^rightEdition isNil 
		ifTrue: 
			[| method |
			(method := leftEdition methodClass methodDictionary at: leftEdition selector ifAbsent: []) isNil 
				ifFalse: 
					["ce je metoda v drugem package-u je ne sme brisat, ker ne gre za loose metodo"
					(Package manager packageOfMethod: method) isNil 
						ifTrue: [leftEdition methodClass removeSelector: leftEdition selector ifAbsent: []]].
			true]
		ifFalse: 
			[rightEdition load.
			rightEdition isLoaded]!

rightSource
	^rightEdition isNil 
		ifTrue: 
			[leftEdition isNil 
				ifTrue: ['']
				ifFalse: [(leftEdition selector printString , ' does not exist') asRichText]]
		ifFalse: [rightEdition source]! !
!StsChangedMethodNode categoriesFor: #browse!public! !
!StsChangedMethodNode categoriesFor: #browseEditions!public! !
!StsChangedMethodNode categoriesFor: #canDoBrowseReferences!public! !
!StsChangedMethodNode categoriesFor: #canDoRemove!public! !
!StsChangedMethodNode categoriesFor: #elementDescription!public! !
!StsChangedMethodNode categoriesFor: #fileOutChangeForSmalltalkXOn:!public! !
!StsChangedMethodNode categoriesFor: #fileOutChangeForSqueakOn:!public! !
!StsChangedMethodNode categoriesFor: #fileOutChangeForVastOn:!public! !
!StsChangedMethodNode categoriesFor: #fileOutChangeForVwUsing:!public! !
!StsChangedMethodNode categoriesFor: #icon!public! !
!StsChangedMethodNode categoriesFor: #isCategoryChangeOnly!public! !
!StsChangedMethodNode categoriesFor: #isWhitespaceChangeOnly!public! !
!StsChangedMethodNode categoriesFor: #isWhitespaceOrCategoryChangeOnly!public! !
!StsChangedMethodNode categoriesFor: #leftSource!public! !
!StsChangedMethodNode categoriesFor: #loadLeft!public! !
!StsChangedMethodNode categoriesFor: #loadRight!public! !
!StsChangedMethodNode categoriesFor: #rightSource!public! !

