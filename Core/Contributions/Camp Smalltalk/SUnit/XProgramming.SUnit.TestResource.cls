"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'XProgramming.SUnit.TestResource'
	instanceVariableNames: 'name description'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'current'
	classConstants: {}!
XProgramming.SUnit.TestResource guid: (Core.GUID fromString: '{69aeb725-622f-43db-a9c7-095932055892}')!
XProgramming.SUnit.TestResource isNonInstantiable: true!
XProgramming.SUnit.TestResource comment: ''!
!XProgramming.SUnit.TestResource categoriesForClass!Unclassified! !
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
!XProgramming.SUnit.TestResource categoriesFor: #description!Accessing!public! !
!XProgramming.SUnit.TestResource categoriesFor: #description:!Accessing!public! !
!XProgramming.SUnit.TestResource categoriesFor: #initialize!Init / Release!public! !
!XProgramming.SUnit.TestResource categoriesFor: #isAvailable!public!Testing! !
!XProgramming.SUnit.TestResource categoriesFor: #isUnavailable!public!Testing! !
!XProgramming.SUnit.TestResource categoriesFor: #name!Accessing!public! !
!XProgramming.SUnit.TestResource categoriesFor: #name:!Accessing!public! !
!XProgramming.SUnit.TestResource categoriesFor: #printOn:!Printing!public! !
!XProgramming.SUnit.TestResource categoriesFor: #resources!public! !
!XProgramming.SUnit.TestResource categoriesFor: #setUp!public!Running! !
!XProgramming.SUnit.TestResource categoriesFor: #tearDown!public!Running! !

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
!XProgramming.SUnit.TestResource class categoriesFor: #current!Accessing!public! !
!XProgramming.SUnit.TestResource class categoriesFor: #current:!Accessing!public! !
!XProgramming.SUnit.TestResource class categoriesFor: #isAvailable!public!Testing! !
!XProgramming.SUnit.TestResource class categoriesFor: #isUnavailable!public!Testing! !
!XProgramming.SUnit.TestResource class categoriesFor: #new!Creation!public! !
!XProgramming.SUnit.TestResource class categoriesFor: #reset!Creation!public! !
!XProgramming.SUnit.TestResource class categoriesFor: #resources!public! !
!XProgramming.SUnit.TestResource class categoriesFor: #signalInitializationError!public!Running! !

