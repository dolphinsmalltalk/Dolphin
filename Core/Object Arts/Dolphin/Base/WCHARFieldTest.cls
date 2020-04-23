"Filed out from Dolphin Smalltalk 7"!

ExternalFieldTest subclass: #WCHARFieldTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WCHARFieldTest guid: (GUID fromString: '{5fae7240-e0b0-4632-b957-750ef821559c}')!
WCHARFieldTest comment: ''!
!WCHARFieldTest categoriesForClass!Unclassified! !
!WCHARFieldTest methodsFor!

testReadFrom
	| struct dolphinString char subject |
	struct := DWORD new.
	dolphinString := Character dolphin asUtf16String.
	struct bytes
		wordAtOffset: 0 put: dolphinString first codeUnit;
		wordAtOffset: 2 put: dolphinString last codeUnit.
	subject := WCHARField new offset: 0; yourself.
	char := (subject readFrom: struct).
	self assert: char isUtf16Lead.
	self assert: char equals: dolphinString first.
	subject offset: 2.
	char := (subject readFrom: struct).
	self assert: char isUtf16Trail .
	self assert: char equals: dolphinString last! !
!WCHARFieldTest categoriesFor: #testReadFrom!public! !

