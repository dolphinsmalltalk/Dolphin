"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'OS.Tests.RegKeyTest'
	instanceVariableNames: 'testKey'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.RegKeyTest guid: (Core.GUID fromString: '{a67b125d-54b1-4bf8-9634-222b74e70c77}')!
OS.Tests.RegKeyTest comment: ''!
!OS.Tests.RegKeyTest categoriesForClass!Unclassified! !
!OS.Tests.RegKeyTest methodsFor!

setUp
	super setUp.
	testKey := RegKey userRoot createKey: 'Software\Object Arts\RegKeyTest'.!

tearDown
	super tearDown.
	RegKey userRoot removeKey: 'Software\Object Arts\Test' ifAbsent: [].
	testKey := nil!

testCreateUnderRoot
	| key |
	key := RegKey userRoot createKey: self class name.
	self assert: key name equals: self class name.
	self assert: key pathFromRoot equals: self class name.
	self assert: key parentPath isEmpty.
	self assert: key parentKey equals: RegKey userRoot.
	RegKey userRoot removeKey: self class name.
	key := RegKey userRoot createKey: '1\2'.
	self assert: key pathFromRoot equals: '1\2'.
	self assert: key name equals: '2'.
	self assert: key parentPath equals: '1'.
	self assert: key parentKey pathFromRoot equals: '1'.
	self assert: key parentKey name equals: '1'.
	self assert: key parentKey parentKey equals: RegKey userRoot.
	RegKey userRoot removeKey: '1'.
	key := RegKey userRoot createKey: '1\2\3'.
	self assert: key pathFromRoot equals: '1\2\3'.
	self assert: key name equals: '3'.
	self assert: key parentPath equals: '1\2'.
	self assert: key parentKey pathFromRoot equals: '1\2'.
	self assert: key parentKey name equals: '2'.
	RegKey userRoot removeKey: '1'!

testEmptyArraySerialisation
	| array |
	#() storeUnderRegKey: testKey as: 'testEmptyArraySerialisation'.
	array := Object fromRegKey: (testKey at: 'testEmptyArraySerialisation').
	self assert: array equals: #()!

testEmptySz
	| temp |
	temp := RegKey userRoot createKey: GUID newUnique asString.
	
	[self assert: (AdvApiLibrary default
				regSetValueEx: temp asParameter
				lpValueName: 'Empty'
				reserved: 0
				dwType: WinRegConstants.REG_SZ
				lpData: #[]
				cbData: 0)
		equals: 0.
	self assert: (temp valueAt: 'Empty') equals: Utf16String empty]
			ensure: [RegKey userRoot removeKey: temp name]!

testExpandSz
	| path |
	path := KernelLibrary default expandEnvironmentStrings: '%PATH%'.
	testKey
		valueAt: 'PATH'
		put: '%PATH%'
		type: #expandString.
	self assert: (testKey valueAt: 'PATH') equals: path!

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
	self assert: ints equals: ints2!

testMultiSz
	#(#() #('') #('' '') #('' '' '') #('a') #('' 'a') #('a' '') #('a' '' 'ab' '' '' 'abc')#('🐬' '£ or #' 'Ḽơᶉëᶆ ȋṕšᶙṁ ḍỡḽǭᵳ ʂǐť ӓṁệẗ, ĉṓɲṩḙċťᶒțûɾ ấɖḯƥĭṩčįɳġ ḝłįʈ, șếᶑ ᶁⱺ ẽḭŭŝḿꝋď ṫĕᶆᶈṓɍ ỉñḉīḑȋᵭṵńť ṷŧ ḹẩḇőꝛế éȶ đꝍꞎôꝛȇ ᵯáꞡᶇā ąⱡîɋṹẵ' 'ẵṹɋîⱡą āᶇꞡáᵯ ȇꝛôꞎꝍđ ȶé ếꝛőḇẩḹ ŧṷ ťńṵᵭȋḑīḉñỉ ɍṓᶈᶆĕṫ ďꝋḿŝŭḭẽ ⱺᶁ ᶑếș ,ʈįłḝ ġɳįčṩĭƥḯɖấ ɾûțᶒťċḙṩɲṓĉ ,ẗệṁӓ ťǐʂ ᵳǭḽỡḍ ṁᶙšṕȋ ᶆëᶉơḼ' '文字化け'))
		do: 
			[:array |
			testKey valueAt: 'Array' put: array.
			self assert: (testKey valueAt: 'Array') equals: array]!

