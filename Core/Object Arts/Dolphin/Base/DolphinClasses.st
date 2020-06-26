"Class Definitions"!

nil subclass: #Object
	instanceVariableNames: ''
	classVariableNames: '_AssertionFailureSignal _DependentsRegister _EventsRegister _PropertyRegister'
	poolDictionaries: '_InstanceBehaviorMasks'
	classInstanceVariableNames: ''
	classConstants: {}!
nil subclass: #ProtoObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #AbstractBindingReference
	instanceVariableNames: ''
	classVariableNames: 'Undeclared'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #ArrayFieldLength
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #AttributeDescriptor
	instanceVariableNames: 'flags'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'AccessorMask' -> 16r4.
		'MutableMask' -> 16r20.
		'MutatorMask' -> 16r8.
		'NonBrowsableMask' -> 16r80.
		'NullableMask' -> 16r40.
		'OverrideMask' -> 16r10.
		'ReadableMask' -> 16r1.
		'WriteableMask' -> 16r2
	}!
Object subclass: #Behavior
	instanceVariableNames: 'superclass methodDictionary instanceSpec subclasses'
	classVariableNames: '_NullMethodDictionary'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_BasicSpecMask' -> 16r7FFF.
		'_BytesSubMask' -> 16r4800.
		'_FundamentalShapeMask' -> 16r30FF.
		'_IndirectMask' -> 16r800.
		'_MournerMask' -> 16r400.
		'_NonInstantiableMask' -> 16r200.
		'_NullTermMask' -> 16r4000.
		'_PointersMask' -> 16r2000.
		'_ShapeMask' -> 16r70FF.
		'_SizeMask' -> 16rFF.
		'_VariableMask' -> 16r1000
	}!
Object variableSubclass: #BlockClosure
	instanceVariableNames: 'outer method initialIP info receiver'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #Boolean
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #Bytecode
	instanceVariableNames: 'instruction args jumpTarget ip'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #ByteCodeDispatcher
	instanceVariableNames: 'byteCodes method ip interpreter instructionLength byteCode instructions'
	classVariableNames: 'RunStarts'
	poolDictionaries: 'OpcodePool'
	classInstanceVariableNames: ''
	classConstants: {
		'FirstShowSpecialSend' -> 16r7E.
		'InstructionLengths' -> #[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 7 4 4 5 ].
		'Instructions' -> #(#break #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushInstVar: #shortPushTemp: #shortPushTemp: #shortPushTemp: #shortPushTemp: #shortPushTemp: #shortPushTemp: #shortPushTemp: #shortPushTemp: #pushContextTemp: #pushContextTemp: #shortPushOuterTemp: #shortPushOuterTemp: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushConst: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #shortPushStatic: #pushSelf #pushPseudo: #pushPseudo: #pushPseudo: #shortPushImmediate: #shortPushImmediate: #shortPushImmediate: #shortPushImmediate: #shortPushSelfAndTemp: #shortPushSelfAndTemp: #shortPushSelfAndTemp: #shortPushSelfAndTemp: #shortStoreTemp: #shortStoreTemp: #shortStoreTemp: #shortStoreTemp: #shortPopPushTemp: #shortPopPushTemp: #popPushSelf #popDup #popContextTemp: #popContextTemp: #shortPopOuterTemp: #shortPopOuterTemp: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopInstVar: #shortPopTemp: #shortPopTemp: #shortPopTemp: #shortPopTemp: #shortPopTemp: #shortPopTemp: #shortPopTemp: #shortPopTemp: #popStackTop #incrementStackTop #decrementStackTop #duplicateStackTop #returnSelf #returnPseudo: #returnPseudo: #returnPseudo: #returnFromMessage #returnFromBlock #returnFromBlockHome #popReturnSelf #nop #shortJump: #shortJump: #shortJump: #shortJump: #shortJump: #shortJump: #shortJump: #shortJump: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortJumpIfFalse: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #isZero #pushActiveFrame #shortSpecialSendEx: #shortSpecialSendEx: #shortSpecialSendEx: #shortSpecialSendEx: #pushInstVar: #pushTemp: #pushConst: #pushStatic: #storeInstVar: #storeTemp: #storeStatic: #popInstVar: #popTemp: #popStatic: #pushImmediate: #pushChar: #send: #supersend: #specialSend: #nearJump: #nearJumpIfTrue: #nearJumpIfFalse: #nearJumpIfNil: #nearJumpIfNotNil: #unused: #unused: #sendTempZeroArgs: #pushSelfAndTemp: #pushOuterTemp: #storeOuterTemp: #popOuterTemp: #sendSelfZeroArgs: #unused: #pushTempPair: #longPushConst:with: #longPushStatic:with: #longStoreStatic:with: #longPopStoreStatic:with: #longPushImmediate:with: #longSend:with: #longSupersend:with: #longJump:with: #longJumpIfTrue:with: #longJumpIfFalse:with: #longJumpIfNil:with: #longJumpIfNotNil:with: #pushOuter:temp: #storeOuter:temp: #incTemp:temp: #incPushTemp:temp: #decTemp:temp: #decPushTemp:temp: #blockCopy:stack:env:copy:offset1:offset2: #exLongSend:with:with: #exLongSupersend:with:with: #exLongPushImmediate:byte2:byte3:byte4:)
	}!
Object subclass: #Category
	instanceVariableNames: 'name'
	classVariableNames: 'PermanentCategories'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #ChunkReader
	instanceVariableNames: 'chunkBlock endAction context'
	classVariableNames: 'Null'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #ClassBuilder
	instanceVariableNames: 'currentClass className instanceVariables superclass instanceSpec classVariables sharedPools comment flags categories classConstants'
	classVariableNames: 'FixedInitialLayout FixedLayout Unsubclassable'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'IgnoreInstsMask' -> 16r2.
		'RecompileMask' -> 16r1
	}!
Object subclass: #Collection
	instanceVariableNames: ''
	classVariableNames: 'AbsentCookie'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #CompilationResult
	instanceVariableNames: 'method rawTextMap rawTempsMap textMap tempsMap oldMethod package'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object variableSubclass: #CompiledCode
	instanceVariableNames: 'header methodClass selector sourceDescriptor byteCodes'
	classVariableNames: 'InfoCacheKeys InfoCacheValues'
	poolDictionaries: 'OpcodePool'
	classInstanceVariableNames: ''
	classConstants: {
		'PrivateMask' -> 16r1
	}!
