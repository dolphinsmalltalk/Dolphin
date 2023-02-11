"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.ScannerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.ScannerTest guid: (Core.GUID fromString: '{f7b5ab2e-148e-4a76-acbc-60ae422b54ef}')!
Kernel.Tests.ScannerTest comment: ''!
!Kernel.Tests.ScannerTest methodsFor!

testIsSelector
	#(#a #ab #a: #ab: #a:b: #< #<= '*' '~~' #- #+ '_' '_:' '_:_:' '@' ',' #\ #/ '?')
		do: [:each | self assert: (Scanner isSelector: each)].
	#(':' '::' '' ' ' '$' '.' '#' '(' ')' '£' '🐬' '`' '"' '''' '1' 'a:b' 'a::' ';' '{' '[' '}' ']' 'ınteresting' 'camión')
		do: [:each | self deny: (Scanner isSelector: each)].
	self deny: (Scanner isSelector: String lineDelimiter)! !
!Kernel.Tests.ScannerTest categoriesForMethods!
testIsSelector!public! !
!

