"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestCase subclass: #'Core.Tests.DolphinTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.DolphinTest guid: (Core.GUID fromString: '{6444f9c6-8a25-4f8a-bade-5f08d7c882be}')!
Core.Tests.DolphinTest isNonInstantiable: true!
Core.Tests.DolphinTest comment: ''!
!Core.Tests.DolphinTest categoriesForClass!Unclassified! !
!Core.Tests.DolphinTest methodsFor!

assertIs: cloneObject deepCopyOf: sourceObject
	self
		assertIs: cloneObject
		deepCopyOf: sourceObject
		visited: IdentityDictionary new!

assertIs: cloneObject deepCopyOf: sourceObject visited: anIdentityDictionary
	((sourceObject isNil and: [cloneObject isNil]) or: [anIdentityDictionary includes: cloneObject])
		ifTrue: [^self].
	self assert: (cloneObject ~~ sourceObject or: [sourceObject deepCopy == sourceObject]).
	self assert: cloneObject basicClass identicalTo: sourceObject basicClass.
	self assert: cloneObject basicSize identicalTo: sourceObject basicSize.
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

createPackage: aString
	| package |
	package := Package name: aString.
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

isAtLeastVmVersion: anArray
	^VM versionInfo fileVersion >= (self versionFromParts: anArray)!

isLogging
	^true!

isOnline
	^true!

methodContextClass
	^Context!

runKnownBug: aString test: aSymbol
	Notification
		signal: ('Warning: Known bug <1s> tested by <2p> not run' expandMacrosWith: aString with: aSymbol).
	#todo.	"Make this controllable by an option or class var"
	^false!

shouldRaiseZeroDivide: aBlock
	| raised |
	Float reset.
	raised := false.
	aBlock
		on: ZeroDivide
		do: [:e | raised := true]
		on: OS.HRESULTError
		do: [:e | e hresult asInteger = -2147352558 ifTrue: [raised := true]].
	self assert: raised!

verifyPropertyManagerOf: subject
	self
		should: [subject propertyAt: #foo]
		raise: NotFoundError
		matching: [:ex | ex tag == #foo and: [ex receiver == subject]].
	self
		should: [subject removePropertyAt: #foo]
		raise: NotFoundError
		matching: [:ex | ex tag == #foo and: [ex receiver == subject]].
	self assert: (subject propertyAt: #foo ifAbsent: ['bar']) equals: 'bar'.
	self assert: (subject removePropertyAt: #foo ifAbsent: ['bar']) equals: 'bar'.
	subject propertyAt: #foo put: 123.
	self assert: (subject propertyAt: #foo) equals: 123.
	subject propertyAt: #bar put: 'abc'.
	self assert: (subject propertyAt: #bar) equals: 'abc'.
	subject propertyAt: #foobar put: 'def'.
	self assert: (subject removePropertyAt: #foo) equals: 123.
	self
		should: [subject removePropertyAt: #foo]
		raise: NotFoundError
		matching: [:ex | ex tag == #foo and: [ex receiver == subject]].
	self assert: (subject removePropertyAt: #bar ifAbsent: ['bar']) equals: 'abc'.
	self assert: (subject removePropertyAt: #bar ifAbsent: ['bar']) equals: 'bar'.
	self assert: (subject propertyAt: #foobar) equals: 'def'.
	subject removeAllProperties.
	self assertIsNil: (subject propertyAt: #foobar ifAbsent: []).
	subject propertyAt: #foo put: #bar.
	self assert: (subject propertyAt: #foo) equals: #bar!

versionFromParts: versionNumbers
	^versionNumbers inject: 0 into: [:sum :each | (sum << 16) + each]! !
!Core.Tests.DolphinTest categoriesFor: #assertIs:deepCopyOf:!public!unit tests! !
!Core.Tests.DolphinTest categoriesFor: #assertIs:deepCopyOf:visited:!private!unit tests! !
!Core.Tests.DolphinTest categoriesFor: #compare:to:epsilon:!comparing!public! !
!Core.Tests.DolphinTest categoriesFor: #createPackage:!helpers!public! !
!Core.Tests.DolphinTest categoriesFor: #createTestPackage!helpers!public! !
!Core.Tests.DolphinTest categoriesFor: #failureLog!Accessing!public! !
!Core.Tests.DolphinTest categoriesFor: #isAtLeastVmVersion:!private!testing! !
!Core.Tests.DolphinTest categoriesFor: #isLogging!Accessing!public! !
!Core.Tests.DolphinTest categoriesFor: #isOnline!public!unit tests! !
!Core.Tests.DolphinTest categoriesFor: #methodContextClass!constants!private! !
!Core.Tests.DolphinTest categoriesFor: #runKnownBug:test:!public!unit tests! !
!Core.Tests.DolphinTest categoriesFor: #shouldRaiseZeroDivide:!Accessing!public! !
!Core.Tests.DolphinTest categoriesFor: #verifyPropertyManagerOf:!helpers!private! !
!Core.Tests.DolphinTest categoriesFor: #versionFromParts:!public!unit tests! !

