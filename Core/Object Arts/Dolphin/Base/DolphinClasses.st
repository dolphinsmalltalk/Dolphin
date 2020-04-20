"Class Definitions"!

nil subclass: #Object
	instanceVariableNames: ''
	classVariableNames: '_AssertionFailureSignal _DependentsRegister _EventsRegister _PropertyRegister'
	poolDictionaries: '_InstanceBehaviorMasks'
	classInstanceVariableNames: ''!
nil subclass: #ProtoObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #AbstractBindingReference
	instanceVariableNames: ''
	classVariableNames: 'Undeclared'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #ArrayFieldLength
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #AttributeDescriptor
	instanceVariableNames: 'flags'
	classVariableNames: 'AccessorMask MutableMask MutatorMask NonBrowsableMask NullableMask OverrideMask ReadableMask WriteableMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #Behavior
	instanceVariableNames: 'superclass methodDictionary instanceSpec subclasses'
	classVariableNames: '_BasicSpecMask _BytesSubMask _FundamentalShapeMask _IndirectMask _MournerMask _NonInstantiableMask _NullMethodDictionary _NullTermMask _PointersMask _ShapeMask _SizeMask _VariableMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object variableSubclass: #BlockClosure
	instanceVariableNames: 'outer method initialIP info receiver'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #Boolean
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #Bytecode
	instanceVariableNames: 'instruction args jumpTarget ip'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #ByteCodeDispatcher
	instanceVariableNames: 'byteCodes method ip interpreter instructionLength byteCode instructions'
	classVariableNames: 'FirstShowSpecialSend InstructionLengths Instructions RunStarts'
	poolDictionaries: 'OpcodePool'
	classInstanceVariableNames: ''!
Object subclass: #Category
	instanceVariableNames: 'name'
	classVariableNames: 'PermanentCategories'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #ChunkReader
	instanceVariableNames: 'chunkBlock endAction context'
	classVariableNames: 'Null'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #ClassBuilder
	instanceVariableNames: 'currentClass className instanceVariables superclass instanceSpec classVariables sharedPools comment flags categories'
	classVariableNames: 'FixedInitialLayout FixedLayout IgnoreInstsMask RecompileMask Unsubclassable'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #Collection
	instanceVariableNames: ''
	classVariableNames: 'AbsentCookie'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #CompilationResult
	instanceVariableNames: 'method rawTextMap rawTempsMap textMap tempsMap oldMethod package'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object variableSubclass: #CompiledCode
	instanceVariableNames: 'header methodClass selector sourceDescriptor byteCodes'
	classVariableNames: 'InfoCacheKeys InfoCacheValues PrivateMask'
	poolDictionaries: 'OpcodePool'
	classInstanceVariableNames: ''!
Object subclass: #Compiler
	instanceVariableNames: ''
	classVariableNames: 'DefaultFlags DisabledWarnings'
	poolDictionaries: 'CompilerFlags SmalltalkParseErrorCodes'
	classInstanceVariableNames: ''!
Object variableSubclass: #Context
	instanceVariableNames: 'outer block'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #DeadObject
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #DeafObject
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #DeferredValue
	instanceVariableNames: 'valueAvailable value exception'
	classVariableNames: 'ValuePending'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #Delay
	instanceVariableNames: 'duration resumptionTime waitSemaphore'
	classVariableNames: 'AccessProtect Current DefaultResolution HighestResolution ImageClock LowestResolution Pending Resolution TicksToNanos TimingProcess TimingSemaphore'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #DiskVolumeInformation
	instanceVariableNames: 'path rootPath label serialNumber maxComponentLength fileSystemFlags fileSystemName sectorsPerCluster bytesPerSector freeClusters totalClusters freeBytes totalBytes totalFreeBytes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #Exception
	instanceVariableNames: 'tag messageText _activeHandler _process _signalFrame _environmentWhenRaised _continueBlock _resignalBlock _resignalException'
	classVariableNames: ''
	poolDictionaries: 'MessageBoxConstants Win32Constants Win32Errors'
	classInstanceVariableNames: ''!
Object subclass: #ExceptionHandlerAbstract
	instanceVariableNames: 'outer protectedBlock returnContinuation'
	classVariableNames: 'RetryCookie'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #ExceptionSet
	instanceVariableNames: 'selectors'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #ExternalCallback
	instanceVariableNames: 'thunk cookie descriptor'
	classVariableNames: 'ArgSizeOffset MaxThunks Registry ThunkBase ThunkSize'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Object variableSubclass: #ExternalDescriptor
	instanceVariableNames: 'descriptor'
	classVariableNames: 'CallingConventions ExternalReferenceTypes ExternalValueTypes RetClassIndex RetTypeMask Shared TypeNames TypeSizes'
	poolDictionaries: 'ExtCallArgTypes'
	classInstanceVariableNames: ''!