Object subclass: #Compiler
	instanceVariableNames: ''
	classVariableNames: 'DefaultFlags DisabledWarnings'
	poolDictionaries: 'CompilerFlags SmalltalkParseErrorCodes'
	classInstanceVariableNames: ''
	classConstants: {}!
Object variableSubclass: #Context
	instanceVariableNames: 'outer block'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #DeadObject
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #DeafObject
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #DeferredValue
	instanceVariableNames: 'valueAvailable value exception'
	classVariableNames: 'ValuePending'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #Delay
	instanceVariableNames: 'duration resumptionTime waitSemaphore'
	classVariableNames: 'AccessProtect Current HighestResolution ImageClock LowestResolution Pending Resolution TicksToNanos TimingProcess TimingSemaphore'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'DefaultResolution' -> 16r3D09
	}!
Object subclass: #DiskVolumeInformation
	instanceVariableNames: 'path rootPath label serialNumber maxComponentLength fileSystemFlags fileSystemName sectorsPerCluster bytesPerSector freeClusters totalClusters freeBytes totalBytes totalFreeBytes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #Exception
	instanceVariableNames: 'tag messageText _activeHandler _process _signalFrame _environmentWhenRaised _continueBlock _resignalBlock _resignalException'
	classVariableNames: ''
	poolDictionaries: 'MessageBoxConstants Win32Constants Win32Errors'
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #ExceptionHandlerAbstract
	instanceVariableNames: 'outer protectedBlock returnContinuation'
	classVariableNames: 'RetryCookie'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #ExceptionSet
	instanceVariableNames: 'selectors'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #ExternalCallback
	instanceVariableNames: 'thunk cookie descriptor'
	classVariableNames: 'Registry ThunkBase'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {
		'ArgSizeOffset' -> 16rE.
		'MaxThunks' -> 16r100.
		'ThunkSize' -> 16r10
	}!
Object variableSubclass: #ExternalDescriptor
	instanceVariableNames: 'descriptor'
	classVariableNames: 'CallingConventions ExternalReferenceTypes ExternalValueTypes Shared TypeNames TypeSizes'
	poolDictionaries: 'ExtCallArgTypes'
	classInstanceVariableNames: ''
	classConstants: {
		'RetClassIndex' -> 16r4.
		'RetTypeMask' -> 16r3F
	}!
Object subclass: #ExternalLibrary
	instanceVariableNames: 'handle'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants Win32Errors'
	classInstanceVariableNames: 'default'
	classConstants: {}!
Object subclass: #ExternalStructure
	instanceVariableNames: 'bytes'
	classVariableNames: 'RecordClasses'
	poolDictionaries: ''
	classInstanceVariableNames: 'template flags alignment'
	classConstants: {
		'CompiledMask' -> 16r1
	}!
Object subclass: #File
	instanceVariableNames: 'handle spec flags shareFlags intBuffer'
	classVariableNames: 'CheckModes NoCheckModes ShareModes'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'AccessFlagsMask' -> -16r8.
		'OpenFlagsMask' -> 16r7
	}!
Object subclass: #FileLocator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object variableByteSubclass: #GUID
	instanceVariableNames: ''
	classVariableNames: 'Null'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #InputState
	instanceVariableNames: 'inputSemaphore idler idleTimer main windows deferredActions lastWindow wakeupEvent msgWindow queueStatusMask'
	classVariableNames: 'EnumHandlesDescriptor MaxIdleSleep SamplingInterval UserInterruptSignal'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #InstructionInterpreter
	instanceVariableNames: 'dispatcher'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #Keyboard
	instanceVariableNames: 'state virtualKeys modifierKeys keyNames'
	classVariableNames: 'DefaultInstance InvariantInstance'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #Link
	instanceVariableNames: 'nextLink'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #Locale
	instanceVariableNames: 'numberFormat'
	classVariableNames: 'Invariant SystemDefault TimeZoneInfo UserDefault'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #Magnitude
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #MemoryManager
	instanceVariableNames: 'finalizer lastRequests hospice hospiceHighWater maxObjects undertaker bereavements bereaved bereavedHighWater gcInterval lastGCTime lastGCDuration objectHeaderSize events'
	classVariableNames: 'Current GCInterval'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #Message
	instanceVariableNames: 'selector args'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #MessageSequenceAbstract
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #MethodName
	instanceVariableNames: 'className selector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #MethodProtocol
	instanceVariableNames: 'name comment selectors flags'
	classVariableNames: 'ANSIMask Protocols ReadOnlyMask StubAddedSignal'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #ModalMsgLoop
	instanceVariableNames: 'loop'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #Model
	instanceVariableNames: 'events'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #Mutex
	instanceVariableNames: 'owner semaphore'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #ObjectRegistry
	instanceVariableNames: 'registry'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #Package
	instanceVariableNames: 'name packagePathname comment classNames methodNames variableNames prerequisiteNames events scripts doNotReuse imageStripperBytes aboutBlock packageVersion manualPrerequisites timestamp untracedVariables changeIndex properties preDeclareClassesOnLoad'
	classVariableNames: '_Uncommitted BinaryPacLoader ChangedIcon CheckTimestamps ClashSignal PreDeclareClassesOnLoad SourcePackageIcon UnsaveableSignal'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #PackageManager
	instanceVariableNames: 'packages processEvents packagedVariables looseMethods events defaultPackage basePackages'
	classVariableNames: 'Current DuplicatePackageSignal PackageNotFoundSignal PrerequisiteNotFoundSignal SystemPackage'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #PostedActionWindow
	instanceVariableNames: 'handle actions'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #ProcessorScheduler
	instanceVariableNames: 'processLists activeProcess pendingReturns comStubs _reserved pendingTerminations'
	classVariableNames: 'ConstWriteSignal InterruptSelectors'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #PropertyManager
	instanceVariableNames: 'register'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #ResourceIdentifier
	instanceVariableNames: 'owningClass selector'
	classVariableNames: 'SelectorPrefix'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #SearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #SessionManager
	instanceVariableNames: 'inputState resourceLibrary imagePath servers argv cmdLineFlags state sentry startupArgs consoleHandler stdioStreams eventLogHandle flags sessionId hConsole settingsChanged events'
	classVariableNames: 'Current PreStartFile'
	poolDictionaries: 'Win32Constants Win32Errors'
	classInstanceVariableNames: ''
	classConstants: {
		'EmbeddingMask' -> 16r1.
		'SettingsChangeTimerId' -> 16r2
	}!
