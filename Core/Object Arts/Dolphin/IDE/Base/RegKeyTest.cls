"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #RegKeyTest
	instanceVariableNames: 'testKey'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RegKeyTest guid: (GUID fromString: '{a67b125d-54b1-4bf8-9634-222b74e70c77}')!
RegKeyTest comment: ''!
!RegKeyTest categoriesForClass!Unclassified! !
!RegKeyTest methodsFor!

setUp
	super setUp.
	testKey := RegKey userRoot createKey: 'Software\Object Arts\RegKeyTest'.!

tearDown
	super tearDown.
	RegKey userRoot removeKey: 'Software\Object Arts\Test' ifAbsent: []!

testCreateUnderRoot
	| key |
	key := RegKey userRoot createKey: self class name.
	self assert: key name = self class name.
	self assert: key pathFromRoot = self class name.
	self assert: key parentPath isEmpty.
	self assert: key parentKey = RegKey userRoot.
	RegKey userRoot removeKey: self class name.

	key := RegKey userRoot createKey: '1\2'.
	self assert: key pathFromRoot = '1\2'.
	self assert: key name = '2'.
	self assert: key parentPath = '1'.
	self assert: key parentKey pathFromRoot = '1'.
	self assert: key parentKey name = '1'.
	self assert: key parentKey parentKey = RegKey userRoot.
	RegKey userRoot removeKey: '1'.
	
	key := RegKey userRoot createKey: '1\2\3'.
	self assert: key pathFromRoot = '1\2\3'.
	self assert: key name = '3'.
	self assert: key parentPath = '1\2'.
	self assert: key parentKey pathFromRoot = '1\2'.
	self assert: key parentKey name = '2'.
	RegKey userRoot removeKey: '1'
	!

testExpandSz
	| path |
	path := KernelLibrary default expandEnvironmentStrings: '%PATH%'.
	testKey 
		valueAt: 'PATH'
		put: '%PATH%'
		type: #expandString.
	self assert: (testKey valueAt: 'PATH') = path!

testIntegerSerialisation
	| ints ints2 |
	ints := OrderedCollection new.
	ints addAll: #(-1 0 1).
	ints add: SmallInteger maximum.
	ints add: SmallInteger maximum + 1.
	ints add: SmallInteger minimum.
	ints add: SmallInteger minimum - 1.
	#(31 32 63 64 127 128 255 256) do: 
			[:each | 
			ints add: 2 ** each - 1.
			ints add: -2 ** each].
	ints := ints asArray.
	ints storeUnderRegKey: testKey as: 'testIntegerSerialisation'.
	ints2 := Object fromRegKey: (testKey at: 'testIntegerSerialisation').
	self assert: ints = ints2!

testMultiSz
	#(#() #('') #('' '') #('' 'a') #('a' '' 'b') #('a') #('a' 'ab' 'abc')) do: 
			[:array | 
			testKey valueAt: 'Array' put: array.
			self assert: (testKey valueAt: 'Array') = array]!

testParentPath
	"#parentKey broken?"

	| key oa sw hklm key2 keyName |
	key := testKey.
	keyName := self class name asString.
	self assert: key name = keyName.
	self assert: key pathFromRoot = ('Software\Object Arts\', keyName).
	self assert: key parentKey pathFromRoot = 'Software\Object Arts'.
	key := ((RegKey userRoot at: 'Software') at: 'Object Arts') at: keyName.
	self assert: key name = keyName.
	self assert: key pathFromRoot = ('Software\Object Arts\', keyName).
	oa := key parentKey.
	self assert: oa name = 'Object Arts'.
	self assert: oa pathFromRoot = 'Software\Object Arts'.
	sw := oa parentKey.
	self assert: sw name = 'Software'.
	self assert: sw pathFromRoot = 'Software'.
	hklm := sw parentKey.
	self assert: hklm name = 'HKEY_CURRENT_USER'.
	self assert: hklm pathFromRoot isEmpty.
	key := RegKey userRoot at: 'Software\Object Arts'.
	key2 := key createKey: keyName, '\Leaf'.
	2 timesRepeat: 
			[self assert: key2 name = 'Leaf'.
			self assert: key2 parentPath = ('Software\Object Arts\', keyName).
			self assert: key2 pathFromRoot = ('Software\Object Arts\', keyName, '\Leaf').
			self assert: key2 parentKey name = keyName.
			self assert: key2 parentKey parentPath = 'Software\Object Arts'.
			self assert: key2 parentKey pathFromRoot  = ('Software\Object Arts\', keyName).
			key2 := key at: keyName, '\Leaf'].
! !
!RegKeyTest categoriesFor: #setUp!private!unit tests! !
!RegKeyTest categoriesFor: #tearDown!private!unit tests! !
!RegKeyTest categoriesFor: #testCreateUnderRoot!public!unit tests! !
!RegKeyTest categoriesFor: #testExpandSz!public!unit tests! !
!RegKeyTest categoriesFor: #testIntegerSerialisation!public!unit tests! !
!RegKeyTest categoriesFor: #testMultiSz!public!unit tests! !
!RegKeyTest categoriesFor: #testParentPath!public!unit tests! !

