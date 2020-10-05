"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Refactory.Browser.BrowserEnvironment'
	instanceVariableNames: 'label searchStrings search filter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.BrowserEnvironment guid: (Core.GUID fromString: '{5a20d17b-a65d-4816-8b27-d25d2773698c}')!
Refactory.Browser.BrowserEnvironment comment: 'BrowserEnvironments represent a selection of the classes/methods in the system. Not only is BrowserEnvironment itself class the superclass of all environments, it also represents the complete image contents (i.e. the selection that includes all classes and methods).

Instance Variables:
	label	<String>	a description of what we''re looking at
	searchStrings	<Collection of: String>	strings to look for whenever we select a method'!
!Refactory.Browser.BrowserEnvironment categoriesForClass!Refactory-Environments! !
!Refactory.Browser.BrowserEnvironment methodsFor!

& anEnvironment
	"If we or anEnvironment includes everything, then just include the other environment (optimization)"

	self isSystem ifTrue: [^anEnvironment].
	anEnvironment isSystem ifTrue: [^self].
	^AndEnvironment onEnvironment: self and: anEnvironment!

| anEnvironment
	"If we or anEnvironment includes everything, then return it instead of creating 
	an or that will include everything."

	self isSystem ifTrue: [^self].
	anEnvironment isSystem ifTrue: [^anEnvironment].
	^OrEnvironment onEnvironment: self or: anEnvironment!

addSearchString: aString
	searchStrings isNil
		ifTrue: 
			[searchStrings := SortedCollection
						sortBlock: [:a :b | (a indexOf: $: ifAbsent: [a size]) > (b indexOf: $: ifAbsent: [b size])]].
	searchStrings add: aString!

allClasses
	"Answer all the unique non-metaclasses of all the classes and metaclasses in this environment.
	Note the inconsistency with allClassesDo:, which also enumerates the metaclasses."

	^Smalltalk allClasses!

allClassesDo: aBlock
	"Private - Evaluate the <monadicValuable> argument, aBlock, for every class and metaclass that could possibly be included in the receiver."

	Smalltalk allBehaviorsDo: aBlock!

associationAt: aKey
	^aKey asQualifiedReference bindingOrNil
		ifNotNil: 
			[:association |
			| class |
			class := association value isBehavior ifTrue: [association value] ifFalse: [association value class].
			((self includesClass: class) or: [self includesClass: class class]) ifTrue: [association]]!

at: aKey
	#rbFix.	"Replace #keyNotFoundError: with #errorNotFound"
	^self at: aKey ifAbsent: [Smalltalk errorNotFound: aKey]!

at: aKey ifAbsent: aBlock
	| assoc |
	assoc := self associationAt: aKey.
	^assoc isNil
		ifTrue: [aBlock value]
		ifFalse: [assoc value]!

categories
	| answer unclassified |
	#rbFix.	"Dolphin's category systems are very different. Enumerating all the categories and
		examining their contents is very slow as ClassCategory>>contents has to perform a
		linear search across each category array of each class in the system, i.e.
		numberCategories x numberClasses. Therefore we enumerate all included classes and
		build a set from those."
	answer := Set new.
	unclassified := ClassCategory unclassified name.
	self classesDo: 
			[:eachClass |
			eachClass isMeta
				ifFalse: 
					[eachClass classCategories
						ifNil: [answer add: unclassified]
						ifNotNil: [:categories | categories do: [:eachCategory | answer add: eachCategory name]]]].
	^answer
	"^Smalltalk organization categories select: [:each | self includesCategory: each]"!

classes
	| classes |
	classes := Set new.
	self classesDo: [:each | classes add: each].
	^classes!

classesAndSelectorsDo: aBlock
	self classesDo: [:class | self selectorsForClass: class do: [:sel | aBlock value: class value: sel]]!

classesDo: aBlock
	self allClassesDo: aBlock!

classNames
	| classes names |
	classes := self allClasses.
	names := Set new: classes size.
	classes do: [:each | names add: each fullName].
	^names!

classNamesFor: aCategoryName
	#rbFix.	"Dolphin class category system not compatible"
	^((ClassCategory name: aCategoryName) classes
		select: [:class | class notNil and: [(self includesClass: class) or: [self includesClass: class class]]])
			collect: [:e | e fullName]!

classVariablesFor: aClass
	^aClass classBindingNames!

classVarRefsTo: classVarName in: aClass 
	^VariableEnvironment 
		on: self
		referencesToClassVariable: classVarName
		in: aClass!

copyEmpty
	^self class new!

defaultLabel
	^'Smalltalk'!

definesClass: aClass
	"Answer whether this environment includes the primary definition of the class argument."

	^true!

environment
	^self!

filter
	^filter ifNil: [[:method | self includesMethodUncached: method]]!

filter: aMonadicValuable 
	filter := aMonadicValuable!

