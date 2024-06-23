"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.COM.Tests.IMonikerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.IMonikerTest guid: (Core.GUID fromString: '{12c38016-378e-4ac7-9a33-8e88d5f9f709}')!

OS.COM.Tests.IMonikerTest comment: ''!

!OS.COM.Tests.IMonikerTest methodsFor!

getMonikerRegisteredClass: anIMoniker
	^((RegKey classesRoot: #read) at: 'CLSID\' , anIMoniker clsid asString) value!

should: aBlockClosure raiseHRESULT: anInteger
	self
		should: aBlockClosure
		raise: HRESULTError
		matching: [:ex | ex hresult asInteger = anInteger asInt32]!

shouldRaiseNotBindable: aBlockClosure
	self should: aBlockClosure raiseHRESULT: 16r800401E8	"MK_E_NOTBINDABLE: Moniker is not bindable"!

shouldRaiseNotImplemented: aBlockClosure
	self should: aBlockClosure raiseHRESULT: Win32Errors.E_NOTIMPL!

testClassMoniker
	| subject displayName clsid factory |
	clsid := CLSID fromString: '{0d43fe01-f093-11cf-8940-00a0c9054228}'.
	subject := IMoniker forCLSID: clsid.
	displayName := 'clsid:<s>:' << clsid idlString asUppercase.
	self assert: subject asString equals: displayName.
	self assert: subject displayName equals: displayName.
	self assert: subject displayString equals: displayName.
	self assert: subject printString equals: 'an IMoniker(<p>)' << displayName.
	self shouldRaiseNotImplemented: [subject isRunning].
	"Class monikers bind to class factories"
	factory := subject bindToObject: IClassFactory.
	self assert: factory notNull.
	self assert: (factory isKindOf: IClassFactory).
	factory free.

	"Not sure why this is the case."
	self assert: subject inverse asString equals: '\..'.
	self assert: subject isSystemMoniker.
	self assert: subject systemMonikerKind equals: #class.
	self assert: (subject queryInterface: IPersistStream) clsid displayString equals: 'clsid'.
	self assert: (self getMonikerRegisteredClass: subject) equals: 'ClassMoniker'!

testCommonPrefixWith
	| subject subject2 prefix |
	subject := IMoniker forPath: 'c:\windows\system32\kernel32.dll'.
	subject2 := IMoniker forPath: 'c:\windows\explorer.exe'.
	prefix := subject commonPrefixWith: subject2.
	self assert: prefix asString equals: 'c:\windows\'.
	self assert: prefix systemMonikerKind equals: #file.
	self assert: (subject2 commonPrefixWith: subject) asString equals: 'c:\windows\'.
	subject2 free.
	subject2 := IMoniker forPath: 'z:\windows\explorer.exe'.
	self should: [subject commonPrefixWith: subject2] raiseHRESULT: 16r800401EE	"MK_E_NOPREFIX: No common prefix"!

testComparing
	| foo foo2 bar |
	foo := IMoniker forPath: 'c:\foo'.
	foo2 := IMoniker forPath: 'c:\Foo'.
	self assert: foo equals: foo2.
	self assert: foo2 equals: foo.
	self assert: foo hash equals: foo2 hash.
	bar := IMoniker forPath: 'c:\bar'.
	self deny: foo equals: bar.
	self deny: bar equals: foo.
	self deny: foo hash equals: bar hash!

testComposeWith
	| subject anti foo bar compositeString |
	foo := IMoniker forPath: 'c:\foo'.
	subject := foo composeWith: (IMoniker forPath: 'bar').
	self assert: subject asString equals: 'c:\foo\bar'.
	self assert: subject isSystemMoniker.
	self assert: subject systemMonikerKind equals: #file.
	self assert: subject components isEmpty.
	self deny: subject isRunning.
	anti := subject inverse.
	self assert: anti asString equals: '\..'.
	self assert: anti systemMonikerKind equals: #anti.
	self assert: (subject composeWith: anti) isNull.
	self assert: anti components isEmpty.
	anti free.
	subject free.
	"Example which composes a typical file!!item moniker (must be generic)."
	bar := IMoniker forItem: 'bar'.
	subject := foo composeWith: bar.
	compositeString := 'c:\foo!!bar'.
	self assert: subject displayName equals: compositeString.
	self assert: subject displayString equals: compositeString.
	self assert: subject printString equals: 'an IMoniker(<p>)' << compositeString.
	self assert: subject isSystemMoniker.
	self assert: subject systemMonikerKind equals: #composite.
	self assert: subject components equals: {foo. bar}.
	self assert: (self getMonikerRegisteredClass: subject) equals: 'CompositeMoniker'.
	self deny: subject isRunning.
	anti := subject inverse.
	self assert: anti asString equals: '\..\..'.
	self assert: anti systemMonikerKind equals: #composite.
	self assert: (subject composeWith: anti) isNull.
	self assert: anti components equals: {foo inverse. bar inverse}.
	anti free.
	subject free!

testEnum
	| subject foo barDir barItem |
	foo := IMoniker forPath: 'c:\foo'.
	barDir := IMoniker forPath: 'bar'.
	subject := foo composeWith: barDir.
	"Not a composite moniker, just a longer path moniker"
	self assert: (subject enum: true) contents isEmpty.
	subject free.
	barDir free.
	"Now an actual composite moniker which is enumerable"
	barItem := IMoniker forItem: 'bar'.
	subject := foo composeWith: barItem.
	self assert: (subject enum: true) contents equals: {foo. barItem}.
	self assert: (subject enum: false) contents equals: {barItem. foo}.
	subject free.
	foo free.
	barItem free.
	subject := IMoniker forPointer: IMalloc task.
	self assert: (subject enum: true) contents isEmpty!

testFileMoniker
	| subject path |
	path := self class fileOutName.
	subject := IMoniker forPath: path.
	self assert: subject asString equals: path.
	self assert: subject displayName equals: path.
	self assert: subject displayString equals: path.
	self assert: subject printString equals: 'an IMoniker(<p>)' << path.
	self deny: subject isRunning.
	"Not sure why this is the case."
	self assert: subject inverse asString equals: '\..'.
	self assert: subject isSystemMoniker.
	self assert: subject systemMonikerKind equals: #file.
	self assert: (self getMonikerRegisteredClass: subject) equals: 'FileMoniker'.
	self assert: subject components isEmpty!

testInverse
	| subject anti |
	subject := IMoniker forPath: 'c:\temp'.
	anti := subject inverse.
	self assert: anti asString equals: '\..'.
	self assert: anti isSystemMoniker.
	self assert: anti systemMonikerKind equals: #anti.
	self assert: (subject composeWith: anti) isNull.
	self assert: anti components isEmpty.
	self deny: anti isRunning.
	anti free!

testItemMoniker
	| subject |
	subject := IMoniker forItem: 'blah'.
	self assert: subject asString equals: '!!blah'.
	self assert: subject displayString equals: '!!blah'.
	self assert: subject printString equals: 'an IMoniker(''!!blah'')'.
	self deny: subject isRunning.
	"Not sure why this is the case."
	self assert: subject inverse asString equals: '\..'.
	self assert: subject isSystemMoniker.
	self assert: subject systemMonikerKind equals: #item.
	self assert: subject components isEmpty.
	self assert: (self getMonikerRegisteredClass: subject) equals: 'ItemMoniker'!

testPointerMoniker
	| subject bound |
	"The task memory allocator is a convenient object to monikerise"
	subject := IMoniker forPointer: IMalloc task.
	self shouldRaiseNotImplemented: [subject displayName].
	self assert: subject printString equals: 'an IMoniker(<1p>)' << subject bytes.
	self assert: subject displayString equals: subject printString.
	self assert: subject isSystemMoniker.
	self assert: subject systemMonikerKind equals: #pointer.
	self assert: subject components isEmpty.
	self assert: (self getMonikerRegisteredClass: subject) equals: 'PointerMoniker'.
	"Any object wrapped by a  pointer moniker is implicitly running, although not in the ROT"
	self assert: subject isRunning.
	bound := subject bindToObject: IMalloc.
	self assert: bound equals: IMalloc task!

testRelativePathTo
	| subject relative subdir item |
	subject := IMoniker forPath: FileLocator imageRelative basePath.
	subdir := IMoniker forPath: IUnknown owningPackage fileOutName.
	relative := subject relativePathTo: subdir.
	self assert: relative asString equals: 'Core\Object Arts\Dolphin\ActiveX\COM\OLE COM.pax'.
	relative free.
	relative := subdir relativePathTo: subject.
	self assert: relative asString equals: '..\..\..\..\..\..\'.
	self assert: relative systemMonikerKind equals: #file.
	relative free.
	item := IMoniker forItem: 'blah'.
	relative := subject relativePathTo: item.
	self assert: relative asString equals: '!!blah'.
	self assert: relative systemMonikerKind equals: #item.
	relative free.
	self shouldRaiseNotBindable: [item relativePathTo: subject].
	item free.
	subject free!

testTimeOfLastChange
	| subject tmp |
	tmp := File tempPath.
	subject := IMoniker forPath: tmp.
	"1) Time the temp dir was last modified"
	self assert: subject timeOfLastChange equals: (File lastWriteTime: tmp).
	self shouldRaiseNotImplemented: [subject inverse timeOfLastChange].
	subject free.

	"2) Attempt to bind an item moniker without specifying context, gives error:"
	subject := IMoniker forItem: 'blah'.
	self shouldRaiseNotBindable: [subject timeOfLastChange].
	subject free.
	"3) Pointer moniker, not implemented:"
	subject := IMoniker forPointer: IMalloc task.
	self shouldRaiseNotImplemented: [subject timeOfLastChange]! !

!OS.COM.Tests.IMonikerTest categoriesForMethods!
getMonikerRegisteredClass:!helpers!private! !
should:raiseHRESULT:!helpers!private! !
shouldRaiseNotBindable:!helpers!private! !
shouldRaiseNotImplemented:!helpers!private! !
testClassMoniker!public!unit tests! !
testCommonPrefixWith!public!unit tests! !
testComparing!public!unit tests! !
testComposeWith!public!unit tests! !
testEnum!public!unit tests! !
testFileMoniker!public!unit tests! !
testInverse!public!unit tests! !
testItemMoniker!public!unit tests! !
testPointerMoniker!public!unit tests! !
testRelativePathTo!public!unit tests! !
testTimeOfLastChange!public!unit tests! !
!

