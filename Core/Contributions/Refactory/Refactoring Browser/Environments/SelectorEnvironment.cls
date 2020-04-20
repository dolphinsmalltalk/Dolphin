"Filed out from Dolphin Smalltalk 7"!

BrowserEnvironmentWrapper subclass: #SelectorEnvironment
	instanceVariableNames: 'classSelectors metaClassSelectors'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SelectorEnvironment guid: (GUID fromString: '{d6de9b1c-4652-474b-97cd-87838c6d2f62}')!
SelectorEnvironment comment: 'SelectorEnvironment represents a predetermined collection of methods to be browsed.

Instance Variables:
	classSelectors		<Dictionary key: Symbol value: (Collection of: Symbol)>	selectors for the class side
	metaClassSelectors	<Dictionary key: Symbol value: (Collection of: Symbol)>	selectors for the metaclass side
'!
!SelectorEnvironment categoriesForClass!Refactory-Environments! !
!SelectorEnvironment methodsFor!

addClass: aClass 
	aClass isMeta 
		ifTrue: 
			[metaClassSelectors at: aClass soleInstance name put: aClass selectors]
		ifFalse: [classSelectors at: aClass name put: aClass selectors]!

addClass: aClass selector: aSymbol 
	#rbFix.	"Extract classdict lookup "
	(self privateSelectorsForClassAdd: aClass) add: aSymbol!

addClass: aClass selectors: aCollection 
	#rbFix.	"Added"
	(self privateSelectorsForClassAdd: aClass) addAll: aCollection!

classes: classArray metaClasses: metaArray 
	"Used to recreate an environment from its storeString"

	classSelectors := IdentityDictionary new.
	metaClassSelectors := IdentityDictionary new.
	classArray 
		do: [:each | classSelectors at: each first put: each last asSet].
	metaArray 
		do: [:each | metaClassSelectors at: each first put: each last asSet]!

classesAndSelectorsDo: aBlock
	classSelectors keysAndValuesDo: 
			[:eachClassName :eachSelectors |
			eachClassName asQualifiedReference valueOrNil ifNotNil:  
					[:class |
					(environment includesClass: class)
						ifTrue: 
							[eachSelectors do: [:each | (class includesSelector: each) ifTrue: [aBlock value: class value: each]]]]].
	metaClassSelectors keysAndValuesDo: 
			[:eachClassName :eachSelectors |
			eachClassName asQualifiedReference valueOrNil ifNotNil:
					[:class |
					| meta |
					meta := class class.
					(environment includesClass: meta)
						ifTrue: 
							[eachSelectors do: [:each | (meta includesSelector: each) ifTrue: [aBlock value: meta value: each]]]]]!

classesDo: aBlock
	classSelectors keysDo: 
			[:each |
			each asQualifiedReference
				ifDefined: [:class | (environment includesClass: class) ifTrue: [aBlock value: class]]].
	metaClassSelectors keysDo: 
			[:each |
			each asQualifiedReference
				ifDefined: [:class | (environment includesClass: class class) ifTrue: [aBlock value: class class]]]!

classNames
	| names collectNames |
	names := IdentitySet new: classSelectors size + metaClassSelectors size.
	collectNames := [:each | names add: each].
	classSelectors keysDo: collectNames.
	metaClassSelectors keysDo: collectNames.
	^names!

classSelectors: classSelectorDictionary metaClassSelectors: metaClassSelectorDictionary 
	classSelectors := classSelectorDictionary.
	metaClassSelectors := metaClassSelectorDictionary!

defaultLabel
	^'some methods'!

includesCategory: aCategory 
	^(super includesCategory: aCategory) and: 
			[(self classNamesFor: aCategory) anySatisfy: 
					[:className | 
					(classSelectors includesKey: className) 
						or: [metaClassSelectors includesKey: className]]]!

includesClass: aClass
	^(aClass isMeta
		ifTrue: [metaClassSelectors lookup: aClass soleInstance name]
		ifFalse: [classSelectors lookup: aClass name]) notNil
		and: [super includesClass: aClass]!

includesProtocol: aProtocol in: aClass 
	^(super includesProtocol: aProtocol in: aClass)
		and: [(environment selectorsFor: aProtocol in: aClass)
				anySatisfy: [:aSelector | self privateIncludesSelector: aSelector inClass: aClass]]!

includesSelector: aSelector in: aClass 
	^(environment includesSelector: aSelector in: aClass)
		and: [self privateIncludesSelector: aSelector inClass: aClass]!

initialize
	super initialize.
	classSelectors := IdentityDictionary new.
	metaClassSelectors := IdentityDictionary new!

