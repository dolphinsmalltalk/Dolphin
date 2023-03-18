"Filed out from Dolphin Smalltalk"!

Refactory.Browser.BrowserEnvironmentWrapper
	subclass: #'Refactory.Browser.VariableEnvironment'
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

addClass: aClass classVariable: aString
	(classVariables at: aClass fullName ifAbsentPutClean: [Set new]) add: aString.
	self flushCachesFor: aClass.
	self addSearchString: aString!

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

classVariables: anObject
	classVariables := anObject!

classVariableSelectorsFor: aClass
	| selectors classVars instanceClass |
	instanceClass := aClass instanceClass.
	selectors := IdentitySet new.
	classVars := Set new.
	classVariables keysDo: 
			[:each |
			| cls |
			cls := self classForName: each.
			(cls notNil and: [instanceClass includesBehavior: cls])
				ifTrue: [classVars addAll: (classVariables at: each)]].
	classVars do: 
			[:each |
			| binding |
			binding := aClass bindingFor: each.
			binding notNil ifTrue: [selectors addAll: (aClass whichSelectorsReferTo: binding)]].
	^selectors!

classVariablesFor: aClass
	^classVariables at: aClass fullName ifAbsent: #()!

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
	((classVariables at: aClass fullName ifAbsent: #()) includes: aSymbol)
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
	((instanceVariables at: aClass fullName ifAbsent: #()) includes: aString)
		ifTrue: 
			[isReader := true.
			isWriter := true].
	((instanceVariableWriters at: aClass fullName ifAbsent: #()) includes: aString)
		ifTrue: [isWriter := true].
	((instanceVariableReaders at: aClass fullName ifAbsent: #()) includes: aString)
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
	selectorCache isNil ifTrue: [^self].
	aClass instanceClass withAllSubclasses do: 
			[:each |
			selectorCache
				removeKey: each ifAbsent: nil;
				removeKey: each class ifAbsent: nil]!

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

instanceVariableReaders: anObject
	instanceVariableReaders := anObject!

instanceVariables: anObject
	instanceVariables := anObject!

instanceVariableSelectorsFor: aClass
	| selectors |
	selectors := IdentitySet new.
	(self instVarsFor: aClass in: instanceVariables)
		do: [:each | selectors addAll: (aClass whichSelectorsAccess: each)].
	(self instVarsFor: aClass in: instanceVariableReaders)
		do: [:each | selectors addAll: (aClass whichSelectorsRead: each)].
	(self instVarsFor: aClass in: instanceVariableWriters)
		do: [:each | selectors addAll: (aClass whichSelectorsAssign: each)].
	^selectors!

instanceVariablesFor: aClass
	| vars name |
	vars := Set new.
	name := aClass fullName.
	vars
		addAll: (instanceVariables at: name ifAbsent: #());
		addAll: (instanceVariableReaders at: name ifAbsent: #());
		addAll: (instanceVariableWriters at: name ifAbsent: #()).
	^vars!

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
	^instanceVariables isEmpty and: 
			[instanceVariableReaders isEmpty and: [instanceVariableWriters isEmpty and: [classVariables isEmpty]]]!

lookupTableClass
	#rbFix.	"Class ref. extracted to method, and use LookupTable rather than Dictionary for improved performance."
	^LookupTable!

numberVariables
	^instanceVariables size + instanceVariableReaders size + instanceVariableWriters size
		+ classVariables size!

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
	vars remove: aSymbol ifAbsent: nil.
	vars isEmpty ifTrue: [classVariables removeKey: aClass fullName ifAbsent: nil].
	self flushCachesFor: aClass!

removeClass: aClass instanceVariable: aString
	| vars |
	vars := instanceVariables at: aClass fullName ifAbsent: [Set new].
	vars remove: aString ifAbsent: nil.
	vars isEmpty ifTrue: [instanceVariables removeKey: aClass fullName ifAbsent: nil].
	self flushCachesFor: aClass!

removeClass: aClass instanceVariableReader: aString
	| vars |
	vars := instanceVariableReaders at: aClass fullName ifAbsent: [Set new].
	vars remove: aString ifAbsent: nil.
	vars isEmpty ifTrue: [instanceVariableReaders removeKey: aClass fullName ifAbsent: nil].
	self flushCachesFor: aClass!

removeClass: aClass instanceVariableWriter: aString
	| vars |
	vars := instanceVariableWriters at: aClass fullName ifAbsent: [Set new].
	vars remove: aString ifAbsent: nil.
	vars isEmpty ifTrue: [instanceVariableWriters removeKey: aClass fullName ifAbsent: nil].
	self flushCachesFor: aClass!

selectorCacheFor: aClass
	^(selectorCache ifNil: [selectorCache := self lookupTableClass new]) at: aClass
		ifAbsentPutClean: [self computeSelectorCacheFor: aClass]!

storeOn: aStream
	aStream
		nextPut: $(;
		nextPutAll: self class fullName;
		nextPutAll: ' new '.
	aStream
		nextPutAll: #instanceVariables:;
		space.
	instanceVariables storeOn: aStream.
	aStream nextPutAll: '; '.
	aStream
		nextPutAll: #instanceVariableReaders:;
		space.
	instanceVariableReaders storeOn: aStream.
	aStream nextPutAll: '; '.
	aStream
		nextPutAll: #instanceVariableWriters:;
		space.
	instanceVariableWriters storeOn: aStream.
	aStream nextPutAll: '; '.
	aStream
		nextPutAll: #classVariables:;
		space.
	classVariables storeOn: aStream.
	aStream nextPutAll: '; yourself)'! !
!Refactory.Browser.VariableEnvironment categoriesForMethods!
addClass:classVariable:!accessing!public! !
addClass:instanceVariable:!accessing!public! !
addClass:instanceVariableReader:!accessing!public! !
addClass:instanceVariableWriter:!accessing!public! !
allClassesDo:!enumerating!private! !
classForName:!helpers!private! !
classNamesWithVariables!accessing!public! !
classVariables:!accessing!private! !
classVariableSelectorsFor:!helpers!private! !
classVariablesFor:!accessing!public! !
computeSelectorCacheFor:!helpers!private! !
copyDictionary:!copying!public! !
environmentForClassVariable:in:!accessing!public! !
environmentForInstanceVariable:in:!accessing!public! !
flushCachesFor:!helpers!private! !
includesCategory:!public!testing! !
includesClass:!public!testing! !
includesProtocol:in:!public!testing! !
includesSelector:in:!public!testing! !
initialize!initialize/release!public! !
instanceVariableReaders:!public! !
instanceVariables:!accessing!private! !
instanceVariableSelectorsFor:!helpers!private! !
instanceVariablesFor:!accessing!public! !
instanceVariableWriters:!accessing!private! !
instVarsFor:in:!helpers!private! !
isEmpty!public!testing! !
lookupTableClass!constants!private! !
numberVariables!accessing!public! !
postCopy!copying!public! !
problemCount!accessing!public! !
removeClass:classVariable:!accessing!public! !
removeClass:instanceVariable:!accessing!public! !
removeClass:instanceVariableReader:!accessing!public! !
removeClass:instanceVariableWriter:!accessing!public! !
selectorCacheFor:!accessing!private! !
storeOn:!printing!public! !
!

!Refactory.Browser.VariableEnvironment class methodsFor!

on: anEnvironment readersOfInstanceVariable: aString in: aClass
	^(self onEnvironment: anEnvironment)
		label: (anEnvironment labelFormats at: #instVarReaders) << {aClass. aString. anEnvironment};
		addClass: aClass instanceVariableReader: aString;
		yourself!

on: anEnvironment referencesToClassVariable: aString in: aClass
	^(self onEnvironment: anEnvironment)
		label: (anEnvironment labelFormats at: #classVarReferences) << {aClass. aString. anEnvironment};
		addClass: aClass classVariable: aString;
		yourself!

on: anEnvironment referencesToInstanceVariable: aString in: aClass
	^(self onEnvironment: anEnvironment)
		label: (anEnvironment labelFormats at: #instVarReferences) << {aClass. aString. anEnvironment};
		addClass: aClass instanceVariable: aString;
		yourself!

on: anEnvironment writersOfInstanceVariable: aString in: aClass
	^(self onEnvironment: anEnvironment)
		label: (anEnvironment labelFormats at: #instVarWriters) << {aClass. aString. anEnvironment};
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
!Refactory.Browser.VariableEnvironment class categoriesForMethods!
on:readersOfInstanceVariable:in:!instance creation!public! !
on:referencesToClassVariable:in:!instance creation!public! !
on:referencesToInstanceVariable:in:!instance creation!public! !
on:writersOfInstanceVariable:in:!instance creation!public! !
readersOfInstanceVariable:in:!instance creation!public! !
referencesToClassVariable:in:!instance creation!public! !
referencesToInstanceVariable:in:!instance creation!public! !
writersOfInstanceVariable:in:!instance creation!public! !
!

