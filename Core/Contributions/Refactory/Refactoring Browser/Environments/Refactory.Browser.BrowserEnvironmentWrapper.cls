"Filed out from Dolphin Smalltalk"!

Refactory.Browser.BrowserEnvironment
	subclass: #'Refactory.Browser.BrowserEnvironmentWrapper'
	instanceVariableNames: 'environment progressBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.BrowserEnvironmentWrapper guid: (Core.GUID fromString: '{73290c8c-a79f-4c55-805c-41c6ed19a64b}')!

Refactory.Browser.BrowserEnvironmentWrapper comment: 'BrowserEnvironmentWrapper is a wrapper for BrowserEnvironments that limits what is shown. While it does not have any #subclassResponsibility methods, it is an abstract class since it doesn''t provide any useful behavior by itself

Instance Variables:
	environment	<BrowserEnvironment>	the environment we''re wrapping'!

!Refactory.Browser.BrowserEnvironmentWrapper categoriesForClass!Refactory-Environments! !

!Refactory.Browser.BrowserEnvironmentWrapper methodsFor!

& anEnvironment
	anEnvironment isSystem ifTrue: [
		"&'d environment includes everything, so conjunection would be no different to self"
		^self].
	^AndEnvironment onEnvironment: self and: anEnvironment!

| anEnvironment
	"If anEnvironment includes everything, then return it instead of creating an Or that will include everything."

	anEnvironment isSystem ifTrue: [
		"Or'd environment contains everything, so disjunction would also contain everything"
		^anEnvironment].
	^OrEnvironment onEnvironment: self or: anEnvironment!

allClasses
	"Answer all the unique non-metaclasses of all the classes and metaclasses in this environment."

	"Note the inconsistency with allClassesDo:, which enumerates both class and metaclasses, and might have been better named #allBehaviorsDo:"

	| allClasses |
	allClasses := Array writeStream: 4096.
	self classesDo: [:each | each isMeta ifFalse: [allClasses nextPut: each]].
	^allClasses contents!

allClassesDo: aBlock
	"Private - Evaluate the <monadicValuable> argument, aBlock, for every class that could possibly be included in the receiver."

	progressBlock
		ifNil: [Smalltalk allBehaviorsDo: aBlock]
		ifNotNil: [self allClassesWithProgressDo: aBlock]!

