"Filed out from Dolphin Smalltalk"!

Object subclass: #TestSuite
	instanceVariableNames: 'tests resources name dependents'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

TestSuite guid: (GUID fromString: '{5e96793c-0810-11d4-a876-0050da643bf9}')!

TestSuite comment: ''!

!TestSuite categoriesForClass!SUnit! !

!TestSuite methodsFor!

addDependentToHierachy: anObject
	self addDependent: anObject.
	self tests do: [:each | each addDependentToHierachy: anObject]!

addTest: aTest
	self tests add: aTest!

addTests: aCollection 
	aCollection do: [:eachTest | self addTest: eachTest]!

defaultResources
	^self tests 
		inject: Set new
		into: 
			[:coll :testCase | 
			coll
				addAll: testCase resources;
				yourself]!

getDependents
	^dependents!

name
	^name!

name: aString
	name := aString!

removeDependentFromHierachy: anObject
	self removeDependent: anObject.
	self tests do: [:each | each removeDependentFromHierachy: anObject]!

resources
	resources isNil ifTrue: [resources := self defaultResources].
	^resources!

resources: anObject
	resources := anObject!

run
	| result |
	result := TestResult new.
	self setUp.
	[self run: result] ensure: [self tearDown].
	^result!

run: aResult
	| start |
	start := Delay microsecondClockValue.
	[self tests do: 
			[:each |
			self changed: each.
			each run: aResult]]
		ensure: [aResult duration: (Delay microsecondClockValue - start) microseconds]!

setDependents: aDependentsCollectionOrNil
	dependents := aDependentsCollectionOrNil!

setUp
	self resources do: 
			[:res |
			self changed: res.
			res isAvailable ifFalse: [res signalInitializationError]]!

tearDown
	^self resources do: [:each | each reset]!

tests
	tests isNil ifTrue: [tests := OrderedCollection new].
	^tests! !

!TestSuite categoriesForMethods!
addDependentToHierachy:!Dependencies!public! !
addTest:!Accessing!public! !
addTests:!Accessing!public! !
defaultResources!Accessing!public! !
getDependents!dependency!private! !
name!Accessing!public! !
name:!Accessing!public! !
removeDependentFromHierachy:!Dependencies!public! !
resources!Accessing!public! !
resources:!Accessing!public! !
run!public!Running! !
run:!public!Running! !
setDependents:!dependency!private! !
setUp!public!Running! !
tearDown!public!Running! !
tests!Accessing!public! !
!

!TestSuite class methodsFor!

named: aString

	^self new
		name: aString;
		yourself! !

!TestSuite class categoriesForMethods!
named:!Creation!public! !
!

