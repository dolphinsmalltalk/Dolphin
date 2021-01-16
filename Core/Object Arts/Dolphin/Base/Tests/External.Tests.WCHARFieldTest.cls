"Filed out from Dolphin Smalltalk 7"!

External.Tests.ExternalFieldTest subclass: #'External.Tests.WCHARFieldTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.WCHARFieldTest guid: (Core.GUID fromString: '{5fae7240-e0b0-4632-b957-750ef821559c}')!
External.Tests.WCHARFieldTest comment: ''!
!External.Tests.WCHARFieldTest categoriesForClass!Unclassified! !
!External.Tests.WCHARFieldTest methodsFor!

testReadFrom
	| struct dolphinString char subject |
	struct := DWORD new.
	dolphinString := Character dolphin asUtf16String.
	struct bytes
		wordAtOffset: 0 put: (dolphinString at: 1) codeUnit;
		wordAtOffset: 2 put: (dolphinString at: 2) codeUnit.
	subject := WCHARField new
				offset: 0;
				yourself.
	char := subject readFrom: struct.
	self assert: char isUtf16Lead.
	self assert: char equals: (dolphinString at: 1).
	subject offset: 2.
	char := subject readFrom: struct.
	self assert: char isUtf16Trail.
	self assert: char equals: (dolphinString at: 2)!

testWriteInto
	| struct dolphinString subject actual |
	struct := DWORD new.
	dolphinString := Character dolphin asUtf16String.
	subject := WCHARField new
				offset: 0;
				yourself.
	subject writeInto: struct value: (dolphinString at: 1).
	subject offset: 2.
	subject writeInto: struct value: (dolphinString at: 2).
	actual := Utf16String fromByteArray: struct bytes.
	self assert: actual equals: dolphinString! !
!External.Tests.WCHARFieldTest categoriesFor: #testReadFrom!public! !
!External.Tests.WCHARFieldTest categoriesFor: #testWriteInto!public! !