Object subclass: #ExternalLibrary
	instanceVariableNames: 'handle'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants Win32Errors'
	classInstanceVariableNames: 'default'!
Object subclass: #ExternalStructure
	instanceVariableNames: 'bytes'
	classVariableNames: 'CompiledMask RecordClasses'
	poolDictionaries: ''
	classInstanceVariableNames: 'template flags alignment'!
Object subclass: #File
	instanceVariableNames: 'handle spec flags shareFlags intBuffer'
	classVariableNames: 'AccessFlagsMask CheckModes NoCheckModes OpenFlagsMask ShareModes'
	poolDictionaries: 'CRTConstants Win32Constants Win32Errors'
	classInstanceVariableNames: ''!
Object subclass: #FileLocator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object variableByteSubclass: #GUID
	instanceVariableNames: ''
	classVariableNames: 'Null'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #InputState
	instanceVariableNames: 'inputSemaphore idler idleTimer main windows deferredActions lastWindow wakeupEvent msgWindow queueStatusMask'
	classVariableNames: 'EnumHandlesDescriptor MaxIdleSleep SamplingInterval UserInterruptSignal'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Object subclass: #InstructionInterpreter
	instanceVariableNames: 'dispatcher'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #Keyboard
	instanceVariableNames: 'state virtualKeys modifierKeys keyNames'
	classVariableNames: 'DefaultInstance InvariantInstance'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Object subclass: #Link
	instanceVariableNames: 'nextLink'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #Locale
	instanceVariableNames: 'numberFormat'
	classVariableNames: 'Invariant SystemDefault TimeZoneInfo UserDefault'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Object subclass: #Magnitude
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #MemoryManager
	instanceVariableNames: 'finalizer lastRequests hospice hospiceHighWater maxObjects undertaker bereavements bereaved bereavedHighWater gcInterval lastGCTime lastGCDuration objectHeaderSize events'
	classVariableNames: 'Current GCInterval'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #Message
	instanceVariableNames: 'selector args'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #MessageSequenceAbstract
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #MethodName
	instanceVariableNames: 'className selector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #MethodProtocol
	instanceVariableNames: 'name comment selectors flags'
	classVariableNames: 'ANSIMask Protocols ReadOnlyMask StubAddedSignal'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #ModalMsgLoop
	instanceVariableNames: 'loop'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #Model
	instanceVariableNames: 'events'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #Mutex
	instanceVariableNames: 'owner semaphore'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Object subclass: #ObjectRegistry
	instanceVariableNames: 'registry'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #Package
	instanceVariableNames: 'name packagePathname comment classNames methodNames variableNames prerequisiteNames events scripts doNotReuse imageStripperBytes aboutBlock packageVersion manualPrerequisites timestamp untracedVariables changeIndex properties preDeclareClassesOnLoad'
	classVariableNames: '_Uncommitted BinaryPacLoader ChangedIcon CheckTimestamps ClashSignal PreDeclareClassesOnLoad SourcePackageIcon UnsaveableSignal'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #PackageManager
	instanceVariableNames: 'packages processEvents packagedVariables looseMethods events defaultPackage basePackages'
	classVariableNames: 'Current DuplicatePackageSignal PackageNotFoundSignal PrerequisiteNotFoundSignal SystemPackage'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #PostedActionWindow
	instanceVariableNames: 'handle actions'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Object subclass: #ProcessorScheduler
	instanceVariableNames: 'processLists activeProcess pendingReturns comStubs _reserved pendingTerminations'
	classVariableNames: 'ConstWriteSignal InterruptSelectors'
	poolDictionaries: 'Win32Errors'
	classInstanceVariableNames: ''!
Object subclass: #PropertyManager
	instanceVariableNames: 'register'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #ResourceIdentifier
	instanceVariableNames: 'owningClass selector'
	classVariableNames: 'SelectorPrefix'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #SearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #SessionManager
	instanceVariableNames: 'inputState resourceLibrary imagePath servers argv cmdLineFlags state sentry startupArgs consoleHandler stdioStreams eventLogHandle flags sessionId hConsole settingsChanged events'
	classVariableNames: 'Current EmbeddingMask PreStartFile SettingsChangeTimerId'
	poolDictionaries: 'Win32Constants Win32Errors'
	classInstanceVariableNames: ''!
