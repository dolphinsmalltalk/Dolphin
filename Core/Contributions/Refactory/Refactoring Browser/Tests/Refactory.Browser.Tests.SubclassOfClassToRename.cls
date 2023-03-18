"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.ClassToRename
	subclass: #'Refactory.Browser.Tests.SubclassOfClassToRename'
	instanceVariableNames: 'rewriteRule1'
	classVariableNames: 'SubclassVar1'
	imports: #(#{Refactory.Browser.Tests.ClassToRename private})
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.SubclassOfClassToRename guid: (Core.GUID fromString: '{b07793cb-e421-4358-b250-e15c44d940e5}')!
Refactory.Browser.Tests.SubclassOfClassToRename comment: ''!
!Refactory.Browser.Tests.SubclassOfClassToRename categoriesForClass!Refactory-Test data! !
!Refactory.Browser.Tests.SubclassOfClassToRename methodsFor!

calls
	^self rewriteRule1: self name , self rewriteRule1!

calls1
	^self rewriteRule1: (self rewriteRule1: self calls)!

externalReference: aClassToRename _: aClassToRename2
	<stdcall: ClassToRename* dummy Refactory.Browser.Tests.ClassToRename Tests.ClassToRename**>
	!

name
	^rewriteRule1!

refersToClassFullyQualified
	^Refactory.Browser.Tests.ClassToRename!

refersToClassFullyQualifiedBinding
	^#{Refactory.Browser.Tests.ClassToRename}!

refersToClassFullyQualifiedName
	^#'Refactory.Browser.Tests.ClassToRename'!

refersToClassPartiallyQualified1
	^Tests.ClassToRename!

refersToClassPartiallyQualified2
	^Browser.Tests.ClassToRename!

refersToClassPartiallyQualifiedBinding1
	^#{_.Tests.ClassToRename}!

refersToClassPartiallyQualifiedBinding2
	^#{_.Browser.Tests.ClassToRename}!

refersToClassPartiallyQualifiedName
	"Not considered a reference. Will not be renamed"

	^#'Tests.ClassToRename'!

refersToClassUnqualified
	^ClassToRename!

refersToClassUnqualifiedBinding
	^#{ClassToRename}!

refersToClassUnqualifiedHybrid
	^##(ClassToRename fullName) -> ClassToRename!

refersToClassUnqualifiedName
	^#ClassToRename!

refersToClassUnqualifiedStaticExpression
	^##(ClassToRename fullName)!

refersToInheritedClassConstant
	^ClassConst1!

refersToInheritedClassVariable
	^ClassVar1!

refersToInheritedClassVariableFullyQualified
	^Refactory.Browser.Tests.ClassToRename.ClassVar1!

refersToInheritedClassVariableFullyQualifiedBinding
	^#{Refactory.Browser.Tests.ClassToRename.ClassVar1}!

refersToInheritedClassVariableQualifiedByOwnName
	^SubclassOfClassToRename.ClassVar1!

refersToInheritedClassVariableUnqualifiedBinding
	^#{ClassVar1}!

refersToInheritedClassVariableWithShadowing
	| ClassVar1 |
	ClassVar1 := ClassToRename.ClassVar1, SubclassOfClassToRename.ClassVar1.
	^ClassVar1!

refersToOtherClassPartiallyQualifiedBinding
	"Not a valid relative reference to the superclass (does not bind - try sending it #value)"

	^#{_.Tools.ClassToRename}!

refersToOtherClassPartiallyQualifiedName
	"Definitely not a reference. Will not be renamed"

	^#'Tools.ClassToRename'!

rewriteRule1
	^rewriteRule1!

rewriteRule1: anObject
	^rewriteRule1 := anObject!

testSkip
	"Can be resolved by unqualified name through the import into the receiver's namespace"

	^TestSkip!

unqualifiedBindingReference
	"This is a relative reference"

	^#{ClassToRename}! !
!Refactory.Browser.Tests.SubclassOfClassToRename categoriesForMethods!
calls!accessing!public! !
calls1!accessing!public! !
externalReference:_:!performing!public! !
name!accessing!public! !
refersToClassFullyQualified!performing!public! !
refersToClassFullyQualifiedBinding!lint!public! !
refersToClassFullyQualifiedName!performing!public! !
refersToClassPartiallyQualified1!performing!public! !
refersToClassPartiallyQualified2!performing!public! !
refersToClassPartiallyQualifiedBinding1!performing!public! !
refersToClassPartiallyQualifiedBinding2!performing!public! !
refersToClassPartiallyQualifiedName!performing!public! !
refersToClassUnqualified!performing!public! !
refersToClassUnqualifiedBinding!performing!public! !
refersToClassUnqualifiedHybrid!performing!public! !
refersToClassUnqualifiedName!performing!public! !
refersToClassUnqualifiedStaticExpression!performing!public! !
refersToInheritedClassConstant!public! !
refersToInheritedClassVariable!public! !
refersToInheritedClassVariableFullyQualified!public! !
refersToInheritedClassVariableFullyQualifiedBinding!public! !
refersToInheritedClassVariableQualifiedByOwnName!public! !
refersToInheritedClassVariableUnqualifiedBinding!public! !
refersToInheritedClassVariableWithShadowing!public! !
refersToOtherClassPartiallyQualifiedBinding!performing!public! !
refersToOtherClassPartiallyQualifiedName!performing!public! !
rewriteRule1!accessing!public! !
rewriteRule1:!accessing!public! !
testSkip!performing!public! !
unqualifiedBindingReference!performing!public! !
!

