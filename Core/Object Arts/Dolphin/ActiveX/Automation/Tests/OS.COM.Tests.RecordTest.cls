"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.COM.Tests.RecordTest'
	instanceVariableNames: 'anonRect'
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.RecordTest guid: (Core.GUID fromString: '{8c016bcb-4499-4ee5-a1ae-e42fbe8c8398}')!

OS.COM.Tests.RecordTest comment: ''!

!OS.COM.Tests.RecordTest methodsFor!

createExternalTestSubject
	| recordInfo |
	recordInfo := (anonRect
				ifNil: 
					[anonRect := self createTrackingRectClass.
					anonRect unregister.
					anonRect])
					queryInterface: IRecordInfo
					ifNone: [self assert: false].
	^(Record createWithInfo: recordInfo)
		left: 100;
		top: 200;
		right: 150;
		bottom: 275;
		yourself!

createInternalTestSubject
	^(anonRect ifNil: [anonRect := self createTrackingRectClass]) origin: 100 @ 200 extent: 50 @ 75!

createTrackingRectClass
	"Private - Setting up a full mock of the IRecordInfo on Structure would be too fiddly, so just override a few methods to capture the calls.
	We really should get around to adding MethodWrappers..."

	| vars |
	anonRect := RECTL newAnonymousSubclass.
	self deny: anonRect guid equals: RECTL guid.
	vars := #('Created' 'Initialized' 'Copied' 'Cleared' 'Destroyed').
	anonRect basicClassPool: (Dictionary
				withAll: (vars collect: [:each | VariableBinding key: each value: OrderedCollection new])).
	anonRect classPool add: (VariableBinding key: 'TestCaseInstance' value: self).
	anonRect class
		compile: 'RecordCreate
	"TestCaseInstance fail: ''Unexpected call to RecordCreate''."
	^Created add: super RecordCreate';
		compile: 'init: pvNew
	Initialized add: pvNew.
	super init: pvNew';
		compile: 'RecordCopy: pvExisting pvNew: pvNew
	Copied add: pvExisting -> pvNew.
	^super RecordCopy: pvExisting pvNew: pvNew';
		compile: 'clear: pvExisting 
	Cleared add: pvExisting.
	super clear: pvExisting';
		compile: 'RecordDestroy: pvRecord 
	"TestCaseInstance fail: ''Unexpected call to RecordDestroy''."
	Destroyed add: pvRecord. 
	^super RecordDestroy: pvRecord'.
	vars do: [:each | anonRect class compile: '<1s> ^<2s>' << { each asLowercase. each }].
	^anonRect!

tearDown
	anonRect
		ifNotNil: 
			["Cause any unexpected finalization to fail"
			anonRect bindingsDo: [:each | each value == self ifFalse: [each value: nil]]].
	^super tearDown!

testExternalRecord
	"Tests the case of a Record created with external heap memory, but owned by the Record object."

	<ignoreNotImplementedSelectors: #(#destroyed #cleared)>
	| subject rectBytes |
	subject := self createExternalTestSubject.
	self deny: subject isNull.
	self assert: subject isReferenceStruct.
	self assert: subject owner isNil.
	rectBytes := subject bytes.
	"We need to call RecordClear, so should be finalizable"
	self assert: subject needsFree.
	self assert: subject isFinalizable.
	self assert: rectBytes class equals: Address.
	self assert: anonRect created removeFirst equals: rectBytes.
	self assert: anonRect initialized removeFirst equals:  rectBytes.
	self verifyNoRecordInfoCalls.
	"Now get/set some values via the DNU mechanism which calls on IRecordInfo Get/Put methods"
	self assert: subject left equals: 100.
	subject left: 101.
	self assert: subject left equals: 101.
	self assert: subject top equals: 200.
	subject top: 202.
	self assert: subject top equals: 202.
	self assert: subject right equals: 150.
	subject right: 155.
	self assert: subject right equals: 155.
	self assert: subject bottom equals: 275.
	subject bottom: 375.
	self assert: subject bottom equals: 375.
	self should: [subject origin] raise: MessageNotUnderstood.
	self
		should: [subject bottom: 'a']
		raise: HRESULTError
		matching: [:ex | ex hresult asInteger = AutomationErrors.DISP_E_TYPEMISMATCH].
	self assert: OrderedCollection new isEmpty.
	subject free.
	self assert: subject isNull.
	self deny: subject needsFree.
	self deny: subject isFinalizable.
	"In this case IRecordInfo::Destroy should have been called, and it calls clear"
	self assert: anonRect cleared removeFirst equals: rectBytes.
	self assert: anonRect destroyed removeFirst equals: rectBytes.
	self verifyNoRecordInfoCalls.!

