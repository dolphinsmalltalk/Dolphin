"Filed out from Dolphin Smalltalk X6"!

BrowserEnvironmentWrapper subclass: #PluggableEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PluggableEnvironment guid: (GUID fromString: '{09CE2832-6E4A-40F8-83C8-B7685A4F6B62}')!
PluggableEnvironment comment: 'PluggableEnvironment is a Dolphin specific <BrowserEnvironment> that includes only those methods (and the classes of those methods) that pass a configurable <monadicValuable> filter. This is very useful for maintaining the contents of dynamically updating method browsers.

Instance Variables:
	filter		<monadicValuable> evaluated against each candidate method
'!
!PluggableEnvironment categoriesForClass!Refactory-Environments! !
!PluggableEnvironment methodsFor!

addMethods: methodCollection 
	^(self snapshot)
		addMethods: methodCollection;
		yourself!

classesAndSelectorsDo: aBlock 
	self 
		allClassesDo: [:each | self selectorsForClass: each do: [:sel | aBlock value: each value: sel]]!

includesAnyMethodsOf: aClass 
	aClass selectorsAndMethodsDo: 
			[:eachSelector :eachMethod | 
			(environment includesSelector: eachSelector in: aClass) 
				ifTrue: [(filter value: eachMethod) ifTrue: [^true]]].
	^false!

includesClass: aClass 
	^(super includesClass: aClass) and: [self includesAnyMethodsOf: aClass]!

includesSelector: aSelector in: aClass 
	^(super includesSelector: aSelector in: aClass) and: 
			[| method |
			method := aClass compiledMethodAt: aSelector ifAbsent: [].
			method notNil and: [filter value: method]]!

selectorsForClass: aClass do: aBlock 
	"Override for improved performance."

	aClass selectorsAndMethodsDo: 
			[:eachSelector :eachMethod | 
			((environment includesSelector: eachSelector in: aClass) and: [filter value: eachMethod]) 
				ifTrue: [aBlock value: eachSelector]]!

snapshot
	"Answer a static snapshot of this dynamic method environment."

	^(SelectorEnvironment onMethods: self allMethods in: environment)
		label: self label;
		yourself!

storeOn: aStream 
	self snapshot storeOn: aStream! !
!PluggableEnvironment categoriesFor: #addMethods:!adding!public! !
!PluggableEnvironment categoriesFor: #classesAndSelectorsDo:!accessing!public! !
!PluggableEnvironment categoriesFor: #includesAnyMethodsOf:!private!testing! !
!PluggableEnvironment categoriesFor: #includesClass:!public!testing! !
!PluggableEnvironment categoriesFor: #includesSelector:in:!public!testing! !
!PluggableEnvironment categoriesFor: #selectorsForClass:do:!enumerating!public! !
!PluggableEnvironment categoriesFor: #snapshot!accessing!private! !
!PluggableEnvironment categoriesFor: #storeOn:!printing!public! !

!PluggableEnvironment class methodsFor!

onEnvironment: anEnvironment select: aMonadicValuable 
	^(self onEnvironment: anEnvironment)
		filter: aMonadicValuable;
		yourself! !
!PluggableEnvironment class categoriesFor: #onEnvironment:select:!instance creation!public! !

