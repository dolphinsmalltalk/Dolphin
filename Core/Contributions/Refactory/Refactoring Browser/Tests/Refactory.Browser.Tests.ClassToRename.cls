"Filed out from Dolphin Smalltalk"!

Core.Model subclass: #'Refactory.Browser.Tests.ClassToRename'
	instanceVariableNames: 'rewriteRule builder class'
	classVariableNames: 'ClassVar1'
	imports: #()
	classInstanceVariableNames: 'notUsed'
	classConstants: {
		'ClassConst1' -> 16r1
	}!
Refactory.Browser.Tests.ClassToRename guid: (Core.GUID fromString: '{83c27f52-b80f-487b-bd8c-b4035ca0cf2e}')!
Refactory.Browser.Tests.ClassToRename isNonInstantiable: true!
Refactory.Browser.Tests.ClassToRename comment: 'Class used to excercise RenameClassRefactory by RenameClassTest'!
!Refactory.Browser.Tests.ClassToRename categoriesForClass!Refactory-Test data! !
!Refactory.Browser.Tests.ClassToRename methodsFor!

method1
	^self method2!

method2
	^self method1!

refersToClassInCustomNamespace
	<namespace: TestData>
	^RefactoryTestDataApp!

refersToClassVariableInCustomNamespace
	<namespace: TestData.RefactoryTestDataApp>
	^ClassVar2!

refersToClassVariablePartiallyQualified
	^TestData.RefactoryTestDataApp.ClassVar1!

refersToOwnClassVariable
	^ClassVar1!

refersToOwnClassVariableFullyQualified
	^Refactory.Browser.Tests.ClassToRename.ClassVar1!

selfReference
	^ClassToRename new!

testFailure
	"Can be resolved by unqualified name through the import into the receiver's namespace"

	^TestFailure! !
!Refactory.Browser.Tests.ClassToRename categoriesForMethods!
method1!performing!public! !
method2!performing!public! !
refersToClassInCustomNamespace!lint!public! !
refersToClassVariableInCustomNamespace!lint!public! !
refersToClassVariablePartiallyQualified!lint!public! !
refersToOwnClassVariable!lint!public! !
refersToOwnClassVariableFullyQualified!lint!public! !
selfReference!performing!public! !
testFailure!performing!public! !
!

!Refactory.Browser.Tests.ClassToRename class methodsFor!

byteSize
	"Defined to allow this class to contain an external method for testing purposes."

	^4!

initialize
	ClassVar1 := 'ClassVar1 of ClassToRename'!

new
	^super new initialize!

testSkip
	"Can be resolved by unqualified name through the import into the receiver's namespace"

	^TestSkip! !
!Refactory.Browser.Tests.ClassToRename class categoriesForMethods!
byteSize!accessing!private! !
initialize!public! !
new!performing!public! !
testSkip!public! !
!