testExternalRecordInSafeArray
	<ignoreNotImplementedSelectors: #(#initialized #destroyed #cleared #copied)>
	| subject recordCopy array pRecordCopy arrayCopy pRect record |
	subject := self createExternalTestSubject.
	pRect := subject bytes.
	self assert: anonRect created removeFirst equals: pRect.
	self assert: anonRect initialized removeFirst equals: pRect.
	self verifyNoRecordInfoCalls.
	array := SAFEARRAY length: 1 recordInfo: anonRect recordInfo.
	self assert: array isReferenceStruct.
	self assert: array needsFree.
	self assert: array isFinalizable.
	self assertIsNil: array owner.
	self assert: array vt equals: VT_ARRAY | VT_RECORD.
	array at: 1 put: subject.
	record := array at: 1.
	self assert: record isReferenceStruct.
	self assert: record owner equals: array.
	self deny: record needsFree.
	self deny: record isFinalizable.
	self assert: record equals: subject.
	self deny: record bytes equals: pRect.
	self assert: anonRect copied removeFirst equals: pRect -> record bytes.
	self verifyNoRecordInfoCalls.
	"SafeArrayCopy will create a copy of the record using IRecordInfo::Copy, and will own that copy. The memory for the record is part of the SAFEARRAY block, so allocated internally by the SAFEARRAY."
	arrayCopy := array copy.
	self assert: arrayCopy isReferenceStruct.
	self assert: arrayCopy needsFree.
	self assert: arrayCopy isFinalizable.
	self assertIsNil: arrayCopy owner.
	self assert: arrayCopy vt equals: VT_ARRAY | VT_RECORD.
	recordCopy := arrayCopy at: 1.
	self assert: anonRect copied removeFirst equals: record bytes -> recordCopy bytes.
	self verifyNoRecordInfoCalls.
	"When we access the record copy in the array copy, we create a reference to it"
	self assert: recordCopy owner equals: arrayCopy.
	self assert: recordCopy isReferenceStruct.
	self deny: recordCopy needsFree.
	self deny: recordCopy isFinalizable.
	self assert: recordCopy equals: subject.
	"The copy should have been allocated (by the SAFEARRAY) from the task heap"
	pRecordCopy := recordCopy bytes.
	self assert: (TaskMemory didAlloc: pRecordCopy).
	"Freeing the variant should free the record copy because the SAFEARRAY memory it is assigned is freed"
	arrayCopy free.
	self isNativeDebuggerPresent ifFalse: [self deny: (TaskMemory didAlloc: pRecordCopy)].
	"As with variants, the safe array doesn't call RecordCreate to make a copy. Rather it calls RecordCopy to copy into task memory that it allocates. 
	This means it doesn't call RecordDestroy either, but rather just RecordClear's the memory."
	self assert: anonRect cleared removeFirst equals: pRecordCopy.
	self verifyNoRecordInfoCalls.
	array free.
	self assert: anonRect cleared removeFirst equals: record bytes.
	self verifyNoRecordInfoCalls.
	subject free.
	self assert: anonRect cleared removeFirst equals: pRect.
	self assert: anonRect destroyed removeFirst equals: pRect.
	self verifyNoRecordInfoCalls!

