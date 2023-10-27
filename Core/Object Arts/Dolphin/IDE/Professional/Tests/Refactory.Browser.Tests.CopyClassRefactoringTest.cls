"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.CopyClassRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.CopyClassRefactoringTest guid: (Core.GUID fromString: '{20137dd7-fe4e-4c82-91c5-d4c2946c6465}')!
Refactory.Browser.Tests.CopyClassRefactoringTest comment: ''!
!Refactory.Browser.Tests.CopyClassRefactoringTest methodsFor!

testAlreadyExistingInstanceVar
	self shouldFail: (CopyClassRefactoring
				clone: LookupTable
				as: 'Core.Foo'
				superclass: RunArray)
		withMessage: 'RunArray or a superclass defines an instance variable ''values'''!

testBadName
	self shouldFail: (CopyClassRefactoring
				clone: self class
				as: #'Obje@ct'
				superclass: Object)
		withMessage: ClassBuilder.ErrorInvalidClassName << 'Refactory.Browser.Tests.Obje@ct'!

testCopyByteClass
	| refactoring newClass |
	refactoring := CopyClassRefactoring
				clone: ByteArray
				as: #'Refactory.Browser.TestData.Foo'
				superclass: Object.
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: #'Refactory.Browser.TestData.Foo'.
	self assert: newClass definition
		equals: 'Core.Object
	variableByteSubclass: #''Refactory.Browser.TestData.Foo''
	instanceVariableNames: ''''
	classVariableNames: ''''
	imports: #()
	classInstanceVariableNames: ''''
	classConstants: {}'.
	self verify: newClass isCopyOf: ByteArray!

testCopyClass
	| superclass progenitor refactoring newClass |
	superclass := model classNamed: 'Core.Model'.
	progenitor := model classNamed: 'Refactory.Browser.Tests.SubclassOfClassToRename'.
	refactoring := CopyClassRefactoring
				model: model
				clone: progenitor
				as: #Foo
				superclass: superclass.
	self assert: refactoring storeString
		equals: '(Refactory.Browser.CopyClassRefactoring clone: <1p> as: #''Refactory.Browser.Tests.Foo'' superclass: <2s>)'
				<< { progenitor. superclass fullName }.
	self assert: refactoring displayString
		equals: 'Clone class <1p> as Refactory.Browser.Tests.Foo' << progenitor.
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: #'Refactory.Browser.Tests.Foo'.
	self assert: newClass definition
		equals: 'Core.Model
	subclass: #''Refactory.Browser.Tests.Foo''
	instanceVariableNames: ''rewriteRule1''
	classVariableNames: ''ClassVar1 SubclassVar1''
	imports: #(#{Refactory.Browser.Tests.ClassToRename private})
	classInstanceVariableNames: ''''
	classConstants: { ''ClassConst1'' -> 16r1 }'.
	self verify: newClass isCopyOf: progenitor!

testCopyIndexedClass
	| refactoring newClass |
	refactoring := CopyClassRefactoring
				clone: LookupTable
				as: #Foo
				superclass: Object.
	self executeRefactoring: refactoring.
	"self verify: newClass isCopyOf: LookupTable"!

testDuplicateClassVarName
	| superclass refactoring |
	superclass := model classNamed: 'Refactory.Browser.Tests.SubclassOfClassToRename'.
	refactoring := CopyClassRefactoring
				model: model
				clone: RefactoryTestDataApp
				as: #Foo
				superclass: superclass.
	self assert: refactoring storeString
		equals: '(Refactory.Browser.CopyClassRefactoring clone: <1p> as: #''Refactory.Browser.TestData.Foo'' superclass: <2p>)'
				<< { RefactoryTestDataApp. superclass }.
	self assert: refactoring displayString
		equals: 'Clone class <1p> as Refactory.Browser.TestData.Foo' << RefactoryTestDataApp.
	self shouldFail: refactoring
		withMessage: 'Refactory.Browser.Tests.SubclassOfClassToRename defines class variable/constant ''ClassVar1'''!

testExistingClassName
	self shouldFail: (CopyClassRefactoring
				clone: self class
				as: #RefactoringTest
				superclass: Object)
		existingVariable: 'Refactory.Browser.Tests.RefactoringTest'!

