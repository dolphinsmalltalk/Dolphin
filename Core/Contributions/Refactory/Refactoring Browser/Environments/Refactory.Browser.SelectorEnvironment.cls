"Filed out from Dolphin Smalltalk"!

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
	(aClass isMeta ifTrue: [metaClassSelectors] ifFalse: [classSelectors])
		at: aClass instanceClass fullName
		put: aClass selectors!

addClass: aClass selector: aSymbol
	((aClass isMeta ifTrue: [metaClassSelectors] ifFalse: [classSelectors]) at: aClass instanceClass fullName
		ifAbsentPutClean: [IdentitySet new: 8]) add: aSymbol!

addClass: aClass selectors: aCollection
	((aClass isMeta ifTrue: [metaClassSelectors] ifFalse: [classSelectors])
		at: aClass instanceClass fullName
		ifAbsentPutClean: [IdentitySet new: 8]) addAll: aCollection!

classes: classArray metaClasses: metaArray
	"Used to recreate an environment from its storeString"

	"Implementation Note: A more elegant and compact solution would be to store one table of selectors using BindingReferences as the keys, but this will be slower for typical usage patterns because of the need to create creating BindingReferences for classes, and because hash table comparisons are slower than for simple strings."

	classSelectors := LookupTable new.
	metaClassSelectors := LookupTable new.
	classArray do: [:each | classSelectors at: each first put: each last asSet].
	metaArray do: [:each | metaClassSelectors at: each first put: each last asSet]!

classesAndSelectorsDo: aBlock
	classSelectors keysAndValuesDo: 
			[:eachClassName :eachSelectors |
			(Smalltalk resolveBindingPath: (BindingReference.PathSeparator split: eachClassName))
				ifNotNil: 
					[:binding |
					| class |
					class := binding value.
					(environment includesClass: class)
						ifTrue: 
							[eachSelectors do: [:each | (class includesSelector: each) ifTrue: [aBlock value: class value: each]]]]].
	metaClassSelectors keysAndValuesDo: 
			[:eachClassName :eachSelectors |
			(Smalltalk resolveBindingPath: (BindingReference.PathSeparator split: eachClassName))
				ifNotNil: 
					[:binding |
					| meta |
					meta := binding value class.
					(environment includesClass: meta)
						ifTrue: 
							[eachSelectors do: [:each | (meta includesSelector: each) ifTrue: [aBlock value: meta value: each]]]]]!

classesDo: aBlock
	classSelectors keysDo: 
			[:each |
			(Smalltalk resolveBindingPath: (BindingReference.PathSeparator split: each))
				ifNotNil: 
					[:binding |
					| class |
					class := binding value.
					(environment includesClass: class) ifTrue: [aBlock value: class]]].
	metaClassSelectors keysDo: 
			[:each |
			(Smalltalk resolveBindingPath: (BindingReference.PathSeparator split: each))
				ifNotNil: 
					[:binding |
					| meta |
					meta := binding value class.
					(environment includesClass: meta) ifTrue: [aBlock value: meta]]]!

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
	^((aClass isMeta ifTrue: [metaClassSelectors] ifFalse: [classSelectors])
		includesKey: aClass instanceClass fullName) and: [super includesClass: aClass]!

includesProtocol: aProtocol in: aClass
	^(super includesProtocol: aProtocol in: aClass) and: 
			[(environment selectorsFor: aProtocol in: aClass) anySatisfy: 
					[:aSelector |
					((aClass isMeta ifTrue: [metaClassSelectors] ifFalse: [classSelectors])
						lookup: aClass instanceClass fullName)
							ifNil: [false]
							ifNotNil: [:selectors | selectors includes: aSelector]]]!

includesSelector: aSelector in: aClass
	^(environment includesSelector: aSelector in: aClass) and: 
			[((aClass isMeta ifTrue: [metaClassSelectors] ifFalse: [classSelectors])
				lookup: aClass instanceClass fullName)
					ifNil: [false]
					ifNotNil: [:selectors | selectors includes: aSelector]]!

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
			(class isMeta ifTrue: [metaClassSelectors] ifFalse: [classSelectors])
				at: class instanceClass fullName
				put: selectors]!

