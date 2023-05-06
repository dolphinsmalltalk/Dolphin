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
	(classVariables at: aClass fullyQualifiedReference ifAbsentPutClean: [Set new]) add: aString.
	self flushCachesFor: aClass.
	self addSearchString: aString!

addClass: aClass instanceVariable: aString
	(instanceVariables at: aClass fullyQualifiedReference ifAbsentPutClean: [Set new]) add: aString.
	self flushCachesFor: aClass.
	self addSearchString: aString!

addClass: aClass instanceVariableReader: aString
	(instanceVariableReaders at: aClass fullyQualifiedReference ifAbsentPutClean: [Set new])
		add: aString.
	self flushCachesFor: aClass.
	self addSearchString: aString!

addClass: aClass instanceVariableWriter: aString
	(instanceVariableWriters at: aClass fullyQualifiedReference ifAbsentPutClean: [Set new]) add: aString.
	self flushCachesFor: aClass.
	self addSearchString: aString!

allClassesDo: aBlock
	| classes instVarBlock numClasses i progress |
	classes := IdentitySet new.
	instVarBlock := 
			[:each |
			| class |
			class := each value.
			classes add: class.
			class allSubclassesDo: [:eachSub | classes add: eachSub]].
	instanceVariables keysDo: instVarBlock.
	instanceVariableReaders keysDo: instVarBlock.
	instanceVariableWriters keysDo: instVarBlock.
	classVariables keysDo: 
			[:each |
			each valueOrNil
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

classNamesWithVariables
	| classNames |
	classNames := Set new.
	classNames
		addAll: instanceVariables keys;
		addAll: instanceVariableReaders keys;
		addAll: instanceVariableWriters keys;
		addAll: classVariables keys.
	^classNames collect: [:each | each asString]!

classVariables: anObject
	classVariables := anObject!

classVariableSelectorsFor: aClass
	| selectors classVars instanceClass |
	classVariables isEmpty ifTrue: [^#()].
	instanceClass := aClass instanceClass.
	selectors := IdentitySet new.
	classVars := Set new.
	classVariables keysDo: 
			[:each |
			| cls |
			cls := each valueOrNil.
			(cls notNil and: [instanceClass includesBehavior: cls])
				ifTrue: [classVars addAll: (classVariables at: each)]].
	classVars do: 
			[:each |
			| binding |
			binding := aClass bindingFor: each.
			binding notNil ifTrue: [selectors addAll: (aClass whichSelectorsReferTo: binding)]].
	^selectors!

classVariablesFor: aClass
	^classVariables at: aClass fullyQualifiedReference ifAbsent: #()!

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
	((classVariables at: aClass fullyQualifiedReference ifAbsent: #()) includes: aSymbol)
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
	| selectorEnvironment isReader isWriter ref |
	selectorEnvironment := SelectorEnvironment onEnvironment: self.
	selectorEnvironment addSearchString: aString.
	isReader := isWriter := false.
	ref := aClass fullyQualifiedReference.
	((instanceVariables at: ref ifAbsent: #()) includes: aString)
		ifTrue: 
			[isReader := true.
			isWriter := true].
	((instanceVariableWriters at: ref ifAbsent: #()) includes: aString) ifTrue: [isWriter := true].
	((instanceVariableReaders at: ref ifAbsent: #()) includes: aString) ifTrue: [isReader := true].
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
	| ref |
	(super includesClass: aClass) ifFalse: [^false].
	ref := aClass fullyQualifiedReference.
	(instanceVariables includesKey: ref) ifTrue: [^true].
	(classVariables includesKey: ref) ifTrue: [^true].
	^(self selectorCacheFor: aClass) anySatisfy: [:each | self includesSelector: each in: aClass]!

includesProtocol: aProtocol in: aClass 
	^(self selectorsFor: aProtocol in: aClass) notEmpty!

includesSelector: aSymbol in: aClass 
	^(environment includesSelector: aSymbol in: aClass) 
		and: [(self selectorCacheFor: aClass) includes: aSymbol]!

initialize
	super initialize.
	instanceVariables := LookupTable new.
	classVariables := LookupTable new.
	instanceVariableReaders := LookupTable new.
	instanceVariableWriters := LookupTable new!

instanceVariableReaders: aLookupTable
	instanceVariableReaders := aLookupTable!

instanceVariables: aLookupTable
	instanceVariables := aLookupTable!

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
	| vars ref |
	vars := Set new.
	ref := aClass fullyQualifiedReference.
	vars
		addAll: (instanceVariables at: ref ifAbsent: #());
		addAll: (instanceVariableReaders at: ref ifAbsent: #());
		addAll: (instanceVariableWriters at: ref ifAbsent: #()).
	^vars!

instanceVariableWriters: aLookupTable
	instanceVariableWriters := aLookupTable!

instVarsFor: aClass in: aLookupTable
	| instVars |
	aLookupTable isEmpty ifTrue: [^#()].
	instVars := Set new.
	aLookupTable keysAndValuesDo: 
			[:bindingRef :vars |
			| cls |
			cls := bindingRef valueOrNil.
			(cls notNil and: [aClass includesBehavior: cls]) ifTrue: [instVars addAll: vars]].
	^instVars!

isEmpty
	^instanceVariables isEmpty and: 
			[instanceVariableReaders isEmpty and: [instanceVariableWriters isEmpty and: [classVariables isEmpty]]]!

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
	| ref |
	ref := aClass fullyQualifiedReference.
	(classVariables lookup: ref)
		ifNotNil: 
			[:vars |
			vars remove: aSymbol ifAbsent: nil.
			vars isEmpty ifTrue: [classVariables removeKey: ref ifAbsent: nil]].
	self flushCachesFor: aClass!

removeClass: aClass instanceVariable: aString
	| ref |
	ref := aClass fullyQualifiedReference.
	(instanceVariables lookup: ref)
		ifNotNil: 
			[:vars |
			vars remove: aString ifAbsent: nil.
			vars isEmpty ifTrue: [instanceVariables removeKey: ref ifAbsent: nil]].
	self flushCachesFor: aClass!

removeClass: aClass instanceVariableReader: aString
	| ref |
	ref := aClass fullyQualifiedReference.
	(instanceVariableReaders lookup: ref)
		ifNotNil: 
			[:vars |
			vars remove: aString ifAbsent: nil.
			vars isEmpty ifTrue: [instanceVariableReaders removeKey: ref ifAbsent: nil]].
	self flushCachesFor: aClass!

removeClass: aClass instanceVariableWriter: aString
	| ref |
	ref := aClass fullyQualifiedReference.
	(instanceVariableWriters lookup: ref)
		ifNotNil: 
			[:vars |
			vars remove: aString ifAbsent: nil.
			vars isEmpty ifTrue: [instanceVariableWriters removeKey: ref ifAbsent: nil]].
	self flushCachesFor: aClass!

selectorCacheFor: aClass
	^(selectorCache ifNil: [selectorCache := LookupTable new]) at: aClass
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