Object subclass: #SharedQueue
	instanceVariableNames: 'accessProtect valueAvailable contents'
	classVariableNames: 'AbsentCookie'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #Signal
	instanceVariableNames: 'description resumable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #SortAlgorithm
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #Sound
	instanceVariableNames: 'name location type fileLocator'
	classVariableNames: 'Registry'
	poolDictionaries: 'MessageBoxConstants Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #SourceFiler
	instanceVariableNames: 'stream evaluationContext flags'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'SourceOnlyMask' -> 16r1
	}!
Object subclass: #SourceManager
	instanceVariableNames: 'mutex'
	classVariableNames: 'ChangesIndex DefaultInstance SourcesIndex'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #StackFrame
	instanceVariableNames: 'process index'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'BPOffset' -> 16r5.
		'EnvOffset' -> 16r1.
		'FrameSize' -> 16r6.
		'IPOffset' -> 16r3.
		'MethodOffset' -> 16r0.
		'ReturnOffset' -> 16r2.
		'SPOffset' -> 16r4
	}!
Object subclass: #STBClassConversion
	instanceVariableNames: 'version instSize dataClass isVariable converterBlock filer'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #STBFiler
	instanceVariableNames: 'stream context version'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'MaxPredefinedRef' -> 16r18
	}!
Object subclass: #STBPrefix
	instanceVariableNames: 'dword'
	classVariableNames: 'DataPrefix ProxyPrefix'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'BytesMask' -> 16r10.
		'CharacterMask' -> 16r4.
		'ClassPrefixMask' -> 16r4.
		'DataPrefixMask' -> 16r2.
		'IndexShift' -> -16r4.
		'InstSizeMask' -> 16rFF.
		'InstSizeShift' -> -16r8.
		'LiteralPrefixMask' -> 16r8.
		'LocatorLenShift' -> -16r10.
		'MaxPredefinedRef' -> 16r18.
		'NonZeroVersionMask' -> 16r40.
		'ProxyMask' -> 16r8.
		'SmallIntegerMask' -> 16r1.
		'VariableMask' -> 16r20
	}!
Object subclass: #STBProxy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #Stream
	instanceVariableNames: ''
	classVariableNames: 'EndOfStreamSignal'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #UndeclaredVariable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #UndefinedObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Object subclass: #VersionInfo
	instanceVariableNames: 'fileInfo prefix fixedInfo'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractBindingReference subclass: #BindingReference
	instanceVariableNames: 'pathString path context binding generation'
	classVariableNames: 'Generation'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractBindingReference subclass: #MetaBindingReference
	instanceVariableNames: 'instance'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ArrayFieldLength subclass: #FixedArrayFieldLength
	instanceVariableNames: 'elementCount'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AttributeDescriptor subclass: #ExternalField
	instanceVariableNames: 'offset structClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalField subclass: #EmbeddedField
	instanceVariableNames: 'fieldClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalField subclass: #FillerField
	instanceVariableNames: 'byteSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalField subclass: #PointerField
	instanceVariableNames: 'pointerClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalField subclass: #ScalarField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
EmbeddedField subclass: #ArrayField
	instanceVariableNames: 'arrayLength'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
EmbeddedField subclass: #StructureField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ArrayField subclass: #StringField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ArrayField subclass: #StructureArrayField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StructureArrayField subclass: #PointerArrayField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PointerField subclass: #ArrayPointerField
	instanceVariableNames: 'arrayLength'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ArrayPointerField subclass: #StructureArrayPointerField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StructureArrayPointerField subclass: #PointerArrayPointerField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScalarField subclass: #AbstractCHARField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScalarField subclass: #BOOLField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScalarField subclass: #BYTEField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScalarField subclass: #DOUBLEField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScalarField subclass: #DWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScalarField subclass: #FLOATField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScalarField subclass: #INT_PTRField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScalarField subclass: #QWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScalarField subclass: #SBYTEField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScalarField subclass: #SDWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScalarField subclass: #SQWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScalarField subclass: #SWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScalarField subclass: #UINT_PTRField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScalarField subclass: #WORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractCHARField subclass: #CHARField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractCHARField subclass: #WCHARField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