postCopy
	classSelectors := classSelectors collect: [:each | each copy].
	metaClassSelectors := metaClassSelectors collect: [:each | each copy].
	^super postCopy!

removeClass: aClass
	(aClass isMeta ifTrue: [metaClassSelectors] ifFalse: [classSelectors])
		removeKey: aClass instanceClass fullName
		ifAbsent: nil!

removeClass: aClass selector: aSelector
	((aClass isMeta ifTrue: [metaClassSelectors] ifFalse: [classSelectors])
		lookup: aClass instanceClass fullName)
			ifNotNil: [:selectors | selectors remove: aSelector ifAbsent: nil]!

selectorsForClass: aClass do: aBlock
	((aClass isMeta ifTrue: [metaClassSelectors] ifFalse: [classSelectors])
		lookup: aClass instanceClass fullName)
			ifNotNil: [:selectors | selectors do: [:each | (aClass includesSelector: each) ifTrue: [aBlock value: each]]]!

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
!Refactory.Browser.SelectorEnvironment categoriesForMethods!
addClass:!adding!public! !
addClass:selector:!adding!public! !
addClass:selectors:!adding!public! !
classes:metaClasses:!initialize/release!public! !
classesAndSelectorsDo:!accessing!public! !
classesDo:!accessing/classes!public! !
classNames!accessing/classes!public! !
classSelectors:metaClassSelectors:!initialize/release!public! !
defaultLabel!constants!private! !
includesCategory:!public!testing! !
includesClass:!public!testing! !
includesProtocol:in:!public!testing! !
includesSelector:in:!public!testing! !
initialize!initialize/release!public! !
isEmpty!public!testing! !
isSelectorEnvironment!public!testing! !
numberSelectors!accessing!public! !
on:!initialize/release!public! !
postCopy!copying!public! !
removeClass:!public!removing! !
removeClass:selector:!public!removing! !
selectorsForClass:do:!accessing!public! !
storeOn:!printing!public! !
!

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
					[(class isMeta ifTrue: [metaDict] ifFalse: [classDict]) at: class instanceClass fullName
						put: selectors]].
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
					[(class isMeta ifTrue: [metaDict] ifFalse: [classDict]) at: class instanceClass fullName
						put: selectors]].
	^(self onEnvironment: anEnvironment)
		classSelectors: classDict metaClassSelectors: metaDict;
		label: (anEnvironment subEnvironmentLabel: #definitions for: aSelector);
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
	env label: (selectorCollection size = 1
				ifTrue: [(anEnvironment labelFormats at: #method) << {aClass. selectorCollection single}]
				ifFalse: [anEnvironment subEnvironmentLabel: #someMethodsOf: for: aClass]).
	^env!

onMethods: methodCollection in: anEnvironment 
	^(self onEnvironment: anEnvironment)
		addMethods: methodCollection;
		yourself!

referencesTo: aLiteral in: aBrowserEnvironment
	| classDict |
	#rbFix.	"Change the label"
	classDict := LookupTable new.
	aBrowserEnvironment classesDo: 
			[:class |
			| selectors |
			selectors := (class whichSelectorsReferTo: aLiteral)
						select: [:aSelector | aBrowserEnvironment includesSelector: aSelector in: class].
			selectors notEmpty ifTrue: [classDict at: class put: selectors]].
	^(self onEnvironment: aBrowserEnvironment)
		on: classDict;
		label: (aBrowserEnvironment subEnvironmentLabel: #references for: aLiteral);
		searchStrings: {aLiteral printString};
		yourself! !
!Refactory.Browser.SelectorEnvironment class categoriesForMethods!
implementorsMatching:in:!instance creation!public! !
implementorsOf:in:!instance creation!public! !
matches:in:!instance creation!public! !
onMethods:forClass:in:!instance creation!public! !
onMethods:in:!instance creation!public! !
referencesTo:in:!instance creation!public! !
!

