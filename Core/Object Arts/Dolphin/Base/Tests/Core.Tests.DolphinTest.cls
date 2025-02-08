"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestCase
	subclass: #'Core.Tests.DolphinTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.DolphinTest guid: (Core.GUID fromString: '{6444f9c6-8a25-4f8a-bade-5f08d7c882be}')!

Core.Tests.DolphinTest isNonInstantiable: true!

Core.Tests.DolphinTest comment: ''!

!Core.Tests.DolphinTest methodsFor!

allDeepCopiedInstVarsOf: anObject
	^(1 to: anObject class instSize + anObject basicSize) collect: [:i | anObject instVarAt: i]!

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
	(self allDeepCopiedInstVarsOf: sourceObject) with: (self allDeepCopiedInstVarsOf: cloneObject)
		do: 
			[:eachSource :eachClone |
			self
				assertIs: eachClone
				deepCopyOf: eachSource
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

isAtLeastVmVersion: anArray
	^VM versionInfo fileVersion >= (self versionFromParts: anArray)!

isDolphin8OrLater
	^SessionManager current productVersion major >= 8!

isInForeground
	^SessionManager current isForegroundProcess!

isLogging
	^true!

isOnline
	| flags |
	flags := External.UInt32Bytes new.
	^OS.WinInetLibrary default internetGetConnectedState: flags dwReserved: 0!

methodContextClass
	^Context!

resourceFilename: aString
	^FileLocator installRelative localFileSpecFor: 'Resources\Tests\' , aString!

resourceStream: aString text: aBoolean
	^FileStream read: (self resourceFilename: aString) text: aBoolean!

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
	self assert: (subject propertyAt: #foo ifAbsent: 'bar') equals: 'bar'.
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
	self assertIsNil: (subject propertyAt: #foobar ifAbsent: nil).
	subject propertyAt: #foo put: #bar.
	self assert: (subject propertyAt: #foo) equals: #bar!

versionFromParts: versionNumbers
	^versionNumbers inject: 0 into: [:sum :each | (sum << 16) + each]! !

!Core.Tests.DolphinTest categoriesForMethods!
allDeepCopiedInstVarsOf:!helpers!private! !
assertIs:deepCopyOf:!helpers!private! !
assertIs:deepCopyOf:visited:!helpers!private! !
compare:to:epsilon:!comparing!public! !
createPackage:!helpers!public! !
createTestPackage!helpers!public! !
isAtLeastVmVersion:!private!testing! !
isDolphin8OrLater!private!testing! !
isInForeground!helpers!public! !
isLogging!Accessing!public! !
isOnline!public!testing! !
methodContextClass!constants!private! !
resourceFilename:!helpers!public! !
resourceStream:text:!helpers!public! !
runKnownBug:test:!helpers!public! !
shouldRaiseZeroDivide:!Accessing!public! !
verifyPropertyManagerOf:!helpers!private! !
versionFromParts:!helpers!public! !
!

