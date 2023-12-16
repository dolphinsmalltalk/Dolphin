"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Refactory.Browser.BrowserEnvironment'
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

bindingFor: aString
	^(Smalltalk resolveBindingPath: (BindingReference.PathSeparator split: aString))
		ifNotNil: 
			[:binding |
			| class |
			class := binding isClassBinding
						ifTrue: [binding value]
						ifFalse: 
							["We want to include non-class bindings if the Namespace is included"
							binding environment].
			(self includesClassOrMetaclass: class) ifTrue: [binding]]!

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
		select: [:class | class notNil and: [self includesClassOrMetaclass: class]])
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
	^SelectorEnvironment
		onMethods: selectorCollection
		forClass: aClass
		in: self!

forClasses: classCollection
	^ClassEnvironment onEnvironment: self classes: classCollection!

forClassesAndTheirMetaclasses: aCollection
	| behaviors |
	behaviors := WriteStream on: (Array new: aCollection size * 2).
	aCollection do: 
			[:each |
			behaviors
				nextPut: each instanceClass;
				nextPut: each instanceClass class].
	^self forClasses: behaviors grabContents!

forClassHierarchyOf: aClass
	"Answers a <BrowserEnvironment> that includes aClass, its superclasses and subclasses, and the corresponding
	metaclasses. See also #forClassHierarchyFrom:/#forClassHierarchyTo:."

	| classes |
	#rbFix.	"Extracted from #referencesTo:in:"
	classes := aClass withAllSuperclasses asSet.
	classes
		addAll: aClass allSubclasses;
		addAll: aClass class withAllSuperclasses;
		addAll: aClass class allSubclasses.
	^(self forClasses: classes)
		label: (self subEnvironmentLabel: #localHierarchy for: aClass);
		yourself!

forMethods: methodCollection
	^(SelectorEnvironment onMethods: methodCollection in: self)
		label: (self subEnvironmentLabel: #someMethods for: methodCollection);
		yourself!

forMethodsIn: aBrowserEnvironment
	| env |
	env := (SelectorEnvironment onEnvironment: self)
				label: (self subEnvironmentLabel: #someMethods for: aBrowserEnvironment);
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

	^true!

includesClassOrMetaclass: aClass
	"Answer whether this environment includes any part of the class, even a single method."

	^(self includesClass: aClass) or: [self includesClass: aClass class]!

includesProtocol: aProtocol in: aClass
	^true!

includesResource: aResourceIdentifier
	"Answer whether this defines the specified resource."

	^true!

includesSelector: aSelector in: aClass
	^true!

instanceVariablesFor: aClass 
	^aClass instanceVariableNames!

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

label
	^label isNil
		ifTrue: [self defaultLabel]
		ifFalse: [label]!

label: aString
	label := aString!

labelFormats
	^##(IdentityDictionary withAll: {
				#definitions -> 'All definitions of <1p>'.
				#bindingReferences -> 'All references to <1p>'.
				#classReferences -> 'All references to <1p>, or its static variables'.
				#classVarReferences -> 'All methods that reference <1p>.<2s>'.
				#instVarReferences -> 'All methods that reference <1p>.<2s>'.
				#instVarReaders -> 'All methods that read <1p>.<2s>'.
				#instVarWriters -> 'All methods that assign to <1p>.<2s>'.
				#literalReferences -> 'All references to <1p>'.
				#method -> '<1p>>><2p>'.
				#methodCategory -> 'All methods in category <1d>'.
				#methodCategories -> 'All methods in categories <1d>'.
				#references -> 'All references to <1p>'.
				#variableReferences -> 'All references to <1d>'.
				#localHierarchy -> 'Local hierarchy of <1p>'.
				#subclassHierarchy -> 'Subclass hierarchy of <1p>'.
				#superclassHierarchy -> 'Superclass hierarchy of <1p>'.
				#someMethods -> 'Some methods'.
				#someMethodsOf -> 'Some methods of <1p>'.
				#annotated -> 'All methods with <1d> annotations'.
				#containing-> 'All methods containing <3s>: <1p>'.
				#bytecode -> 'All methods with bytecode <1p>'.
				#thisContext -> 'All methods referencing thisContext'.
			})!

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

referencesToClass: aClass
	^(self filterMethods: [:method | method refersToLiteral: aClass])
		label: (self subEnvironmentLabel: #classReferences for: aClass);
		addSearchString: aClass unqualifiedName;
		yourself!

referencesToVariable: aVariableBinding
	^(self filterMethods: [:method | method refersToLiteral: aVariableBinding])
		label: (self subEnvironmentLabel: #variableReferences for: aVariableBinding);
		addSearchString: aVariableBinding key;
		yourself
	"addSearchString: aVariableBinding fullName;"!

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

whichCategoriesInclude: aClassName
	^aClassName asQualifiedReference valueOrNil ifNil: [#()] ifNotNil: [:class | class categories]!

whichProtocolIncludes: aSelector in: aClass
	#rbFix.	"Dolphin allows methods to be in multiple categories"
	^(self whichProtocolsInclude: aSelector in: aClass) asSortedArray first!

whichProtocolsInclude: aSelector in: aClass
	#rbFix.	"Dolphin specific method to support multiple method categories, also map names from strings to symbols."
	^(aClass compiledMethodAt: aSelector ifAbsent: nil)
		ifNil: [#()]
		ifNotNil: [:method | method realCategories collect: [:each | each name asSymbol]]! !
!Refactory.Browser.BrowserEnvironment categoriesForMethods!
&!environments!public! !
|!environments!public! !
addSearchString:!accessing!public! !
allClasses!enumerating!public! !
allClassesDo:!enumerating!public! !
bindingFor:!public! !
categories!accessing!public! !
classes!accessing/classes!public! !
classesAndSelectorsDo:!accessing!public! !
classesDo:!accessing/classes!public! !
classNames!accessing/classes!public! !
classNamesFor:!accessing!public! !
classVariablesFor:!accessing!public! !
classVarRefsTo:in:!environments!public! !
copyEmpty!copying!public! !
defaultLabel!constants!private! !
definesClass:!public!testing! !
environment!public! !
filter!accessing!private! !
filter:!accessing!private! !
forCategories:!environments!public! !
forClass:protocols:!environments!public! !
forClass:selectors:!environments!public! !
forClasses:!environments!public! !
forClassesAndTheirMetaclasses:!browsing!public! !
forClassHierarchyOf:!environments!public! !
forMethods:!environments!public! !
forMethodsIn:!environments!public! !
implementorsMatching:!environments!public! !
implementorsOf:!environments!public! !
includesCategory:!public!testing! !
includesClass:!public!testing! !
includesClassOrMetaclass:!public!testing! !
includesProtocol:in:!public!testing! !
includesResource:!public!testing! !
includesSelector:in:!public!testing! !
instanceVariablesFor:!accessing!public! !
instVarReadersTo:in:!environments!public! !
instVarRefsTo:in:!environments!public! !
instVarWritersTo:in:!environments!public! !
isClassEnvironment!public!testing! !
isEmpty!public!testing! !
isSelectorEnvironment!public!testing! !
isSystem!public!testing! !
label!accessing!private! !
label:!initialize/release!public! !
labelFormats!constants!public! !
matches:!environments!public! !
methodsDo:!public! !
not!environments!public! !
notEmpty!public!testing! !
numberClasses!accessing!public! !
numberSelectors!accessing!public! !
printOn:!printing!public! !
problemCount!accessing!public! !
protocolsFor:!accessing!public! !
referencesTo:!environments!public! !
referencesTo:in:!environments!public! !
referencesToClass:!enquiries!private! !
referencesToVariable:!enquiries!private! !
searchStrings!accessing!public! !
searchStrings:!accessing!public! !
selectMethods:!environments!public! !
selectorsDo:!enumerating!public! !
selectorsFor:in:!accessing!public! !
selectorsForClass:!accessing!public! !
selectorsForClass:do:!accessing!public! !
storeOn:!printing!public! !
whichCategoriesInclude:!accessing!public! !
whichProtocolIncludes:in:!accessing!public! !
whichProtocolsInclude:in:!accessing!public! !
!

!Refactory.Browser.BrowserEnvironment class methodsFor!

new
	^(super new)
		initialize;
		yourself! !
!Refactory.Browser.BrowserEnvironment class categoriesForMethods!
new!instance creation!public! !
!

