"Filed out from Dolphin Smalltalk 7"!

BrowserEnvironmentWrapper subclass: #OrEnvironment
	instanceVariableNames: 'oredEnvironment'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
OrEnvironment guid: (GUID fromString: '{72c876b4-b565-41f0-85a5-957532328c69}')!
OrEnvironment comment: ''!
!OrEnvironment categoriesForClass!Refactoring-Environment! !
!OrEnvironment methodsFor!

classesDo: aBlock
	| enumerated |
	enumerated := IdentitySet new.
	environment classesDo: 
			[:each |
			aBlock value: each.
			enumerated add: each].
	oredEnvironment classesDo: [:each | (enumerated includes: each) ifFalse: [aBlock value: each]]!

definesClass: aClass
	^(environment definesClass: aClass) or: [oredEnvironment definesClass: aClass]!

includesCategory: aCategory
	^(environment includesCategory: aCategory) or: [oredEnvironment includesCategory: aCategory]!

includesClass: aClass
	^(environment includesClass: aClass) or: [oredEnvironment includesClass: aClass]!

includesProtocol: aProtocol in: aClass
	^(environment includesProtocol: aProtocol in: aClass)
		or: [oredEnvironment includesProtocol: aProtocol in: aClass]!

includesSelector: aSelector in: aClass
	^(environment includesSelector: aSelector in: aClass)
		or: [oredEnvironment includesSelector: aSelector in: aClass]!

oredEnvironment: aBrowserEnvironment
	oredEnvironment := aBrowserEnvironment!

selectorsForClass: aClass do: aBlock
	| enumerated |
	enumerated := IdentitySet new: 16.
	environment selectorsForClass: aClass
		do: 
			[:each |
			enumerated add: each.
			aBlock value: each].
	oredEnvironment selectorsForClass: aClass
		do: [:each | (enumerated includes: each) ifFalse: [aBlock value: each]]!

storeOn: aStream
	aStream nextPut: $(.
	environment storeOn: aStream.
	aStream nextPutAll: ' | '.
	oredEnvironment storeOn: aStream.
	aStream nextPut: $)! !
!OrEnvironment categoriesFor: #classesDo:!accessing!public! !
!OrEnvironment categoriesFor: #definesClass:!public!testing! !
!OrEnvironment categoriesFor: #includesCategory:!public!testing! !
!OrEnvironment categoriesFor: #includesClass:!public!testing! !
!OrEnvironment categoriesFor: #includesProtocol:in:!public!testing! !
!OrEnvironment categoriesFor: #includesSelector:in:!public!testing! !
!OrEnvironment categoriesFor: #oredEnvironment:!initialization!private! !
!OrEnvironment categoriesFor: #selectorsForClass:do:!accessing!public! !
!OrEnvironment categoriesFor: #storeOn:!printing!public! !

!OrEnvironment class methodsFor!

onEnvironment: anEnvironment or: anotherEnvironment
	^(self onEnvironment: anEnvironment)
		oredEnvironment: anotherEnvironment;
		yourself! !
!OrEnvironment class categoriesFor: #onEnvironment:or:!instance creation!public! !

