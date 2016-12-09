"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #SmalltalkParserTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ExtCallArgTypes SmalltalkParseErrorCodes'
	classInstanceVariableNames: ''!
SmalltalkParserTest guid: (GUID fromString: '{947B6D13-1A2A-43C0-8053-BDE0FCCFBD44}')!
SmalltalkParserTest comment: 'SUnitBrowser openOnTestCase: self'!
!SmalltalkParserTest categoriesForClass!Refactory-Testing! !
!SmalltalkParserTest methodsFor!

assertToken: aStToken isChar: aCharacter
	self assert: aStToken isLiteralToken.
	self assert: aStToken value == aCharacter!

parserClass
	^SmalltalkParser!

scannerClass
	^SmalltalkScanner!

testCharacterScanning
	| subject tok |
	0 to: 255
		do: 
			[:i |
			| char ch |
			ch := Character value: i.
			subject := self scannerClass on: ch printString readStream.
			char := subject next.
			self assertToken: char isChar: ch.
			self assert: subject next isEof.
			subject := self scannerClass on: ('$\x' , i asHexString) readStream.
			char := subject next.
			self assertToken: char isChar: ch.
			self assert: subject next isEof].
	subject := self scannerClass on: '$\.' readStream.
	self assertToken: subject next isChar: (Character value: 92).
	self assert: (subject next isSpecial: $.).
	subject := self scannerClass on: '$\c' readStream.
	self assertToken: subject next isChar: (Character value: 92).
	tok := subject next.
	self assert: tok isIdentifier.
	self assert: 'c' equals: tok value.
	subject := self scannerClass on: '$\xAG' readStream.
	self assertToken: subject next isChar: (Character value: 16rA).
	tok := subject next.
	self assert: tok isIdentifier.
	self assert: 'G' equals: tok value!

testExternalCallEquality
	| strings |
	strings := #('test <stdcall: void Test>' 'test <overlap stdcall: void Test>' 'test: a <stdcall: void Test dword>').
	1 to: strings size
		do: 
			[:i | 
			1 to: strings size
				do: 
					[:j | 
					self 
						deny: ((self parserClass parseMethod: (strings at: i)) 
								= (self parserClass parseMethod: (strings at: j)) xor: i = j)]]!

testExternalCalls
	| ffiCall tree src types |
	self assert: (KernelLibrary parseTreeFor: #loadLibraryEx:hFile:dwFlags:) isPrimitive.
	"Zero args"
	tree := SmalltalkParser parseMethod: 'blah <stdcall: void blah>'.
	self assert: tree formattedCode trimBlanks = 'blah
	<stdcall: void blah>'.
	ffiCall := tree tag.
	self assert: ffiCall argumentTypes isEmpty.
	self assert: ffiCall returnType typeOrdinal = ExtCallArgVOID.
	self assert: ffiCall returnType indirections = 0.
	self assert: ffiCall returnType structClass isNil.

	"One simple arg"
	tree := SmalltalkParser parseMethod: 'blah: x <stdcall: dword blah sdword>'.
	self assert: tree formattedCode trimBlanks = 'blah: x
	<stdcall: dword blah sdword>'.
	ffiCall := tree tag.
	self assert: ffiCall returnType typeOrdinal = ExtCallArgDWORD.
	self assert: ffiCall returnType indirections = 0.
	self assert: ffiCall returnType structClass isNil.
	self assert: ffiCall argumentTypes size = 1.
	ffiCall argumentTypes with: (Array with: ExtCallArgSDWORD)
		do: 
			[:eachArg :eachType |
			self assert: eachArg typeOrdinal = eachType.
			self assert: eachArg indirections = 0.
			self assert: eachArg structClass isNil].

	"Void is not a valid argument type (can only be used for return)"
	self
		should: [SmalltalkParser parseMethod: 'blah: x <stdcall: void blah void>']
		raise: SmalltalkParser errorClass
		matching: [:err | err errorCode = CErrArgTypeCannotBeVoid].

	"Mismatch between Smalltalk arguments and external argument types."
	self should: [SmalltalkParser parseMethod: 'blah: x _: y <stdcall: void blah void>']
		raise: SmalltalkParser errorClass.


	"Many simple args"
	src := String writeStream.
	types := #('lpvoid' 'char' 'byte' 'sbyte' 'word' 'sword' 'dword' 'sdword' 'bool' 'handle' 'double' 'lpstr' 'oop' 'float' 'lppvoid' 'hresult' 'lpwstr' 'qword' 'sqword' 'ote' 'bstr' 'variant' 'date' 'varbool' 'guid').
	types do: 
			[:each |
			src
				nextPutAll: each;
				nextPutAll: ': ';
				nextPutAll: each]
		separatedBy: [src space].
	src
		crtab;
		nextPutAll: '<stdcall: void fn'.
	types do: 
			[:each |
			src
				space;
				nextPutAll: each].
	src nextPut: $>.
	src := src contents.
	tree := SmalltalkParser parseMethod: src.
	self assert: tree formattedCode trimBlanks = src.
	ffiCall := tree tag.
	self assert: ffiCall argumentTypes size = types size.
	ffiCall argumentTypes with: (1 to: types size)
		do: 
			[:eachArg :eachType |
			self assert: eachArg typeOrdinal = eachType.
			self assert: eachArg indirections = 0.
			self assert: eachArg structClass isNil]! !
!SmalltalkParserTest categoriesFor: #assertToken:isChar:!helpers!private! !
!SmalltalkParserTest categoriesFor: #parserClass!constants!private! !
!SmalltalkParserTest categoriesFor: #scannerClass!constants!private! !
!SmalltalkParserTest categoriesFor: #testCharacterScanning!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testExternalCallEquality!public!unit tests! !
!SmalltalkParserTest categoriesFor: #testExternalCalls!public!unit tests! !

!SmalltalkParserTest class methodsFor!

parserClass
	^SmalltalkParser! !
!SmalltalkParserTest class categoriesFor: #parserClass!accessing!public! !