Object subclass: #SharedQueue
	instanceVariableNames: 'accessProtect valueAvailable contents'
	classVariableNames: 'AbsentCookie'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Object subclass: #Signal
	instanceVariableNames: 'description resumable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #SortAlgorithm
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #Sound
	instanceVariableNames: 'name location type fileLocator'
	classVariableNames: 'Registry'
	poolDictionaries: 'MessageBoxConstants Win32Constants'
	classInstanceVariableNames: ''!
Object subclass: #SourceFiler
	instanceVariableNames: 'stream evaluationContext flags'
	classVariableNames: 'SourceOnlyMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #SourceManager
	instanceVariableNames: 'mutex'
	classVariableNames: 'ChangesIndex DefaultInstance SourcesIndex'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #StackFrame
	instanceVariableNames: 'process index'
	classVariableNames: 'BPOffset EnvOffset FrameSize IPOffset MethodOffset ReturnOffset SPOffset'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #STBClassConversion
	instanceVariableNames: 'version instSize dataClass isVariable converterBlock filer'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #STBFiler
	instanceVariableNames: 'stream context version'
	classVariableNames: 'MaxPredefinedRef'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #STBPrefix
	instanceVariableNames: 'dword'
	classVariableNames: 'BytesMask CharacterMask ClassPrefixMask DataPrefix DataPrefixMask IndexShift InstSizeMask InstSizeShift LiteralPrefixMask LocatorLenShift MaxPredefinedRef NonZeroVersionMask ProxyMask ProxyPrefix SmallIntegerMask VariableMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #STBProxy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #Stream
	instanceVariableNames: ''
	classVariableNames: 'EndOfStreamSignal'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #UndeclaredVariable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #UndefinedObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Object subclass: #VersionInfo
	instanceVariableNames: 'fileInfo prefix fixedInfo'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractBindingReference subclass: #BindingReference
	instanceVariableNames: 'pathString path binding context'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractBindingReference subclass: #MetaBindingReference
	instanceVariableNames: 'instance'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayFieldLength subclass: #FixedArrayFieldLength
	instanceVariableNames: 'elementCount'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AttributeDescriptor subclass: #ExternalField
	instanceVariableNames: 'offset structClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalField subclass: #EmbeddedField
	instanceVariableNames: 'fieldClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalField subclass: #FillerField
	instanceVariableNames: 'byteSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalField subclass: #PointerField
	instanceVariableNames: 'pointerClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalField subclass: #ScalarField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmbeddedField subclass: #ArrayField
	instanceVariableNames: 'arrayLength'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EmbeddedField subclass: #StructureField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayField subclass: #StringField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayField subclass: #StructureArrayField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StructureArrayField subclass: #PointerArrayField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PointerField subclass: #ArrayPointerField
	instanceVariableNames: 'arrayLength'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayPointerField subclass: #StructureArrayPointerField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StructureArrayPointerField subclass: #PointerArrayPointerField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScalarField subclass: #AbstractCHARField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScalarField subclass: #BOOLField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScalarField subclass: #BYTEField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScalarField subclass: #DOUBLEField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScalarField subclass: #DWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScalarField subclass: #FLOATField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScalarField subclass: #INT_PTRField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScalarField subclass: #QWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScalarField subclass: #SBYTEField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScalarField subclass: #SDWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScalarField subclass: #SQWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScalarField subclass: #SWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScalarField subclass: #UINT_PTRField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScalarField subclass: #WORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractCHARField subclass: #CHARField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractCHARField subclass: #WCHARField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BOOLField subclass: #BOOLEANField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UINT_PTRField subclass: #HANDLEField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UINT_PTRField subclass: #LPVOIDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Behavior subclass: #ClassDescription
	instanceVariableNames: 'instanceVariables methodsCatalogue protocols'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassDescription subclass: #Class
	instanceVariableNames: 'name classPool sharedPools comment classCategories _guid'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassDescription subclass: #Metaclass
	instanceVariableNames: 'instanceClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Boolean subclass: #False
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Boolean subclass: #True
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Category subclass: #ClassCategory
	instanceVariableNames: ''
	classVariableNames: 'Table Unclassified'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Category subclass: #MethodCategory
	instanceVariableNames: ''
	classVariableNames: 'Private Pseuds Public Table'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Collection subclass: #Bag
	instanceVariableNames: 'contents'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Collection subclass: #SequenceableCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Collection variableSubclass: #Set
	instanceVariableNames: 'tally'
	classVariableNames: 'MaxOffsetIndex PrimeSizes SmallPrimeOffsets'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SequenceableCollection subclass: #ArrayedCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SequenceableCollection subclass: #Interval
	instanceVariableNames: 'start stop step'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SequenceableCollection subclass: #SequencedGrowableCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayedCollection variableSubclass: #Array
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayedCollection variableByteSubclass: #ByteArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayedCollection subclass: #RunArray
	instanceVariableNames: 'values runs'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayedCollection variableByteSubclass: #String
	instanceVariableNames: ''
	classVariableNames: 'EncodingAnsi Encodings EncodingUtf16 EncodingUtf32 EncodingUtf8 LineDelimiter'
	poolDictionaries: ''
	classInstanceVariableNames: 'empty'!
