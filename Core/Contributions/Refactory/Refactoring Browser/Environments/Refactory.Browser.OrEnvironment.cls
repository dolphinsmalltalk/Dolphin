"Filed out from Dolphin Smalltalk"!

Refactory.Browser.BrowserEnvironmentWrapper
	subclass: #'Refactory.Browser.OrEnvironment'
	instanceVariableNames: 'oredEnvironment'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.OrEnvironment guid: (Core.GUID fromString: '{72c876b4-b565-41f0-85a5-957532328c69}')!
Refactory.Browser.OrEnvironment comment: ''!
!Refactory.Browser.OrEnvironment categoriesForClass!Refactoring-Environment! !
!Refactory.Browser.OrEnvironment methodsFor!

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
!Refactory.Browser.OrEnvironment categoriesForMethods!
classesDo:!accessing!public! !
definesClass:!public!testing! !
includesCategory:!public!testing! !
includesClass:!public!testing! !
includesProtocol:in:!public!testing! !
includesSelector:in:!public!testing! !
oredEnvironment:!initialization!private! !
selectorsForClass:do:!accessing!public! !
storeOn:!printing!public! !
!

!Refactory.Browser.OrEnvironment class methodsFor!

onEnvironment: anEnvironment or: anotherEnvironment
	^(self onEnvironment: anEnvironment)
		oredEnvironment: anotherEnvironment;
		yourself! !
!Refactory.Browser.OrEnvironment class categoriesForMethods!
onEnvironment:or:!instance creation!public! !
!

