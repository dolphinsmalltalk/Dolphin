"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.ProductReleaseTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.ProductReleaseTest guid: (Core.GUID fromString: '{685d25f7-ba9b-419b-af63-61526013895c}')!
Tools.Tests.ProductReleaseTest comment: ''!
!Tools.Tests.ProductReleaseTest categoriesForClass!Unclassified! !
!Tools.Tests.ProductReleaseTest methodsFor!

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
	self assert: failed asArray equals: #()
	"
	(Refactory.Browser.BrowserEnvironment new forMethods: failed) browse
	"! !
!Tools.Tests.ProductReleaseTest categoriesFor: #checkNoClass:!public!unit tests! !
!Tools.Tests.ProductReleaseTest categoriesFor: #isReleased!private!unit tests! !
!Tools.Tests.ProductReleaseTest categoriesFor: #specialAssert:!private!unit tests! !
!Tools.Tests.ProductReleaseTest categoriesFor: #testCompilationFailures!public!unit tests! !