ArrayedCollection variableSubclass: #WeakArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ByteArray variableByteSubclass: #ExternalIntegerBytes
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalIntegerBytes variableByteSubclass: #DWORDBytes
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalIntegerBytes variableByteSubclass: #UIntPtrBytes
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UIntPtrBytes variableByteSubclass: #ExternalAddress
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UIntPtrBytes variableByteSubclass: #ExternalHandle
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalAddress variableByteSubclass: #ExternalMemory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
ExternalAddress variableByteSubclass: #REFGUID
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
String variableByteSubclass: #AnsiString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
String variableByteSubclass: #UtfEncodedString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UtfEncodedString variableByteSubclass: #Utf16String
	instanceVariableNames: ''
	classVariableNames: 'Bom LeadOffset SurrogateOffset'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UtfEncodedString variableByteSubclass: #Utf8String
	instanceVariableNames: ''
	classVariableNames: 'Bom LeadByteMask2 LeadByteMask3 LeadByteMask4 TrailByteMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Utf8String variableByteSubclass: #Symbol
	instanceVariableNames: ''
	classVariableNames: 'CharClassifications Table'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WeakArray variableSubclass: #MourningWeakArray
	instanceVariableNames: 'pathologist'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SequencedGrowableCollection subclass: #LinkedList
	instanceVariableNames: 'firstLink lastLink'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SequencedGrowableCollection variableSubclass: #OrderedCollection
	instanceVariableNames: 'firstIndex lastIndex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LinkedList subclass: #Semaphore
	instanceVariableNames: 'signals'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
OrderedCollection variableSubclass: #SortedCollection
	instanceVariableNames: 'algorithm'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Set variableSubclass: #Dictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Set variableSubclass: #IdentitySet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Set variableSubclass: #PluggableSet
	instanceVariableNames: 'searchPolicy'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Set variableSubclass: #SharedSet
	instanceVariableNames: 'mutex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Dictionary variableSubclass: #LookupTable
	instanceVariableNames: 'values'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Dictionary variableSubclass: #PoolDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Dictionary variableSubclass: #SystemDictionary
	instanceVariableNames: 'events allClasses allRoots'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LookupTable variableSubclass: #IdentityDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LookupTable variableSubclass: #PluggableLookupTable
	instanceVariableNames: 'searchPolicy'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LookupTable variableSubclass: #SharedLookupTable
	instanceVariableNames: 'mutex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdentityDictionary variableSubclass: #MethodDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SharedLookupTable variableSubclass: #DeferredValueTable
	instanceVariableNames: 'priority'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SharedLookupTable variableSubclass: #SharedIdentityDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SharedLookupTable variableSubclass: #WeakLookupTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SharedIdentityDictionary variableSubclass: #EventsCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EventsCollection variableSubclass: #NullEventsCollection
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WeakLookupTable variableSubclass: #WeakIdentityDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PoolDictionary variableSubclass: #PoolConstantsDictionary
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SharedSet variableSubclass: #SharedIdentitySet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SharedSet variableSubclass: #WeakSet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WeakSet variableSubclass: #WeakIdentitySet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompiledCode variableSubclass: #CompiledExpression
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompiledCode variableSubclass: #CompiledMethod
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompiledMethod variableSubclass: #CompileFailedMethod
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompiledMethod variableSubclass: #ExternalMethod
	instanceVariableNames: ''
	classVariableNames: 'ArgsLenIndex ArgumentStartIndex CallingConventionIndex ReturnParmIndex ReturnTypeIndex'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Exception subclass: #Error
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MessageBoxConstants'
	classInstanceVariableNames: ''!
