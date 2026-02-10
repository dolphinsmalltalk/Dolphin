"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.COM.Tests.RecordTest'
	instanceVariableNames: 'trackingRecordInfo anonRect recordInfo'
	classVariableNames: ''
	imports: #(#{OS.COM.OleVariant private})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.RecordTest guid: (Core.GUID fromString: '{8c016bcb-4499-4ee5-a1ae-e42fbe8c8398}')!

OS.COM.Tests.RecordTest comment: ''!

!OS.COM.Tests.RecordTest methodsFor!

createExternalTestSubject
	"In order to suppress mapping of the record info to an internal class, we remove it from the structure register. This will cause a COM.Record to be created to represent an instance when accessing from a variant."
	anonRect
		ifNil: 
			[self createTrackingRectClass.
			anonRect unregister].
	recordInfo := anonRect recordInfo.
	^(Record createWithInfo: recordInfo)
		left: 100;
		top: 200;
		right: 150;
		bottom: 275;
		yourself!

createInternalTestSubject
	anonRect ifNil: [self createTrackingRectClass].
	^anonRect origin: 100 @ 200 extent: 50 @ 75!

createTrackingRectClass
	"Private - Setting up a full mock of RecordInfo would be too fiddly, so just override a few methods to capture the calls.
	We really should get around to adding MethodWrappers..."

	| vars |
	trackingRecordInfo := RecordInfo newAnonymousSubclass.
	self deny: trackingRecordInfo guid equals: RecordInfo guid.
	vars := #('Created' 'Initialized' 'Copied' 'Cleared' 'Destroyed').
	trackingRecordInfo basicClassPool: (Dictionary
				withAll: (vars collect: [:each | VariableBinding key: each value: OrderedCollection new])).
	trackingRecordInfo
		compile: 'RecordCreate ^Created add: super RecordCreate';
		compile: 'RecordInit: pvNew Initialized add: pvNew. ^super RecordInit: pvNew';
		compile: 'RecordCopy: pvExisting pvNew: pvNew Copied add: pvExisting -> pvNew. ^super RecordCopy: pvExisting pvNew: pvNew';
		compile: 'RecordClear: pvExisting Cleared add: pvExisting. ^super RecordClear: pvExisting';
		compile: 'RecordDestroy: pvRecord Destroyed add: pvRecord. ^super RecordDestroy: pvRecord'.
	vars do: [:each | trackingRecordInfo class compile: '<1s> ^<2s>' << { each asLowercase. each }].
	anonRect := RECTL newAnonymousSubclass.
	anonRect
		basicClassPool: (Dictionary withAll: {
						VariableBinding key: 'TrackingRecordInfo' value: trackingRecordInfo.
						VariableBinding key: 'TestCaseInstance' value: self
					}).
	anonRect class
		compile: 'recordInfo ^OS.COM.IRecordInfo on: self implementor: (TrackingRecordInfo recordClass: self)'!

shutterTrackingRecordInfo
	"To be run at the end of a successful test - check that all tracked calls have been verified, and burn the tracking state so that any further recordinfo Destroy/Clear calls from finalization will fail.
	This is run from the end of successful tests rather than tearDown to avoid generating misleading finalization errors that are a knock on effect of test failure."

	self verifyNoRecordInfoCalls.
	trackingRecordInfo bindingsDo: [:each | each value == self ifFalse: [each value: nil]].
	(anonRect bindingFor: 'TestCaseInstance') value: nil.
	recordInfo isNull ifFalse: [
		self assert: recordInfo referenceCount equals: 1.
		recordInfo free.
		recordInfo := nil].!

tearDown
	recordInfo := nil.
	^super tearDown!

