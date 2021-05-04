"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Refactory.Browser.Tests.AddMethodChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.AddMethodChangeTest guid: (Core.GUID fromString: '{08457a65-10d4-409d-93df-440bce0fac93}')!
Refactory.Browser.Tests.AddMethodChangeTest comment: ''!
!Refactory.Browser.Tests.AddMethodChangeTest categoriesForClass!Unclassified! !
!Refactory.Browser.Tests.AddMethodChangeTest methodsFor!

changeClass
	^DolphinAddMethodChange!

testEnvironmentAndPackageMaintained
	"Verify that a method's environment is maintained if different from it's method class', and likewise the owning package"

	| example change undo package |
	example := OS.KernelLibrary
				>> #createProcess:lpCommandLine:lpProcessAttributes:lpThreadAttributes:bInheritsHandles:dwCreationFlags:lpEnvironment:lpCurrentDirectory:lpStartupInfo:lpProcessInformation:.
	"This test will break if the example's package is updated, so perform a sanity check."
	self assert: example environment identicalTo: Smalltalk.
	package := example owningPackage.
	self assert: package ~~ OS.KernelLibrary owningPackage.
	change := self changeClass compile: example getSource in: example methodClass.
	self assert: change environment identicalTo: Smalltalk.
	self assert: change package identicalTo: package.
	undo := change asUndoOperation.
	self assert: undo environment identicalTo: Smalltalk.
	self assert: undo package identicalTo: package.
	"But normally the environment will be that of the method class"
	example := OS.KernelLibrary >> #close.
	self assert: example environment identicalTo: OS.
	self assert: example owningPackage identicalTo: OS.KernelLibrary owningPackage.
	change := self changeClass compile: example getSource in: example methodClass.
	self assert: change environment identicalTo: OS.
	self assert: change package identicalTo: OS.KernelLibrary owningPackage.
	undo := change asUndoOperation.
	self assert: undo environment identicalTo: OS.
	self assert: undo package identicalTo: OS.KernelLibrary owningPackage!

testPrintOn
	| change |
	change := self changeClass
				compile: 'isAbstract ^false'
				in: Refactory.Browser.Tests.AddMethodChangeTest class
				classified: 'testing'.
	self assert: change printString readStream nextLine
		equals: '!!Refactory.Browser.Tests.AddMethodChangeTest class methodsFor: ''testing''!!'.
	#'1593'.
	change protocols: #().
	self assertIsNil: change protocol.
	self assert: change printString readStream nextLine
		equals: '!!Refactory.Browser.Tests.AddMethodChangeTest class methodsFor: ''''!!'! !
!Refactory.Browser.Tests.AddMethodChangeTest categoriesFor: #changeClass!public!unit tests! !
!Refactory.Browser.Tests.AddMethodChangeTest categoriesFor: #testEnvironmentAndPackageMaintained!public!unit tests! !
!Refactory.Browser.Tests.AddMethodChangeTest categoriesFor: #testPrintOn!public!unit tests! !