Exception subclass: #Notification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MessageBoxConstants'
	classInstanceVariableNames: ''!
Exception subclass: #ProcessTermination
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Exception subclass: #StackOverflow
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Error subclass: #ArithmeticError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Error subclass: #BoundsError
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Error subclass: #CannotReturnError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Error subclass: #ClassRemovalError
	instanceVariableNames: 'originalError'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Error subclass: #CRTError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Error subclass: #HRESULTError
	instanceVariableNames: 'errorInfo osErrorMessage'
	classVariableNames: 'FacilityClasses'
	poolDictionaries: 'FacilityCodes'
	classInstanceVariableNames: ''!
Error subclass: #InvalidArgumentError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Error subclass: #InvalidExternalCall
	instanceVariableNames: 'argument type'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Error subclass: #InvalidFormat
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Error subclass: #MessageNotUnderstood
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Error subclass: #NotFoundError
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Error subclass: #OperationAborted
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Error subclass: #RaisedSignal
	instanceVariableNames: 'signalType'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Error subclass: #STBError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Error subclass: #SubclassResponsibilityError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArithmeticError subclass: #FloatingPointException
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArithmeticError subclass: #ZeroDivide
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HRESULTError subclass: #Win32Error
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Win32Error subclass: #FileException
	instanceVariableNames: 'file resumable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Win32Error subclass: #OutOfMemoryError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Win32Error subclass: #RPCError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Win32Error subclass: #Win32Fault
	instanceVariableNames: 'exceptionRecord'
	classVariableNames: 'ExceptionNames'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Win32Fault subclass: #GPFault
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Notification subclass: #CompilerNotification
	instanceVariableNames: 'position ranges line extras methodClass source selector offset'
	classVariableNames: 'ErrorFormats'
	poolDictionaries: 'SmalltalkParseErrorCodes'
	classInstanceVariableNames: ''!
Notification subclass: #HRESULTNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Notification subclass: #MethodCompileFailed
	instanceVariableNames: 'compilerErrorNotification'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Notification subclass: #RaisedNotificationSignal
	instanceVariableNames: 'signalType'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Notification subclass: #Warning
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompilerNotification subclass: #CompilerErrorNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompilerNotification subclass: #CompilerInfoNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompilerNotification subclass: #CompilerWarningNotification
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExceptionHandlerAbstract subclass: #ExceptionHandler
	instanceVariableNames: 'selector handler'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExceptionHandlerAbstract subclass: #ExceptionHandlerSet
	instanceVariableNames: 'handlers'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalCallback subclass: #BlockCallback
	instanceVariableNames: 'block'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalCallback subclass: #MessageCallback
	instanceVariableNames: 'receiver selector closure'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalLibrary subclass: #AdvApiLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalLibrary subclass: #CompilerLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalLibrary subclass: #ExternalResourceLibrary
	instanceVariableNames: 'fileName loadFlags'
	classVariableNames: 'Libraries'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalLibrary subclass: #PermanentLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalLibrary subclass: #RPCLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalLibrary subclass: #ShlwapiLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalLibrary subclass: #VersionLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalLibrary subclass: #WinMMLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PermanentLibrary subclass: #CRTLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PermanentLibrary subclass: #KernelLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PermanentLibrary subclass: #NTLibrary
	instanceVariableNames: ''
	classVariableNames: 'IsWine'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PermanentLibrary subclass: #UserLibrary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MessageBoxConstants'
	classInstanceVariableNames: ''!
