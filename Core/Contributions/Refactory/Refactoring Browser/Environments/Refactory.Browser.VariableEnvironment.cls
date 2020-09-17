"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.BrowserEnvironmentWrapper subclass: #'Refactory.Browser.VariableEnvironment'
	instanceVariableNames: 'instanceVariables instanceVariableReaders instanceVariableWriters classVariables selectorCache'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.VariableEnvironment guid: (Core.GUID fromString: '{e9cada30-17fa-4434-96e9-1e962bb36333}')!
Refactory.Browser.VariableEnvironment comment: 'VariableEnvironment defines a set of methods (and their classes) that read and/or write to any of a set of named instance and class variables. It is used to implement the browse variable references, readers & writers commands in the browsers.


Instance Variables:
	instanceVariables		<abstractDictionary>, mapping class names to the referenced instance variable names
	instanceVariableReaders	<abstractDictionary>, mapping class names to the read instance variable names
	instanceVariableWriters	<abstractDictionary>, mapping class names to the written instance variable names
	classVariables			<abstractDictionary>, mapping class names to referenced class variable names
	selectorCache			<abstractDictionary>, mapping classes to selectors of methods that read or write one of the variables in the above maps

Note that in Dolphin all <abstractDictionary>s are implemented as instances of <LookupTable> because of its better speed/memory performance relative to <Dictionary>.


'!
!Refactory.Browser.VariableEnvironment categoriesForClass!Refactory-Environments! !
!Refactory.Browser.VariableEnvironment methodsFor!

accessorMethods
	^#(#instanceVariables #instanceVariableReaders #instanceVariableWriters #classVariables)!

addClass: aClass classVariable: aSymbol
	(classVariables at: aClass fullName ifAbsentPutClean: [Set new]) add: aSymbol.
	self flushCachesFor: aClass.
	self addSearchString: aSymbol!

addClass: aClass instanceVariable: aString
	(instanceVariables at: aClass fullName ifAbsentPutClean: [Set new]) add: aString.
	self flushCachesFor: aClass.
	self addSearchString: aString!

addClass: aClass instanceVariableReader: aString
	(instanceVariableReaders at: aClass fullName ifAbsentPutClean: [Set new]) add: aString.
	self flushCachesFor: aClass.
	self addSearchString: aString!

addClass: aClass instanceVariableWriter: aString
	(instanceVariableWriters at: aClass fullName ifAbsentPutClean: [Set new]) add: aString.
	self flushCachesFor: aClass.
	self addSearchString: aString!

