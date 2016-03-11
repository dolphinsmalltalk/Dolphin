"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #DolphinTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinTest guid: (GUID fromString: '{6444F9C6-8A25-4F8A-BADE-5F08D7C882BE}')!
DolphinTest comment: ''!
!DolphinTest categoriesForClass!Unclassified! !
!DolphinTest methodsFor!

assertIs: cloneObject deepCopyOf: sourceObject 
	self 
		assertIs: cloneObject
		deepCopyOf: sourceObject
		visited: IdentityDictionary new!

assertIs: cloneObject deepCopyOf: sourceObject visited: anIdentityDictionary 
	((sourceObject isNil and: [cloneObject isNil]) or: [anIdentityDictionary includes: cloneObject]) 
		ifTrue: [^self].
	self assert: (cloneObject ~~ sourceObject or: [sourceObject deepCopy == sourceObject]).
	self assert: cloneObject basicClass == sourceObject basicClass.
	self assert: cloneObject basicSize == sourceObject basicSize.
	anIdentityDictionary at: cloneObject put: sourceObject.
	1 to: cloneObject class instSize + self basicSize
		do: 
			[:i | 
			self 
				assertIs: (cloneObject instVarAt: i)
				deepCopyOf: (sourceObject instVarAt: i)
				visited: anIdentityDictionary]!

compare: x to: y epsilon: epsilon
	"Compare that the two <Float> values are equivalent to within the specified <Float> difference."

	| max |
	^(max := x abs max: y abs) <= epsilon or: [(x - y) abs < (epsilon * max)]!

createPackage: name
	| package |
	package := Package name: name.
	Package manager addPackage: package.
	^package!

createTestPackage
	^self createPackage: 'Object Arts\Dolphin\Tests\Dolphin Tests Test Package'
!

failureLog
	"dialect-specific"
	"VA - System errorLog"
	"VW, Dolphin - Transcript"
	
	^Transcript
!

hasFullClosures
	^self isD6OrLater!

isD6OrLater
	^self class isD6OrLater!

isLogging
	^true!

isOnline
	^true!

methodContextClass
	^Smalltalk at: (self hasFullClosures ifTrue: [#Context] ifFalse: [#MethodContext])!

runKnownBug: aString test: aSymbol 
	Notification 
		signal: ('Warning: Known bug <1s> tested by <2p> not run' expandMacrosWith: aString
				with: aSymbol).
	#todo.	"Make this controllable by an option or class var"
	^false!

setUp

	super setUp.
	(SessionManager inputState)
		pumpMessages;
		processDeferredActions.
!

shouldRaiseZeroDivide: aBlock
	| raised |
	Float reset.
	raised := false.
	aBlock 
		on: ZeroDivide do: [:e | raised := true]
		on: HRESULTError do: [:e | e hresult asInteger = -2147352558 ifTrue: [raised := true]].
	self assert: raised! !
!DolphinTest categoriesFor: #assertIs:deepCopyOf:!public!unit tests! !
!DolphinTest categoriesFor: #assertIs:deepCopyOf:visited:!private!unit tests! !
!DolphinTest categoriesFor: #compare:to:epsilon:!comparing!public! !
!DolphinTest categoriesFor: #createPackage:!helpers!public! !
!DolphinTest categoriesFor: #createTestPackage!helpers!public! !
!DolphinTest categoriesFor: #failureLog!Accessing!public! !
!DolphinTest categoriesFor: #hasFullClosures!public!testing! !
!DolphinTest categoriesFor: #isD6OrLater!public!testing! !
!DolphinTest categoriesFor: #isLogging!Accessing!public! !
!DolphinTest categoriesFor: #isOnline!public!unit tests! !
!DolphinTest categoriesFor: #methodContextClass!constants!private! !
!DolphinTest categoriesFor: #runKnownBug:test:!public!unit tests! !
!DolphinTest categoriesFor: #setUp!public! !
!DolphinTest categoriesFor: #shouldRaiseZeroDivide:!Accessing!public! !

!DolphinTest class methodsFor!

hasFullClosures
	^self isD6OrLater!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)!

isD6OrLater
	^VMLibrary default bytecodeVersion lowWord >= 6! !
!DolphinTest class categoriesFor: #hasFullClosures!public!testing! !
!DolphinTest class categoriesFor: #isAbstract!public!Testing! !
!DolphinTest class categoriesFor: #isD6OrLater!public!testing! !