testExternalRecordInVariant
	<ignoreNotImplementedSelectors: #(#initialized #destroyed #cleared)>
	| subject recordCopy variant copiedVariant pRecordCopy deepCopiedVariant recordRefCopy pRect |
	subject := self createExternalTestSubject.
	self assert: subject printString
		equals: 'a COM.Record(a subclass of RECTL: left=100 top=200 right=150 bottom=275)'.
	pRect := subject bytes.
	self assert: anonRect created removeFirst equals: pRect.
	self assert: anonRect initialized removeFirst equals: pRect.
	self verifyNoRecordInfoCalls.
	variant := subject asVariant.
	"The variant will only reference the record - it won't call RecordClear on the record"
	self assert: variant value identicalTo: subject.
	self assert: variant vt equals: VT_RECORD | VT_BYREF.
	"Normal VariantCopy will just create a copy of the reference - it still doesn't own the record"
	copiedVariant := variant copy.
	self assert: copiedVariant bytes equals: variant bytes.
	recordRefCopy := copiedVariant value.
	self assert: recordRefCopy bytes equals: pRect.
	copiedVariant free.
	"VariantCopyInd will create an actual copy of the record, and will own that copy"
	deepCopiedVariant := variant deepCopy.
	self assert: deepCopiedVariant vt equals: VT_RECORD.
	recordCopy := deepCopiedVariant value.
	"When we access the record copy in the variant, we create a reference to it"
	self assert: recordCopy owner equals: deepCopiedVariant.
	self assert: recordCopy isReferenceStruct.
	self deny: recordCopy needsFree.
	self deny: recordCopy isFinalizable.
	self assert: recordCopy equals: subject.
	"The copy should have been allocated (by the Variant) from the task heap"
	pRecordCopy := recordCopy bytes.
	self assert: (TaskMemory didAlloc: pRecordCopy).
	"Freeing the variant should free the record copy"
	deepCopiedVariant free.
	self isNativeDebuggerPresent ifFalse: [self deny: (TaskMemory didAlloc: pRecordCopy)].
	"Note that the variant code doesn't call RecordCreate to make the copy. Rather it calls RecordCopy to copy into task memory that it allocates. 
	This means it doesn't call RecordDestroy either, but rather just RecordClear's the memory and then frees the task memory its allocated."
	self assert: anonRect copied removeFirst equals: pRect -> pRecordCopy.
	self assert: anonRect cleared removeFirst equals: pRecordCopy.
	self verifyNoRecordInfoCalls.
	subject free.
	self assert: anonRect cleared removeFirst equals: pRect.
	self assert: anonRect destroyed removeFirst equals: pRect.
	self verifyNoRecordInfoCalls!

