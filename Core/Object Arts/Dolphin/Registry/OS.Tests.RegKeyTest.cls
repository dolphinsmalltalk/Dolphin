"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.RegKeyTest'
	instanceVariableNames: 'testKey'
	classVariableNames: ''
	imports: #(#{OS.WinRegConstants})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.RegKeyTest guid: (Core.GUID fromString: '{a67b125d-54b1-4bf8-9634-222b74e70c77}')!

OS.Tests.RegKeyTest comment: ''!

!OS.Tests.RegKeyTest methodsFor!

keyPath
	^'Software\Object Arts\Dolphin Smalltalk\' , self class name!

setUp
	super setUp.
	testKey := RegKey userRoot createKey: self keyPath!

tearDown
	testKey free.
	RegKey userRoot removeSubTree: self keyPath.
	testKey := nil.
	super tearDown.
!

testClassesRootReadOnly
	| hkcr |
	hkcr := RegKey classesRoot.
	"HKCR\.exe key should exist on any machine"
	self assert: (hkcr at: '.exe') value equals: 'exefile'!

testCreateUnderRoot
	| key |
	key := RegKey userRoot createKey: self class name.
	self assert: key name equals: self class name.
	self assert: key pathFromRoot equals: self class name.
	self assert: key parentPath isEmpty.
	self assert: key parentKey equals: RegKey userRoot.
	key free.
	RegKey userRoot removeKey: self class name.
	key := RegKey userRoot createKey: '1\2'.
	self assert: key pathFromRoot equals: '1\2'.
	self assert: key name equals: '2'.
	self assert: key parentPath equals: '1'.
	self assert: key parentKey pathFromRoot equals: '1'.
	self assert: key parentKey name equals: '1'.
	self assert: key parentKey parentKey equals: RegKey userRoot.
	key free.
	RegKey userRoot removeKey: '1'.
	key := RegKey userRoot createKey: '1\2\3'.
	self assert: key pathFromRoot equals: '1\2\3'.
	self assert: key name equals: '3'.
	self assert: key parentPath equals: '1\2'.
	self assert: key parentKey pathFromRoot equals: '1\2'.
	self assert: key parentKey name equals: '2'.
	key free.
	RegKey userRoot removeKey: '1'!

testDefaultValue
	self assertIsNil: testKey value.
	#(1234 'abc' #[1 2 3] #('Abc' 'def')) do: 
			[:each |
			testKey value: each.
			self assert: testKey value equals: each].
	"Nil'ing the default value is a special case - see RegKeyAbstract>>valueAt:put:type:"
	testKey value: nil.
	self assertIsNil: testKey value!

testExpandSz
	| path |
	testKey
		valueAt: 'PATH'
		put: '%PATH%'
		type: #expandString.
	path := Kernel32 expandEnvironmentStrings: '%PATH%'.
	self assert: (testKey valueAt: 'PATH') equals: path!

