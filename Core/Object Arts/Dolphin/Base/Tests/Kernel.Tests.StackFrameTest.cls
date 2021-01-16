"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.StackFrameTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.StackFrameTest guid: (Core.GUID fromString: '{23991667-5a26-4271-a113-851da1870814}')!
Kernel.Tests.StackFrameTest comment: ''!
!Kernel.Tests.StackFrameTest categoriesForClass!Unclassified! !
!Kernel.Tests.StackFrameTest methodsFor!

testOnProcessIndex
	| topFrame frame1 frame2 originalMethod testMethod |
	topFrame := Processor activeProcess topFrame.
	frame1 := StackFrame onProcess: topFrame process index: topFrame index.
	self assert: frame1 equals: topFrame.
	originalMethod := StackFrame class lookupMethod: #onProcess:index:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	frame2 := testMethod value: StackFrame withArguments: {topFrame process. topFrame index}.
	self assert: frame2 equals: topFrame! !
!Kernel.Tests.StackFrameTest categoriesFor: #testOnProcessIndex!public!unit tests! !