allClassesWithProgressDo: aBlock
	| step allClasses numClasses |
	allClasses := Smalltalk allClasses.
	numClasses := allClasses size.
	step := numClasses // 100.
	progressBlock value: 0.
	1 to: numClasses
		do: 
			[:i |
			| class |
			aBlock
				value: (class := allClasses at: i);
				value: class class.
			i \\ step == 0 ifTrue: [progressBlock value: i * 100 // numClasses]].
	^progressBlock value: 100!

approximateNumberOfClasses
	^8!

classesDo: aBlock 
	self 
		allClassesDo: [:each | (self includesClass: each) ifTrue: [aBlock value: each]]!

classNames
	| names |
	names := Set new: self approximateNumberOfClasses.
	self classesDo: [:each | names add: each instanceClass fullName].
	^names!

definesClass: aClass
	"Answer whether this environment includes the primary definition of the class argument."

	"The majority of environment wrapper types do not include the primary definition."

	^false!

environment
	^environment!

includesCategory: aCategory
	^environment includesCategory: aCategory!

includesClass: aClass 
	^environment includesClass: aClass!

includesClassOrMetaclass: aClass
	"Answer whether this environment includes any part of the class, even a single method."

	^(self includesClass: aClass) or: [self includesClass: aClass class]!

includesProtocol: aProtocol in: aClass
	^(self includesClass: aClass)
		and: [environment includesProtocol: aProtocol in: aClass]!

includesSelector: aSelector in: aClass
	^(self includesClass: aClass)
		and: [environment includesSelector: aSelector in: aClass]!

isEmpty
	self classesDo: [:each | ^false].
	^true!

isSystem
	^false!

labelFormats
	^##(IdentityDictionary withAll: {
				#definitions -> 'Definitions of <1p> in <2p>'.
				#bindingReferences -> 'References to <1p> in <2p>'.
				#classReferences -> 'References to <1p>, or its static variables, in <2p>'.
				#classVarReferences -> 'Methods that reference <1p>.<2s> in <3p>'.
				#instVarReferences -> 'Methods that reference <1p>.<2s> in <3p>'.
				#instVarReaders -> 'Methods that read <1p>.<2s> in <3p>'.
				#instVarWriters -> 'Methods that assign to <1p>.<2s> in <3p>'.
				#literalReferences -> 'References to <1p> in <2p>'.
				#method -> '<1p>>><2p>'.
				#methodCategory -> 'Methods of <2p> in category <1d>'.
				#methodCategories -> 'Methods of <2p> in categories <1d>'.
				#references -> 'References to <1p> in <2p>'.
				#variableReferences -> 'References to <1d> in <2p>'.
				#localHierarchy -> 'Local hierarchy of <1p> in <2p>'.
				#subclassHierarchy -> 'Subclass hierarchy of <1p> in <2p>'.
				#superclassHierarchy -> 'Superclass hierarchy of <1p> in <2p>'.
				#someMethods -> 'Some methods in <2p>'.
				#someMethodsOf -> 'Some methods of <1p> in <2p>'.
				#annotated -> 'Methods annotated with <1d> in <2p>'.
				#containing -> 'Methods containing <3s>: <1p> in <2p>'.
				#bytecode -> 'Methods with bytecode <1p> in <2p>'.
				#thisContext -> 'Methods referencing thisContext in <2p>'.
				#snapshot -> 'Snapshot of <2p>'
			})!

not
	^NotEnvironment onEnvironment: self!

numberClasses
	^self classNames size!

numberSelectors
	| total |
	total := 0.
	self selectorsDo: [:eachSelector | total := total + 1].
	^total!

onEnvironment: anEnvironment
	environment := anEnvironment!

progressBlock
	^progressBlock ?? [:p | ]!

progressBlock: aMonadicValuable 
	progressBlock := aMonadicValuable!

storeOn: aStream
	aStream
		nextPutAll: '(';
		nextPutAll: self class fullName;
		nextPutAll: ' onEnvironment: '.
	environment storeOn: aStream.
	aStream nextPut: $)! !

!Refactory.Browser.BrowserEnvironmentWrapper categoriesForMethods!
&!environments!public! !
|!environments!public! !
allClasses!enumerating!public! !
allClassesDo:!enumerating!private! !
allClassesWithProgressDo:!enumerating!private! !
approximateNumberOfClasses!accessing!private! !
classesDo:!accessing/classes!public! !
classNames!accessing/classes!public! !
definesClass:!public!testing! !
environment!accessing!public! !
includesCategory:!public!testing! !
includesClass:!public!testing! !
includesClassOrMetaclass:!public!testing! !
includesProtocol:in:!public!testing! !
includesSelector:in:!public!testing! !
isEmpty!public!testing! !
isSystem!public!testing! !
labelFormats!constants!public! !
not!environments!public! !
numberClasses!accessing!public! !
numberSelectors!accessing!public! !
onEnvironment:!initialize/release!public! !
progressBlock!accessing!public! !
progressBlock:!accessing!public! !
storeOn:!printing!public! !
!

!Refactory.Browser.BrowserEnvironmentWrapper class methodsFor!

new
	^self onEnvironment: BrowserEnvironment new!

onEnvironment: anEnvironment 
	^(self basicNew)
		initialize;
		onEnvironment: anEnvironment;
		yourself! !

!Refactory.Browser.BrowserEnvironmentWrapper class categoriesForMethods!
new!instance creation!public! !
onEnvironment:!instance creation!public! !
!

