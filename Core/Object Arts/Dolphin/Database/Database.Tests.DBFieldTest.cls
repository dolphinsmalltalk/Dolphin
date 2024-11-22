"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Database.Tests.DBFieldTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ODBCCTypes} #{OS.ODBCTypes})
	classInstanceVariableNames: ''
	classConstants: {}!

Database.Tests.DBFieldTest guid: (Core.GUID fromString: '{a873d9de-fe3d-43d9-a303-769afc6ac2bd}')!

Database.Tests.DBFieldTest comment: ''!

!Database.Tests.DBFieldTest categoriesForClass!Kernel-Objects! !

!Database.Tests.DBFieldTest methodsFor!

shouldRaiseTypeMismatch: aNiladicValuable
	self
		should: aNiladicValuable
		raise: OS.HRESULTError
		matching: [:ex | ex hresult = (OS.HRESULT fromInteger: OS.Win32Errors.STATUS_OBJECT_TYPE_MISMATCH)]!

testMarshalBinary
	| subject col |
	col := Smalltalk.DBColAttr new
				precision: 4;
				type: SQL_BINARY.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assert: subject fieldBuf isKindOf: DBBinaryBuffer.
	self assertIsNil: subject value.
	0 to: 4
		do: 
			[:i |
			| bytes |
			bytes := (0 to: i - 1) asByteArray.
			subject value: bytes.
			self assert: subject value equals: (bytes copy resize: 4)].
	"If too large, gets truncated. Not sure this is the right behaviour, but too late to change now."
	self
		should: [subject value: #[1 2 3 4 5]]
		raise: BoundsError
		matching: [:ex | ex tag = 5].
	subject value: nil.
	self assertIsNil: subject value.
	self shouldRaiseTypeMismatch: [subject value: 1]!

testMarshalBit
	| subject col |
	col := Smalltalk.DBColAttr new type: SQL_BIT.
	self assert: col length equals: 1.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assert: subject fieldBuf isKindOf: External.BOOLEAN.
	self assertIsNil: subject value.
	subject value: true.
	self assert: subject value.
	subject value: false.
	self deny: subject value.
	subject value: nil.
	self assertIsNil: subject value.
	self
		should: [subject value: 1]
		raise: Error
		matching: [:ex | ex description = 'Must be boolean']!

testMarshalChar
	| subject col string |
	string := 'Abcdefg'.
	col := Smalltalk.DBColAttr new
				precision: string size;
				type: SQL_CHAR;
				yourself.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assert: subject fieldBuf isKindOf: DBCharBuffer.
	self assert: subject fieldBuf byteSize equals: string size + 1.
	self assertIsNil: subject value.
	0 to: string size
		do: 
			[:i |
			| substring |
			substring := string copyFrom: 1 to: i.
			subject value: substring.
			self assert: subject value
				equals: substring , ((String new: string size withAll: $\0) copyFrom: 1 to: string size - i)].
	"Too large is an error - important that we test too large by one to verify correct handling of null terminator"
	#('h' 'hi') do: 
			[:each |
			self
				should: [subject value: string , each]
				raise: BoundsError
				matching: [:ex | ex tag = (string size + each size)]].
	subject value: nil.
	self assertIsNil: subject value.
	"Non-ansi chars are translated to replacement char, which in an ANSI string is $?"
	string := 'a🐬b    '.
	subject value: string.
	self assert: subject value equals: string asAnsiString.
	self
		should: [subject value: 1]
		raise: MessageNotUnderstood
		matching: [:ex | ex description = 'SmallInteger does not understand #asAnsiString']!

testMarshalDate
	| subject col |
	col := Smalltalk.DBColAttr new type: SQL_TYPE_DATE.
	self assert: col length equals: OS.SQL_DATE_STRUCT byteSize.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assert: subject fieldBuf isKindOf: OS.SQL_DATE_STRUCT.
	self assertIsNil: subject value.
	{Date today.
		Date fromDays: 0.
		Date newDay: 1 year: -1.
		Date newDay: 365 year: 32767.
		Date newDay: 1 year: -32768} do: 
				[:each |
				subject value: each.
				self assert: subject value equals: each].
	"Year is represented as a 16-bit signed integer, so has limited range"
	{Date newDay: 1 year: 32768. Date newDay: 1 year: -32769} do: 
			[:each |
			self
				should: [subject value: each]
				raise: OS.HRESULTError
				matching: [:ex | ex hresult = (OS.HRESULT fromPrimitiveFailureCode: Kernel._PrimitiveFailureCode.IntegerOutOfRange)]].
	subject value: nil.
	self assertIsNil: subject value!

testMarshalDatetime2
	"Test conversion of DateAndTime <-> SQL server datetime2"

	| subject col dt |
	col := Smalltalk.DBColAttr new
				type: SQL_TYPE_TIMESTAMP;
				length: OS.SQL_TIMESTAMP_STRUCT byteSize;
				scale: 7.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assert: subject fieldBuf isKindOf: OS.SQL_TIMESTAMP_STRUCT.
	dt := DateAndTime fromString: ' 9999-12-31T00:20:34.123456789+13:30'.
	subject value: dt.
	self
		assert: subject value
		closeTo: dt
		precision: 100 nanoseconds!

testMarshalDouble
	| subject col |
	col := Smalltalk.DBColAttr new type: SQL_DOUBLE.
	self assert: col length equals: 8.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assertIsNil: subject value.
	{Float fminDenormalized.
		Float fminNormalized.
		Float fmax.
		Float fmax negated.
		0.0.
		-0.0.
		Float infinity.
		Float negativeInfinity.
		1234.5.
		0.
		1.
		3 / 4.
		100 factorial} do: 
				[:each |
				subject value: each.
				self assert: subject value equals: each asFloat].
	subject value: Float nan.
	self assert: subject value isNaN.
	subject value: nil.
	self assertIsNil: subject value.
	self
		should: [subject value: true]
		raise: Error
		matching: [:ex | ex description = 'True does not understand #asFloat']!

testMarshalFloat
	| subject col |
	col := Smalltalk.DBColAttr new type: SQL_REAL.
	self assert: col length equals: 4.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assertIsNil: subject value.
	{0.0. -0.0. Float infinity. Float negativeInfinity. 1234.5. 0. 1. 3 / 4} do: 
			[:each |
			subject value: each.
			self assert: subject value equals: each asFloat].
	subject value: 100 factorial.
	self assert: subject value equals: Float infinity.
	subject value: Float fmin.
	self assert: subject value equals: 0.0.
	subject value: Float nan.
	self assert: subject value isNaN.
	subject value: nil.
	self assertIsNil: subject value.
	self
		should: [subject value: true]
		raise: MessageNotUnderstood
		matching: [:ex | ex description = 'True does not understand #asFloat']!

testMarshalGuid
	| subject col |
	col := Smalltalk.DBColAttr new type: SQL_GUID.
	self assert: col length equals: GUID byteSize.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assertIsNil: subject value.
	subject value: self class guid.
	self assert: subject value equals: self class guid.
	"GUID null value is not the same as null (no value)"
	subject value: GUID null.
	self assert: subject value equals: GUID null.
	subject value: nil.
	self assertIsNil: subject value.
	self shouldRaiseTypeMismatch: [subject value: true]!

testMarshalInt16
	| subject col |
	col := Smalltalk.DBColAttr new type: SQL_SMALLINT.
	self assert: col length equals: 2.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assert: subject fieldBuf isKindOf: Smalltalk.SWORD.
	self assertIsNil: subject value.
	#(-32768 -2 -1 0 1 2 32767 123.0 -456.0) do: 
			[:each |
			subject value: each.
			self assert: subject value equals: each].
	#(-16r8001 16r8000) do: 
			[:each |
			self
				should: [subject value: each]
				raise: OS.HRESULTError
				matching: 
					[:ex |
					ex hresult = (OS.HRESULT fromPrimitiveFailureCode: Kernel._PrimitiveFailureCode.IntegerOutOfRange)]].
	subject value: nil.
	self assertIsNil: subject value.
	self
		should: [subject value: '1']
		raise: MessageNotUnderstood
		matching: [:ex | ex message selector == #asInteger]!

testMarshalInt32
	| subject col |
	col := Smalltalk.DBColAttr new type: SQL_INTEGER.
	self assert: col length equals: 4.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assert: subject fieldBuf isKindOf: Smalltalk.SDWORD.
	self assertIsNil: subject value.
	#(-16r80000000 -16r40000001 -16r40000000 -2 -1 0 1 2 16r3FFFFFFF 16r40000000 16r7FFFFFFF 123.0 -456.0)
		do: 
			[:each |
			subject value: each.
			self assert: subject value equals: each].
	#(-16r80000001 16r80000000) do: 
			[:each |
			self
				should: [subject value: each]
				raise: OS.HRESULTError
				matching: 
					[:ex |
					ex hresult = (OS.HRESULT fromPrimitiveFailureCode: Kernel._PrimitiveFailureCode.InvalidParameter2)]].
	subject value: nil.
	self assertIsNil: subject value.
	self
		should: [subject value: '1']
		raise: MessageNotUnderstood
		matching: [:ex | ex message selector == #asInteger]!

testMarshalInt64
	| subject col |
	col := Smalltalk.DBColAttr new type: SQL_BIGINT.
	self assert: col length equals: 8.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assert: subject fieldBuf isKindOf: Smalltalk.LARGE_INTEGER.
	self assertIsNil: subject value.
	#(-16r8000000000000000 -16r4000000000000001 -16r4000000000000000 -2 -1 0 1 2 16r3FFFFFFF 16r40000000 16r7FFFFFFFFFFFFFFF 123.0 -456.0)
		do: 
			[:each |
			subject value: each.
			self assert: subject value equals: each].
	#(-16r8000000000000001 16r8000000000000000) do: 
			[:each |
			self
				should: [subject value: each]
				raise: OS.HRESULTError
				matching: [:ex | ex hresult = (OS.HRESULT fromPrimitiveFailureCode: Kernel._PrimitiveFailureCode.InvalidParameter2)]].
	subject value: nil.
	self assertIsNil: subject value.
	self
		should: [subject value: '1']
		raise: MessageNotUnderstood
		matching: [:ex | ex message selector == #asInteger]!

testMarshalLongWChar
	| subject col string utf16ByteSize |
	string := 'a🐬b'.
	utf16ByteSize := 4 * 2.
	col := Smalltalk.DBColAttr new type: SQL_WCHAR.
	self assert: col length equals: 0.
	col length: utf16ByteSize.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assert: subject fieldBuf isKindOf: DBWCharBuffer.
	self assert: subject fieldBuf byteSize equals: utf16ByteSize + 2.
	self assertIsNil: subject value.
	0 to: 4
		do: 
			[:i |
			| substring |
			substring := string asUtf16String copyFrom: 1 to: i.
			subject value: substring.
			self assert: subject value equals: (substring copy resize: 4)].
	"Too large is an error - important that we test too large by one to verify correct handling of null terminator"
	#('h' 'hi') do: 
			[:each |
			| utf16 |
			utf16 := (string , each) asUtf16String.
			self should: [subject value: utf16] raise: BoundsError].
	subject value: nil.
	self assertIsNil: subject value.
	self
		should: [subject value: 1]
		raise: MessageNotUnderstood
		matching: [:ex | ex description = 'SmallInteger does not understand #asUtf16String']!

testMarshalTime
	"Test conversion of Time <-> SQL_TIME_STRUCT"

	| increment subject col |
	increment := 1 / 100.
	col := Smalltalk.DBColAttr new type: SQL_TYPE_TIME.
	self assert: col length equals: OS.SQL_TIME_STRUCT byteSize.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assert: subject fieldBuf isKindOf: OS.SQL_TIME_STRUCT.
	self assertIsNil: subject value.
	0 to: 60 - increment
		by: increment
		do: 
			[:seconds |
			| hours minutes time |
			hours := seconds truncated \\ 24.
			minutes := seconds truncated max: 59.
			time := Time
						hours: hours
						minutes: minutes
						seconds: seconds.
			subject value: time.
			self assert: subject value hour equals: hours.
			self assert: subject value minute equals: minutes.
			self assert: subject value second equals: seconds truncated].
	subject value: nil.
	self assertIsNil: subject value.
	{Time fromSeconds: 123456.
		DateAndTime fromString: '2024-10-09T18:50:00.8948164+13:30'.
		TimeStamp current} do: 
				[:each |
				subject value: each.
				self
					assert: subject value
					closeTo: each asTime
					precision: 1 seconds].
	self
		should: [subject value: 1]
		raise: MessageNotUnderstood
		matching: [:ex | ex description = 'SmallInteger does not understand #asTime']!

testMarshalTime2
	"Test conversion of Time <-> DBTIME2"

	| subject col |
	col := Smalltalk.DBColAttr new
				type: SQL_SS_TIME2;
				scale: 3.
	self assert: col length equals: OS.DBTIME2 byteSize.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assert: subject fieldBuf isKindOf: OS.DBTIME2.
	self assertIsNil: subject value.
	{Time fromSeconds: 123456.
		DateAndTime fromString: '2024-10-09T18:50:00.8948164+13:30'.
		TimeStamp current} do: 
				[:each |
				subject value: each.
				self
					assert: subject value
					closeTo: each asTime
					precision: 1 milliseconds].
	subject value: nil.
	self assertIsNil: subject value.
	self
		should: [subject value: 1]
		raise: MessageNotUnderstood
		matching: [:ex | ex description = 'SmallInteger does not understand #asTime']!

testMarshalTimeStamp
	"Test conversion of DateAndTime <-> SQL_TIMESTAMP_STRUCT"

	| subject col |
	col := Smalltalk.DBColAttr new
				type: SQL_TYPE_TIMESTAMP;
				scale: 3.
	self assert: col length equals: OS.SQL_TIMESTAMP_STRUCT byteSize.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assert: subject fieldBuf isKindOf: OS.SQL_TIMESTAMP_STRUCT.
	self assertIsNil: subject value.
	{Time fromSeconds: 123456.
		DateAndTime fromString: '2024-10-09T18:50:00.8948164+13:30'.
		TimeStamp current} do: 
				[:each |
				subject value: each.
				self
					assert: subject value
					closeTo: each asDateAndTime
					precision: 1 milliseconds].
	subject value: nil.
	self assertIsNil: subject value.
	self
		should: [subject value: 1]
		raise: MessageNotUnderstood
		matching: [:ex | ex description = 'SmallInteger does not understand #asDateAndTime']!

testMarshalUInt8
	| subject col |
	col := Smalltalk.DBColAttr new
				type: SQL_TINYINT;
				length: 1.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assert: subject fieldBuf isKindOf: Smalltalk.BYTE.
	self assertIsNil: subject value.
	#(0 1 255) do: 
			[:each |
			subject value: each.
			self assert: subject value equals: each].
	#(-1 256 16r3FFFFFFF -16r40000000 16r40000000 -16r40000001) do: 
			[:each |
			self
				should: [subject value: each]
				raise: OS.HRESULTError
				matching: 
					[:ex |
					| hr |
					hr := ex hresult.
					hr = (OS.HRESULT fromPrimitiveFailureCode: Kernel._PrimitiveFailureCode.InvalidParameter2)
						or: [hr = (OS.HRESULT fromPrimitiveFailureCode: Kernel._PrimitiveFailureCode.IntegerOutOfRange)]]].
	subject value: nil.
	self assertIsNil: subject value.
	self
		should: [subject value: '1']
		raise: MessageNotUnderstood
		matching: [:ex | ex message selector == #asInteger]!

testMarshalWChar
	| subject col string utf16ByteSize precision |
	string := 'a🐬b'.
	precision := 4.
	utf16ByteSize := precision * 2.
	col := Smalltalk.DBColAttr new
				precision: precision;
				type: SQL_WCHAR;
				yourself.
	self assert: col length equals: utf16ByteSize.
	subject := col newBoundField.
	self assert: subject isKindOf: DBBoundField.
	self assert: subject fieldBuf isKindOf: DBWCharBuffer.
	self assert: subject fieldBuf byteSize equals: utf16ByteSize + 2.
	self assertIsNil: subject value.
	0 to: precision
		do: 
			[:i |
			| substring |
			substring := string asUtf16String copyFrom: 1 to: i.
			subject value: substring.
			self assert: subject value equals: (substring copy resize: precision)].
	"Too large is an error - important that we test too large by one to verify correct handling of null terminator"
	#('h' 'hi') do: 
			[:each |
			| utf16 |
			utf16 := (string , each) asUtf16String.
			self should: [subject value: utf16] raise: BoundsError].
	subject value: nil.
	self assertIsNil: subject value.
	self
		should: [subject value: 1]
		raise: MessageNotUnderstood
		matching: [:ex | ex description = 'SmallInteger does not understand #asUtf16String']! !

!Database.Tests.DBFieldTest categoriesForMethods!
shouldRaiseTypeMismatch:!helpers!private! !
testMarshalBinary!public!unit tests! !
testMarshalBit!public!unit tests! !
testMarshalChar!public!unit tests! !
testMarshalDate!public!unit tests! !
testMarshalDatetime2!public!unit tests! !
testMarshalDouble!public!unit tests! !
testMarshalFloat!public!unit tests! !
testMarshalGuid!public!unit tests! !
testMarshalInt16!public!unit tests! !
testMarshalInt32!public!unit tests! !
testMarshalInt64!public!unit tests! !
testMarshalLongWChar!public!unit tests! !
testMarshalTime!public!unit tests! !
testMarshalTime2!public!unit tests! !
testMarshalTimeStamp!public!unit tests! !
testMarshalUInt8!public!unit tests! !
testMarshalWChar!public!unit tests! !
!