allClassesDo: aBlock
	| classes instVarBlock numClasses i progress |
	classes := IdentitySet new.
	instVarBlock := 
			[:each |
			| class |
			class := self classForName: each.
			classes add: class.
			class allSubclassesDo: [:eachSub | classes add: eachSub]].
	instanceVariables keysDo: instVarBlock.
	instanceVariableReaders keysDo: instVarBlock.
	instanceVariableWriters keysDo: instVarBlock.
	classVariables keysDo: 
			[:each |
			(self classForName: each)
				ifNotNil: 
					[:class |
					classes add: class.
					class allSubclassesDo: [:eachSub | classes add: eachSub].
					classes add: class class.
					class class allSubclassesDo: [:eachSub | classes add: eachSub]]].
	numClasses := classes size.
	progress := self progressBlock.
	i := 0.0.
	progress value: i.
	classes do: 
			[:class |
			aBlock value: class.
			i := i + 1.
			progress value: i * 100 // numClasses]!

classForName: aString
	| index |
	index := aString
				nextIndexOf: $\x20
				from: 1
				to: aString size.
	^(index == 0
		ifTrue: [BindingReference pathString: aString]
		ifFalse: [(BindingReference pathString: (aString copyFrom: 1 to: index - 1)) meta]) valueOrNil!

classNamesWithVariables
	| classNames |
	classNames := Set new.
	classNames
		addAll: instanceVariables keys;
		addAll: instanceVariableReaders keys;
		addAll: instanceVariableWriters keys;
		addAll: classVariables keys.
	^classNames!

classVariables
	^classVariables!

classVariables: anObject
	classVariables := anObject!

classVariableSelectorsFor: aClass
	| selectors classVars nonMetaClass |
	nonMetaClass := aClass instanceClass.
	selectors := IdentitySet new.
	classVars := Set new.
	classVariables keysDo: 
			[:each |
			| cls |
			cls := self classForName: each.
			(cls notNil and: [nonMetaClass includesBehavior: cls])
				ifTrue: [classVars addAll: (classVariables at: each)]].
	classVars do: 
			[:each |
			| binding |
			binding := aClass bindingFor: each.
			binding notNil ifTrue: [selectors addAll: (aClass whichSelectorsReferTo: binding)]].
	^selectors!

classVariablesFor: aClass
	^classVariables at: aClass fullName ifAbsent: [#()]!

computeSelectorCacheFor: aClass 
	^(self instanceVariableSelectorsFor: aClass)
		addAll: (self classVariableSelectorsFor: aClass);
		yourself!

copyDictionary: aDictionary 
	#rbFix.	"Because we are using LookupTables (instead of Dictionaries) we don't need any
			special copying for the dictionaries."
	^aDictionary copy!

environmentForClassVariable: aSymbol in: aClass
	| selectorEnvironment assoc block |
	selectorEnvironment := SelectorEnvironment onEnvironment: self.
	selectorEnvironment addSearchString: aSymbol.
	((classVariables at: aClass fullName ifAbsent: [#()]) includes: aSymbol)
		ifFalse: [^selectorEnvironment].
	assoc := aClass bindingFor: aSymbol.
	block := 
			[:each |
			(each whichSelectorsReferTo: assoc) do: [:sel | selectorEnvironment addClass: each selector: sel]].
	aClass withAllSubclasses do: 
			[:each |
			block
				value: each;
				value: each class].
	^selectorEnvironment!

environmentForInstanceVariable: aString in: aClass
	| selectorEnvironment isReader isWriter |
	selectorEnvironment := SelectorEnvironment onEnvironment: self.
	selectorEnvironment addSearchString: aString.
	isReader := isWriter := false.
	((instanceVariables at: aClass fullName ifAbsent: [#()]) includes: aString)
		ifTrue: 
			[isReader := true.
			isWriter := true].
	((instanceVariableWriters at: aClass fullName ifAbsent: [#()]) includes: aString)
		ifTrue: [isWriter := true].
	((instanceVariableReaders at: aClass fullName ifAbsent: [#()]) includes: aString)
		ifTrue: [isReader := true].
	aClass withAllSubclasses do: 
			[:each |
			isWriter
				ifTrue: 
					[(each whichSelectorsAssign: aString) do: [:sel | selectorEnvironment addClass: each selector: sel]].
			isReader
				ifTrue: 
					[(each whichSelectorsRead: aString) do: [:sel | selectorEnvironment addClass: each selector: sel]]].
	^selectorEnvironment!

flushCachesFor: aClass 
	| nonMetaClass |
	selectorCache isNil ifTrue: [^self].
	nonMetaClass := aClass instanceClass.
	nonMetaClass withAllSubclasses do: 
			[:each | 
			selectorCache
				removeKey: each ifAbsent: [];
				removeKey: each class ifAbsent: []]!

includesCategory: aCategory 
	^(self classNamesFor: aCategory) notEmpty!

includesClass: aClass
	| name |
	#rbFix.	"SW: The *Variable dictionaries are keyed by class name not class"
	(super includesClass: aClass) ifFalse: [^false].
	name := aClass fullName.
	(instanceVariables includesKey: name) ifTrue: [^true].
	(classVariables includesKey: name) ifTrue: [^true].
	^(self selectorCacheFor: aClass) anySatisfy: [:each | self includesSelector: each in: aClass]!

includesProtocol: aProtocol in: aClass 
	^(self selectorsFor: aProtocol in: aClass) notEmpty!

includesSelector: aSymbol in: aClass 
	^(environment includesSelector: aSymbol in: aClass) 
		and: [(self selectorCacheFor: aClass) includes: aSymbol]!

initialize
	super initialize.
	instanceVariables := self lookupTableClass new.
	classVariables := self lookupTableClass new.
	instanceVariableReaders := self lookupTableClass new.
	instanceVariableWriters := self lookupTableClass new!

instanceVariableReaders
	^instanceVariableReaders!

instanceVariableReaders: anObject
	instanceVariableReaders := anObject!

instanceVariables
	^instanceVariables!

instanceVariables: anObject
	instanceVariables := anObject!

instanceVariableSelectorsFor: aClass
	| selectors |
	selectors := IdentitySet new.
	(self instVarsFor: aClass in: self instanceVariables)
		do: [:each | selectors addAll: (aClass whichSelectorsAccess: each)].
	(self instVarsFor: aClass in: self instanceVariableReaders)
		do: [:each | selectors addAll: (aClass whichSelectorsRead: each)].
	(self instVarsFor: aClass in: self instanceVariableWriters)
		do: [:each | selectors addAll: (aClass whichSelectorsAssign: each)].
	^selectors!

instanceVariablesFor: aClass
	| vars name |
	vars := Set new.
	name := aClass fullName.
	vars
		addAll: (instanceVariables at: name ifAbsent: [#()]);
		addAll: (instanceVariableReaders at: name ifAbsent: [#()]);
		addAll: (instanceVariableWriters at: name ifAbsent: [#()]).
	^vars!

instanceVariableWriters
	^instanceVariableWriters!

instanceVariableWriters: anObject
	instanceVariableWriters := anObject!

instVarsFor: aClass in: aDictionary
	| instVars |
	aDictionary keysAndValuesDo: 
			[:eachKey :eachValue |
			| cls |
			cls := self classForName: eachKey.
			(cls notNil and: [aClass includesBehavior: cls])
				ifTrue: [(instVars ifNil: [instVars := OrderedCollection new]) addAll: eachValue]].
	^instVars ?? #()!

isEmpty
	self accessorMethods do: [:each | (self perform: each) notEmpty ifTrue: [^false]].
	^true!

lookupTableClass
	#rbFix.	"Class ref. extracted to method, and use LookupTable rather than Dictionary for improved performance."
	^LookupTable!

numberVariables
	^self accessorMethods inject: 0
		into: [:sum :each | sum + ((self perform: each) inject: 0 into: [:s :e | s + e size])]!

postCopy
	super postCopy.
	instanceVariables := self copyDictionary: instanceVariables.
	instanceVariableReaders := self copyDictionary: instanceVariableReaders.
	instanceVariableWriters := self copyDictionary: instanceVariableWriters.
	classVariables := self copyDictionary: classVariables.
	selectorCache := nil.
	^self!

problemCount
	^self numberVariables!

removeClass: aClass classVariable: aSymbol
	| vars |
	vars := classVariables at: aClass fullName ifAbsent: [Set new].
	vars remove: aSymbol ifAbsent: [].
	vars isEmpty ifTrue: [classVariables removeKey: aClass fullName ifAbsent: []].
	self flushCachesFor: aClass!

removeClass: aClass instanceVariable: aString
	| vars |
	vars := instanceVariables at: aClass fullName ifAbsent: [Set new].
	vars remove: aString ifAbsent: [].
	vars isEmpty ifTrue: [instanceVariables removeKey: aClass fullName ifAbsent: []].
	self flushCachesFor: aClass!

removeClass: aClass instanceVariableReader: aString
	| vars |
	vars := instanceVariableReaders at: aClass fullName ifAbsent: [Set new].
	vars remove: aString ifAbsent: [].
	vars isEmpty ifTrue: [instanceVariableReaders removeKey: aClass fullName ifAbsent: []].
	self flushCachesFor: aClass!

removeClass: aClass instanceVariableWriter: aString
	| vars |
	vars := instanceVariableWriters at: aClass fullName ifAbsent: [Set new].
	vars remove: aString ifAbsent: [].
	vars isEmpty ifTrue: [instanceVariableWriters removeKey: aClass fullName ifAbsent: []].
	self flushCachesFor: aClass!

selectorCacheFor: aClass
	^(selectorCache ifNil: [selectorCache := self lookupTableClass new]) at: aClass
		ifAbsentPutClean: [self computeSelectorCacheFor: aClass]!

storeOn: aStream
	aStream
		nextPut: $(;
		nextPutAll: self class fullName;
		nextPutAll: ' new '.
	#(#instanceVariables #instanceVariableReaders #instanceVariableWriters #classVariables) do: 
			[:each |
			aStream
				nextPutAll: each;
				nextPutAll: ': '.
			(self perform: each) storeOn: aStream.
			aStream nextPutAll: '; '].
	aStream nextPutAll: ' yourself)'! !
!Refactory.Browser.VariableEnvironment categoriesFor: #accessorMethods!constants!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #addClass:classVariable:!accessing!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #addClass:instanceVariable:!accessing!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #addClass:instanceVariableReader:!accessing!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #addClass:instanceVariableWriter:!accessing!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #allClassesDo:!enumerating!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #classForName:!helpers!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #classNamesWithVariables!accessing!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #classVariables!accessing!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #classVariables:!accessing!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #classVariableSelectorsFor:!helpers!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #classVariablesFor:!accessing!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #computeSelectorCacheFor:!helpers!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #copyDictionary:!copying!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #environmentForClassVariable:in:!accessing!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #environmentForInstanceVariable:in:!accessing!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #flushCachesFor:!helpers!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #includesCategory:!public!testing! !
!Refactory.Browser.VariableEnvironment categoriesFor: #includesClass:!public!testing! !
!Refactory.Browser.VariableEnvironment categoriesFor: #includesProtocol:in:!public!testing! !
!Refactory.Browser.VariableEnvironment categoriesFor: #includesSelector:in:!public!testing! !
!Refactory.Browser.VariableEnvironment categoriesFor: #initialize!initialize/release!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #instanceVariableReaders!accessing!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #instanceVariableReaders:!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #instanceVariables!accessing!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #instanceVariables:!accessing!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #instanceVariableSelectorsFor:!helpers!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #instanceVariablesFor:!accessing!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #instanceVariableWriters!accessing!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #instanceVariableWriters:!accessing!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #instVarsFor:in:!helpers!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #isEmpty!public!testing! !
!Refactory.Browser.VariableEnvironment categoriesFor: #lookupTableClass!constants!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #numberVariables!accessing!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #postCopy!copying!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #problemCount!accessing!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #removeClass:classVariable:!accessing!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #removeClass:instanceVariable:!accessing!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #removeClass:instanceVariableReader:!accessing!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #removeClass:instanceVariableWriter:!accessing!public! !
!Refactory.Browser.VariableEnvironment categoriesFor: #selectorCacheFor:!accessing!private! !
!Refactory.Browser.VariableEnvironment categoriesFor: #storeOn:!printing!public! !

!Refactory.Browser.VariableEnvironment class methodsFor!

on: anEnvironment readersOfInstanceVariable: aString in: aClass
	^(self onEnvironment: anEnvironment)
		label: 'Readers of ''' , aString , ''' in ' , aClass fullName;
		addClass: aClass instanceVariableReader: aString;
		yourself!

on: anEnvironment referencesToClassVariable: aSymbol in: aClass
	^(self onEnvironment: anEnvironment)
		label: 'References to ''' , aSymbol , ''' in ' , aClass fullName;
		addClass: aClass classVariable: aSymbol;
		yourself!

on: anEnvironment referencesToInstanceVariable: aString in: aClass
	^(self onEnvironment: anEnvironment)
		label: 'References to ''' , aString , ''' in ' , aClass fullName;
		addClass: aClass instanceVariable: aString;
		yourself!

on: anEnvironment writersOfInstanceVariable: aString in: aClass
	^(self onEnvironment: anEnvironment)
		label: 'Writers of ''' , aString , ''' in ' , aClass fullName;
		addClass: aClass instanceVariableWriter: aString;
		yourself!

readersOfInstanceVariable: aString in: aClass
	^self
		on: BrowserEnvironment new
		readersOfInstanceVariable: aString
		in: aClass!

referencesToClassVariable: aSymbol in: aClass
	^self
		on: BrowserEnvironment new
		referencesToClassVariable: aSymbol
		in: aClass!

referencesToInstanceVariable: aString in: aClass
	^self
		on: BrowserEnvironment new
		referencesToInstanceVariable: aString
		in: aClass!

writersOfInstanceVariable: aString in: aClass
	^self
		on: BrowserEnvironment new
		writersOfInstanceVariable: aString
		in: aClass! !
!Refactory.Browser.VariableEnvironment class categoriesFor: #on:readersOfInstanceVariable:in:!instance creation!public! !
!Refactory.Browser.VariableEnvironment class categoriesFor: #on:referencesToClassVariable:in:!instance creation!public! !
!Refactory.Browser.VariableEnvironment class categoriesFor: #on:referencesToInstanceVariable:in:!instance creation!public! !
!Refactory.Browser.VariableEnvironment class categoriesFor: #on:writersOfInstanceVariable:in:!instance creation!public! !
!Refactory.Browser.VariableEnvironment class categoriesFor: #readersOfInstanceVariable:in:!instance creation!public! !
!Refactory.Browser.VariableEnvironment class categoriesFor: #referencesToClassVariable:in:!instance creation!public! !
!Refactory.Browser.VariableEnvironment class categoriesFor: #referencesToInstanceVariable:in:!instance creation!public! !
!Refactory.Browser.VariableEnvironment class categoriesFor: #writersOfInstanceVariable:in:!instance creation!public! !

