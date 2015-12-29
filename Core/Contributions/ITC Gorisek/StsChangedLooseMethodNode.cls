"Filed out from Dolphin Smalltalk X6.2"!

StsChangedMethodNode subclass: #StsChangedLooseMethodNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangedLooseMethodNode guid: (GUID fromString: '{58386C1C-2A4F-444A-AE44-1F6CB719EA06}')!
StsChangedLooseMethodNode comment: ''!
!StsChangedLooseMethodNode categoriesForClass!Unclassified! !
!StsChangedLooseMethodNode methodsFor!

fileOutChangeForSqueakOn: aStream 
	leftEdition isNil 
		ifFalse: 
			["Added or changed method."
			leftEdition basicExportAsSqueakFileOutOn: aStream packageName: self owningPackageName]
		ifTrue: 
			["Removed method."
			aStream 
				nextPutAll: '
' , rightEdition className , ' removeSelector: ' , rightEdition selector printString 
						, '!!

']!

loadLeft
	^leftEdition isNil 
		ifTrue: [self removeLooseMethodEdition: rightEdition]
		ifFalse: [self loadLooseMethodEdition: leftEdition]!

loadLooseMethodEdition: aMethodEdition 
	"Load aMethodEdition as a loose method in the owningPackage and answer <true> if successfull, else answer <false>."

	| newlyCompiledMethod methodClass classIsChanged packageIsChanged existingCompiledMethod classPackage |
	^(methodClass := aMethodEdition methodClass) notNil and: 
			[existingCompiledMethod := methodClass methodDictionary at: aMethodEdition selector ifAbsent: [].
			classIsChanged := methodClass instanceClass isChanged or: 
							[existingCompiledMethod notNil 
								and: [owningPackage notNil and: [existingCompiledMethod owningPackage ~~ owningPackage]]].
			packageIsChanged := (classPackage := Package manager packageOfClass: methodClass instanceClass) 
						isNil ifFalse: [classPackage isChanged].
			((newlyCompiledMethod := methodClass 
						compile: aMethodEdition source
						categories: aMethodEdition categories
						package: owningPackage) notNil 
				and: [owningPackage notNil]) 
					ifTrue: 
						[Package manager addMethod: newlyCompiledMethod to: owningPackage.
						classIsChanged = true ifFalse: [methodClass instanceClass isChanged: false].
						(classPackage notNil 
							and: [packageIsChanged ~= true and: [methodClass instanceClass isChanged = false]]) 
								ifTrue: [classPackage isChanged: false]].
			aMethodEdition isLoaded]!

loadRight
	^rightEdition isNil 
		ifTrue: [self removeLooseMethodEdition: leftEdition]
		ifFalse: [self loadLooseMethodEdition: rightEdition]!

removeLooseMethodEdition: aMethodEdition 
	| method |
	(method := aMethodEdition methodClass methodDictionary at: aMethodEdition selector ifAbsent: []) 
		isNil 
			ifFalse: 
				["If method is contained in other package it can't be removed."
				((Package manager packageOfMethod: method) == owningPackage and: [owningPackage notNil]) 
					ifTrue: [aMethodEdition methodClass removeSelector: aMethodEdition selector ifAbsent: []]].
	^true! !
!StsChangedLooseMethodNode categoriesFor: #fileOutChangeForSqueakOn:!public! !
!StsChangedLooseMethodNode categoriesFor: #loadLeft!public! !
!StsChangedLooseMethodNode categoriesFor: #loadLooseMethodEdition:!private! !
!StsChangedLooseMethodNode categoriesFor: #loadRight!public! !
!StsChangedLooseMethodNode categoriesFor: #removeLooseMethodEdition:!private! !