testExistingVariableName
	self shouldFail: (CopyClassRefactoring
				clone: self class
				as: #'Kernel.SourceFiles'
				superclass: Object)
		existingVariable: 'Kernel.SourceFiles'!

testIncompatibleByteSubclassOfFixed
	self shouldFail: (CopyClassRefactoring
				clone: ByteArray
				as: #Foo
				superclass: Association)
		withMessage: ClassBuilder.ErrorByteSubclassOfFixed!

testIncompatibleByteSubclassOfVariable
	| details |
	details := ClassDetails
				className: #Foo
				superclass: Core.Array
				categories: #().
	details isBytes: true.
	self shouldFail: (AddClassRefactoring details: details subclasses: #())
		withMessage: ClassBuilder.ErrorByteSubclassOfVariable!

testIncompatibleFixedPointerSubclassOfBytes
	self shouldFail: (CopyClassRefactoring
				clone: Association
				as: #Foo
				superclass: ByteArray)
		withMessage: ClassBuilder.ErrorPointerSubclassOfBytes!

testIncompatibleFixedSubclassOfVariable
	self shouldFail: (CopyClassRefactoring
				clone: Association
				as: #Foo
				superclass: Array)
		withMessage: ClassBuilder.ErrorFixedSubclassOfVariable!

testIncompatibleVariablePointerSubclassOfBytes
	self shouldFail: (CopyClassRefactoring
				clone: Array
				as: #Foo
				superclass: ByteArray)
		withMessage: ClassBuilder.ErrorPointerSubclassOfBytes!

testNilSuperclass
	| refactoring newClass |
	refactoring := CopyClassRefactoring
				clone: RefactoryTestDataApp
				as: #Foo
				superclass: nil.
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: #'Refactory.Browser.TestData.Foo'.
	self assert: newClass definition
		equals: 'nil
	subclass: #''Refactory.Browser.TestData.Foo''
	instanceVariableNames: ''temporaryVariable''
	classVariableNames: <1p>
	imports: #(#{OS.CRTConstants})
	classInstanceVariableNames: ''''
	classConstants: { ''AppConst1'' -> ''ClassConst1 of RefactoryTestDataApp'' }'
				<< ($\x20 join: RefactoryTestDataApp classVariableNames asSortedArray).
	self verify: newClass isCopyOf: RefactoryTestDataApp!

testSuperclassIsMetaclass
	self shouldFail: (CopyClassRefactoring
				clone: self class
				as: #Foo
				superclass: RefactoringTest class)
		withMessage: 'Superclass must not be a metaclass'!

testUnsubclassable
	self shouldFail: (CopyClassRefactoring
				clone: self class
				as: #Foo
				superclass: Character)
		withMessage: ClassBuilder.ErrorUnsubclassable << Character!

verify: newClass isCopyOf: sourceClass
	self assertIsNil: newClass comment.
	self assert: newClass instanceSpec equals: sourceClass instanceSpec.
	self verifySameMethods: newClass as: sourceClass.
	self verifySameMethods: newClass metaclass as: sourceClass metaclass!

verifySameMethods: newClass as: sourceClass
	self assert: newClass selectors equals: sourceClass selectors.
	newClass methodsDo: 
			[:each |
			self assert: each parseTree equals: (sourceClass compiledMethodAt: each selector) parseTree]! !
!Refactory.Browser.Tests.CopyClassRefactoringTest categoriesForMethods!
testAlreadyExistingInstanceVar!failure tests!public! !
testBadName!failure tests!public! !
testCopyByteClass!public!tests! !
testCopyClass!public!tests! !
testCopyIndexedClass!public!tests! !
testDuplicateClassVarName!public!tests! !
testExistingClassName!failure tests!public! !
testExistingVariableName!failure tests!public! !
testIncompatibleByteSubclassOfFixed!public!tests! !
testIncompatibleByteSubclassOfVariable!public!tests! !
testIncompatibleFixedPointerSubclassOfBytes!public!tests! !
testIncompatibleFixedSubclassOfVariable!public!tests! !
testIncompatibleVariablePointerSubclassOfBytes!public!tests! !
testNilSuperclass!public!tests! !
testSuperclassIsMetaclass!failure tests!public! !
testUnsubclassable!failure tests!public! !
verify:isCopyOf:!helpers!private! !
verifySameMethods:as:!helpers!private! !
!

