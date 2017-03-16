"Filed out from Dolphin Smalltalk 7"!

StsAbstractClassEditionChangeNode subclass: #StsChangedClassNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsChangedClassNode guid: (GUID fromString: '{661ce4c7-289a-11d4-b0d0-000000000000}')!
StsChangedClassNode comment: ''!
!StsChangedClassNode categoriesForClass!Unclassified! !
!StsChangedClassNode methodsFor!

browseEditions
	(leftEdition ifNil: [rightEdition ifNil: [^nil]]) browseEdition!

canDoRemove
	^(leftEdition notNil and: [leftEdition realClass notNil]) 
		or: [rightEdition notNil and: [rightEdition realClass notNil]]!

elementDescription
	^super elementDescription ifNil: [self elementName , ' class']!

fileOutChangeForSqueakOn: aStream 
	leftEdition isNil 
		ifFalse: 
			["Class is added."
			leftEdition basicExportAsSqueakFileOutOn: aStream packageName: self owningPackageName]
		ifTrue: 
			["Class is removed."
			aStream nextPutAll: 'Smalltalk removeClassNamed: #' , rightEdition className , '!!
']!

fileOutChangeForVastOn: aStream 
	leftEdition isNil 
		ifFalse: 
			["Class is added."
			aStream nextPutAll: '"--- add a class"
'.
			leftEdition basicExportAsVastDoItScriptOn: aStream packageName: self owningPackageName]
		ifTrue: 
			["Class is removed."
			aStream
				nextPutAll: '"--- remove a class"

(Smalltalk includesKey: #';
				nextPutAll: rightEdition className;
				nextPutAll: ') ifTrue: [(controllers at: ';
				nextPutAll: self owningPackageName printString;
				nextPutAll: ') deleteClasses: (Array with: (Smalltalk at: #';
				nextPutAll: rightEdition className;
				nextPutAll: '))].
']!

fileOutChangeForVwUsing: xmlWriter 
	leftEdition isNil 
		ifFalse: 
			["Class is added."
			leftEdition basicExportAsVWChangeSetOn: xmlWriter parcelName: self owningPackageName]
		ifTrue: 
			["Class is removed. TODO."
			self halt]!

icon
	^Class icon!

leftComment
	^(leftEdition isNil or: [leftEdition comment isNil]) ifTrue: [''] ifFalse: [leftEdition comment]!

leftSource
	^leftEdition isNil 
		ifTrue: 
			[rightEdition isNil 
				ifTrue: ['']
				ifFalse: [(rightEdition name asString , ' does not exist') asRichText]]
		ifFalse: [leftEdition definition]!

loadLeft
	^leftEdition isNil 
		ifFalse: [leftEdition loadIn: self owningPackageObject]
		ifTrue: 
			[rightEdition realClass isNil 
				ifFalse: 
					["remove class from package"
					rightEdition realClass owningPackage == self owningPackageObject 
						ifTrue: 
							[rightEdition 
								logWarning: 'Class ' , rightEdition realClass printString , ' removed from package ' 
										, self owningPackageObject name , ' and is now uncommitted (without a package).'.
							Package manager addClass: rightEdition realClass to: nil]].
			true]!

loadRight
	^rightEdition isNil 
		ifFalse: [rightEdition loadIn: self owningPackageObject]
		ifTrue: 
			[leftEdition realClass isNil 
				ifFalse: 
					["remove class from package"
					leftEdition realClass owningPackage == self owningPackageObject 
						ifTrue: 
							[leftEdition 
								logWarning: 'Class ' , leftEdition realClass printString , ' removed from package ' 
										, self owningPackageObject name , ' and is now uncommitted (without a package).'.
							Package manager addClass: leftEdition realClass to: nil]].
			true]!

rightComment
	^(rightEdition isNil or: [rightEdition comment isNil]) ifTrue: [''] ifFalse: [rightEdition comment]!

rightSource
	^rightEdition isNil 
		ifTrue: 
			[leftEdition isNil ifTrue: [''] ifFalse: [(leftEdition name asString , ' does not exist') asRichText]]
		ifFalse: [rightEdition definition]! !
!StsChangedClassNode categoriesFor: #browseEditions!public! !
!StsChangedClassNode categoriesFor: #canDoRemove!public! !
!StsChangedClassNode categoriesFor: #elementDescription!public! !
!StsChangedClassNode categoriesFor: #fileOutChangeForSqueakOn:!public! !
!StsChangedClassNode categoriesFor: #fileOutChangeForVastOn:!public! !
!StsChangedClassNode categoriesFor: #fileOutChangeForVwUsing:!public! !
!StsChangedClassNode categoriesFor: #icon!public! !
!StsChangedClassNode categoriesFor: #leftComment!public! !
!StsChangedClassNode categoriesFor: #leftSource!public! !
!StsChangedClassNode categoriesFor: #loadLeft!public! !
!StsChangedClassNode categoriesFor: #loadRight!public! !
!StsChangedClassNode categoriesFor: #rightComment!public! !
!StsChangedClassNode categoriesFor: #rightSource!public! !