BOOLField subclass: #BOOLEANField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
UINT_PTRField subclass: #HANDLEField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
UINT_PTRField subclass: #LPVOIDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Behavior subclass: #ClassDescription
	instanceVariableNames: 'instanceVariables methodsCatalogue protocols'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ClassDescription subclass: #Class
	instanceVariableNames: 'name classPool sharedPools comment classCategories _guid'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ClassDescription subclass: #Metaclass
	instanceVariableNames: 'instanceClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Boolean subclass: #False
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Boolean subclass: #True
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Category subclass: #ClassCategory
	instanceVariableNames: ''
	classVariableNames: 'Table Unclassified'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Category subclass: #MethodCategory
	instanceVariableNames: ''
	classVariableNames: 'Private Pseuds Public Table'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Collection subclass: #Bag
	instanceVariableNames: 'contents'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Collection subclass: #SequenceableCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Collection variableSubclass: #Set
	instanceVariableNames: 'tally'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'MaxOffsetIndex' -> 16r402.
		'PrimeSizes' -> #(2069 2237 2423 2617 2797 2999 3167 3359 3539 3727 3911 4441 4787 5119 5471 5801 6143 6521 6827 7177 7517 7853 8783 9601 10243 10867 11549 12239 12919 13679 14293 15013 15731 17569 19051 20443 21767 23159 24611 25847 27397 28571 30047 31397 35771 38201 40841 43973 46633 48989 51631 54371 57349 60139 62969 70589 76091 80347 85843 90697 95791 101027 106261 111143 115777 120691 126311 140863 150523 160969 170557 181243 190717 201653 211891 221251 232591 242873 251443 282089 300869 321949 341227 362353 383681 401411 422927 443231 464951 482033 504011 562621 605779 647659 681607 723623 763307 808261 844709 886163 926623 967229 1014617).
		'SmallPrimeOffsets' -> #[0 0 0 8 6 4 2 0 0 2 0 4 2 0 0 4 2 0 2 0 0 2 0 4 2 0 4 2 0 0 4 2 0 2 0 0 4 2 0 8 6 4 2 0 6 4 2 0 2 0 0 2 0 0 2 0 12 10 8 6 4 2 0 2 0 4 2 0 0 8 6 4 2 0 0 4 2 0 4 2 0 2 0 4 2 0 4 2 0 0 8 6 4 2 0 0 2 0 0 10 8 6 4 2 0 10 8 6 4 2 0 2 0 0 2 0 4 2 0 0 8 6 4 2 0 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 52 50 48 46 44 42 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 0 16 14 12 10 8 6 4 2 0 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 52 50 48 46 44 42 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 2 0 10 8 6 4 2 0 10 8 6 4 2 0 10 8 6 4 2 0 4 2 0 12 10 8 6 4 2 0 16 14 12 10 8 6 4 2 0 14 12 10 8 6 4 2 0 4 2 0 6 4 2 0 14 12 10 8 6 4 2 0 10 8 6 4 2 0 16 14 12 10 8 6 4 2 0 0 22 20 18 16 14 12 10 8 6 4 2 0 2 0 10 8 6 4 2 0 16 14 12 10 8 6 4 2 0 22 20 18 16 14 12 10 8 6 4 2 0 6 4 2 0 8 6 4 2 0 6 4 2 0 10 8 6 4 2 0 2 0 6 4 2 0 4 2 0 2 0 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 12 10 8 6 4 2 0 14 12 10 8 6 4 2 0 0 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 2 0 12 10 8 6 4 2 0 4 2 0 2 0 18 16 14 12 10 8 6 4 2 0 2 0 16 14 12 10 8 6 4 2 0 6 4 2 0 2 0 4 2 0 4 2 0 12 10 8 6 4 2 0 2 0 4 2 0 4 2 0 6 4 2 0 16 14 12 10 8 6 4 2 0 10 8 6 4 2 0 8 6 4 2 0 0 14 12 10 8 6 4 2 0 0 8 6 4 2 0 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 0 2 0 18 16 14 12 10 8 6 4 2 0 10 8 6 4 2 0 20 18 16 14 12 10 8 6 4 2 0 0 8 6 4 2 0 6 4 2 0 8 6 4 2 0 10 8 6 4 2 0 6 4 2 0 14 12 10 8 6 4 2 0 4 2 0 4 2 0 0 26 24 22 20 18 16 14 12 10 8 6 4 2 0 18 16 14 12 10 8 6 4 2 0 2 0 4 2 0 0 4 2 0 2 0 0 2 0 10 8 6 4 2 0 6 4 2 0 44 42 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 6 4 2 0 26 24 22 20 18 16 14 12 10 8 6 4 2 0 18 16 14 12 10 8 6 4 2 0 2 0 12 10 8 6 4 2 0 2 0 0 16 14 12 10 8 6 4 2 0 8 6 4 2 0 0 2 0 4 2 0 16 14 12 10 8 6 4 2 0 18 16 14 12 10 8 6 4 2 0 10 8 6 4 2 0 8 6 4 2 0 4 2 0 6 4 2 0 2 0 6 4 2 0 2 0 16 14 12 10 8 6 4 2 0 4 2 0 10 8 6 4 2 0 0 4 2 0 8 6 4 2 0 24 22 20 18 16 14 12 10 8 6 4 2 0 2 0 0 22 20 18 16 14 12 10 8 6 4 2 0 2 0 0 8 6 4 2 0 10 8 6 4 2 0 0 8 6 4 2 0 6 4 2 0 4 2 0 4 2 0 4 2 0 22 20 18 16 14 12 10 8 6 4 2 0 2 0 12 10 8 6 4 2 0 8 6 4 2 0 10 8 6 4 2 0 6 4 2 0 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 4 2 0 8 6 4 2 0 0 8 6 4 2 0 16 14 12 10 8 6 4 2 0 4 2 0 18 16 14 12 10 8 6 4 2 0 14 12 10 8 6 4 2 0 0 26 24 22 20 18 16 14 12 10 8 6 4 2 0 6 4 2 0 4 2 0 4 2 0 2 0 6 4 2 0 4 2 0 8 6 4 2 0 0 8 6 4 2 0 12 10 8 6 4 2 0 ]
	}!
SequenceableCollection subclass: #ArrayedCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SequenceableCollection subclass: #Interval
	instanceVariableNames: 'start stop step'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SequenceableCollection subclass: #SequencedGrowableCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ArrayedCollection variableSubclass: #Array
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ArrayedCollection variableByteSubclass: #ByteArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ArrayedCollection subclass: #RunArray
	instanceVariableNames: 'values runs'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ArrayedCollection variableByteSubclass: #String
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'empty'
	classConstants: {
		'EncodingAnsi' -> 16r0.
		'Encodings' -> #(#ansi #utf8 #utf16le #utf32).
		'EncodingUtf16' -> 16r2.
		'EncodingUtf32' -> 16r3.
		'EncodingUtf8' -> 16r1.
		'LineDelimiter' -> '
'
	}!
ArrayedCollection variableSubclass: #WeakArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ByteArray variableByteSubclass: #ExternalIntegerBytes
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalIntegerBytes variableByteSubclass: #DWORDBytes
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalIntegerBytes variableByteSubclass: #UIntPtrBytes
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
UIntPtrBytes variableByteSubclass: #ExternalAddress
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
UIntPtrBytes variableByteSubclass: #ExternalHandle
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalAddress variableByteSubclass: #ExternalMemory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalAddress variableByteSubclass: #REFGUID
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
String variableByteSubclass: #AnsiString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
String variableByteSubclass: #UtfEncodedString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
UtfEncodedString variableByteSubclass: #Utf16String
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'Bom' -> #[255 254 ].
		'LeadOffset' -> 16rD7C0.
		'SurrogateOffset' -> 16r35FDC00
	}!
UtfEncodedString variableByteSubclass: #Utf8String
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'Bom' -> #[239 187 191 ].
		'LeadByteMask2' -> 16rC0.
		'LeadByteMask3' -> 16rE0.
		'LeadByteMask4' -> 16rF0.
		'TrailByteMask' -> 16r80
	}!