testParentPath
	"#parentKey broken?"

	| key oa sw hklm key2 keyName |
	key := testKey.
	keyName := self class name asString.
	self assert: key name equals: keyName.
	self assert: key pathFromRoot equals: 'Software\Object Arts\' , keyName.
	self assert: key parentKey pathFromRoot equals: 'Software\Object Arts'.
	key := ((RegKey userRoot at: 'Software') at: 'Object Arts') at: keyName.
	self assert: key name equals: keyName.
	self assert: key pathFromRoot equals: 'Software\Object Arts\' , keyName.
	oa := key parentKey.
	self assert: oa name equals: 'Object Arts'.
	self assert: oa pathFromRoot equals: 'Software\Object Arts'.
	sw := oa parentKey.
	self assert: sw name equals: 'Software'.
	self assert: sw pathFromRoot equals: 'Software'.
	hklm := sw parentKey.
	self assert: hklm name equals: 'HKEY_CURRENT_USER'.
	self assert: hklm pathFromRoot isEmpty.
	key := RegKey userRoot at: 'Software\Object Arts'.
	key2 := key createKey: keyName , '\Leaf'.
	2 timesRepeat: 
			[self assert: key2 name equals: 'Leaf'.
			self assert: key2 parentPath equals: 'Software\Object Arts\' , keyName.
			self assert: key2 pathFromRoot equals: 'Software\Object Arts\' , keyName , '\Leaf'.
			self assert: key2 parentKey name equals: keyName.
			self assert: key2 parentKey parentPath equals: 'Software\Object Arts'.
			self assert: key2 parentKey pathFromRoot equals: 'Software\Object Arts\' , keyName.
			key2 := key at: keyName , '\Leaf']!

testScintillaTextStyleSerialization
	| styles rehydratedStyles |
	styles := Tools.SmalltalkWorkspace textStyles asArray.
	styles storeUnderRegKey: testKey as: 'testScintillaTextStyleSerialization'.
	rehydratedStyles := Object fromRegKey: (testKey at: 'testScintillaTextStyleSerialization').
	self deny: rehydratedStyles identicalTo: styles.
	self assert: rehydratedStyles equals: styles!

testSz
	{''. $\0 asUtf8String. 'a'. 'ab'. 'abc'. 'abcd'. Character dolphin asUtf16String} do: 
			[:each |
			testKey valueAt: 'String' put: each.
			self assert: (testKey valueAt: 'String') equals: each]! !
!OS.Tests.RegKeyTest categoriesFor: #setUp!private!unit tests! !
!OS.Tests.RegKeyTest categoriesFor: #tearDown!private!unit tests! !
!OS.Tests.RegKeyTest categoriesFor: #testCreateUnderRoot!public!unit tests! !
!OS.Tests.RegKeyTest categoriesFor: #testEmptyArraySerialisation!public!unit tests! !
!OS.Tests.RegKeyTest categoriesFor: #testEmptySz!public!unit tests! !
!OS.Tests.RegKeyTest categoriesFor: #testExpandSz!public!unit tests! !
!OS.Tests.RegKeyTest categoriesFor: #testIntegerSerialisation!public!unit tests! !
!OS.Tests.RegKeyTest categoriesFor: #testMultiSz!public!unit tests! !
!OS.Tests.RegKeyTest categoriesFor: #testParentPath!public!unit tests! !
!OS.Tests.RegKeyTest categoriesFor: #testScintillaTextStyleSerialization!public!unit tests! !
!OS.Tests.RegKeyTest categoriesFor: #testSz!public!unit tests! !

