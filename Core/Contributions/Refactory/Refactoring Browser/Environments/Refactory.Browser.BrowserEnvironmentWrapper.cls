"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.BrowserEnvironment subclass: #'Refactory.Browser.BrowserEnvironmentWrapper'
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

allClasses
	"Answer all the unique non-metaclasses of all the classes and metaclasses in this environment."

	"Note the inconsistency with allClassesDo:, which enumerates both class and metaclasses, and might have been better named #allBehaviorsDo:"

	| allClasses |
	allClasses := Array writeStream: 4096.
	self classesDo: [:each | each isMeta ifFalse: [allClasses nextPut: each]].
	^allClasses contents!

allClassesDo: aBlock
	"Private - Evaluate the <monadicValuable> argument, aBlock, for every class that could possibly be included in the receiver."

	| allClasses |
	allClasses := Smalltalk allClasses.
	progressBlock
		ifNil: 
			[1 to: allClasses size
				do: 
					[:i |
					| class |
					aBlock
						value: (class := allClasses at: i);
						value: class class]]
		ifNotNil: 
			[:progress |
			| numClasses step |
			numClasses := allClasses size.
			step := numClasses // 100.
			progress value: 0.
			1 to: numClasses
				do: 
					[:i |
					| class |
					aBlock
						value: (class := allClasses at: i);
						value: class class.
					i \\ step == 0 ifTrue: [progress value: i * 100 // numClasses]].
			progress value: 100]!

classesDo: aBlock 
	self 
		allClassesDo: [:each | (self includesClass: each) ifTrue: [aBlock value: each]]!

classNames
	| names |
	names := Set new.
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
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #allClasses!enumerating!public! !
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #allClassesDo:!enumerating!private! !
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #classesDo:!accessing/classes!public! !
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #classNames!accessing/classes!public! !
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #definesClass:!public!testing! !
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #environment!accessing!private! !
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #includesCategory:!public!testing! !
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #includesClass:!public!testing! !
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #includesProtocol:in:!public!testing! !
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #includesSelector:in:!public!testing! !
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #isEmpty!public!testing! !
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #isSystem!public!testing! !
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #numberSelectors!accessing!public! !
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #onEnvironment:!initialize/release!public! !
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #progressBlock!accessing!public! !
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #progressBlock:!accessing!public! !
!Refactory.Browser.BrowserEnvironmentWrapper categoriesFor: #storeOn:!printing!public! !

!Refactory.Browser.BrowserEnvironmentWrapper class methodsFor!

new
	^self onEnvironment: BrowserEnvironment new!

onEnvironment: anEnvironment 
	^(self basicNew)
		initialize;
		onEnvironment: anEnvironment;
		yourself! !
!Refactory.Browser.BrowserEnvironmentWrapper class categoriesFor: #new!instance creation!public! !
!Refactory.Browser.BrowserEnvironmentWrapper class categoriesFor: #onEnvironment:!instance creation!public! !