PermanentLibrary subclass: #VMLibrary
	instanceVariableNames: 'wndProc dlgProc genericCallback vtable specialSelectorStart'
	classVariableNames: 'Registry RegistryKeys WinVerOrGreaterMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CRTLibrary subclass: #CRTLibraryNonBlocking
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalStructure subclass: #_FPIEEE_RECORD
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cause _OffsetOf_enable _OffsetOf_flags _OffsetOf_operand1 _OffsetOf_operand2 _OffsetOf_result _OffsetOf_status'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalStructure subclass: #_FPIEEE_VALUE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_filler _OffsetOf_flags _OffsetOf_value'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalStructure subclass: #CPINFOEXW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_codepage _OffsetOf_CodePageName _OffsetOf_DefaultChar _OffsetOf_LeadByte _OffsetOf_MaxCharSize _OffsetOf_UnicodeDefaultChar'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalStructure subclass: #ExternalArray
	instanceVariableNames: 'length'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalStructure subclass: #ExternalScalar
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_value'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalStructure subclass: #StructurePointer
	instanceVariableNames: 'elementClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalStructure subclass: #VOID
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalStructure subclass: #Win32Structure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
ExternalArray subclass: #DOUBLEArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalArray subclass: #DWORDArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalArray subclass: #FLOATArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalArray subclass: #GenericExternalArray
	instanceVariableNames: 'elementClass owner'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalArray subclass: #INT_PTRArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalArray subclass: #SBYTEArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalArray subclass: #SDWORDArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalArray subclass: #SWORDArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalArray subclass: #UINT_PTRArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalArray subclass: #WORDArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GenericExternalArray subclass: #StructureArray
	instanceVariableNames: 'elementSpacing'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UINT_PTRArray subclass: #HandleArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UINT_PTRArray subclass: #PointerArray
	instanceVariableNames: 'elementClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalScalar subclass: #DOUBLE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalScalar subclass: #ExternalInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalScalar subclass: #FLOAT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalScalar subclass: #LPVOID
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalInteger subclass: #BYTE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalInteger subclass: #DWORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalInteger subclass: #HRESULT
	instanceVariableNames: ''
	classVariableNames: 'Facilities FACILITY_NT_BIT Fail'
	poolDictionaries: 'FacilityCodes Win32Constants Win32Errors'
	classInstanceVariableNames: ''!
ExternalInteger subclass: #QWORD
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_highPart _OffsetOf_lowPart'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalInteger subclass: #UINT_PTR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalInteger subclass: #WORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BYTE subclass: #BOOLEAN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BYTE subclass: #SBYTE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DWORD subclass: #SDWORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SDWORD subclass: #BOOL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
QWORD subclass: #LARGE_INTEGER
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
QWORD subclass: #ULARGE_INTEGER
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UINT_PTR subclass: #INT_PTR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WORD subclass: #SWORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LPVOID subclass: #ExternalPointer
	instanceVariableNames: 'byteSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LPVOID subclass: #LPSTR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LPVOID subclass: #LPWSTR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Win32Structure subclass: #EXCEPTION_RECORD
	instanceVariableNames: 'info'
	classVariableNames: '_OffsetOf_ExceptionAddress _OffsetOf_ExceptionCode _OffsetOf_ExceptionFlags _OffsetOf_ExceptionInformation _OffsetOf_ExceptionRecord _OffsetOf_NumberParameters'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Win32Structure subclass: #FILETIME
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwHighDateTime _OffsetOf_dwLowDateTime UnixEpoch'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Win32Structure subclass: #MSG
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_hwnd _OffsetOf_lParam _OffsetOf_message _OffsetOf_time _OffsetOf_wParam _OffsetOf_x _OffsetOf_y'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Win32Structure subclass: #MSGBOXPARAMSW
	instanceVariableNames: 'text caption'
	classVariableNames: '_OffsetOf_dwContextHelpId _OffsetOf_dwLanguageId _OffsetOf_dwSize _OffsetOf_dwStyle _OffsetOf_hInstance _OffsetOf_hwndOwner _OffsetOf_lpfnMsgBoxCallback _OffsetOf_lpszCaption _OffsetOf_lpszIcon _OffsetOf_lpszText'
	poolDictionaries: 'MessageBoxConstants'
	classInstanceVariableNames: ''!
