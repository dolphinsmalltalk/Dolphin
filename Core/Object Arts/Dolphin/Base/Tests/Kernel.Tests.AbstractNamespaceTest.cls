"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.AbstractNamespaceTest'
	instanceVariableNames: 'removedVariables'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.AbstractNamespaceTest guid: (Core.GUID fromString: '{8509e019-ee66-42a0-9ef9-2a5afd16b048}')!
Kernel.Tests.AbstractNamespaceTest isNonInstantiable: true!
Kernel.Tests.AbstractNamespaceTest comment: ''!
!Kernel.Tests.AbstractNamespaceTest methodsFor!

canonicalSubject
	^self subclassResponsibility!

classTestCases
	^{{'Association'. Association}. {Core.Date. Date}. {'XProgramming.SUnit.TestCase'. TestCase}}!

onVariableRemoved: aVariableBinding
	removedVariables add: aVariableBinding!

setUp
	super setUp.
	removedVariables := OrderedCollection new!

testAbsoluteName
	self subclassResponsibility!

testAbsoluteReference
	self subclassResponsibility!

testAllClasses
	self subclassResponsibility!

testIncludesKey
	self subclassResponsibility!

testRemoveLocalBindingFor
	| binding subject key changesPos |
	key := 'Aa341b325051'.
	binding := VariableBinding key: key value: 4912.
	subject := self canonicalSubject.
	changesPos := SourceManager default changesFileSize.
	
	[| ref removed |
	subject basicAddBinding: binding.
	Smalltalk
		when: #variableRemoved:
		send: #onVariableRemoved:
		to: self.
	ref := BindingReference pathString: key scope: subject.
	self assert: ref bindingOrNil identicalTo: binding.
	removed := subject removeBindingFor: key.
	self assert: removed identicalTo: binding.
	self assert: removedVariables asArray equals: {binding}.
	"Binding ref should no longer resolve, and should not returned previously cached binding"
	self assertIsNil: ref bindingOrNil.
	"Already gone, so should return nil."
	self assertIsNil: (subject removeBindingFor: key).
	"This will fail if something got written to the change log when we removed the binding, which we do not expect."
	self assert: SourceManager default changesFileSize equals: changesPos]
			ensure: 
				[Smalltalk removeEventsTriggeredFor: self.
				subject basicRemoveBinding: binding]! !
!Kernel.Tests.AbstractNamespaceTest categoriesForMethods!
canonicalSubject!private! !
classTestCases!private! !
onVariableRemoved:!private! !
setUp!private! !
testAbsoluteName!public!unit tests! !
testAbsoluteReference!public!unit tests! !
testAllClasses!public! !
testIncludesKey!public! !
testRemoveLocalBindingFor!private! !
!