forCategories: categoryList
	^CategoryEnvironment onEnvironment: self categories: categoryList!

forClass: aClass protocols: protocolCollection
	^ProtocolEnvironment
		onEnvironment: self
		class: aClass
		protocols: protocolCollection!

forClass: aClass selectors: selectorCollection
	^(SelectorEnvironment
		onMethods: selectorCollection
		forClass: aClass
		in: self)
		label: aClass fullName , '>>#' , (selectorCollection detect: [:each | true] ifNone: ['']);
		yourself!

forClasses: classCollection
	^ClassEnvironment onEnvironment: self classes: classCollection!

forClassHierarchyOf: aClass
	"Answers a <BrowserEnvironment> that includes aClass, its superclasses and subclasses, and the corresponding
	metaclasses. See also #forClassHierarchyFrom:."

	| classes |
	#rbFix.	"Extracted from #referencesTo:in:"
	classes := aClass withAllSuperclasses asSet.
	classes
		addAll: aClass allSubclasses;
		addAll: aClass class withAllSuperclasses;
		addAll: aClass class allSubclasses.
	^(self forClasses: classes)
		label: ('Local hierarchy of <1p> in <2p>' expandMacrosWith: aClass with: self);
		yourself!

forMethods: methodCollection
	^(SelectorEnvironment onMethods: methodCollection in: self)
		label: ('Some methods in <1p>' expandMacrosWith: self);
		yourself!

forMethodsIn: aBrowserEnvironment
	| env |
	env := (SelectorEnvironment onEnvironment: self)
				label: ('Some methods in <1d>' expandMacrosWith: self);
				yourself.
	aBrowserEnvironment
		classesAndSelectorsDo: [:class :selector | env addClass: class selector: selector].
	^env!

implementorsMatching: aString
	^SelectorEnvironment implementorsMatching: aString in: self!

implementorsOf: aSelector
	^SelectorEnvironment implementorsOf: aSelector in: self!

includesCategory: aCategory
	^true!

includesClass: aClass 
	"Answer whether this environment includes any part of the class, even a single method."

	#rbFix.	"By default an environment should include only those classes that it defines."
	^self definesClass: aClass!

includesProtocol: aProtocol in: aClass
	^true!

includesResource: aResourceIdentifier
	"Answer whether this defines the specified resource."

	^true!

includesSelector: aSelector in: aClass
	^true!

instanceVariablesFor: aClass 
	^aClass instVarNames!

instVarReadersTo: instVarName in: aClass 
	^VariableEnvironment 
		on: self
		readersOfInstanceVariable: instVarName
		in: aClass!

instVarRefsTo: instVarName in: aClass 
	^VariableEnvironment 
		on: self
		referencesToInstanceVariable: instVarName
		in: aClass!

instVarWritersTo: instVarName in: aClass 
	^VariableEnvironment 
		on: self
		writersOfInstanceVariable: instVarName
		in: aClass!

isClassEnvironment
	^false!

isEmpty
	^false!

isSelectorEnvironment
	^false!

isSystem
	^true!

keys
	| keys |
	keys := IdentitySet new.
	Smalltalk keysAndValuesDo: 
			[:key :value |
			value isBehavior
				ifTrue: [((self includesClass: value) or: [self includesClass: value class]) ifTrue: [keys add: key]]
				ifFalse: [(self includesClass: value class) ifTrue: [keys add: key]]].
	^keys!

label
	^label isNil
		ifTrue: [self defaultLabel]
		ifFalse: [label]!

label: aString
	label := aString!

lookup: aKey
	^(self associationAt: aKey) ifNotNil: [:assoc | assoc value]!

matches: aString
	^SelectorEnvironment matches: aString in: self!

methodsDo: aBlock 
	"Evaluate the <monadicValuable> argument for each method defined in this environment."

	self 
		classesAndSelectorsDo: [:class :selector | aBlock value: (class compiledMethodAt: selector)]!

not
	self isSystem ifTrue: [^SelectorEnvironment onEnvironment: self].
	^NotEnvironment onEnvironment: self!

notEmpty
	^self isEmpty not!

numberClasses
	^self classNames size!

numberSelectors
	| total classes |
	total := 0.
	classes := Smalltalk allClasses.
	1 to: classes size
		do: 
			[:i |
			| class |
			total := total + (class := classes at: i) numberSelectors + class class numberSelectors].
	^total!

printOn: aStream
	aStream nextPutAll: self label!

problemCount
	^self numberSelectors!

protocolsFor: aClass
	#rbFix. "category system again"
	^aClass realMethodCategories "organization categories "
		select: [:each | self includesProtocol: each in: aClass]!

referencesTo: aLiteral
	^SelectorEnvironment referencesTo: aLiteral in: self!

