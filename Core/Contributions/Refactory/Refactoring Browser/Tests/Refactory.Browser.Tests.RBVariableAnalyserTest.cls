"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest
	subclass: #'Refactory.Browser.Tests.RBVariableAnalyserTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.RBVariableAnalyserTest guid: (Core.GUID fromString: '{07c92c36-1991-47fc-985b-c10d3a2ad06f}')!

Refactory.Browser.Tests.RBVariableAnalyserTest comment: ''!

!Refactory.Browser.Tests.RBVariableAnalyserTest categoriesForClass!Refactory-Testing! !

!Refactory.Browser.Tests.RBVariableAnalyserTest methodsFor!

testNamespaceAnnotation
	"Test that a namepace annotation is bound, and allows unqualified names reachable from that namespace to be bound."

	| parseTree tags namespaceAnnotation namespace browserEnv message rbModelRef variable |
	parseTree := self
				parseMethod: 'newEnv <namespace: Refactory.Browser> ^BrowserEnvironment forClasses: #{RBModel} value'.
	tags := parseTree tags.
	namespaceAnnotation := tags first.
	namespace := namespaceAnnotation arguments first.
	self assertIsNil: namespace variable.
	message := parseTree body statements first value.
	browserEnv := message receiver.
	self assertIsNil: browserEnv variable.
	rbModelRef := message arguments first receiver.
	RBVariableAnalyser analyseParseTree: parseTree.
	variable := namespace variable.
	self assert: variable binding identicalTo: Refactory.Browser binding.
	self deny: namespace isBindingChanged.
	self assert: browserEnv variable binding identicalTo: Refactory.Browser.BrowserEnvironment binding.
	self assert: rbModelRef binding identicalTo: Refactory.Browser.RBModel binding!

testNamespaceAnnotationInModel
	"As testNamespaceAnnotation, but in a refactoring model"

	| model parseTree tags namespaceAnnotation namespace browserEnv message rbModelRef |
	model := RBModel new.
	parseTree := self parseMethod: 'newEnv <namespace: Refactory.Browser> ^BrowserEnvironment forClasses: #{RBModel} value'
				in: (model classFor: UndefinedObject).
	tags := parseTree tags.
	namespaceAnnotation := tags first.
	namespace := namespaceAnnotation arguments first.
	self assertIsNil: namespace variable.
	message := parseTree body statements first value.
	browserEnv := message receiver.
	self assertIsNil: browserEnv variable.
	rbModelRef := message arguments first receiver.
	RBVariableAnalyser analyseParseTree: parseTree.
	self assert: namespace variable binding identicalTo: (model classFor: Refactory.Browser) binding.
	self assert: browserEnv variable binding
		identicalTo: (model classFor: Refactory.Browser.BrowserEnvironment) binding.
	self assert: rbModelRef binding identicalTo: (model classFor: Refactory.Browser.RBModel) binding! !

!Refactory.Browser.Tests.RBVariableAnalyserTest categoriesForMethods!
testNamespaceAnnotation!public! !
testNamespaceAnnotationInModel!public! !
!

