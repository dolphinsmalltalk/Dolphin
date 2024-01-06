"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Tools.Tests.DisassemblerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.DisassemblerTest guid: (Core.GUID fromString: '{0e5ffada-8287-4392-9b23-1146198af056}')!
Tools.Tests.DisassemblerTest comment: ''!
!Tools.Tests.DisassemblerTest methodsFor!

testExLongPushImmediate
	| method |
	method := Compiler
				compileExpression: '{##(SmallInteger minimum).  ##(SmallInteger maximum).  32768. -32769}'
				in: Object.
	self assert: (Disassembler method: method) disassemble
		equals: '	1	Push -1073741824
	6	Push 1073741823
	11	Push 32768
	16	Push -32769
	21	Push Static[0]: #Array -> Array
	22	Push 4
	24	Send[1]: #newFromStack: with 1 args
	25	Return'! !
!Tools.Tests.DisassemblerTest categoriesForMethods!
testExLongPushImmediate!public! !
!