Win32Structure subclass: #NUMBERFMTW
	instanceVariableNames: 'decimalSeparator numberGrouping groupSeparator'
	classVariableNames: '_OffsetOf_Grouping _OffsetOf_LeadingZero _OffsetOf_lpDecimalSep _OffsetOf_lpThousandSep _OffsetOf_NegativeOrder _OffsetOf_NumDigits'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Win32Structure subclass: #OSVERSIONINFOEXW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwBuildNumber _OffsetOf_dwMajorVersion _OffsetOf_dwMinorVersion _OffsetOf_dwPlatformId _OffsetOf_dwSize _OffsetOf_szCSDVersion _OffsetOf_wProductType _OffsetOf_wReserved _OffsetOf_wServicePackMajor _OffsetOf_wServicePackMinor _OffsetOf_wSuiteMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Win32Structure subclass: #SECURITY_ATTRIBUTES
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_bInheritHandle _OffsetOf_dwSize _OffsetOf_lpSecurityDescriptor'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Win32Structure subclass: #SYSTEMTIME
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_wDay _OffsetOf_wDayOfWeek _OffsetOf_wHour _OffsetOf_wMilliseconds _OffsetOf_wMinute _OffsetOf_wMonth _OffsetOf_wSecond _OffsetOf_wYear'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Win32Structure subclass: #TIME_ZONE_INFORMATION
	instanceVariableNames: 'zoneId offset'
	classVariableNames: '_OffsetOf_bias _OffsetOf_daylightBias _OffsetOf_daylightDate _OffsetOf_daylightName _OffsetOf_standardBias _OffsetOf_standardDate _OffsetOf_standardName'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Win32Structure subclass: #VS_FIXEDFILEINFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwFileDateLS _OffsetOf_dwFileDateMS _OffsetOf_dwFileFlags _OffsetOf_dwFileFlagsMask _OffsetOf_dwFileOS _OffsetOf_dwFileSubtype _OffsetOf_dwFileType _OffsetOf_dwFileVersionLS _OffsetOf_dwFileVersionMS _OffsetOf_dwProductVersionLS _OffsetOf_dwProductVersionMS _OffsetOf_dwSignature _OffsetOf_dwStrucVersion'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Win32Structure subclass: #WIN32_FIND_DATAW
	instanceVariableNames: 'directory'
	classVariableNames: '_OffsetOf_cAlternateFileName _OffsetOf_cFileName _OffsetOf_dwFileAttributes _OffsetOf_dwReserved0 _OffsetOf_dwReserved1 _OffsetOf_ftCreationTime _OffsetOf_ftLastAccessTime _OffsetOf_ftLastWriteTime _OffsetOf_nFileSizeHigh _OffsetOf_nFileSizeLow'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
FILETIME subclass: #LocalFILETIME
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileLocator subclass: #AbsoluteFileLocator
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileLocator subclass: #ClassLocator
	instanceVariableNames: 'packageName codeBase key'
	classVariableNames: 'Aliases DefaultFileLocator ImportedClasses ImportedClassesMutex InstallationFileLocator'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileLocator subclass: #RelativeFileLocator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassLocator subclass: #ValidatingClassLocator
	instanceVariableNames: 'validationBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RelativeFileLocator subclass: #FolderRelativeFileLocator
	instanceVariableNames: 'basePath'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RelativeFileLocator subclass: #ImageRelativeFileLocator
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RelativeFileLocator subclass: #InstallRelativeFileLocator
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InstructionInterpreter subclass: #MessageSendCollector
	instanceVariableNames: 'messageBlock superMessageBlock'
	classVariableNames: 'SendInstructions'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Link variableSubclass: #Process
	instanceVariableNames: 'suspendedFrame priority myList callbackDepth _unused6 _unused7 fpControl threadSync thread exceptionEnvironment _alreadyPrinted _reserved1 debugger name _reserved2'
	classVariableNames: 'DefaultFpControl DefaultMaxStack DefaultStack'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Locale subclass: #SmalltalkLocale
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Locale subclass: #WindowsLocale
	instanceVariableNames: 'lcid info'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Magnitude subclass: #ArithmeticValue
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Magnitude subclass: #Association
	instanceVariableNames: 'key value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Magnitude subclass: #Character
	instanceVariableNames: 'code'
	classVariableNames: 'AnsiCharacters AnsiCodePage AnsiCodePoints CharacterSet EncodingMask EscapeChars Utf16LeadMask Utf16Mask Utf16SurrogateMask Utf16TrailMask Utf32Mask Utf8Default Utf8Mask Utf8SurrogateMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Magnitude subclass: #DateAndTime
	instanceVariableNames: 'rataDie seconds offset'
	classVariableNames: 'FiletimeEpochSeconds JulianDateOffset LilianDayOffset SmalltalkEpochRD'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Magnitude subclass: #Duration
	instanceVariableNames: 'seconds'
	classVariableNames: 'SecondsPerDay SecondsPerHour Zero'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArithmeticValue subclass: #Number
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Number variableByteSubclass: #Float
	instanceVariableNames: ''
	classVariableNames: 'DefaultDecimalExponents EMax EMin EMinDenormalized FMax FMin FMinDenormalized FpClassDenormal FpClassFinite FpClassInfinite FpClassNaN FpClassNegative FpClassNormal FpClassStrictlyPositive FpClassZero Infinity InvalidOperationFlag Ln2 MantissaHighBit MantissaMask NaN NegativeInfinity Precision SignificantDifference'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Number subclass: #Fraction
	instanceVariableNames: 'numerator denominator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Number subclass: #Integer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Number subclass: #ScaledDecimal
	instanceVariableNames: 'fraction scale'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Integer variableByteSubclass: #LargeInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Integer subclass: #SmallInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Association subclass: #VariableBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Message subclass: #MessageSendAbstract
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MessageSendAbstract variableSubclass: #EventMessageSend
	instanceVariableNames: 'expectedArgCount'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MessageSendAbstract subclass: #MessageSend
	instanceVariableNames: 'receiver'
	classVariableNames: 'EmptySend'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MessageSequenceAbstract subclass: #EventMessageSequence
	instanceVariableNames: 'receivers messages tally'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MessageSequenceAbstract subclass: #MessageSequence
	instanceVariableNames: 'list'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ObjectRegistry subclass: #PermanentRegistry
	instanceVariableNames: 'freeHead'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ObjectRegistry subclass: #WeakRegistry
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SearchPolicy subclass: #PluggableSearchPolicy
	instanceVariableNames: 'compareBlock hashBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SearchPolicy subclass: #SingletonSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'current'!
