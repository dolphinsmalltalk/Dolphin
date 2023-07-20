"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'XProgramming.SUnit.TestSuite'
	instanceVariableNames: 'tests resources name dependents'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
XProgramming.SUnit.TestSuite guid: (Core.GUID fromString: '{5e96793c-0810-11d4-a876-0050da643bf9}')!
XProgramming.SUnit.TestSuite comment: ''!
!XProgramming.SUnit.TestSuite categoriesForClass!SUnit! !
!XProgramming.SUnit.TestSuite methodsFor!

addDependentToHierachy: anObject
	self addDependent: anObject.
	self tests do: [:each | each addDependentToHierachy: anObject]!

addTest: aTest
	self tests add: aTest!

addTests: aCollection 
	aCollection do: [:eachTest | self addTest: eachTest]!

defaultResources
	^self tests inject: Set new
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
	self resources do: [:res | res isAvailable ifFalse: [^res signalInitializationError]].
	[self run: result] ensure: [self resources do: [:each | each reset]].
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

tests
	tests isNil ifTrue: [tests := OrderedCollection new].
	^tests! !
!XProgramming.SUnit.TestSuite categoriesForMethods!
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
tests!Accessing!public! !
!

!XProgramming.SUnit.TestSuite class methodsFor!

named: aString

	^self new
		name: aString;
		yourself! !
!XProgramming.SUnit.TestSuite class categoriesForMethods!
named:!Creation!public! !
!