testExternalRecord
	"Tests the case of a Record created with external heap memory, but owned by the Record object."

	<ignoreNotImplementedSelectors: #(#destroyed #cleared)>
	| subject rectBytes |
	trackingRecordInfo := anonRect := nil.
	subject := self createExternalTestSubject.
	self deny: subject isNull.
	self assert: subject isReferenceStruct.
	self assert: subject owner isNil.
	rectBytes := subject bytes.
	"We need to call RecordClear, so should be finalizable"
	self assert: subject needsFree.
	self assert: subject isFinalizable.
	self assert: rectBytes class equals: Address.
	self assert: trackingRecordInfo created removeFirst equals: rectBytes.
	self assert: trackingRecordInfo initialized removeFirst equals: rectBytes.
	self verifyNoRecordInfoCalls.
	self assert: recordInfo referenceCount equals: 1.
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
		matching: [:ex | ex statusCode = 36].
	self assert: OrderedCollection new isEmpty.
	subject free.
	self assert: subject isNull.
	self deny: subject needsFree.
	self deny: subject isFinalizable.
	"In this case IRecordInfo::Destroy should have been called, and it calls clear"
	self assert: trackingRecordInfo cleared removeFirst equals: rectBytes.
	self assert: trackingRecordInfo destroyed removeFirst equals: rectBytes.
	self shutterTrackingRecordInfo!

testExternalRecordInSafeArray
	<ignoreNotImplementedSelectors: #(#initialized #destroyed #cleared #copied)>
	| subject recordCopy array pRecordCopy arrayCopy pRect record |
	trackingRecordInfo := anonRect := nil.
	subject := self createExternalTestSubject.
	pRect := subject bytes.
	self assert: trackingRecordInfo created removeFirst equals: pRect.
	self assert: trackingRecordInfo initialized removeFirst equals: pRect.
	self verifyNoRecordInfoCalls.
	array := SAFEARRAY length: 1 recordInfo: recordInfo.
	self assert: array isReferenceStruct.
	self assert: array needsFree.
	self assert: array isFinalizable.
	self assertIsNil: array owner.
	self assert: array vt equals: VT_ARRAY | VT_RECORD.
	self assert: recordInfo referenceCount equals: 2.
	array at: 1 put: subject.
	record := array at: 1.
	self assert: record isKindOf: Record.
	self assert: record isReferenceStruct.
	self assert: record owner equals: array.
	self deny: record needsFree.
	self deny: record isFinalizable.
	self assert: record equals: subject.
	self deny: record bytes equals: pRect.
	self assert: trackingRecordInfo copied removeFirst equals: pRect -> record bytes.
	self verifyNoRecordInfoCalls.
	self assert: recordInfo referenceCount equals: 3.
	"SafeArrayCopy will create a copy of the record using IRecordInfo::Copy, and will own that copy. The memory for the record is part of the SAFEARRAY block, so allocated internally by the SAFEARRAY."
	arrayCopy := array copy.
	self assert: arrayCopy isReferenceStruct.
	self assert: arrayCopy needsFree.
	self assert: arrayCopy isFinalizable.
	self assertIsNil: arrayCopy owner.
	self assert: arrayCopy vt equals: VT_ARRAY | VT_RECORD.
	self assert: arrayCopy elementClass isKindOf: COM.RecordClass.
	self assert: arrayCopy elementClass identicalTo: array elementClass.
	self assert: recordInfo referenceCount equals: 4.
	self assert: (arrayCopy recordInfo isSameCOMObject: recordInfo).
	self assert: recordInfo referenceCount equals: 5.
	recordCopy := arrayCopy at: 1.
	self assert: recordCopy isKindOf: Record.
	self assert: recordCopy recordInfo identicalTo: arrayCopy elementClass recordInfo.
	self deny: recordCopy recordInfo identicalTo: arrayCopy recordInfo.
	self assert: recordInfo referenceCount equals: 5.
	self assert: trackingRecordInfo copied removeFirst equals: record bytes -> recordCopy bytes.
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
	self assert: recordInfo referenceCount equals: 4.
	self assert: arrayCopy recordInfo isFinalizable.
	arrayCopy recordInfo free.
	self assert: recordInfo referenceCount equals: 3.
	self isNativeDebuggerPresent ifFalse: [self deny: (TaskMemory didAlloc: pRecordCopy)].
	"As with variants, the safe array doesn't call RecordCreate to make a copy. Rather it calls RecordCopy to copy into task memory that it allocates. 
	This means it doesn't call RecordDestroy either, but rather just RecordClear's the memory."
	self assert: trackingRecordInfo cleared removeFirst equals: pRecordCopy.
	self verifyNoRecordInfoCalls.
	self assert: recordCopy recordInfo isFinalizable.
	recordCopy recordInfo free.
	self assert: recordInfo referenceCount equals: 2.
	array free.
	self assert: trackingRecordInfo cleared removeFirst equals: record bytes.
	self verifyNoRecordInfoCalls.
	self assert: recordInfo referenceCount equals: 1.
	subject free.
	self assert: trackingRecordInfo cleared removeFirst equals: pRect.
	self assert: trackingRecordInfo destroyed removeFirst equals: pRect.
	self shutterTrackingRecordInfo!