SingletonSearchPolicy subclass: #AlwaysSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SingletonSearchPolicy subclass: #CaseInsensitiveSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SingletonSearchPolicy subclass: #EqualitySearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SingletonSearchPolicy subclass: #IdentitySearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SingletonSearchPolicy subclass: #NeverSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EqualitySearchPolicy subclass: #AssociationSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SessionManager subclass: #BootSessionManager
	instanceVariableNames: 'productDetails startTime'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SessionManager subclass: #ConsoleSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''!
Signal subclass: #NotificationSignal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NotificationSignal subclass: #WarningSignal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SortAlgorithm subclass: #DefaultSortAlgorithm
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SortAlgorithm subclass: #PluggableSortAlgorithm
	instanceVariableNames: 'sortBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PluggableSortAlgorithm subclass: #IntrosortAlgorithm
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SourceFiler subclass: #ChunkSourceFiler
	instanceVariableNames: 'sourceFileIndex'
	classVariableNames: 'NormalizeEolsMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StackFrame subclass: #BlockFrame
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBFiler subclass: #STBInFiler
	instanceVariableNames: 'readMap converters classLocator deferredActions flags'
	classVariableNames: 'UpgradingMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBFiler subclass: #STBOutFiler
	instanceVariableNames: 'writeMap globals globalNils proxyOverrides refOffset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBInFiler subclass: #STBValidatingInFiler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBProxy subclass: #STBClassProxy
	instanceVariableNames: 'packageName locatorKey'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBProxy subclass: #STBCollectionProxy
	instanceVariableNames: 'class array'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBProxy subclass: #STBExternalResourceLibraryProxy
	instanceVariableNames: 'fileName _reserved1'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBProxy subclass: #STBGlobalObjectProxy
	instanceVariableNames: 'symbol object'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBProxy subclass: #STBSingletonProxy
	instanceVariableNames: 'class selector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBClassProxy subclass: #STBMetaclassProxy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBCollectionProxy subclass: #STBIdentityDictionaryProxy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBCollectionProxy subclass: #STBSortedCollectionProxy
	instanceVariableNames: 'sortAlgorithm'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Stream subclass: #SequencedStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SequencedStream subclass: #PositionableStream
	instanceVariableNames: 'collection position readLimit'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SequencedStream subclass: #StdioFileStream
	instanceVariableNames: 'stream flags name oldFd fd crtlib'
	classVariableNames: 'ClassForEncoding Codecs DeviceMask NonBlockingMask ReadOnlyMask'
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''!
PositionableStream subclass: #ReadStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PositionableStream subclass: #WriteStream
	instanceVariableNames: 'writeLimit'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WriteStream subclass: #ReadWriteStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ReadWriteStream subclass: #FileStream
	instanceVariableNames: 'file flags pageBase logicalFileSize offset'
	classVariableNames: 'BufferClasses BufferUpdatedMask DirtyBufferMask LimitsChangedMask OwnsFileMask PageSize'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StdioFileStream subclass: #StdioBinaryFileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StdioFileStream subclass: #StdioTextFileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StdioTextFileStream subclass: #StdioAnsiFileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StdioTextFileStream subclass: #StdioUnicodeFileStream
	instanceVariableNames: 'offset'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StdioUnicodeFileStream subclass: #StdioUtf16FileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StdioUnicodeFileStream subclass: #StdioUtf8FileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

