"Filed out from Dolphin Smalltalk 7"!

Object subclass: #TestResource
	instanceVariableNames: 'name description'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'current'
	classConstants: {}!
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
!TestResource categoriesFor: #description!Accessing!public! !
!TestResource categoriesFor: #description:!Accessing!public! !
!TestResource categoriesFor: #initialize!Init / Release!public! !
!TestResource categoriesFor: #isAvailable!public!Testing! !
!TestResource categoriesFor: #isUnavailable!public!Testing! !
!TestResource categoriesFor: #name!Accessing!public! !
!TestResource categoriesFor: #name:!Accessing!public! !
!TestResource categoriesFor: #printOn:!Printing!public! !
!TestResource categoriesFor: #resources!public! !
!TestResource categoriesFor: #setUp!public!Running! !
!TestResource categoriesFor: #tearDown!public!Running! !

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
!TestResource class categoriesFor: #current!Accessing!public! !
!TestResource class categoriesFor: #current:!Accessing!public! !
!TestResource class categoriesFor: #isAvailable!public!Testing! !
!TestResource class categoriesFor: #isUnavailable!public!Testing! !
!TestResource class categoriesFor: #new!Creation!public! !
!TestResource class categoriesFor: #reset!Creation!public! !
!TestResource class categoriesFor: #resources!public! !
!TestResource class categoriesFor: #signalInitializationError!public!Running! !

