"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ChangeObjectTest subclass: #'Refactory.Browser.Tests.AddMethodChangeTest'
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
	^Refactory.Browser.AddMethodChange!

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
				in: AddMethodChangeTest class
				categories: #('testing').
	self assert: change printString
		equals: '!!<1d> class methodsFor!!

isAbstract ^false!! !!
!!<1d> class categoriesFor: #isAbstract!!testing!! !!
'
				<< self class fullName.
	#'1593'.
	change protocols: #().
	self assert: change printString
		equals: '!!<1d> class methodsFor!!

isAbstract ^false!! !!' << self class fullName! !
!Refactory.Browser.Tests.AddMethodChangeTest categoriesForMethods!
changeClass!public!unit tests! !
testEnvironmentAndPackageMaintained!public!unit tests! !
testPrintOn!public!unit tests! !
!

