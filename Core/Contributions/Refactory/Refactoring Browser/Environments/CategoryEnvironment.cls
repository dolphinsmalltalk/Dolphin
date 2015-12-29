"Filed out from Dolphin Smalltalk XP"!

BrowserEnvironmentWrapper subclass: #CategoryEnvironment
	instanceVariableNames: 'categories'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CategoryEnvironment guid: (GUID fromString: '{01EA18F1-D09F-4A63-B569-62A1D8D6C1CD}')!
CategoryEnvironment comment: 'CategoryEnvironment represents a collection of classes (and all the methods they own) that belong to at least one of a particular set of class categories. 

Instance Variables:
	categories	<Collection of: Symbol>	the category names to browse'!
!CategoryEnvironment categoriesForClass!Refactory-Environments! !
!CategoryEnvironment methodsFor!

categories
	^categories select: [:each | self includesCategory: each]!

categories: aCollection
	categories := aCollection!

classNames
	^self categories inject: OrderedCollection new into: [:col :each | col addAll: (self classNamesFor: each); yourself]!

defaultLabel
	| stream |
	stream := String new writeStream.
	categories do: [:each | stream nextPutAll: each; nextPut: $ ].
	^stream contents!

includesCategory: aCategory
	^(categories includes: aCategory)
		and: [super includesCategory: aCategory]!

includesClass: aClass 
	^(super includesClass: aClass) and: 
			[| nonMetaClass |
			nonMetaClass := aClass isMeta 
						ifTrue: [aClass soleInstance]
						ifFalse: [aClass].
			categories 
				includes: (environment whichCategoryIncludes: nonMetaClass name)]!

initialize
	super initialize.
	categories := Set new!

isEmpty
	^categories isEmpty!

postCopy
	categories := categories copy.
	^super postCopy!

storeOn: aStream
	aStream nextPut: $(.
	super storeOn: aStream.
	aStream nextPutAll: ' categories: '.
	categories asArray storeOn: aStream.
	aStream nextPut: $)! !
!CategoryEnvironment categoriesFor: #categories!accessing!public! !
!CategoryEnvironment categoriesFor: #categories:!initialize/release!public! !
!CategoryEnvironment categoriesFor: #classNames!accessing/classes!public! !
!CategoryEnvironment categoriesFor: #defaultLabel!constants!private! !
!CategoryEnvironment categoriesFor: #includesCategory:!public!testing! !
!CategoryEnvironment categoriesFor: #includesClass:!public!testing! !
!CategoryEnvironment categoriesFor: #initialize!initialize/release!public! !
!CategoryEnvironment categoriesFor: #isEmpty!public!testing! !
!CategoryEnvironment categoriesFor: #postCopy!copying!public! !
!CategoryEnvironment categoriesFor: #storeOn:!printing!public! !

!CategoryEnvironment class methodsFor!

onEnvironment: anEnvironment categories: aCollection
	^(self onEnvironment: anEnvironment)
		categories: aCollection; yourself! !
!CategoryEnvironment class categoriesFor: #onEnvironment:categories:!instance creation!public! !