testExternalRecordInVariant
	<ignoreNotImplementedSelectors: #(#initialized #destroyed #cleared #copied)>
	| subject recordCopy variant pRecordCopy copiedVariant pRect value |
	trackingRecordInfo := anonRect := nil.
	subject := self createExternalTestSubject.
	self assert: subject printString
		equals: 'a COM.Record(a subclass of RECTL: left=100 top=200 right=150 bottom=275)'.
	pRect := subject bytes.
	self assert: trackingRecordInfo created removeFirst equals: pRect.
	self assert: trackingRecordInfo initialized removeFirst equals: pRect.
	self verifyNoRecordInfoCalls.
	variant := subject asVariant.
	"Will have called CreateCopy"
	self assert: trackingRecordInfo created removeFirst equals: variant refAddress.
	self assert: trackingRecordInfo initialized removeFirst equals: variant refAddress.
	self assert: trackingRecordInfo copied removeFirst equals: pRect -> variant refAddress.
	self verifyNoRecordInfoCalls.
	self assert: variant vt equals: VT_RECORD.
	self assert: recordInfo referenceCount equals: 2.
	value := variant value.
	self assert: value isKindOf: Record.
	self assert: value isReferenceStruct.
	self deny: value isFinalizable.
	self deny: value needsFree.
	self assert: (value recordInfo isSameCOMObject: recordInfo).
	self assert: value recordInfo isFinalizable.
	self assert: recordInfo referenceCount equals: 3.
	self assert: value equals: subject.
	value recordInfo free.
	self assert: recordInfo referenceCount equals: 2.
	value := nil.
	"VariantCopy"
	copiedVariant := variant copy.
	"Note that VariantCopy doesn't call RecordCreate or RecordCreateCopy, rather it calls RecordCopy to copy into task memory that it allocates."
	self assert: trackingRecordInfo copied removeFirst
		equals: variant refAddress -> copiedVariant refAddress.
	self verifyNoRecordInfoCalls.
	self assert: copiedVariant vt equals: VT_RECORD.
	self assert: recordInfo referenceCount equals: 3.
	recordCopy := copiedVariant value.
	"When we access the record copy in the variant, we create a reference to it"
	self assert: recordCopy owner equals: copiedVariant.
	self assert: recordCopy isReferenceStruct.
	self deny: recordCopy needsFree.
	self deny: recordCopy isFinalizable.
	self assert: recordCopy equals: subject.
	self assert: (recordCopy recordInfo isSameCOMObject: recordInfo).
	self assert: recordInfo referenceCount equals: 4.
	"The copy should have been allocated (by the Variant) from the task heap"
	pRecordCopy := recordCopy bytes.
	self assert: (TaskMemory didAlloc: pRecordCopy).
	"Freeing the variant should free the record copy"
	copiedVariant free.
	self assert: recordInfo referenceCount equals: 3.
	"The record copy memory should have been returned to the task heap."
	self isNativeDebuggerPresent ifFalse: [self deny: (TaskMemory didAlloc: pRecordCopy)].
	"As noted above the variant code doesn't call RecordCreate to make the copy. This means it doesn't call RecordDestroy either, but rather just RecordClear's the memory and then frees the task memory its allocated."
	self assert: trackingRecordInfo cleared removeFirst equals: pRecordCopy.
	self verifyNoRecordInfoCalls.
	self assert: recordCopy recordInfo isFinalizable.
	recordCopy recordInfo free.
	self assert: recordInfo referenceCount equals: 2.
	subject free.
	"Our implementation of Record>>#free will call RecordDestroy, which internally calls RecordClear"
	self assert: trackingRecordInfo cleared removeFirst equals: pRect.
	self assert: trackingRecordInfo destroyed removeFirst equals: pRect.
	self verifyNoRecordInfoCalls.
	self assert: recordInfo referenceCount equals: 2.
	pRect := variant refAddress.
	variant free.
	self assert: trackingRecordInfo cleared removeFirst equals: pRect.
	self assert: recordInfo referenceCount equals: 1.
	self shutterTrackingRecordInfo!

