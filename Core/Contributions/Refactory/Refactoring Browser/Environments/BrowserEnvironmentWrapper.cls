"Filed out from Dolphin Smalltalk 7"!

BrowserEnvironment subclass: #BrowserEnvironmentWrapper
	instanceVariableNames: 'environment'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BrowserEnvironmentWrapper guid: (GUID fromString: '{73290c8c-a79f-4c55-805c-41c6ed19a64b}')!
BrowserEnvironmentWrapper comment: 'BrowserEnvironmentWrapper is a wrapper for BrowserEnvironments that limits what is shown. While it does not have any #subclassResponsibility methods, it is an abstract class since it doesn''t provide any useful behavior by itself

Instance Variables:
	environment	<BrowserEnvironment>	the environment we''re wrapping'!
!BrowserEnvironmentWrapper categoriesForClass!Refactory-Environments! !
!BrowserEnvironmentWrapper methodsFor!

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

onEnvironment: anEnvironment
	environment := anEnvironment!

storeOn: aStream 
	aStream
		nextPutAll: '(';
		nextPutAll: self class name;
		nextPutAll: ' onEnvironment: '.
	environment storeOn: aStream.
	aStream nextPut: $)! !
!BrowserEnvironmentWrapper categoriesFor: #definesClass:!public!testing! !
!BrowserEnvironmentWrapper categoriesFor: #environment!accessing!private! !
!BrowserEnvironmentWrapper categoriesFor: #includesCategory:!public!testing! !
!BrowserEnvironmentWrapper categoriesFor: #includesClass:!public!testing! !
!BrowserEnvironmentWrapper categoriesFor: #includesProtocol:in:!public!testing! !
!BrowserEnvironmentWrapper categoriesFor: #includesSelector:in:!public!testing! !
!BrowserEnvironmentWrapper categoriesFor: #isEmpty!public!testing! !
!BrowserEnvironmentWrapper categoriesFor: #isSystem!public!testing! !
!BrowserEnvironmentWrapper categoriesFor: #onEnvironment:!initialize/release!public! !
!BrowserEnvironmentWrapper categoriesFor: #storeOn:!printing!public! !

!BrowserEnvironmentWrapper class methodsFor!

new
	^self onEnvironment: BrowserEnvironment new!

onEnvironment: anEnvironment 
	^(self basicNew)
		initialize;
		onEnvironment: anEnvironment;
		yourself! !
!BrowserEnvironmentWrapper class categoriesFor: #new!instance creation!public! !
!BrowserEnvironmentWrapper class categoriesFor: #onEnvironment:!instance creation!public! !