Utf8String variableByteSubclass: #Symbol
	instanceVariableNames: ''
	classVariableNames: 'Table'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'CharClassifications' -> #(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #binary nil nil nil #binary #binary nil nil nil #binary #binary #binary #binary nil #binary #digit #digit #digit #digit #digit #digit #digit #digit #digit #digit #colon nil #binary #binary #binary #binary #binary #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic nil #binary nil nil #alphabetic nil #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic #alphabetic nil #binary nil #binary nil)
	}!
WeakArray variableSubclass: #MourningWeakArray
	instanceVariableNames: 'pathologist'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SequencedGrowableCollection subclass: #LinkedList
	instanceVariableNames: 'firstLink lastLink'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SequencedGrowableCollection variableSubclass: #OrderedCollection
	instanceVariableNames: 'firstIndex lastIndex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LinkedList subclass: #Semaphore
	instanceVariableNames: 'signals'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
OrderedCollection variableSubclass: #SortedCollection
	instanceVariableNames: 'algorithm'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Set variableSubclass: #Dictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Set variableSubclass: #IdentitySet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Set variableSubclass: #PluggableSet
	instanceVariableNames: 'searchPolicy'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Set variableSubclass: #SharedSet
	instanceVariableNames: 'mutex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Dictionary variableSubclass: #LookupTable
	instanceVariableNames: 'values'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Dictionary variableSubclass: #PoolDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Dictionary variableSubclass: #SystemDictionary
	instanceVariableNames: 'events allClasses allRoots'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LookupTable variableSubclass: #IdentityDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LookupTable variableSubclass: #PluggableLookupTable
	instanceVariableNames: 'searchPolicy'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LookupTable variableSubclass: #SharedLookupTable
	instanceVariableNames: 'mutex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
IdentityDictionary variableSubclass: #MethodDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SharedLookupTable variableSubclass: #DeferredValueTable
	instanceVariableNames: 'priority'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SharedLookupTable variableSubclass: #SharedIdentityDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SharedLookupTable variableSubclass: #WeakLookupTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SharedIdentityDictionary variableSubclass: #EventsCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
EventsCollection variableSubclass: #NullEventsCollection
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
WeakLookupTable variableSubclass: #WeakIdentityDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PoolDictionary variableSubclass: #PoolConstantsDictionary
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SharedSet variableSubclass: #SharedIdentitySet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SharedSet variableSubclass: #WeakSet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
WeakSet variableSubclass: #WeakIdentitySet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CompiledCode variableSubclass: #CompiledExpression
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CompiledCode variableSubclass: #CompiledMethod
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CompiledMethod variableSubclass: #CompileFailedMethod
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CompiledMethod variableSubclass: #ExternalMethod
	instanceVariableNames: ''
	classVariableNames: 'ArgsLenIndex ArgumentStartIndex CallingConventionIndex ReturnParmIndex ReturnTypeIndex'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Exception subclass: #Error
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Exception subclass: #Notification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Exception subclass: #ProcessTermination
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Exception subclass: #StackOverflow
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Error subclass: #ArithmeticError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Error subclass: #BoundsError
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Error subclass: #CannotReturnError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Error subclass: #ClassRemovalError
	instanceVariableNames: 'originalError'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Error subclass: #CRTError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Error subclass: #HRESULTError
	instanceVariableNames: 'errorInfo osErrorMessage'
	classVariableNames: 'FacilityClasses'
	poolDictionaries: 'FacilityCodes'
	classInstanceVariableNames: ''
	classConstants: {}!
Error subclass: #InvalidArgumentError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Error subclass: #InvalidExternalCall
	instanceVariableNames: 'argument type'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Error subclass: #InvalidFormat
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Error subclass: #MessageNotUnderstood
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Error subclass: #NotFoundError
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Error subclass: #OperationAborted
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Error subclass: #RaisedSignal
	instanceVariableNames: 'signalType'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Error subclass: #STBError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Error subclass: #SubclassResponsibilityError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ArithmeticError subclass: #FloatingPointException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ArithmeticError subclass: #ZeroDivide
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
HRESULTError subclass: #Win32Error
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Win32Error subclass: #FileException
	instanceVariableNames: 'file resumable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Win32Error subclass: #OutOfMemoryError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Win32Error subclass: #RPCError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Win32Error subclass: #Win32Fault
	instanceVariableNames: 'exceptionRecord'
	classVariableNames: 'ExceptionNames'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Win32Fault subclass: #GPFault
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Notification subclass: #CompilerNotification
	instanceVariableNames: 'position ranges line extras methodClass source selector offset'
	classVariableNames: 'ErrorFormats'
	poolDictionaries: 'SmalltalkParseErrorCodes'
	classInstanceVariableNames: ''
	classConstants: {}!
Notification subclass: #HRESULTNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Notification subclass: #MethodCompileFailed
	instanceVariableNames: 'compilerErrorNotification'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Notification subclass: #RaisedNotificationSignal
	instanceVariableNames: 'signalType'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Notification subclass: #Warning
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CompilerNotification subclass: #CompilerErrorNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CompilerNotification subclass: #CompilerInfoNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CompilerNotification subclass: #CompilerWarningNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExceptionHandlerAbstract subclass: #ExceptionHandler
	instanceVariableNames: 'selector handler'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExceptionHandlerAbstract subclass: #ExceptionHandlerSet
	instanceVariableNames: 'handlers'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalCallback subclass: #BlockCallback
	instanceVariableNames: 'block'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalCallback subclass: #MessageCallback
	instanceVariableNames: 'receiver selector closure'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalLibrary subclass: #AdvApiLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalLibrary subclass: #CompilerLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalLibrary subclass: #ExternalResourceLibrary
	instanceVariableNames: 'fileName loadFlags'
	classVariableNames: 'Libraries'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalLibrary subclass: #PermanentLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalLibrary subclass: #RPCLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalLibrary subclass: #ShlwapiLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalLibrary subclass: #VersionLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalLibrary subclass: #WinMMLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PermanentLibrary subclass: #CRTLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PermanentLibrary subclass: #KernelLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PermanentLibrary subclass: #NTLibrary
	instanceVariableNames: ''
	classVariableNames: 'IsWine'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PermanentLibrary subclass: #UserLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MessageBoxConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
