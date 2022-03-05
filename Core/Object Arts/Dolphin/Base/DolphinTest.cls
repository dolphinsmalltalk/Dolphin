"Filed out from Dolphin Smalltalk"!

TestCase subclass: #DolphinTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinTest guid: (GUID fromString: '{6444f9c6-8a25-4f8a-bade-5f08d7c882be}')!
DolphinTest isAbstract: true!
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

isAtLeastVmVersion: anArray
	^VMLibrary default versionInfo fileVersion >= (self versionFromParts: anArray)!

isLogging
	^true!

isOnline
	^true!

methodContextClass
	^Context!

runKnownBug: aString test: aSymbol 
	Notification 
		signal: ('Warning: Known bug <1s> tested by <2p> not run' expandMacrosWith: aString
				with: aSymbol).
	#todo.	"Make this controllable by an option or class var"
	^false!

shouldRaiseZeroDivide: aBlock
	| raised |
	Float reset.
	raised := false.
	aBlock 
		on: ZeroDivide do: [:e | raised := true]
		on: HRESULTError do: [:e | e hresult asInteger = -2147352558 ifTrue: [raised := true]].
	self assert: raised!

versionFromParts: versionNumbers
	^versionNumbers inject: 0 into: [:sum :each | (sum << 16) + each]! !
!DolphinTest categoriesForMethods!
assertIs:deepCopyOf:!public!unit tests! !
assertIs:deepCopyOf:visited:!private!unit tests! !
compare:to:epsilon:!comparing!public! !
createPackage:!helpers!public! !
createTestPackage!helpers!public! !
failureLog!Accessing!public! !
isAtLeastVmVersion:!private!testing! !
isLogging!Accessing!public! !
isOnline!public!unit tests! !
methodContextClass!constants!private! !
runKnownBug:test:!public!unit tests! !
shouldRaiseZeroDivide:!Accessing!public! !
versionFromParts:!public!unit tests! !
!

