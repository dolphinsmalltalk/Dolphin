"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.BrowserEnvironmentWrapper subclass: #'Refactory.Browser.SelectorEnvironment'
	instanceVariableNames: 'classSelectors metaClassSelectors'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.SelectorEnvironment guid: (Core.GUID fromString: '{d6de9b1c-4652-474b-97cd-87838c6d2f62}')!
Refactory.Browser.SelectorEnvironment comment: 'SelectorEnvironment represents a predetermined collection of methods to be browsed.

Instance Variables:
	classSelectors		<Dictionary key: Symbol value: (Collection of: Symbol)>	selectors for the class side
	metaClassSelectors	<Dictionary key: Symbol value: (Collection of: Symbol)>	selectors for the metaclass side
'!
!Refactory.Browser.SelectorEnvironment categoriesForClass!Refactory-Environments! !
!Refactory.Browser.SelectorEnvironment methodsFor!

addClass: aClass
	aClass isMeta
		ifTrue: [metaClassSelectors at: aClass soleInstance fullName put: aClass selectors]
		ifFalse: [classSelectors at: aClass fullName put: aClass selectors]!

addClass: aClass selector: aSymbol 
	#rbFix.	"Extract classdict lookup "
	(self privateSelectorsForClassAdd: aClass) add: aSymbol!

addClass: aClass selectors: aCollection 
	#rbFix.	"Added"
	(self privateSelectorsForClassAdd: aClass) addAll: aCollection!

classes: classArray metaClasses: metaArray
	"Used to recreate an environment from its storeString"

	classSelectors := LookupTable new.
	metaClassSelectors := LookupTable new.
	classArray do: [:each | classSelectors at: each first put: each last asSet].
	metaArray do: [:each | metaClassSelectors at: each first put: each last asSet]!

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
	names := Set new: classSelectors size + metaClassSelectors size.
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
		ifTrue: [metaClassSelectors lookup: aClass soleInstance fullName]
		ifFalse: [classSelectors lookup: aClass fullName]) notNil
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
	classSelectors := LookupTable new.
	metaClassSelectors := LookupTable new!

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
				ifTrue: [metaClassSelectors at: class soleInstance fullName put: selectors]
				ifFalse: [classSelectors at: class fullName put: selectors]]!

postCopy
	classSelectors := classSelectors collect: [:each | each copy].
	metaClassSelectors := metaClassSelectors collect: [:each | each copy].
	^super postCopy!

privateIncludesSelector: aSelector inClass: aClass 
	^(self privateSelectorsForClass: aClass) includes: aSelector!

privateSelectorsForClass: aClass
	^(aClass isMeta
		ifTrue: [metaClassSelectors lookup: aClass soleInstance fullName]
		ifFalse: [classSelectors lookup: aClass fullName]) ?? #()!

privateSelectorsForClassAdd: aClass
	^aClass isMeta
		ifTrue: [metaClassSelectors at: aClass soleInstance fullName ifAbsentPut: [IdentitySet new: 8]]
		ifFalse: [classSelectors at: aClass fullName ifAbsentPut: [IdentitySet new: 8]]!

removeClass: aClass
	aClass isMeta
		ifTrue: [metaClassSelectors removeKey: aClass soleInstance fullName ifAbsent: []]
		ifFalse: [classSelectors removeKey: aClass fullName ifAbsent: []]!

removeClass: aClass selector: aSelector
	(aClass isMeta
		ifTrue: [metaClassSelectors at: aClass soleInstance fullName ifAbsent: [^self]]
		ifFalse: [classSelectors at: aClass fullName ifAbsent: [^self]]) remove: aSelector ifAbsent: []!

selectorsForClass: aClass do: aBlock 
	^(self privateSelectorsForClass: aClass) 
		do: [:each | (aClass includesSelector: each) ifTrue: [aBlock value: each]]!

