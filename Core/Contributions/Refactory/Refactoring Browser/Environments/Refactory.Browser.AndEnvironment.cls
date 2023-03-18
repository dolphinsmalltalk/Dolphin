"Filed out from Dolphin Smalltalk"!

Refactory.Browser.BrowserEnvironmentWrapper
	subclass: #'Refactory.Browser.AndEnvironment'
	instanceVariableNames: 'andedEnvironment'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.AndEnvironment guid: (Core.GUID fromString: '{43ed7adb-6481-4a93-8ebe-b0861fc1ac52}')!
Refactory.Browser.AndEnvironment comment: ''!
!Refactory.Browser.AndEnvironment categoriesForClass!Refactory-Environments! !
!Refactory.Browser.AndEnvironment methodsFor!

andedEnvironment
	^andedEnvironment!

andedEnvironment: aBrowserEnvironment 
	andedEnvironment := aBrowserEnvironment!

classesDo: aBlock 
	environment 
		classesDo: [:each | (self includesClass: each) ifTrue: [aBlock value: each]]!

definesClass: aClass
	^(environment definesClass: aClass) and: [andedEnvironment definesClass: aClass]!

includesCategory: aCategory 
	^(self classNamesFor: aCategory) notEmpty!

includesClass: aClass 
	| doesntHaveSelectors |
	(environment includesClass: aClass) ifFalse: [^false].
	(andedEnvironment includesClass: aClass) ifFalse: [^false].
	doesntHaveSelectors := true.
	environment selectorsForClass: aClass
		do: 
			[:each | 
			doesntHaveSelectors := false.
			(andedEnvironment includesSelector: each in: aClass) ifTrue: [^true]].
	^doesntHaveSelectors!

includesProtocol: aProtocol in: aClass 
	^(self selectorsFor: aProtocol in: aClass) notEmpty!

includesSelector: aSelector in: aClass 
	^(environment includesSelector: aSelector in: aClass) 
		and: [andedEnvironment includesSelector: aSelector in: aClass]!

numberSelectors
	| total |
	total := 0.
	environment classesAndSelectorsDo: 
			[:each :sel | 
			(andedEnvironment includesSelector: sel in: each) 
				ifTrue: [total := total + 1]].
	^total!

problemCount
	^environment isClassEnvironment 
		ifTrue: [self numberClasses]
		ifFalse: [super problemCount]!

selectorsForClass: aClass do: aBlock 
	environment selectorsForClass: aClass
		do: 
			[:each | 
			(andedEnvironment includesSelector: each in: aClass) 
				ifTrue: [aBlock value: each]]!

storeOn: aStream 
	aStream nextPut: $(.
	environment storeOn: aStream.
	aStream nextPutAll: ' & '.
	andedEnvironment storeOn: aStream.
	aStream nextPut: $)! !
!Refactory.Browser.AndEnvironment categoriesForMethods!
andedEnvironment!accessing!private! !
andedEnvironment:!initialize/release!public! !
classesDo:!accessing!public! !
definesClass:!public!testing! !
includesCategory:!public! !
includesClass:!public!testing! !
includesProtocol:in:!public! !
includesSelector:in:!public!testing! !
numberSelectors!accessing!public! !
problemCount!accessing!public! !
selectorsForClass:do:!accessing!public! !
storeOn:!printing!public! !
!

!Refactory.Browser.AndEnvironment class methodsFor!

onEnvironment: anEnvironment and: anotherEnvironment 
	^(self onEnvironment: anEnvironment)
		andedEnvironment: anotherEnvironment;
		yourself! !
!Refactory.Browser.AndEnvironment class categoriesForMethods!
onEnvironment:and:!instance creation!public! !
!