PermanentLibrary subclass: #VMLibrary
	instanceVariableNames: 'wndProc dlgProc genericCallback vtable specialSelectorStart'
	classVariableNames: 'Registry RegistryKeys WinVerOrGreaterMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CRTLibrary subclass: #CRTLibraryNonBlocking
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalStructure subclass: #_FPIEEE_RECORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cause' -> 16r4.
		'_OffsetOf_enable' -> 16r8.
		'_OffsetOf_flags' -> 16r0.
		'_OffsetOf_operand1' -> 16r10.
		'_OffsetOf_operand2' -> 16r28.
		'_OffsetOf_result' -> 16r40.
		'_OffsetOf_status' -> 16rC
	}!
ExternalStructure subclass: #_FPIEEE_VALUE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_filler' -> 16r14.
		'_OffsetOf_flags' -> 16r10.
		'_OffsetOf_value' -> 16r0
	}!
ExternalStructure subclass: #CPINFOEXW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_codepage' -> 16r14.
		'_OffsetOf_CodePageName' -> 16r18.
		'_OffsetOf_DefaultChar' -> 16r4.
		'_OffsetOf_LeadByte' -> 16r6.
		'_OffsetOf_MaxCharSize' -> 16r0.
		'_OffsetOf_UnicodeDefaultChar' -> 16r12
	}!
ExternalStructure subclass: #ExternalArray
	instanceVariableNames: 'length'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalStructure subclass: #ExternalScalar
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_value' -> 16r0
	}!
ExternalStructure subclass: #StructurePointer
	instanceVariableNames: 'elementClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalStructure subclass: #VOID
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalStructure subclass: #Win32Structure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalArray subclass: #DOUBLEArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalArray subclass: #DWORDArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalArray subclass: #FLOATArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalArray subclass: #GenericExternalArray
	instanceVariableNames: 'elementClass owner'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalArray subclass: #INT_PTRArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalArray subclass: #SBYTEArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalArray subclass: #SDWORDArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalArray subclass: #SWORDArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalArray subclass: #UINT_PTRArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalArray subclass: #WORDArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GenericExternalArray subclass: #StructureArray
	instanceVariableNames: 'elementSpacing'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
UINT_PTRArray subclass: #HandleArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
UINT_PTRArray subclass: #PointerArray
	instanceVariableNames: 'elementClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalScalar subclass: #DOUBLE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalScalar subclass: #ExternalInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalScalar subclass: #FLOAT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalScalar subclass: #LPVOID
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalInteger subclass: #BYTE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalInteger subclass: #DWORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalInteger subclass: #HRESULT
	instanceVariableNames: ''
	classVariableNames: 'Facilities Fail'
	poolDictionaries: 'FacilityCodes Win32Constants Win32Errors'
	classInstanceVariableNames: ''
	classConstants: {
		'FACILITY_NT_BIT' -> 16r10000000
	}!
ExternalInteger subclass: #QWORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_highPart' -> 16r4.
		'_OffsetOf_lowPart' -> 16r0
	}!
ExternalInteger subclass: #UINT_PTR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalInteger subclass: #WORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
BYTE subclass: #BOOLEAN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
BYTE subclass: #SBYTE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DWORD subclass: #SDWORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SDWORD subclass: #BOOL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
QWORD subclass: #LARGE_INTEGER
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
QWORD subclass: #ULARGE_INTEGER
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
UINT_PTR subclass: #INT_PTR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
WORD subclass: #SWORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LPVOID subclass: #ExternalPointer
	instanceVariableNames: 'byteSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LPVOID subclass: #LPSTR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LPVOID subclass: #LPWSTR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Win32Structure subclass: #EXCEPTION_RECORD
	instanceVariableNames: 'info'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_ExceptionAddress' -> 16rC.
		'_OffsetOf_ExceptionCode' -> 16r0.
		'_OffsetOf_ExceptionFlags' -> 16r4.
		'_OffsetOf_ExceptionInformation' -> 16r14.
		'_OffsetOf_ExceptionRecord' -> 16r8.
		'_OffsetOf_NumberParameters' -> 16r10
	}!
Win32Structure subclass: #FILETIME
	instanceVariableNames: ''
	classVariableNames: 'UnixEpoch'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwHighDateTime' -> 16r4.
		'_OffsetOf_dwLowDateTime' -> 16r0
	}!
Win32Structure subclass: #MSG
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_hwnd' -> 16r0.
		'_OffsetOf_lParam' -> 16rC.
		'_OffsetOf_message' -> 16r4.
		'_OffsetOf_time' -> 16r10.
		'_OffsetOf_wParam' -> 16r8.
		'_OffsetOf_x' -> 16r14.
		'_OffsetOf_y' -> 16r18
	}!
Win32Structure subclass: #MSGBOXPARAMSW
	instanceVariableNames: 'text caption'
	classVariableNames: ''
	poolDictionaries: 'MessageBoxConstants'
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwContextHelpId' -> 16r1C.
		'_OffsetOf_dwLanguageId' -> 16r24.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_dwStyle' -> 16r14.
		'_OffsetOf_hInstance' -> 16r8.
		'_OffsetOf_hwndOwner' -> 16r4.
		'_OffsetOf_lpfnMsgBoxCallback' -> 16r20.
		'_OffsetOf_lpszCaption' -> 16r10.
		'_OffsetOf_lpszIcon' -> 16r18.
		'_OffsetOf_lpszText' -> 16rC
	}!
Win32Structure subclass: #NUMBERFMTW
	instanceVariableNames: 'decimalSeparator numberGrouping groupSeparator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_Grouping' -> 16r8.
		'_OffsetOf_LeadingZero' -> 16r4.
		'_OffsetOf_lpDecimalSep' -> 16rC.
		'_OffsetOf_lpThousandSep' -> 16r10.
		'_OffsetOf_NegativeOrder' -> 16r14.
		'_OffsetOf_NumDigits' -> 16r0
	}!
Win32Structure subclass: #OSVERSIONINFOEXW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwBuildNumber' -> 16rC.
		'_OffsetOf_dwMajorVersion' -> 16r4.
		'_OffsetOf_dwMinorVersion' -> 16r8.
		'_OffsetOf_dwPlatformId' -> 16r10.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_szCSDVersion' -> 16r14.
		'_OffsetOf_wProductType' -> 16r11A.
		'_OffsetOf_wReserved' -> 16r11B.
		'_OffsetOf_wServicePackMajor' -> 16r114.
		'_OffsetOf_wServicePackMinor' -> 16r116.
		'_OffsetOf_wSuiteMask' -> 16r118
	}!
