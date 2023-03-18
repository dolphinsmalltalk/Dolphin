"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'XProgramming.SUnit.TestResource'
	instanceVariableNames: 'name description'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'current'
	classConstants: {}!
XProgramming.SUnit.TestResource guid: (Core.GUID fromString: '{69aeb725-622f-43db-a9c7-095932055892}')!
XProgramming.SUnit.TestResource isNonInstantiable: true!
XProgramming.SUnit.TestResource comment: ''!
!XProgramming.SUnit.TestResource methodsFor!

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
!XProgramming.SUnit.TestResource categoriesForMethods!
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

!XProgramming.SUnit.TestResource class methodsFor!

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
!XProgramming.SUnit.TestResource class categoriesForMethods!
current!Accessing!public! !
current:!Accessing!public! !
isAvailable!public!Testing! !
isUnavailable!public!Testing! !
new!Creation!public! !
reset!Creation!public! !
resources!public! !
signalInitializationError!public!Running! !
!