testExternalRecordRefInVariant
	<ignoreNotImplementedSelectors: #(#initialized #destroyed #cleared #copied)>
	| subject recordCopy variant copiedVariant pRecordCopy deepCopiedVariant recordRefCopy pRect |
	trackingRecordInfo := anonRect := nil.
	subject := self createExternalTestSubject.
	self assert: recordInfo referenceCount equals: 1.
	self assert: subject printString
		equals: 'a COM.Record(a subclass of RECTL: left=100 top=200 right=150 bottom=275)'.
	pRect := subject bytes.
	self assert: trackingRecordInfo created removeFirst equals: pRect.
	self assert: trackingRecordInfo initialized removeFirst equals: pRect.
	self verifyNoRecordInfoCalls.
	variant := VARIANT new struct: subject.
	"The variant will only reference the record - VariantClear won't call RecordClear on the record, nor IRecordInfo::Release"
	self assert: variant value identicalTo: subject.
	self assert: variant vt equals: VT_RECORD | VT_BYREF.
	self assert: recordInfo referenceCount equals: 1.
	"Normal VariantCopy will just create a copy of the reference - it still doesn't own the record"
	copiedVariant := variant copy.
	self assert: copiedVariant bytes equals: variant bytes.
	self assert: recordInfo referenceCount equals: 1.
	recordRefCopy := copiedVariant value.
	self assert: recordInfo referenceCount equals: 2.
	self assert: recordRefCopy bytes equals: pRect.
	copiedVariant free.
	self assert: recordInfo referenceCount equals: 2.
	self assert: recordRefCopy recordInfo isFinalizable.
	recordRefCopy recordInfo free.
	self assert: recordInfo referenceCount equals: 1.

	"VariantCopyInd will create an actual copy of the record, and will own that copy"
	deepCopiedVariant := variant deepCopy.
	self assert: deepCopiedVariant vt equals: VT_RECORD.
	self assert: recordInfo referenceCount equals: 2.
	recordCopy := deepCopiedVariant value.
	self assert: recordInfo referenceCount equals: 3.
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
	self assert: recordInfo referenceCount equals: 2.
	self assert: recordCopy recordInfo isFinalizable.
	recordCopy recordInfo free.
	"Note that the variant code doesn't call RecordCreate to make the copy. Rather it calls RecordCopy to copy into task memory that it allocates. 
	This means it doesn't call RecordDestroy either, but rather just RecordClear's the memory and then frees the task memory its allocated."
	self assert: trackingRecordInfo copied removeFirst equals: pRect -> pRecordCopy.
	self assert: trackingRecordInfo cleared removeFirst equals: pRecordCopy.
	self verifyNoRecordInfoCalls.
	subject free.
	self assert: trackingRecordInfo cleared removeFirst equals: pRect.
	self assert: trackingRecordInfo destroyed removeFirst equals: pRect.
	self shutterTrackingRecordInfo!

