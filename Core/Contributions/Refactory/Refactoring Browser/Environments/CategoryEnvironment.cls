"Filed out from Dolphin Smalltalk"!

BrowserEnvironmentWrapper subclass: #CategoryEnvironment
	instanceVariableNames: 'categories'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CategoryEnvironment guid: (GUID fromString: '{01ea18f1-d09f-4a63-b569-62a1d8d6c1cd}')!
CategoryEnvironment comment: 'CategoryEnvironment represents a collection of classes (and all the methods they own) that belong to at least one of a particular set of class categories. 

Instance Variables:
	categories	<Collection of: Symbol>	the category names to browse'!
!CategoryEnvironment categoriesForClass!Refactory-Environments! !
!CategoryEnvironment methodsFor!

categories
	^categories select: [:each | self includesCategory: each]!

categories: aCollection
	categories := aCollection asSet!

classNames
	^self categories inject: IdentitySet new
		into: 
			[:answer :each |
			answer
				addAll: (self classNamesFor: each);
				yourself]!

defaultLabel
	| stream |
	stream := String new writeStream.
	categories do: [:each | stream nextPutAll: each; nextPut: $ ].
	^stream contents!

definesClass: aClass
	^self includesClass: aClass!

includesCategory: aCategory
	^(categories includes: aCategory)
		and: [super includesCategory: aCategory]!

includesClass: aClass
	^(super includesClass: aClass) and: 
			[#rbFix.	"Support Dolphin's multi-category system."
			aClass instanceClass categories anySatisfy: [:each | categories includes: each name]]!

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
!CategoryEnvironment categoriesForMethods!
categories!accessing!public! !
categories:!initialize/release!public! !
classNames!accessing/classes!public! !
defaultLabel!constants!private! !
definesClass:!public!testing! !
includesCategory:!public!testing! !
includesClass:!public!testing! !
initialize!initialize/release!public! !
isEmpty!public!testing! !
postCopy!copying!public! !
storeOn:!printing!public! !
!

!CategoryEnvironment class methodsFor!

onEnvironment: anEnvironment categories: aCollection
	^(self onEnvironment: anEnvironment)
		categories: aCollection; yourself! !
!CategoryEnvironment class categoriesForMethods!
onEnvironment:categories:!instance creation!public! !
!

