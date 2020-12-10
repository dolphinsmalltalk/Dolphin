"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.BrowserEnvironmentWrapper subclass: #'Refactory.Browser.MethodCategoryEnvironment'
	instanceVariableNames: 'categories'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.MethodCategoryEnvironment guid: (Core.GUID fromString: '{d9a3e87e-16b6-4a73-8469-e08822dcb6dd}')!
Refactory.Browser.MethodCategoryEnvironment comment: 'MethodCategoryEnvironment is a Dolphin specific <BrowserEnvironment> that represents the contents of one or more Dolphin method categories. This can be very powerful when used in conjunction with Dolphin''s >VirtualMethodCategory>s, as the latter have an arbitrary filtering capability.

Instance Variables:
	categories		<collection> of <MethodCategory>

'!
!Refactory.Browser.MethodCategoryEnvironment categoriesForClass!Refactory-Environments! !
!Refactory.Browser.MethodCategoryEnvironment methodsFor!

categories: aCollection
	categories := aCollection asArray!

categoryNames: aCollection
	self categories: (aCollection collect: [:each | each asMethodCategory])!

classesAndSelectorsDo: aBlock
	self allClassesDo: 
			[:eachClass |
			(environment includesClass: eachClass)
				ifTrue: 
					["Use open-coded loops to reduce block instantiations, which is especially beneficial for the innermost loop that may be evaluated 1000's of times. This is only of real benefit because we know the collections enumerated over are Arrays."
					1 to: categories size
						do: 
							[:i |
							| selectors |
							selectors := (categories at: i) selectorsInBehavior: eachClass.
							1 to: selectors size
								do: 
									[:j |
									| selector |
									(environment includesSelector: (selector := selectors at: j) in: eachClass)
										ifTrue: [aBlock value: eachClass value: selector]]]]]!

defaultLabel
	| stream |
	stream := String new writeStream.
	categories do: [:each | stream display: each] separatedBy: [stream nextPutAll: ', '].
	stream
		nextPutAll: ' methods in ';
		display: environment.
	^stream contents!

includesClass: aClass
	(super includesClass: aClass)
		ifTrue: 
			[1 to: categories size do: [:i | ((categories at: i) includesBehavior: aClass) ifTrue: [^true]]].
	^false!

includesSelector: aSelector in: aClass
	(super includesSelector: aSelector in: aClass)
		ifTrue: 
			[(aClass compiledMethodAt: aSelector ifAbsent: [])
				ifNotNil: 
					[:method |
					1 to: categories size do: [:i | ((categories at: i) includesMethod: method) ifTrue: [^true]]]].
	^false!

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
!Refactory.Browser.MethodCategoryEnvironment categoriesFor: #categories:!accessing!private! !
!Refactory.Browser.MethodCategoryEnvironment categoriesFor: #categoryNames:!accessing!private! !
!Refactory.Browser.MethodCategoryEnvironment categoriesFor: #classesAndSelectorsDo:!enumerating!public! !
!Refactory.Browser.MethodCategoryEnvironment categoriesFor: #defaultLabel!constants!private! !
!Refactory.Browser.MethodCategoryEnvironment categoriesFor: #includesClass:!public!testing! !
!Refactory.Browser.MethodCategoryEnvironment categoriesFor: #includesSelector:in:!public!testing! !
!Refactory.Browser.MethodCategoryEnvironment categoriesFor: #isEmpty!public!testing! !
!Refactory.Browser.MethodCategoryEnvironment categoriesFor: #postCopy!copying!public! !
!Refactory.Browser.MethodCategoryEnvironment categoriesFor: #selectorsForClass:do:!enumerating!public! !
!Refactory.Browser.MethodCategoryEnvironment categoriesFor: #storeOn:!printing!public! !

!Refactory.Browser.MethodCategoryEnvironment class methodsFor!

onEnvironment: anEnvironment categories: aCollection
	^(self onEnvironment: anEnvironment)
		categoryNames: aCollection;
		yourself!

referencesTo: aLiteral in: anEnvironment
	| literalName label refs |
	literalName := (aLiteral isVariableBinding ifTrue: [aLiteral key] ifFalse: [aLiteral])
				displayString: Locale smalltalk.
	label := 'References to: ' , literalName.
	refs := Tools.ReferencesCategory newNamed: label literal: aLiteral.
	^(self onEnvironment: anEnvironment categories: {refs})
		label: label;
		searchStrings: {literalName};
		yourself! !
!Refactory.Browser.MethodCategoryEnvironment class categoriesFor: #onEnvironment:categories:!instance creation!public! !
!Refactory.Browser.MethodCategoryEnvironment class categoriesFor: #referencesTo:in:!instance creation!public! !

