"Filed out from Dolphin Smalltalk"!

BrowserEnvironmentWrapper subclass: #NotEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NotEnvironment guid: (GUID fromString: '{8aa751c1-7180-4413-8b57-c60fc841bf12}')!

NotEnvironment comment: 'NotEnvironment is a <BrowserEnvironmentWrapper> which includes all methods in the system that are not in the <BrowserEnvironment> it wraps. NotEnvironments are constructed by sending the #not message to an existing <BrowserEnvironment>.

Note that a NotEnvironment may include classes that are also included in the environment it inverts, because both may include methods of that class if the original environment includes only a slice of methods in the class.'!

!NotEnvironment categoriesForClass!Refactory-Environments! !

!NotEnvironment methodsFor!

defaultLabel
	^'!!(' , environment label , ')'!

definesClass: aClass
	^(environment definesClass: aClass) not!

includesCategory: aCategory 
	^(self classNamesFor: aCategory) notEmpty!

includesClass: aClass
	"A <NotEnvironment> includes a class if its wrapped environment does not include the class,
	or only partially includes it."

	(environment includesClass: aClass) ifFalse: [^true].
	#rbFix.	"If the inverse environment does not include the whole class, then we must include some of it"
	aClass selectorsDo: [:each | (environment includesSelector: each in: aClass) ifFalse: [^true]].
	^false!

includesProtocol: aProtocol in: aClass 
	^(self selectorsFor: aProtocol in: aClass) notEmpty!

includesSelector: aSelector in: aClass
	^(environment includesSelector: aSelector in: aClass) not!

not
	^environment!

numberSelectors
	#rbFix.	"Overridden for improved performance only - at least it makes the environment tests a bit faster"
	^BrowserEnvironment new numberSelectors - self environment numberSelectors!

storeOn: aStream
	environment storeOn: aStream.
	aStream nextPutAll: ' not'! !

!NotEnvironment categoriesForMethods!
defaultLabel!constants!private! !
definesClass:!public!testing! !
includesCategory:!public!testing! !
includesClass:!public!testing! !
includesProtocol:in:!public!testing! !
includesSelector:in:!public!testing! !
not!environments!public! !
numberSelectors!public! !
storeOn:!printing!public! !
!

