"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.AddPackagedMethodChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.AddPackagedMethodChangeTest guid: (Core.GUID fromString: '{08457a65-10d4-409d-93df-440bce0fac93}')!
Tools.Tests.AddPackagedMethodChangeTest comment: ''!
!Tools.Tests.AddPackagedMethodChangeTest categoriesForClass!Unclassified! !
!Tools.Tests.AddPackagedMethodChangeTest methodsFor!

changeClass
	^AddPackagedMethodChange!

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
				in: AddPackagedMethodChangeTest class
				classified: 'testing'.
	self assert: change printString readStream nextLine
		equals: '!!<1d> class methodsFor: ''testing''!!' << self class fullName.
	#'1593'.
	change protocols: #().
	self assertIsNil: change protocol.
	self assert: change printString readStream nextLine
		equals: '!!<1d> class methodsFor: ''''!!' << self class fullName! !
!Tools.Tests.AddPackagedMethodChangeTest categoriesForMethods!
changeClass!public!unit tests! !
testEnvironmentAndPackageMaintained!public!unit tests! !
testPrintOn!public!unit tests! !
!

