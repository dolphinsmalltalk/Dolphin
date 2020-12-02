"Filed out from Dolphin Smalltalk 7"!

BrowserEnvironmentWrapper subclass: #PluggableEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PluggableEnvironment guid: (GUID fromString: '{09ce2832-6e4a-40f8-83c8-b7685a4f6b62}')!
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
	environment classesDo: 
			[:class | 
			self selectorsForClass: class do: [:sel | aBlock value: class value: sel]]!

classesDo: aBlock
	environment classesDo: [:each | (self includesAnyMethodsOf: each) ifTrue: [aBlock value: each]]!

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
!PluggableEnvironment categoriesFor: #classesDo:!accessing!public! !
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

