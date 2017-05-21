"Filed out from Dolphin Smalltalk 7"!

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
	self specialAssert: (Smalltalk at: aSymbol ifAbsent: []) isNil!

isReleased
	^(Smalltalk at: #DolphinOAEdition ifAbsent: []) isNil!

specialAssert: aBoolean 
	"Private - In an released development environment assert that aBoolean is true. In an OA development
	environment assert that aBoolean is false"

	self assert: (self isReleased ifTrue: [aBoolean] ifFalse: [aBoolean not])!

testCompilationFailures
	| failed |
	failed := (MethodCategory name: '*-compilation failures') contents.
	self assert: failed isEmpty! !
!ProductReleaseTest categoriesFor: #checkNoClass:!public!unit tests! !
!ProductReleaseTest categoriesFor: #isReleased!private!unit tests! !
!ProductReleaseTest categoriesFor: #specialAssert:!private!unit tests! !
!ProductReleaseTest categoriesFor: #testCompilationFailures!private!unit tests! !

