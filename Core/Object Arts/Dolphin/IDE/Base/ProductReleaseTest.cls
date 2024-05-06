"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #ProductReleaseTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ProductReleaseTest guid: (GUID fromString: '{685d25f7-ba9b-419b-af63-61526013895c}')!

ProductReleaseTest comment: ''!

!ProductReleaseTest categoriesForClass!Unclassified! !

!ProductReleaseTest methodsFor!

checkNoClass: aSymbol
	self specialAssert: (Smalltalk lookup: aSymbol) isNil!

isReleased
	^(Smalltalk lookup: #DolphinOAEdition) isNil!

specialAssert: aBoolean 
	"Private - In an released development environment assert that aBoolean is true. In an OA development
	environment assert that aBoolean is false"

	self assert: (self isReleased ifTrue: [aBoolean] ifFalse: [aBoolean not])!

testCompilationFailures
	| failed |
	failed := '*-compilation failures' asMethodCategory methods.
	self assert: failed asArray equals: #()! !

!ProductReleaseTest categoriesForMethods!
checkNoClass:!public!unit tests! !
isReleased!private!unit tests! !
specialAssert:!private!unit tests! !
testCompilationFailures!public!unit tests! !
!