Win32Structure subclass: #SECURITY_ATTRIBUTES
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_bInheritHandle' -> 16r8.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_lpSecurityDescriptor' -> 16r4
	}!
Win32Structure subclass: #SYSTEMTIME
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_wDay' -> 16r6.
		'_OffsetOf_wDayOfWeek' -> 16r4.
		'_OffsetOf_wHour' -> 16r8.
		'_OffsetOf_wMilliseconds' -> 16rE.
		'_OffsetOf_wMinute' -> 16rA.
		'_OffsetOf_wMonth' -> 16r2.
		'_OffsetOf_wSecond' -> 16rC.
		'_OffsetOf_wYear' -> 16r0
	}!
Win32Structure subclass: #TIME_ZONE_INFORMATION
	instanceVariableNames: 'zoneId offset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_bias' -> 16r0.
		'_OffsetOf_daylightBias' -> 16rA8.
		'_OffsetOf_daylightDate' -> 16r98.
		'_OffsetOf_daylightName' -> 16r58.
		'_OffsetOf_standardBias' -> 16r54.
		'_OffsetOf_standardDate' -> 16r44.
		'_OffsetOf_standardName' -> 16r4
	}!
Win32Structure subclass: #VS_FIXEDFILEINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwFileDateLS' -> 16r30.
		'_OffsetOf_dwFileDateMS' -> 16r2C.
		'_OffsetOf_dwFileFlags' -> 16r1C.
		'_OffsetOf_dwFileFlagsMask' -> 16r18.
		'_OffsetOf_dwFileOS' -> 16r20.
		'_OffsetOf_dwFileSubtype' -> 16r28.
		'_OffsetOf_dwFileType' -> 16r24.
		'_OffsetOf_dwFileVersionLS' -> 16rC.
		'_OffsetOf_dwFileVersionMS' -> 16r8.
		'_OffsetOf_dwProductVersionLS' -> 16r14.
		'_OffsetOf_dwProductVersionMS' -> 16r10.
		'_OffsetOf_dwSignature' -> 16r0.
		'_OffsetOf_dwStrucVersion' -> 16r4
	}!
Win32Structure subclass: #WIN32_FIND_DATAW
	instanceVariableNames: 'directory'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cAlternateFileName' -> 16r234.
		'_OffsetOf_cFileName' -> 16r2C.
		'_OffsetOf_dwFileAttributes' -> 16r0.
		'_OffsetOf_dwReserved0' -> 16r24.
		'_OffsetOf_dwReserved1' -> 16r28.
		'_OffsetOf_ftCreationTime' -> 16r4.
		'_OffsetOf_ftLastAccessTime' -> 16rC.
		'_OffsetOf_ftLastWriteTime' -> 16r14.
		'_OffsetOf_nFileSizeHigh' -> 16r1C.
		'_OffsetOf_nFileSizeLow' -> 16r20
	}!
FILETIME subclass: #LocalFILETIME
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
FileLocator subclass: #AbsoluteFileLocator
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
FileLocator subclass: #ClassLocator
	instanceVariableNames: 'packageName codeBase key'
	classVariableNames: 'Aliases DefaultFileLocator ImportedClasses ImportedClassesMutex InstallationFileLocator'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
FileLocator subclass: #RelativeFileLocator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ClassLocator subclass: #ValidatingClassLocator
	instanceVariableNames: 'validationBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RelativeFileLocator subclass: #FolderRelativeFileLocator
	instanceVariableNames: 'basePath'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RelativeFileLocator subclass: #ImageRelativeFileLocator
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RelativeFileLocator subclass: #InstallRelativeFileLocator
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
InstructionInterpreter subclass: #MessageSendCollector
	instanceVariableNames: 'messageBlock superMessageBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'SendInstructions' -> #(nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSpecialSend: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendSelfZeroArgs: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendOneArg: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: #shortSendTwoArgs: nil nil #shortSpecialSendEx: #shortSpecialSendEx: #shortSpecialSendEx: #shortSpecialSendEx: nil nil nil nil nil nil nil nil nil nil nil nil #send: #supersend: #specialSend: nil nil nil nil nil nil nil #sendTempZeroArgs: nil nil nil nil #sendSelfZeroArgs: nil nil nil nil nil nil nil #longSend:with: #longSupersend:with: nil nil nil nil nil nil nil nil nil nil nil nil #exLongSend:with:with: #exLongSupersend:with:with: nil)
	}!
Link variableSubclass: #Process
	instanceVariableNames: 'suspendedFrame priority myList callbackDepth _unused6 _unused7 fpControl threadSync thread exceptionEnvironment _alreadyPrinted _reserved1 debugger name _reserved2'
	classVariableNames: 'DefaultMaxStack'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'DefaultFpControl' -> 16r80007.
		'DefaultStack' -> 16r1
	}!
Locale subclass: #SmalltalkLocale
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Locale subclass: #WindowsLocale
	instanceVariableNames: 'lcid info'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Magnitude subclass: #ArithmeticValue
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Magnitude subclass: #Association
	instanceVariableNames: 'key value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Magnitude subclass: #Character
	instanceVariableNames: 'code'
	classVariableNames: 'AnsiCharacters AnsiCodePage AnsiCodePoints CharacterSet Utf8Default'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'EncodingMask' -> 16r3F000000.
		'EscapeChars' -> #($0 nil nil nil nil nil nil $a $b $t $n $v $f $r).
		'Utf16LeadMask' -> 16rD800.
		'Utf16Mask' -> 16r2000000.
		'Utf16SurrogateMask' -> 16rFC00.
		'Utf16TrailMask' -> 16rDC00.
		'Utf32Mask' -> 16r3000000.
		'Utf8Mask' -> 16r1000000.
		'Utf8SurrogateMask' -> 16rC0
	}!
Magnitude subclass: #DateAndTime
	instanceVariableNames: 'rataDie seconds offset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'FiletimeEpochSeconds' -> -16r234474600.
		'JulianDateOffset' -> 16r22A11020C0.
		'LilianDayOffset' -> -16r8D0C7.
		'SmalltalkEpochRD' -> 16rA96C9
	}!
