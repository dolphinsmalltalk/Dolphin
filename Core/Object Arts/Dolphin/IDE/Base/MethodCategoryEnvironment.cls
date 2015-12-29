"Filed out from Dolphin Smalltalk X6"!

BrowserEnvironmentWrapper subclass: #MethodCategoryEnvironment
	instanceVariableNames: 'categories'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodCategoryEnvironment guid: (GUID fromString: '{D9A3E87E-16B6-4A73-8469-E08822DCB6DD}')!
MethodCategoryEnvironment comment: 'MethodCategoryEnvironment is a Dolphin specific <BrowserEnvironment> that represents the contents of one or more Dolphin method categories. This can be very powerful when used in conjunction with Dolphin''s >VirtualMethodCategory>s, as the latter have an arbitrary filtering capability.

Instance Variables:
	categories		<collection> of <MethodCategory>

'!
!MethodCategoryEnvironment categoriesForClass!Refactory-Environments! !
!MethodCategoryEnvironment methodsFor!

categories: aCollection
	categories := aCollection!

categoryNames: aCollection 
	categories := aCollection collect: [:each | MethodCategory name: aCollection]!

classesAndSelectorsDo: aBlock 
	categories do: 
			[:each | 
			each behaviorsDo: 
					[:eachClass | 
					(super includesClass: eachClass) 
						ifTrue: 
							[(each methodsInBehavior: eachClass) do: 
									[:eachMethod | 
									(environment includesSelector: eachMethod selector in: eachMethod methodClass) 
										ifTrue: [aBlock value: eachMethod methodClass value: eachMethod selector]]]]]!

defaultLabel
	| stream |
	stream := String new writeStream.
	categories do: [:each | stream display: each] separatedBy: [stream nextPutAll: ', '].
	stream
		nextPutAll: ' methods in ';
		display: environment.
	^stream contents!

includesClass: aClass 
	^(super includesClass: aClass) 
		and: [categories anySatisfy: [:each | (each methodsInBehavior: aClass) notEmpty]]!

includesSelector: aSelector in: aClass 
	^(super includesSelector: aSelector in: aClass) and: 
			[| method |
			method := aClass compiledMethodAt: aSelector ifAbsent: [].
			method notNil and: [categories anySatisfy: [:each | each includesMethod: method]]]!

isEmpty
	^categories allSatisfy: [:each | each isEmpty]!

postCopy
	categories := categories copy.
	^super postCopy!

selectorsForClass: aClass do: aBlock 
	(super includesClass: aClass) ifFalse: [^self].
	categories do: 
			[:each | 
			(each methodsInBehavior: aClass) do: 
					[:eachMethod | 
					(environment includesSelector: eachMethod selector in: aClass) 
						ifTrue: [aBlock value: eachMethod selector]]]!

storeOn: aStream 
	aStream nextPut: $(.
	super storeOn: aStream.
	aStream
		space;
		display: #categoryNames:;
		space.
	(categories asArray collect: [:each | each name]) storeOn: aStream.
	aStream nextPut: $)! !
!MethodCategoryEnvironment categoriesFor: #categories:!accessing!private! !
!MethodCategoryEnvironment categoriesFor: #categoryNames:!accessing!private! !
!MethodCategoryEnvironment categoriesFor: #classesAndSelectorsDo:!enumerating!public! !
!MethodCategoryEnvironment categoriesFor: #defaultLabel!constants!private! !
!MethodCategoryEnvironment categoriesFor: #includesClass:!public!testing! !
!MethodCategoryEnvironment categoriesFor: #includesSelector:in:!public!testing! !
!MethodCategoryEnvironment categoriesFor: #isEmpty!public!testing! !
!MethodCategoryEnvironment categoriesFor: #postCopy!copying!public! !
!MethodCategoryEnvironment categoriesFor: #selectorsForClass:do:!enumerating!public! !
!MethodCategoryEnvironment categoriesFor: #storeOn:!printing!public! !

!MethodCategoryEnvironment class methodsFor!

onEnvironment: anEnvironment categories: aCollection
	^(self onEnvironment: anEnvironment)
		categories: aCollection;
		yourself!

referencesTo: aLiteral in: anEnvironment 
	| literalName label refs |
	literalName := (aLiteral isVariableBinding ifTrue: [aLiteral key] ifFalse: [aLiteral]) 
				displayString.
	label := 'References to: ' , literalName.
	refs := ReferencesCategory newNamed: label literal: aLiteral.
	^(self onEnvironment: anEnvironment categories: (Array with: refs))
		label: label;
		searchStrings: (Array with: literalName);
		yourself! !
!MethodCategoryEnvironment class categoriesFor: #onEnvironment:categories:!instance creation!public! !
!MethodCategoryEnvironment class categoriesFor: #referencesTo:in:!instance creation!public! !

