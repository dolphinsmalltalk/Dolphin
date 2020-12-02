"Filed out from Dolphin Smalltalk 7"!

BrowserEnvironmentWrapper subclass: #AndEnvironment
	instanceVariableNames: 'andedEnvironment'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AndEnvironment guid: (GUID fromString: '{43ed7adb-6481-4a93-8ebe-b0861fc1ac52}')!
AndEnvironment comment: ''!
!AndEnvironment categoriesForClass!Refactory-Environments! !
!AndEnvironment methodsFor!

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
!AndEnvironment categoriesFor: #andedEnvironment!accessing!private! !
!AndEnvironment categoriesFor: #andedEnvironment:!initialize/release!public! !
!AndEnvironment categoriesFor: #classesDo:!accessing!public! !
!AndEnvironment categoriesFor: #definesClass:!public!testing! !
!AndEnvironment categoriesFor: #includesCategory:!public! !
!AndEnvironment categoriesFor: #includesClass:!public!testing! !
!AndEnvironment categoriesFor: #includesProtocol:in:!public! !
!AndEnvironment categoriesFor: #includesSelector:in:!public!testing! !
!AndEnvironment categoriesFor: #numberSelectors!accessing!public! !
!AndEnvironment categoriesFor: #problemCount!accessing!public! !
!AndEnvironment categoriesFor: #selectorsForClass:do:!accessing!public! !
!AndEnvironment categoriesFor: #storeOn:!printing!public! !

!AndEnvironment class methodsFor!

onEnvironment: anEnvironment and: anotherEnvironment 
	^(self onEnvironment: anEnvironment)
		andedEnvironment: anotherEnvironment;
		yourself! !
!AndEnvironment class categoriesFor: #onEnvironment:and:!instance creation!public! !