Magnitude subclass: #Duration
	instanceVariableNames: 'seconds'
	classVariableNames: 'Zero'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'SecondsPerDay' -> 16r15180.
		'SecondsPerHour' -> 16rE10
	}!
ArithmeticValue subclass: #Number
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Number variableByteSubclass: #Float
	instanceVariableNames: ''
	classVariableNames: 'DefaultDecimalExponents FMinDenormalized Infinity NaN NegativeInfinity'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'EMax' -> 16r3FF.
		'EMin' -> -16r3FE.
		'EMinDenormalized' -> -16r432.
		'FMax' -> 1.7976931348623157e308.
		'FMin' -> 2.2250738585072014e-308.
		'FpClassDenormal' -> 16r90.
		'FpClassFinite' -> 16r1F8.
		'FpClassInfinite' -> 16r204.
		'FpClassNaN' -> 16r3.
		'FpClassNegative' -> 16r3C.
		'FpClassNormal' -> 16r108.
		'FpClassStrictlyPositive' -> 16r380.
		'FpClassZero' -> 16r60.
		'InvalidOperationFlag' -> 16r1.
		'Ln2' -> 0.6931471805599453.
		'MantissaHighBit' -> 16r10000000000000.
		'MantissaMask' -> 16rFFFFFFFFFFFFF.
		'Precision' -> 16r35.
		'SignificantDifference' -> 1.0e-9
	}!
Number subclass: #Fraction
	instanceVariableNames: 'numerator denominator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Number subclass: #Integer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Number subclass: #ScaledDecimal
	instanceVariableNames: 'fraction scale'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Integer variableByteSubclass: #LargeInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Integer subclass: #SmallInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Association subclass: #VariableBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Message subclass: #MessageSendAbstract
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MessageSendAbstract variableSubclass: #EventMessageSend
	instanceVariableNames: 'expectedArgCount'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MessageSendAbstract subclass: #MessageSend
	instanceVariableNames: 'receiver'
	classVariableNames: 'EmptySend'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MessageSequenceAbstract subclass: #EventMessageSequence
	instanceVariableNames: 'receivers messages tally'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MessageSequenceAbstract subclass: #MessageSequence
	instanceVariableNames: 'list'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ObjectRegistry subclass: #PermanentRegistry
	instanceVariableNames: 'freeHead'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ObjectRegistry subclass: #WeakRegistry
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SearchPolicy subclass: #PluggableSearchPolicy
	instanceVariableNames: 'compareBlock hashBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SearchPolicy subclass: #SingletonSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'current'
	classConstants: {}!
SingletonSearchPolicy subclass: #AlwaysSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SingletonSearchPolicy subclass: #CaseInsensitiveSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SingletonSearchPolicy subclass: #EqualitySearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SingletonSearchPolicy subclass: #IdentitySearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SingletonSearchPolicy subclass: #NeverSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
EqualitySearchPolicy subclass: #AssociationSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SessionManager subclass: #BootSessionManager
	instanceVariableNames: 'productDetails startTime'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SessionManager subclass: #ConsoleSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
Signal subclass: #NotificationSignal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
NotificationSignal subclass: #WarningSignal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SortAlgorithm subclass: #DefaultSortAlgorithm
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SortAlgorithm subclass: #PluggableSortAlgorithm
	instanceVariableNames: 'sortBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PluggableSortAlgorithm subclass: #IntrosortAlgorithm
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SourceFiler subclass: #ChunkSourceFiler
	instanceVariableNames: 'sourceFileIndex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'NormalizeEolsMask' -> 16r2
	}!
StackFrame subclass: #BlockFrame
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STBFiler subclass: #STBInFiler
	instanceVariableNames: 'readMap converters classLocator deferredActions flags'
	classVariableNames: 'UpgradingMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STBFiler subclass: #STBOutFiler
	instanceVariableNames: 'writeMap globals globalNils proxyOverrides refOffset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STBInFiler subclass: #STBValidatingInFiler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STBProxy subclass: #STBClassProxy
	instanceVariableNames: 'packageName locatorKey'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STBProxy subclass: #STBCollectionProxy
	instanceVariableNames: 'class array'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STBProxy subclass: #STBExternalResourceLibraryProxy
	instanceVariableNames: 'fileName _reserved1'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STBProxy subclass: #STBGlobalObjectProxy
	instanceVariableNames: 'symbol object'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STBProxy subclass: #STBSingletonProxy
	instanceVariableNames: 'class selector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STBClassProxy subclass: #STBMetaclassProxy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STBCollectionProxy subclass: #STBIdentityDictionaryProxy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STBCollectionProxy subclass: #STBSortedCollectionProxy
	instanceVariableNames: 'sortAlgorithm'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Stream subclass: #SequencedStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SequencedStream subclass: #PositionableStream
	instanceVariableNames: 'collection position readLimit'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SequencedStream subclass: #StdioFileStream
	instanceVariableNames: 'stream flags name oldFd fd crtlib'
	classVariableNames: 'ClassForEncoding Codecs'
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''
	classConstants: {
		'DeviceMask' -> 16r40.
		'NonBlockingMask' -> 16r2.
		'ReadOnlyMask' -> 16r1
	}!
PositionableStream subclass: #ReadStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PositionableStream subclass: #WriteStream
	instanceVariableNames: 'writeLimit'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
WriteStream subclass: #ReadWriteStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ReadWriteStream subclass: #FileStream
	instanceVariableNames: 'file flags pageBase logicalFileSize offset'
	classVariableNames: 'BufferClasses'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'BufferUpdatedMask' -> 16r3.
		'DirtyBufferMask' -> 16r2.
		'LimitsChangedMask' -> 16r1.
		'OwnsFileMask' -> 16r100.
		'PageSize' -> 16r2000
	}!
StdioFileStream subclass: #StdioBinaryFileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StdioFileStream subclass: #StdioTextFileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StdioTextFileStream subclass: #StdioAnsiFileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StdioTextFileStream subclass: #StdioUnicodeFileStream
	instanceVariableNames: 'offset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StdioUnicodeFileStream subclass: #StdioUtf16FileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StdioUnicodeFileStream subclass: #StdioUtf8FileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!