isEmpty
	^classSelectors isEmpty and: [metaClassSelectors isEmpty]!

isSelectorEnvironment
	^true!

numberSelectors
	"This doesn't compute the correct result when a method that is included in our method list is not in the
	environment we are wrapping. It is implemented this way for efficiency."

	^(classSelectors inject: 0 into: [:sum :each | sum + each size]) 
		+ (metaClassSelectors inject: 0 into: [:sum :each | sum + each size])!

on: aDictionary 
	aDictionary keysAndValuesDo: 
			[:class :selectors | 
			class isMeta 
				ifTrue: [metaClassSelectors at: class soleInstance name put: selectors]
				ifFalse: [classSelectors at: class name put: selectors]]!

postCopy
	classSelectors := classSelectors collect: [:each | each copy].
	metaClassSelectors := metaClassSelectors collect: [:each | each copy].
	^super postCopy!

privateIncludesSelector: aSelector inClass: aClass 
	^(self privateSelectorsForClass: aClass) includes: aSelector!

privateSelectorsForClass: aClass
	^(aClass isMeta
		ifTrue: [metaClassSelectors lookup: aClass soleInstance name]
		ifFalse: [classSelectors lookup: aClass name]) ?? #()!

privateSelectorsForClassAdd: aClass 
	^aClass isMeta ifTrue: [metaClassSelectors at: aClass soleInstance name ifAbsentPut: [IdentitySet new: 8]] ifFalse: [classSelectors at: aClass name ifAbsentPut: [IdentitySet new: 8]]!

removeClass: aClass 
	aClass isMeta 
		ifTrue: [metaClassSelectors removeKey: aClass soleInstance name ifAbsent: []]
		ifFalse: [classSelectors removeKey: aClass name ifAbsent: []]!

removeClass: aClass selector: aSelector 
	(aClass isMeta 
		ifTrue: [metaClassSelectors at: aClass soleInstance name ifAbsent: [^self]]
		ifFalse: [classSelectors at: aClass name ifAbsent: [^self]]) 
			remove: aSelector
			ifAbsent: []!

selectorsForClass: aClass do: aBlock 
	^(self privateSelectorsForClass: aClass) 
		do: [:each | (aClass includesSelector: each) ifTrue: [aBlock value: each]]!

storeOn: aStream 
	| classBlock |
	aStream
		nextPutAll: '((';
		nextPutAll: self class name;
		nextPutAll: ' onEnvironment: '.
	environment storeOn: aStream.
	aStream
		nextPut: $);
		nextPutAll: ' classes: #('.
	classBlock := 
			[:key :value | 
			aStream
				nextPutAll: '#(';
				nextPutAll: key;
				nextPutAll: ' #('.
			value do: 
					[:each | 
					aStream
						nextPutAll: each;
						nextPut: $ ].
			aStream
				nextPutAll: '))';
				cr].
	classSelectors keysAndValuesDo: classBlock.
	aStream nextPutAll: ') metaClasses: #('.
	metaClassSelectors keysAndValuesDo: classBlock.
	aStream nextPutAll: '))'! !
!SelectorEnvironment categoriesFor: #addClass:!adding!public! !
!SelectorEnvironment categoriesFor: #addClass:selector:!adding!public! !
!SelectorEnvironment categoriesFor: #addClass:selectors:!adding!public! !
!SelectorEnvironment categoriesFor: #classes:metaClasses:!initialize/release!public! !
!SelectorEnvironment categoriesFor: #classesAndSelectorsDo:!accessing!public! !
!SelectorEnvironment categoriesFor: #classesDo:!accessing/classes!public! !
!SelectorEnvironment categoriesFor: #classNames!accessing/classes!public! !
!SelectorEnvironment categoriesFor: #classSelectors:metaClassSelectors:!initialize/release!public! !
!SelectorEnvironment categoriesFor: #defaultLabel!constants!private! !
!SelectorEnvironment categoriesFor: #includesCategory:!public!testing! !
!SelectorEnvironment categoriesFor: #includesClass:!public!testing! !
!SelectorEnvironment categoriesFor: #includesProtocol:in:!public!testing! !
!SelectorEnvironment categoriesFor: #includesSelector:in:!public!testing! !
!SelectorEnvironment categoriesFor: #initialize!initialize/release!public! !
!SelectorEnvironment categoriesFor: #isEmpty!public!testing! !
!SelectorEnvironment categoriesFor: #isSelectorEnvironment!public!testing! !
!SelectorEnvironment categoriesFor: #numberSelectors!accessing!public! !
!SelectorEnvironment categoriesFor: #on:!initialize/release!public! !
!SelectorEnvironment categoriesFor: #postCopy!copying!public! !
!SelectorEnvironment categoriesFor: #privateIncludesSelector:inClass:!private!testing! !
!SelectorEnvironment categoriesFor: #privateSelectorsForClass:!accessing!private! !
!SelectorEnvironment categoriesFor: #privateSelectorsForClassAdd:!adding!private! !
!SelectorEnvironment categoriesFor: #removeClass:!public!removing! !
!SelectorEnvironment categoriesFor: #removeClass:selector:!public!removing! !
!SelectorEnvironment categoriesFor: #selectorsForClass:do:!accessing!public! !
!SelectorEnvironment categoriesFor: #storeOn:!printing!public! !