testInternalRecord
	"Tests the case of a Record referencing or copied from a struct in Dolphin memory."

	<ignoreNotImplementedSelectors: #(#destroyed #cleared #initialized #copied)>
	| subject rectBytes refRecord copyRecord pCopyBytes |
	subject := self createInternalTestSubject.
	self deny: subject isNull.
	self assert: subject isValueStruct.
	"Internal RECTL doesn't require finalization"
	self deny: subject needsFree.
	self deny: subject isFinalizable.
	rectBytes := subject bytes.
	self assert: rectBytes class equals: ByteArray.
	"Created internally - no record info calls expected"
	self verifyNoRecordInfoCalls.
	refRecord := Record fromAddress: subject yourAddress recordInfo: subject recordInfo owner: subject.
	self assert: refRecord bytes class equals: Address.
	self deny: refRecord isFinalizable.
	self deny: refRecord needsFree.
	self verifyNoRecordInfoCalls.
	"Now get/set some values via the DNU mechanism which calls on IRecordInfo Get/Put methods"
	self assert: refRecord left equals: 100.
	refRecord left: 16r7FFFFFFF.
	self assert: refRecord left equals: 16r7FFFFFFF.
	self assert: subject left equals: 16r7FFFFFFF.
	self should: [refRecord origin] raise: MessageNotUnderstood.
	self
		should: [refRecord bottom: 'a']
		raise: HRESULTError
		matching: [:ex | ex hresult asInteger = AutomationErrors.DISP_E_TYPEMISMATCH].
	refRecord free.
	self verifyNoRecordInfoCalls.
	copyRecord := Record fromBytes: rectBytes recordInfo: subject recordInfo.
	self assert: copyRecord bytes class equals: ByteArray.
	self assert: copyRecord needsFree.
	self assert: copyRecord isFinalizable.
	pCopyBytes := copyRecord bytes yourAddress asExternalAddress.
	self assert: anonRect initialized removeFirst equals: pCopyBytes.
	self assert: anonRect copied removeFirst equals: subject bytes yourAddress asExternalAddress -> pCopyBytes.
	self verifyNoRecordInfoCalls.
	self assert: copyRecord left equals: 16r7FFFFFFF.
	subject free.
	self assert: subject isNull.
	self deny: subject needsFree.
	self deny: subject isFinalizable.
	self verifyNoRecordInfoCalls.
	self assert: copyRecord left equals: 16r7FFFFFFF.
	copyRecord free.
	self assert: anonRect cleared removeFirst equals: pCopyBytes.
	self verifyNoRecordInfoCalls.
	
!

testInternalRecordInSafeArray
	<ignoreNotImplementedSelectors: #(#initialized #destroyed #cleared #copied)>
	| rect copyRecordRef array pRecordCopy arrayCopy pRect record pRecord |
	rect := self createInternalTestSubject.
	pRect := rect yourAddress asExternalAddress.
	array := SAFEARRAY with: rect.
	self assert: array isReferenceStruct.
	self assert: array needsFree.
	self assert: array isFinalizable.
	self assertIsNil: array owner.
	self assert: array vt equals: VT_ARRAY | VT_RECORD.
	record := array at: 1.
	self assert: record isReferenceStruct.
	self assert: record owner equals: array.
	self deny: record needsFree.
	self deny: record isFinalizable.
	self assert: record equals: rect.
	self deny: record bytes equals: pRect.
	pRecord := record bytes.
	self assert: anonRect copied removeFirst equals: pRect -> pRecord.
	self verifyNoRecordInfoCalls.
	"SafeArrayCopy will create a copy of the record using IRecordInfo::Copy, and will own that copy. The memory for the record is part of the SAFEARRAY block, so allocated internally by the SAFEARRAY."
	arrayCopy := array copy.
	self assert: arrayCopy isReferenceStruct.
	self assert: arrayCopy needsFree.
	self assert: arrayCopy isFinalizable.
	self assertIsNil: arrayCopy owner.
	self assert: arrayCopy vt equals: VT_ARRAY | VT_RECORD.
	copyRecordRef := arrayCopy at: 1.
	self assert: anonRect copied removeFirst equals: pRecord -> copyRecordRef bytes.
	self verifyNoRecordInfoCalls.
	"When we access the record copy in the array copy, we create a reference to it"
	self assert: copyRecordRef owner equals: arrayCopy.
	self assert: copyRecordRef isReferenceStruct.
	self deny: copyRecordRef needsFree.
	self deny: copyRecordRef isFinalizable.
	self assert: copyRecordRef equals: rect.
	"The copy should have been allocated (by the SAFEARRAY) from the task heap"
	pRecordCopy := copyRecordRef bytes.
	self assert: (TaskMemory didAlloc: pRecordCopy).
	"Freeing the safearray copy should free the record copy because the SAFEARRAY memory it is assigned is freed"
	arrayCopy free.
	self isNativeDebuggerPresent ifFalse: [self deny: (TaskMemory didAlloc: pRecordCopy)].
	"As with variants, the safe array doesn't call RecordCreate to make a copy. Rather it calls RecordCopy to copy into task memory that it allocates. 
	This means it doesn't call RecordDestroy either, but rather just RecordClear's the memory."
	self assert: anonRect cleared removeFirst equals: pRecordCopy.
	self verifyNoRecordInfoCalls.
	"Freeing the array should clear the copy of the original record copy of the rect that it made"
	array free.
	self assert: anonRect cleared removeFirst equals: pRecord.
	self verifyNoRecordInfoCalls.
	"Original rect should be untouched."
	self assert: rect left equals: 100!

