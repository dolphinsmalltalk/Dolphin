"Filed out from Dolphin Smalltalk XP"!

Object subclass: #TestSuite
	instanceVariableNames: 'tests resources name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestSuite guid: (GUID fromString: '{5E96793C-0810-11D4-A876-0050DA643BF9}')!
TestSuite comment: ''!
!TestSuite categoriesForClass!SUnit! !
!TestSuite methodsFor!

addDependentToHierachy: anObject
	self sunitAddDependent: anObject.
	self tests do: [ :each | each addDependentToHierachy: anObject]!

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

name
	^name!

name: aString
	name := aString!

removeDependentFromHierachy: anObject
	self sunitRemoveDependent: anObject.
	self tests do: [ :each | each removeDependentFromHierachy: anObject]!

resources
	resources isNil ifTrue: [resources := self defaultResources].
	^resources!

resources: anObject
	resources := anObject!

run
	| result |
	result := TestResult new.
	self resources do: [:res | res isAvailable ifFalse: [^res signalInitializationError]].
	[self run: result] sunitEnsure: [self resources do: [:each | each reset]].
	^result!

run: aResult 
	self tests do: 
		[:each | 
		self sunitChanged: each.
		each run: aResult]!

signalResourceErrorFor: res
	^res signalInitializationError!

tests
	tests isNil ifTrue: [tests := OrderedCollection new].
	^tests! !
!TestSuite categoriesFor: #addDependentToHierachy:!Dependencies!public! !
!TestSuite categoriesFor: #addTest:!Accessing!public! !
!TestSuite categoriesFor: #addTests:!Accessing!public! !
!TestSuite categoriesFor: #defaultResources!Accessing!public! !
!TestSuite categoriesFor: #name!Accessing!public! !
!TestSuite categoriesFor: #name:!Accessing!public! !
!TestSuite categoriesFor: #removeDependentFromHierachy:!Dependencies!public! !
!TestSuite categoriesFor: #resources!Accessing!public! !
!TestSuite categoriesFor: #resources:!Accessing!public! !
!TestSuite categoriesFor: #run!public!Running! !
!TestSuite categoriesFor: #run:!public!Running! !
!TestSuite categoriesFor: #signalResourceErrorFor:!public!Running! !
!TestSuite categoriesFor: #tests!Accessing!public! !

!TestSuite class methodsFor!

named: aString

	^self new
		name: aString;
		yourself! !
!TestSuite class categoriesFor: #named:!Creation!public! !

