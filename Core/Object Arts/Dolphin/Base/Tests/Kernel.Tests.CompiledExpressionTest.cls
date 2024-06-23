"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Kernel.Tests.CompiledExpressionTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.Tests.CompiledExpressionTest guid: (Core.GUID fromString: '{1fa499df-b290-49ea-9f78-1babcc5a62fd}')!

Kernel.Tests.CompiledExpressionTest comment: ''!

!Kernel.Tests.CompiledExpressionTest methodsFor!

testAsDebugMethodNoCustomEnvironment
	"Verifies that for an expression without a custom namespace that its debug method also does not have a custom namespace"

	| expr debugExpr |
	expr := [] method.
	self assert: expr environment identicalTo: Core.
	self assert: expr customEnvironment isNil.
	self deny: expr isDebugMethod.
	debugExpr := expr asDebugMethod.
	self assert: debugExpr isDebugMethod.
	self assert: expr environment identicalTo: Core.
	self assert: expr customEnvironment isNil!

testAsDebugMethodWithCustomEnvironment
	"Verifies that for an expression with a custom namespace that its debug method inherits the custom namespace"

	| expr debugExpr |
	expr := (Compiler
				compileExpression: self class name
				in: Object
				environment: self class environment).
	self assert: expr environment identicalTo: self class environment.
	self assert: (expr value: Object name) identicalTo: self class.
	self deny: expr isDebugMethod.
	debugExpr := expr asDebugMethod.
	self assert: debugExpr isDebugMethod.
	self assert: debugExpr environment identicalTo: self class environment.
	self assert: (debugExpr value: Object name) identicalTo: self class!

testGetDebugInfoWithCustomEnvironment
	| expr debugInfo |
	expr := Compiler
				compileExpression: self class name
				in: Object
				environment: self class environment.
	self assert: expr environment identicalTo: self class environment.
	self assert: (expr value: Object name) identicalTo: self class.
	debugInfo := expr getDebugInfo.
	self deny: debugInfo method identicalTo: expr.
	self assert: debugInfo method environment identicalTo: self class environment.
	self assert: (debugInfo method value: Object name) identicalTo: self class! !

!Kernel.Tests.CompiledExpressionTest categoriesForMethods!
testAsDebugMethodNoCustomEnvironment!public! !
testAsDebugMethodWithCustomEnvironment!public! !
testGetDebugInfoWithCustomEnvironment!public! !
!