testInternalRecordInVariant
	<ignoreNotImplementedSelectors: #(#initialized #destroyed #cleared #copied)>
	| rect recordCopy variant copiedVariant pRecordCopy deepCopiedVariant recordRefCopy pRect |
	rect := self createInternalTestSubject.
	pRect := rect yourAddress asExternalAddress.
	variant := rect asVariant.
	"The variant will only reference the record - it won't call RecordClear on the record"
	self assert: variant value identicalTo: rect.
	self assert: variant vt equals: VT_RECORD | VT_BYREF.
	"Normal VariantCopy will just create a copy of the reference - it still doesn't own the record"
	copiedVariant := variant copy.
	self assert: copiedVariant bytes equals: variant bytes.
	recordRefCopy := copiedVariant value.
	self assert: recordRefCopy bytes equals: pRect.
	copiedVariant free.
	"VariantCopyInd will create an actual copy of the record, and will own that copy"
	deepCopiedVariant := variant deepCopy.
	self assert: deepCopiedVariant vt equals: VT_RECORD.
	recordCopy := deepCopiedVariant value.
	"When we access the record copy in the variant, we create a reference to it"
	self assert: recordCopy owner equals: deepCopiedVariant.
	self assert: recordCopy isReferenceStruct.
	self deny: recordCopy needsFree.
	self deny: recordCopy isFinalizable.
	self assert: recordCopy equals: rect.
	"The copy should have been allocated (by the Variant) from the task heap"
	pRecordCopy := recordCopy bytes.
	self assert: (TaskMemory didAlloc: pRecordCopy).
	"Freeing the variant should free the record copy"
	deepCopiedVariant free.
	"Don't call didAlloc: for freed blocks if debugger present as it causes the debugger to break on a first change exception. This is expected, and continuing execution will proceed without failure, but it is unsettling/annoying."
	self isNativeDebuggerPresent ifFalse: [self deny: (TaskMemory didAlloc: pRecordCopy)].
	"Note that the variant code doesn't call RecordCreate to make the copy. Rather it calls RecordCopy to copy into task memory that it allocates. 
	This means it doesn't call RecordDestroy either, but rather just RecordClear's the memory and then frees the task memory its allocated."
	self assert: anonRect copied removeFirst equals: pRect -> pRecordCopy.
	self assert: anonRect cleared removeFirst equals: pRecordCopy.
	self verifyNoRecordInfoCalls!

verifyNoRecordInfoCalls
	anonRect bindingsDo: [:each | each key = 'TestCaseInstance' ifFalse: [self assert: each value isEmpty]]! !

!OS.COM.Tests.RecordTest categoriesForMethods!
createExternalTestSubject!helpers!private! !
createInternalTestSubject!helpers!private! !
createTrackingRectClass!helpers!private! !
tearDown!public!running! !
testExternalRecord!public!unit tests! !
testExternalRecordInSafeArray!public!unit tests! !
testExternalRecordInVariant!public!unit tests! !
testInternalRecord!public!unit tests! !
testInternalRecordInSafeArray!public!unit tests! !
testInternalRecordInVariant!public!unit tests! !
verifyNoRecordInfoCalls!helpers!private! !
!