testLocalMachineRootReadOnly
	| hklm |
	hklm := RegKey localMachineRoot.
	self assert: (#('SOFTWARE' 'SECURITY' 'HARDWARE' 'SAM' 'SYSTEM') difference: hklm keys) isEmpty!

testMultiSz
	"Note that no strings and one empty string, are particularly important test cases as the representation makes it easy to lose the distinction."
	#(#() #('') #('' '') #('' '' '') #('a') #('' 'a') #('a' '') #('a' '' 'ab' '' '' 'abc')#('🐬' '£ or #' 'Ḽơᶉëᶆ ȋṕšᶙṁ ḍỡḽǭᵳ ʂǐť ӓṁệẗ, ĉṓɲṩḙċťᶒțûɾ ấɖḯƥĭṩčįɳġ ḝłįʈ, șếᶑ ᶁⱺ ẽḭŭŝḿꝋď ṫĕᶆᶈṓɍ ỉñḉīḑȋᵭṵńť ṷŧ ḹẩḇőꝛế éȶ đꝍꞎôꝛȇ ᵯáꞡᶇā ąⱡîɋṹẵ' 'ẵṹɋîⱡą āᶇꞡáᵯ ȇꝛôꞎꝍđ ȶé ếꝛőḇẩḹ ŧṷ ťńṵᵭȋḑīḉñỉ ɍṓᶈᶆĕṫ ďꝋḿŝŭḭẽ ⱺᶁ ᶑếș ,ʈįłḝ ġɳįčṩĭƥḯɖấ ɾûțᶒťċḙṩɲṓĉ ,ẗệṁӓ ťǐʂ ᵳǭḽỡḍ ṁᶙšṕȋ ᶆëᶉơḼ' '文字化け'))
		do: 
			[:array |
			testKey valueAt: 'Array' put: array.
			self assert: (testKey valueAt: 'Array') equals: array].
	"We allow individual strings to be stored as REG_MULTISZ as an optimisation"
	testKey valueAt: '8' put: '123' type: #stringArray.
	self assert: (testKey valueAt: '8') equals: #('123')!

testParentPath
	| key oa sw hklm key2 keyName dolphin |
	key := testKey.
	keyName := self class name asString.
	self assert: key name equals: keyName.
	self assert: key pathFromRoot equals: self keyPath.
	self assert: key parentKey pathFromRoot equals: ($\ join: ($\ split: self keyPath) allButLast).
	key := ($\ split: self keyPath) inject: RegKey userRoot
				into: 
					[:parentKey :each |
					| nextParent |
					nextParent := parentKey at: each.
					"We don't strictly need to free these, but we do to avoid creating finalizable garbage"
					parentKey free.
					nextParent].
	self assert: key name equals: keyName.
	self assert: key pathFromRoot equals: self keyPath.
	dolphin := key parentKey.
	key free.
	self assert: dolphin name equals: 'Dolphin Smalltalk'.
	self assert: dolphin pathFromRoot equals: 'Software\Object Arts\Dolphin Smalltalk'.
	oa := dolphin parentKey.
	self assert: oa name equals: 'Object Arts'.
	self assert: oa pathFromRoot equals: 'Software\Object Arts'.
	sw := oa parentKey.
	self assert: sw name equals: 'Software'.
	self assert: sw pathFromRoot equals: 'Software'.
	hklm := sw parentKey.
	self assert: hklm name equals: 'HKEY_CURRENT_USER'.
	self assert: hklm pathFromRoot isEmpty.
	key := RegKey userRoot at: 'Software\Object Arts\Dolphin Smalltalk'.
	key2 := key createKey: keyName , '\Leaf'.
	2 timesRepeat: 
			[self assert: key2 name equals: 'Leaf'.
			self assert: key2 parentPath equals: 'Software\Object Arts\Dolphin Smalltalk\' , keyName.
			self assert: key2 pathFromRoot equals: 'Software\Object Arts\Dolphin Smalltalk\' , keyName , '\Leaf'.
			dolphin := key2 parentKey.
			self assert: dolphin name equals: keyName.
			self assert: dolphin parentPath equals: 'Software\Object Arts\Dolphin Smalltalk'.
			self assert: dolphin pathFromRoot equals: 'Software\Object Arts\Dolphin Smalltalk\' , keyName.
			key2 free.
			key2 := key at: keyName , '\Leaf'].
	key free.
	key2 free!

testReadingEmptySz
	"Verify reading of an empty string written using the raw API so we know it is really empty"
	AdvApi32
		regSetValueEx: testKey asParameter
		lpValueName: 'Empty'
		reserved: 0
		dwType: WinRegConstants.REG_SZ
		lpData: nil
		cbData: 0.
	self assert: (testKey valueAt: 'Empty') equals: Utf16String empty!

testRemoveKeyIfAbsent
	| subbie |
	self assert: (testKey removeKey: 'subbie' ifAbsent: ['absent']) equals: 'absent'.
	subbie := testKey createKey: 'subbie'.
	subbie free.
	testKey removeKey: 'subbie' ifAbsent: [self fail: 'Sub-key unexpectedly missing'].
	self deny: (testKey includesKey: 'subbie').
	subbie := testKey createKey: 'subbie'.
	(subbie createKey: 'sub-subbie') free.
	subbie free.
	testKey removeKey: 'subbie' ifAbsent: [self fail: 'Sub-key unexpectedly missing'].
	self deny: (testKey includesKey: 'subbie')!

testRemoveSubKeyIfAbsent
	| subbie |
	self assert: (testKey removeSubKey: 'subbie' ifAbsent: ['absent']) equals: 'absent'.
	subbie := testKey createKey: 'subbie'.
	subbie free.
	testKey removeSubKey: 'subbie' ifAbsent: [self fail: 'Sub-key unexpectedly missing'].
	self deny: (testKey includesKey: 'subbie').
	subbie := testKey createKey: 'subbie'.
	(subbie createKey: 'sub-subbie') free.
	subbie free.
	self
		should: [testKey removeSubKey: 'subbie' ifAbsent: [self fail: 'Sub-key unexpectedly missing']]
		raise: Win32Error
		matching: [:ex | ex statusCode = Win32Errors.ERROR_ACCESS_DENIED].
	self assert: (testKey includesKey: 'subbie')
!

testSubValueNames
	self assert: testKey subValueNames equals: #().
	self assert: testKey subValues keys isEmpty.
	testKey valueAt: '' put: 123.
	self assert: testKey subValueNames equals: #('').
	self assert: testKey subValues keys asArray equals: #('').
	testKey valueAt: 'foo' put: 'bar'.
	self assert: testKey subValueNames equals: #('' 'foo').
	self assert: testKey subValues keys equals: #('' 'foo') asSet.
	self assert: (testKey removeSubValue: '' ifAbsent: nil) equals: 123.
	self assert: testKey subValueNames equals: #('foo').
	self assert: testKey subValues  keys asArray equals: #('foo').
	self assert: (testKey removeSubValue: 'foo' ifAbsent: nil) equals: 'bar'.
	self assert: testKey subValueNames equals: #().
	self assert: testKey subValues keys isEmpty.
!

testSubValueNamesAndValuesDoMoreData
	| pairs |
	testKey value: 'default'.
	testKey valueAt: 'foo' put: 'bar'.
	self assert: testKey keyInfo maxValueNameLen equals: 3.
	pairs := Array writeStream.
	testKey subValueNamesAndValuesDo: 
			[:each :eachValue |
			each = '' ifTrue: [testKey valueAt: 'foobar' put: 123].
			pairs nextPut: each -> eachValue].
	pairs := pairs contents.
	self assert: pairs equals: {'' -> 'default'. 'foo' -> 'bar'. 'foobar' -> 123}!

testSubValueNamesDoMoreData
	| names |
	testKey value: 'default'.
	testKey valueAt: 'foo' put: 'bar'.
	names := Array writeStream.
	testKey subValueNamesDo: 
			[:each |
			each = 'foo' ifTrue: [testKey valueAt: 'foobar' put: 'foobar'].
			names nextPut: each].
	names := names contents.
	self assert: names equals: #('' 'foo' 'foobar')!

testSz
	{''. $\0 asUtf8String. 'a'. 'ab'. 'abc'. 'abcd'. Character dolphin asUtf16String} do: 
			[:each |
			testKey valueAt: 'String' put: each.
			self assert: (testKey valueAt: 'String') equals: each]!

testUsersRootReadOnly
	| hku |
	hku := RegKey usersRoot.
	"HKCR\.exe key should exist on any machine"
	self assert: ((hku at: '.DEFAULT') keys includes: 'Environment')!

testValueAtPut
	{1234. REG_DWORD. 16r7FFFFFFF. REG_DWORD. -16r80000000. REG_DWORD. 16r80000000. REG_QWORD. -16r80000001. REG_QWORD. 'abc'. REG_SZ. #[1 2 3]. REG_BINARY. #('Abc' 'def'). REG_MULTI_SZ. nil. REG_NONE} pairsDo: 
			[:each :eachType |
			| dwErr typeBuf |
			testKey valueAt: 'each' put: each.
			typeBuf := UInt32Bytes new.
			dwErr := AdvApi32
						regQueryValueEx: testKey asParameter
						lpValueName: 'each'
						lpReserved: nil
						lpType: typeBuf
						lpData: nil
						lpcbData: nil.
			self assert: dwErr equals: OS.Win32Errors.ERROR_SUCCESS.
			self assert: typeBuf value equals: eachType.
			self assert: (testKey valueAt: 'each') equals: each].
	"Nil'ing the default value is a special case - see RegKeyAbstract>>valueAt:put:type:"
	testKey value: nil.
	self assertIsNil: testKey value! !

!OS.Tests.RegKeyTest categoriesForMethods!
keyPath!constants!private! !
setUp!private!running! !
tearDown!private!running! !
testClassesRootReadOnly!public!unit tests! !
testCreateUnderRoot!public!unit tests! !
testDefaultValue!public!unit tests! !
testExpandSz!public!unit tests! !
testLocalMachineRootReadOnly!public!unit tests! !
testMultiSz!public!unit tests! !
testParentPath!public!unit tests! !
testReadingEmptySz!public!unit tests! !
testRemoveKeyIfAbsent!public!unit tests! !
testRemoveSubKeyIfAbsent!public!unit tests! !
testSubValueNames!public!unit tests! !
testSubValueNamesAndValuesDoMoreData!public!unit tests! !
testSubValueNamesDoMoreData!public!unit tests! !
testSz!public!unit tests! !
testUsersRootReadOnly!public!unit tests! !
testValueAtPut!public!unit tests! !
!

