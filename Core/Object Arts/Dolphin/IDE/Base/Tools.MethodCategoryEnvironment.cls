"Filed out from Dolphin Smalltalk"!

Refactory.Browser.BrowserEnvironmentWrapper
	subclass: #'Tools.MethodCategoryEnvironment'
	instanceVariableNames: 'categories'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.MethodCategoryEnvironment guid: (Core.GUID fromString: '{d9a3e87e-16b6-4a73-8469-e08822dcb6dd}')!
Tools.MethodCategoryEnvironment comment: '`MethodCategoryEnvironment` is a Dolphin specific `BrowserEnvironment` that represents the contents of one or more Dolphin method categories. This can be very powerful when used in conjunction with Dolphin''s `Tools.VirtualMethodCategory`s, as the latter have an arbitrary filtering capability.

Instance Variables:
	categories		`<collection>` of `Kernel.MethodCategory`

'!
!Tools.MethodCategoryEnvironment categoriesForClass!Refactory-Environments! !
!Tools.MethodCategoryEnvironment methodsFor!

categories: aCollection
	categories := aCollection asSortedArray.
	self label: (categories size = 1
				ifTrue: [environment subEnvironmentLabel: #methodCategory for: categories first]
				ifFalse: [environment subEnvironmentLabel: #methodCategories for: categories])!

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
			[(aClass compiledMethodAt: aSelector ifAbsent: nil)
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
!Tools.MethodCategoryEnvironment categoriesForMethods!
categories:!accessing!private! !
categoryNames:!accessing!private! !
classesAndSelectorsDo:!enumerating!public! !
defaultLabel!constants!private! !
includesClass:!public!testing! !
includesSelector:in:!public!testing! !
isEmpty!public!testing! !
postCopy!copying!public! !
selectorsForClass:do:!enumerating!public! !
storeOn:!printing!public! !
!

!Tools.MethodCategoryEnvironment class methodsFor!

onEnvironment: anEnvironment categories: aCollection
	^(self onEnvironment: anEnvironment)
		categoryNames: aCollection;
		yourself!

referencesTo: aLiteral in: anEnvironment
	| literalName label refs |
	literalName := (aLiteral isVariableBinding ifTrue: [aLiteral key] ifFalse: [aLiteral])
				displayString: Locale smalltalk.
	label := 'References to: ' , literalName.
	refs := ReferencesCategory newNamed: label literal: aLiteral.
	^(self onEnvironment: anEnvironment categories: {refs})
		label: label;
		searchStrings: {literalName};
		yourself! !
!Tools.MethodCategoryEnvironment class categoriesForMethods!
onEnvironment:categories:!instance creation!public! !
referencesTo:in:!instance creation!public! !
!