referencesTo: aLiteral in: aClass 
	#rbFix.	"Extract construction of hierarchy environment."
	^(self forClassHierarchyOf: aClass) referencesTo: aLiteral!

searchStrings
	^searchStrings isNil
		ifTrue: [#()]
		ifFalse: [searchStrings]!

searchStrings: aCollection 
	searchStrings := aCollection!

selectMethods: aBlock
	| env |
	env := SelectorEnvironment onEnvironment: self.
	self classesAndSelectorsDo: 
			[:each :sel |
			(aBlock value: (each compiledMethodAt: sel)) ifTrue: [env addClass: each selector: sel]].
	^env!

selectorsDo: aMonadicValuable
	#rbFix.	"Use #classesDo: (allClassesDo: not necessary and very slow for some subclasses)"
	self classesAndSelectorsDo: [:eachClass :eachSelector | aMonadicValuable value: eachSelector]!

selectorsFor: aProtocol in: aClass
	#rbFix. "Category system incompatible. aProtocol can be a <String> or <MethodCategory>"
	"^(aClass organization listAtCategoryNamed: aProtocol)"
	^(aProtocol asMethodCategory methodsInBehavior: aClass)
		select: [:each | self includesSelector: each selector in: aClass] thenCollect: [:each | each selector]!

selectorsForClass: aClass
	| selectors |
	selectors := IdentitySet new: 50.
	self selectorsForClass: aClass do: [:each | selectors add: each].
	^selectors!

selectorsForClass: aClass do: aBlock
	aClass selectorsDo: [:each | (self includesSelector: each in: aClass) ifTrue: [aBlock value: each]]!

storeOn: aStream
	aStream
		nextPutAll: self class fullName;
		nextPutAll: ' new'!

whichCategoryIncludes: aClassName
	#rbFix. "Dolphin's category system completely different"
	^aClassName asQualifiedReference value categories asSortedCollection first name
"	^Smalltalk organization categoryOfElement: aClassName"!

whichProtocolIncludes: aSelector in: aClass
	#rbFix.	"Dolphin allows methods to be in multiple categories"
	^(self whichProtocolsInclude: aSelector in: aClass) asSortedCollection 
		first!

whichProtocolsInclude: aSelector in: aClass 
	#rbFix.	"Dolphin specific method to support multiple method categories, also map names from strings to symbols."
	^(aClass compiledMethodAt: aSelector ifAbsent: []) 
		ifNil: [#()]
		ifNotNil: [:method | method realCategories collect: [:each | each name asSymbol]]! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #&!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #|!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #addSearchString:!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #allClasses!enumerating!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #allClassesDo:!enumerating!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #associationAt:!accessing/classes!accessing-classes!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #at:!accessing/classes!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #at:ifAbsent:!accessing/classes!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #categories!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #classes!accessing/classes!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #classesAndSelectorsDo:!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #classesDo:!accessing/classes!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #classNames!accessing/classes!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #classNamesFor:!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #classVariablesFor:!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #classVarRefsTo:in:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #copyEmpty!copying!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #defaultLabel!constants!private! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #definesClass:!public!testing! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #environment!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #filter!accessing!private! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #filter:!accessing!private! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #forCategories:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #forClass:protocols:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #forClass:selectors:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #forClasses:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #forClassHierarchyOf:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #forMethods:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #forMethodsIn:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #implementorsMatching:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #implementorsOf:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #includesCategory:!public!testing! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #includesClass:!public!testing! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #includesProtocol:in:!public!testing! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #includesResource:!public!testing! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #includesSelector:in:!public!testing! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #instanceVariablesFor:!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #instVarReadersTo:in:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #instVarRefsTo:in:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #instVarWritersTo:in:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #isClassEnvironment!public!testing! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #isEmpty!public!testing! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #isSelectorEnvironment!public!testing! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #isSystem!public!testing! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #keys!accessing/classes!accessing-classes!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #label!accessing!private! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #label:!initialize/release!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #lookup:!accessing/classes!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #matches:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #methodsDo:!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #not!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #notEmpty!public!testing! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #numberClasses!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #numberSelectors!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #printOn:!printing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #problemCount!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #protocolsFor:!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #referencesTo:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #referencesTo:in:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #searchStrings!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #searchStrings:!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #selectMethods:!environments!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #selectorsDo:!enumerating!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #selectorsFor:in:!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #selectorsForClass:!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #selectorsForClass:do:!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #storeOn:!printing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #whichCategoryIncludes:!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #whichProtocolIncludes:in:!accessing!public! !
!Refactory.Browser.BrowserEnvironment categoriesFor: #whichProtocolsInclude:in:!accessing!public! !

!Refactory.Browser.BrowserEnvironment class methodsFor!

new
	^(super new)
		initialize;
		yourself! !
!Refactory.Browser.BrowserEnvironment class categoriesFor: #new!instance creation!public! !