!SelectorEnvironment class methodsFor!

implementorsMatching: aString in: anEnvironment 
	| classDict metaDict |
	classDict := IdentityDictionary new.
	metaDict := IdentityDictionary new.
	anEnvironment classesDo: 
			[:class | 
			| selectors |
			selectors := Set new.
			anEnvironment selectorsForClass: class
				do: [:each | (aString match: each) ifTrue: [selectors add: each]].
			selectors notEmpty 
				ifTrue: 
					[class isMeta 
						ifTrue: [metaDict at: class soleInstance name put: selectors]
						ifFalse: [classDict at: class name put: selectors]]].
	^(self onEnvironment: anEnvironment)
		classSelectors: classDict metaClassSelectors: metaDict;
		label: ('Definitions matching <1p> in <2p>' expandMacrosWith: aString with: anEnvironment);
		yourself!

implementorsOf: aSelector in: anEnvironment 
	| classDict metaDict selectors |
	classDict := IdentityDictionary new.
	metaDict := IdentityDictionary new.
	selectors := Array with: aSelector.
	anEnvironment classesDo: 
			[:class | 
			((class includesSelector: aSelector) 
				and: [anEnvironment includesSelector: aSelector in: class]) 
					ifTrue: 
						[class isMeta 
							ifTrue: [metaDict at: class soleInstance name put: selectors]
							ifFalse: [classDict at: class name put: selectors]]].
	^(self onEnvironment: anEnvironment)
		classSelectors: classDict metaClassSelectors: metaDict;
		label: ('Definitions of <1p> in <2p>' expandMacrosWith:  aSelector with: anEnvironment);
		yourself!

matches: aString in: anEnvironment 
	| newEnvironment |
	newEnvironment := (self onEnvironment: anEnvironment)
				label: 'Matching: ' , aString;
				searchStrings: (Array with: aString);
				yourself.
	anEnvironment classesAndSelectorsDo: 
			[:each :sel | 
			| method |
			method := each compiledMethodAt: sel.
			method allLiterals do: 
					[:lit | 
					lit isString 
						ifTrue: 
							[(aString match: lit) ifTrue: [newEnvironment addClass: each selector: sel]]]].
	^newEnvironment!

onMethods: selectorCollection forClass: aClass in: anEnvironment 
	| env |
	env := self onEnvironment: anEnvironment.
	selectorCollection do: [:each | env addClass: aClass selector: each].
	^env!

onMethods: methodCollection in: anEnvironment 
	^(self onEnvironment: anEnvironment)
		addMethods: methodCollection;
		yourself!

referencesTo: aLiteral in: aBrowserEnvironment 
	| classDict label |
	#rbFix.	"Change the label"
	label := 'References to <1p> in <2d>' expandMacrosWith: aLiteral with: aBrowserEnvironment.
	classDict := LookupTable new.
	aBrowserEnvironment classesDo: 
			[:class | 
			| selectors |
			selectors := (class whichSelectorsReferTo: aLiteral) 
						select: [:aSelector | aBrowserEnvironment includesSelector: aSelector in: class].
			selectors notEmpty ifTrue: [classDict at: class put: selectors]].
	^(self onEnvironment: aBrowserEnvironment)
		on: classDict;
		label: label;
		searchStrings: (Array with: aLiteral printString);
		yourself! !
!SelectorEnvironment class categoriesFor: #implementorsMatching:in:!instance creation!public! !
!SelectorEnvironment class categoriesFor: #implementorsOf:in:!instance creation!public! !
!SelectorEnvironment class categoriesFor: #matches:in:!instance creation!public! !
!SelectorEnvironment class categoriesFor: #onMethods:forClass:in:!instance creation!public! !
!SelectorEnvironment class categoriesFor: #onMethods:in:!instance creation!public! !
!SelectorEnvironment class categoriesFor: #referencesTo:in:!instance creation!public! !

