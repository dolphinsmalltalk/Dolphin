"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.BrowserEnvironmentWrapper subclass: #'Refactory.Browser.PluggableEnvironment'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.PluggableEnvironment guid: (Core.GUID fromString: '{09ce2832-6e4a-40f8-83c8-b7685a4f6b62}')!
Refactory.Browser.PluggableEnvironment comment: 'PluggableEnvironment is a Dolphin specific <BrowserEnvironment> that includes only those methods (and the classes of those methods) that pass a configurable <monadicValuable> filter. This is very useful for maintaining the contents of dynamically updating method browsers.

Instance Variables:
	filter		<monadicValuable> evaluated against each candidate method
'!
!Refactory.Browser.PluggableEnvironment categoriesForClass!Refactory-Environments! !
!Refactory.Browser.PluggableEnvironment methodsFor!

addMethods: methodCollection 
	^(self snapshot)
		addMethods: methodCollection;
		yourself!

classesAndSelectorsDo: aBlock 
	self allClassesDo: 
			[:class | 
			self selectorsForClass: class do: [:sel | aBlock value: class value: sel]]!

classesDo: aBlock
	self allClassesDo: [:each | (self includesAnyMethodsOf: each) ifTrue: [aBlock value: each]]!

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
!Refactory.Browser.PluggableEnvironment categoriesFor: #addMethods:!adding!public! !
!Refactory.Browser.PluggableEnvironment categoriesFor: #classesAndSelectorsDo:!accessing!public! !
!Refactory.Browser.PluggableEnvironment categoriesFor: #classesDo:!accessing!public! !
!Refactory.Browser.PluggableEnvironment categoriesFor: #includesAnyMethodsOf:!private!testing! !
!Refactory.Browser.PluggableEnvironment categoriesFor: #includesClass:!public!testing! !
!Refactory.Browser.PluggableEnvironment categoriesFor: #includesSelector:in:!public!testing! !
!Refactory.Browser.PluggableEnvironment categoriesFor: #selectorsForClass:do:!enumerating!public! !
!Refactory.Browser.PluggableEnvironment categoriesFor: #snapshot!accessing!private! !
!Refactory.Browser.PluggableEnvironment categoriesFor: #storeOn:!printing!public! !

!Refactory.Browser.PluggableEnvironment class methodsFor!

onEnvironment: anEnvironment select: aMonadicValuable 
	^(self onEnvironment: anEnvironment)
		filter: aMonadicValuable;
		yourself! !
!Refactory.Browser.PluggableEnvironment class categoriesFor: #onEnvironment:select:!instance creation!public! !

