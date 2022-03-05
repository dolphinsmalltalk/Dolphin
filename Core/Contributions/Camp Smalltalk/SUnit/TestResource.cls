"Filed out from Dolphin Smalltalk"!

Object subclass: #TestResource
	instanceVariableNames: 'name description'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'current'!
TestResource guid: (GUID fromString: '{69aeb725-622f-43db-a9c7-095932055892}')!
TestResource isAbstract: true!
TestResource comment: ''!
!TestResource categoriesForClass!Unclassified! !
!TestResource methodsFor!

description
	description isNil ifTrue: [^''].
	^description!

description: aString
	description := aString!

initialize
	self setUp!

isAvailable
	"override to provide information on the readiness of the resource"
	^true!

isUnavailable
	"override to provide information on the readiness of the resource"
	^self isAvailable not!

name
	name isNil ifTrue: [^self printString].
	^name!

name: aString
	name := aString!

printOn: aStream
	aStream nextPutAll: self class printString!

resources
	^self class resources!

setUp
	"Does nothing. Subclasses should override this
	to initialize their resource"!

tearDown
	"Does nothing. Subclasses should override this
	to tear down their resource"! !
!TestResource categoriesForMethods!
description!Accessing!public! !
description:!Accessing!public! !
initialize!Init / Release!public! !
isAvailable!public!Testing! !
isUnavailable!public!Testing! !
name!Accessing!public! !
name:!Accessing!public! !
printOn:!Printing!public! !
resources!public! !
setUp!public!Running! !
tearDown!public!Running! !
!

!TestResource class methodsFor!

current
	current isNil ifTrue: [current := self new].
	^current!

current: aTestResource
	current := aTestResource!

isAvailable
	^self current notNil and: [self current isAvailable]!

isUnavailable
	^self isAvailable not!

new
	^super new initialize!

reset

	current notNil ifTrue: [
		[current tearDown] ensure: [
			current := nil]]!

resources
	^#()!

signalInitializationError
	^TestResult signalErrorWith: 'Resource ' , self name , ' could not be initialized'! !
!TestResource class categoriesForMethods!
current!Accessing!public! !
current:!Accessing!public! !
isAvailable!public!Testing! !
isUnavailable!public!Testing! !
new!Creation!public! !
reset!Creation!public! !
resources!public! !
signalInitializationError!public!Running! !
!