testInternalRecord
	"Tests the case of a Record referencing or copied from a struct in Dolphin memory."

	<ignoreNotImplementedSelectors: #(#destroyed #cleared #initialized #copied)>
	| subject rectBytes refRecord copyRecord pCopyBytes recordInfo |
	trackingRecordInfo := anonRect := nil.
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
	recordInfo := subject recordInfo.
	refRecord := Record
				fromAddress: subject yourAddress
				recordInfo: recordInfo
				owner: subject.
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
		matching: [:ex | ex statusCode = 36].
	refRecord free.
	self verifyNoRecordInfoCalls.
	recordInfo free.
	copyRecord := Record fromBytes: rectBytes recordInfo: subject recordInfo.
	self assert: copyRecord bytes class equals: ByteArray.
	self assert: copyRecord needsFree.
	self assert: copyRecord isFinalizable.
	pCopyBytes := copyRecord bytes yourAddress asExternalAddress.
	self assert: trackingRecordInfo initialized removeFirst equals: pCopyBytes.
	self assert: trackingRecordInfo copied removeFirst
		equals: subject bytes yourAddress asExternalAddress -> pCopyBytes.
	self verifyNoRecordInfoCalls.
	self assert: copyRecord left equals: 16r7FFFFFFF.
	subject free.
	self assert: subject isNull.
	self deny: subject needsFree.
	self deny: subject isFinalizable.
	self verifyNoRecordInfoCalls.
	self assert: copyRecord left equals: 16r7FFFFFFF.
	copyRecord free.
	self assert: trackingRecordInfo cleared removeFirst equals: pCopyBytes.
	self shutterTrackingRecordInfo!

testInternalRecordInSafeArray
	<ignoreNotImplementedSelectors: #(#initialized #destroyed #cleared #copied)>
	| rect copyRecordRef array pRecordCopy arrayCopy pRect record pRecord |
	trackingRecordInfo := anonRect := nil.
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
	self assert: trackingRecordInfo copied removeFirst equals: pRect -> pRecord.
	self verifyNoRecordInfoCalls.
	"SafeArrayCopy will create a copy of the record using IRecordInfo::Copy, and will own that copy. The memory for the record is part of the SAFEARRAY block, so allocated internally by the SAFEARRAY."
	arrayCopy := array copy.
	self assert: arrayCopy isReferenceStruct.
	self assert: arrayCopy needsFree.
	self assert: arrayCopy isFinalizable.
	self assertIsNil: arrayCopy owner.
	self assert: arrayCopy vt equals: VT_ARRAY | VT_RECORD.
	copyRecordRef := arrayCopy at: 1.
	self assert: trackingRecordInfo copied removeFirst equals: pRecord -> copyRecordRef bytes.
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
	self assert: trackingRecordInfo cleared removeFirst equals: pRecordCopy.
	self verifyNoRecordInfoCalls.
	"Freeing the array should clear the copy of the original record copy of the rect that it made"
	array free.
	"Original rect should be untouched."
	self assert: rect left equals: 100.
	self assert: trackingRecordInfo cleared removeFirst equals: pRecord.
	self shutterTrackingRecordInfo!