storeOn: aStream
	| classBlock |
	aStream
		nextPutAll: '((';
		nextPutAll: self class fullName;
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
						nextPut: $\x20].
			aStream
				nextPutAll: '))';
				cr].
	classSelectors keysAndValuesDo: classBlock.
	aStream nextPutAll: ') metaClasses: #('.
	metaClassSelectors keysAndValuesDo: classBlock.
	aStream nextPutAll: '))'! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #addClass:!adding!public! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #addClass:selector:!adding!public! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #addClass:selectors:!adding!public! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #classes:metaClasses:!initialize/release!public! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #classesAndSelectorsDo:!accessing!public! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #classesDo:!accessing/classes!public! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #classNames!accessing/classes!public! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #classSelectors:metaClassSelectors:!initialize/release!public! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #defaultLabel!constants!private! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #includesCategory:!public!testing! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #includesClass:!public!testing! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #includesProtocol:in:!public!testing! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #includesSelector:in:!public!testing! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #initialize!initialize/release!public! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #isEmpty!public!testing! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #isSelectorEnvironment!public!testing! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #numberSelectors!accessing!public! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #on:!initialize/release!public! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #postCopy!copying!public! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #privateIncludesSelector:inClass:!private!testing! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #privateSelectorsForClass:!accessing!private! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #privateSelectorsForClassAdd:!adding!private! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #removeClass:!public!removing! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #removeClass:selector:!public!removing! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #selectorsForClass:do:!accessing!public! !
!Refactory.Browser.SelectorEnvironment categoriesFor: #storeOn:!printing!public! !

!Refactory.Browser.SelectorEnvironment class methodsFor!

implementorsMatching: aString in: anEnvironment
	| classDict metaDict |
	classDict := LookupTable new.
	metaDict := LookupTable new.
	anEnvironment classesDo: 
			[:class |
			| selectors |
			selectors := Set new.
			anEnvironment selectorsForClass: class
				do: [:each | (aString match: each) ifTrue: [selectors add: each]].
			selectors notEmpty
				ifTrue: 
					[class isMeta
						ifTrue: [metaDict at: class soleInstance fullName put: selectors]
						ifFalse: [classDict at: class fullName put: selectors]]].
	^(self onEnvironment: anEnvironment)
		classSelectors: classDict metaClassSelectors: metaDict;
		label: ('Definitions matching <1p> in <2p>' expandMacrosWith: aString with: anEnvironment);
		yourself!

implementorsOf: aSelector in: anEnvironment
	| classDict metaDict selectors |
	classDict := LookupTable new.
	metaDict := LookupTable new.
	selectors := {aSelector}.
	anEnvironment classesDo: 
			[:class |
			((class includesSelector: aSelector) and: [anEnvironment includesSelector: aSelector in: class])
				ifTrue: 
					[class isMeta
						ifTrue: [metaDict at: class soleInstance fullName put: selectors]
						ifFalse: [classDict at: class fullName put: selectors]]].
	^(self onEnvironment: anEnvironment)
		classSelectors: classDict metaClassSelectors: metaDict;
		label: ('Definitions of <1p> in <2p>' expandMacrosWith: aSelector with: anEnvironment);
		yourself!

matches: aString in: anEnvironment
	| newEnvironment |
	newEnvironment := (self onEnvironment: anEnvironment)
				label: 'Matching: ' , aString;
				searchStrings: {aString};
				yourself.
	anEnvironment classesAndSelectorsDo: 
			[:each :sel |
			| method |
			method := each compiledMethodAt: sel.
			method allLiterals
				do: [:lit | lit isString ifTrue: [(aString match: lit) ifTrue: [newEnvironment addClass: each selector: sel]]]].
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
	label := 'References to <1p> in <2p>' expandMacrosWith: aLiteral with: aBrowserEnvironment.
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
		searchStrings: {aLiteral printString};
		yourself! !
!Refactory.Browser.SelectorEnvironment class categoriesFor: #implementorsMatching:in:!instance creation!public! !
!Refactory.Browser.SelectorEnvironment class categoriesFor: #implementorsOf:in:!instance creation!public! !
!Refactory.Browser.SelectorEnvironment class categoriesFor: #matches:in:!instance creation!public! !
!Refactory.Browser.SelectorEnvironment class categoriesFor: #onMethods:forClass:in:!instance creation!public! !
!Refactory.Browser.SelectorEnvironment class categoriesFor: #onMethods:in:!instance creation!public! !
!Refactory.Browser.SelectorEnvironment class categoriesFor: #referencesTo:in:!instance creation!public! !