testInternalRecordInVariant
	<ignoreNotImplementedSelectors: #(#initialized #destroyed #cleared #copied)>
	| rect recordCopy variant pRecordCopy copiedVariant pRect |
	trackingRecordInfo := anonRect := nil.
	rect := self createInternalTestSubject.
	pRect := rect yourAddress asExternalAddress.
	self verifyNoRecordInfoCalls.
	variant := rect asVariant.
	"Will have called CreateCopy"
	self assert: trackingRecordInfo created removeFirst equals: variant refAddress.
	self assert: trackingRecordInfo initialized removeFirst equals: variant refAddress.
	self assert: trackingRecordInfo copied removeFirst equals: pRect -> variant refAddress.
	self verifyNoRecordInfoCalls.
	self assert: variant value equals: rect.
	self assert: variant vt equals: VT_RECORD.
	"VariantCopyInd"
	copiedVariant := variant deepCopy.
	"Note that VariantCopyInd doesn't call RecordCreate or RecordCreateCopy, rather it calls RecordCopy to copy into task memory that it allocates."
	self assert: trackingRecordInfo copied removeFirst equals: variant refAddress -> copiedVariant refAddress.
	self verifyNoRecordInfoCalls.
	self assert: copiedVariant vt equals: VT_RECORD.
	recordCopy := copiedVariant value.
	"When we access the record copy in the variant, we create a reference to it"
	self assert: recordCopy owner equals: copiedVariant.
	self assert: recordCopy isReferenceStruct.
	self deny: recordCopy needsFree.
	self deny: recordCopy isFinalizable.
	self assert: recordCopy equals: rect.
	"The copy should have been allocated (by the Variant) from the task heap"
	pRecordCopy := recordCopy bytes.
	self assert: (TaskMemory didAlloc: pRecordCopy).
	"Freeing the variant should free the record copy"
	copiedVariant free.
	"Don't call didAlloc: for freed blocks if debugger present as it causes the debugger to break on a first change exception. This is expected, and continuing execution will proceed without failure, but it is unsettling/annoying."
	self isNativeDebuggerPresent ifFalse: [self deny: (TaskMemory didAlloc: pRecordCopy)].
	"As noted above the variant code doesn't call RecordCreate to make the copy. This means it doesn't call RecordDestroy either, but rather just RecordClear's the memory and then frees the task memory its allocated."
	self assert: trackingRecordInfo cleared removeFirst equals: pRecordCopy.
	self verifyNoRecordInfoCalls.
	pRect := variant refAddress.
	variant free.
	self assert: trackingRecordInfo cleared removeFirst equals: pRect.
	self shutterTrackingRecordInfo!

testInternalRecordRefInVariant
	<ignoreNotImplementedSelectors: #(#initialized #destroyed #cleared #copied)>
	| rect recordCopy variant copiedVariant pRecordCopy deepCopiedVariant recordRefCopy pRect |
	trackingRecordInfo := anonRect := nil.
	rect := self createInternalTestSubject.
	pRect := rect yourAddress asExternalAddress.
	variant := VARIANT new
				struct: rect;
				yourself.
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
	self assert: trackingRecordInfo copied removeFirst equals: pRect -> pRecordCopy.
	self assert: trackingRecordInfo cleared removeFirst equals: pRecordCopy.
	self shutterTrackingRecordInfo!

verifyNoRecordInfoCalls
	trackingRecordInfo bindingsDo: [:each | self assert: each value isEmpty]! !

!OS.COM.Tests.RecordTest categoriesForMethods!
createExternalTestSubject!helpers!private! !
createInternalTestSubject!helpers!private! !
createTrackingRectClass!helpers!private! !
shutterTrackingRecordInfo!helpers!private! !
tearDown!public!running! !
testExternalRecord!public!unit tests! !
testExternalRecordInSafeArray!public!unit tests! !
testExternalRecordInVariant!public!unit tests! !
testExternalRecordRefInVariant!public!unit tests! !
testInternalRecord!public!unit tests! !
testInternalRecordInSafeArray!public!unit tests! !
testInternalRecordInVariant!public!unit tests! !
testInternalRecordRefInVariant!public!unit tests! !
verifyNoRecordInfoCalls!helpers!private! !
!

