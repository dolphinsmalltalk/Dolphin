"Filed out from Dolphin Smalltalk 7"!

OS.COM.TypeInfoObject subclass: #'OS.COM.TypeLibraryAnalyzer'
	instanceVariableNames: 'attributes namespaceName packageName libVariableName constantsPoolName aliasMap typeAnalyzers'
	classVariableNames: 'TypeLibs'
	imports: #(#{OS.Win32Constants} #{OS.COM.AutomationErrors})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.TypeLibraryAnalyzer guid: (Core.GUID fromString: '{c06f3b76-0868-11d3-93af-00a024ca708a}')!
OS.COM.TypeLibraryAnalyzer comment: 'AXTypeLibraryAnalyzer is a wrapper class around <ITypeLib> which adds higher level wrapper functions which make ITypeLib easier to use. It is also the starting point for Dolphin''s automatic generation of wrapper classes &c for Active-X objects described by type libraries.

A Type Library is a repository of meta-information, typically about Active-X (COM, OLE, choose your favourite name) objects and interfaces. AXTypeLibraryAnalyzer permits one to enquire about general attributes of a Type Library, but more importantly it enables one to enumerate through the individual meta-elements by acquiring <AXTypeInfoAnalyzer> objects which describe them. For example it is easy to acquire all of the meta-information of a particular type from the library by sending one of the following selectors:
	#interfaces
	#dispinterfaces
	#coclasses
	#enums
	#unions
	#structs
	#modules
	#typedefs

AXTypeLibraryAnalyzer is primarily intended as part of Dolphin''s development environment, but it also has run time uses when Dolphin is implementing dispinterfaces (for example).

AXTypeLibraryAnalyzer can also reverse engineer the IDL for a type library in the same manner as Microsoft''s OLEVIEW.EXE (except that it is does a more accurate job and is nearly twice as fast as the latter). For example:

	(AXTypeLibraryAnalyzer open: ''stdole2.tlb'') printIDL

Instance Variables:
	attributes		<TLIBATTR>. Information to uniquely identify a type library registration.
	prefix			readableString> prefix for generated names (to avoid name clashes)
	packageName	<readableString> name of the package into which globals are generated.
	globalName		<Symbol>. Name of the global variable generated for this analyzer.
	constantsPoolName	<Symbol>. Name of the <PoolConstantsDictionary> into which consts are generated.
	aliasMap		<LookupTable> mapping <String> type names to <Symbol> global names for the type.
	typeAnalyzers	<Array> of <AXTypeInfoAnalyzer>s. Cache of all types defined in the library.

Class Variables:
	TypeLibs			<WeakLookupTable>. Repository of instances of the receiver, one per type library.
'!
!OS.COM.TypeLibraryAnalyzer categoriesForClass!ActiveX Automation! !
!OS.COM.TypeLibraryAnalyzer methodsFor!

= comparand
	"Answer whether the receiver and the <Object>, comparand, 
	are considered equivalent.
	Implementation Note: Two type analyzers are considered equivalent
	if they have the same GUID."

	^comparand species == self species and: [comparand libid = self libid]!

aliasMap
	^aliasMap!

at: memberName
	"Answer an <AXTypeInfoAnalyzer> on the member of the receiver with the specified
	name, or raise an exception if no such member."

	^self at: memberName ifAbsent: [self errorNotFound: memberName]!

at: memberName ifAbsent: exceptionHandler
	"Answer an <AXTypeInfoAnalyzer> on the member of the receiver with the specified
	name, or the result of evaluating the niladic valuable, exceptionHandler, if no such member."

	^((self find: memberName count: 1) at: 1 ifAbsent: [^exceptionHandler value]) value asImplType!

attributes
	"Answer a <TLIBATTR> detailing the library attributes for the receiver
	(its LIBID, version, locale id, some flags, and an enumerator identifying
	the target OS - which will always be Win32 in our case).
	Implementation Note: This is held in an instance variable in order to be able
	to re-load the associated type library should the need arise."

	^attributes!

basicName
	^self tlbInterface nameAt: 0!

basicTypeInfoAt: index 
	"Private - Answer an <ITypeInfo> for the member of the receiver at the specified
	integer index, resolved to the implementation type if a dual interface."

	^(self tlbInterface typeInfoAt: index) asImplType!

buildTypeAnalyzers
	"Private - Build the collection of <AXTypeInfoAnalyzers> which describe the types in the receiver."

	| count lib |
	count := self typeInfoCount.
	lib := self tlbInterface.
	typeAnalyzers := (1 to: count) collect: 
					[:i |
					TypeInfoAnalyzer
						onTypeInfo: (lib typeInfoAt: i) asImplType
						typeLib: self
						index: i]!

classBindingForGuid: aGUID
	^(Smalltalk classesByGuid lookup: aGUID) ifNotNil: [:class | class binding]!

clearCachedAnalyzers
	"Clear the cached the list of analyzers."

	typeAnalyzers := nil!

coclasses
	"Answer a <collection> of all the coclasses (component objects) in the receiver."

	^self selectTypeKind: TKIND_COCLASS!

customInterfaces
	"Answer a <collection> of all the custom interfaces in the receiver.
	These are vtbl only interfaces."

	^self selectTypes: [:t | t typekind == TKIND_INTERFACE and: [t isDual not]]!

defaultGenerationFlags
	"Answer a set of default AXTypeGenerationFlags to control code generation by
	the receiver.
	By default turn off MethodProtocol generation, as we rarely need to implement
	interfaces, it is much more normal to just call them."

	^LowercaseIdentifiers!

dispatchableInterfaces
	"Answer a <collection> of all the interfaces in the receiver 
	which can be late bound (i.e. they implement IDispatch)."

	^self interfaces select: [:each | each isDispatchable]!

dispinterfaces
	"Answer a <collection> of all the interfaces in the receiver 
	which can only be late bound (i.e. non-dual IDispatch)"

	^self selectTypeKind: TKIND_DISPATCH!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self variableName!

documentation
	"Answer an <AXTypeLibDocumentation> containing the documentation for the library.
	See #documentationAt: for more details.
	Implementation Note: Because we adjust to 1 based indices for Smalltalk compatibility
	in #documentationAt: the documentation for the library is retrieved with index 0 
	rather than -1 as specified in the documentation."

	^[self documentationAt: 0] on: HRESULTError
		do: 
			[:ex |
			TypeLibDocumentation new
				name: libVariableName
				helpstring: ex messageText
				helpcontext: 0
				helpfile: '']!

documentationAt: index
	"Private - Answer a  new <AXTypeLibraryDocumentation> containing the documentation 
	for the type info. identified by the <integer>, index, in the receiver. 
	The range of indices is 0..<type info count>, with 0 answering docs
	for the library itself, and 1..<type infor count> for the type info elements of the receiver.
	The elements of the documentation array are, respectively:
		- the name of the specified item (a String).
		- the 'documentation' String for the specified item. This is the help string from the IDL (if any).
		- the Help context ID associated with the specified item (an Integer).
		- the fully qualified name of the Help file (a String).
	The method may raise an HRESULTError, e.g. if the index is out of range. Refer
	to the SDK help for further possible error conditions."

	^self documentationAt: index ifAbsent: [self errorNotFound: index]!

documentationAt: index ifAbsent: exceptionHandler
	"Private - Answer a  new <AXTypeLibraryDocumentation> containing the documentation 
	for the type info. identified by the <integer>, index, in the receiver. 
	The range of indices is 0..<type info count>, with 0 answering docs
	for the library itself, and 1..<type infor count> for the type info elements of the receiver.
	The elements of the documentation array are, respectively:
		- the name of the specified item (a String).
		- the 'documentation' String for the specified item. This is the help string from the IDL (if any).
		- the Help context ID associated with the specified item (an Integer).
		- the fully qualified name of the Help file (a String).
	The method may raise an HRESULTError, e.g. if the index is out of range. Refer
	to the SDK help for further possible error conditions."

	| bstrName bstrDocString dwHelpContext bstrHelpFile answer hr |
	bstrName := BSTR new.
	bstrDocString := BSTR new.
	bstrHelpFile := BSTR new.
	dwHelpContext := DWORDBytes new.
	hr := self tlbInterface
				GetDocumentation: index - 1
				pBstrName: bstrName
				pBstrDocString: bstrDocString
				pdwHelpContext: dwHelpContext
				pBstrHelpFile: bstrHelpFile.
	hr < 0
		ifTrue: 
			[hr = TYPE_E_ELEMENTNOTFOUND ifTrue: [^exceptionHandler value].
			^HRESULTError signalWith: hr].
	answer := TypeLibDocumentation new
				name: bstrName asString
				helpstring: bstrDocString asString
				helpcontext: dwHelpContext value
				helpfile: bstrHelpFile asString trimNulls.
	bstrName free.
	bstrDocString free.
	bstrHelpFile free.
	^answer

	"
tlb := AXTypeLibraryAnalyzer open: 'c:\msoffice\access\msaccess.tlb'
tlb documentation
tlb typeInfoCount
tlb names
tlb dispinterfaces first 
tlb 
tlb documentationAt: 1
tlb := nil
"!

dualInterfaces
	"Answer a <collection> of all the dispatch interfaces in the receiver 
	which can be early bound (i.e. interfaces derived from IDispatch)."

	^self selectTypes: [:t | t isDual]!

enums
	"Answer a <collection> of all the enumerated type 
	members of the receiver."

	^self selectTypeKind: TKIND_ENUM!

find: memberName count: numToFind
	"Find up to the <integer> argument, numToFind, member id -> ITypeInfo pairs for the
	specified name in the receiver."

	| rgMemId ppTInfo pcFound infos |
	rgMemId := SDWORDArray new: numToFind.
	ppTInfo := DWORDArray new: numToFind.
	pcFound := DWORDBytes fromInteger: numToFind.
	self tlbInterface
		FindName: memberName
		lHashVal: 0
		ppTInfo: ppTInfo
		rgMemId: rgMemId
		pcFound: pcFound.	"let system compute hash value"	"arg type not implicitly coercable"
	infos := self typeAnalyzers.
	^(1 to: pcFound asInteger) collect: 
			[:i |
			| piTInfo assoc info |
			piTInfo := ITypeInfo newPointer.
			piTInfo attach: (ppTInfo at: i).
			assoc := piTInfo libraryAndIndex.
			self assert: [assoc key isSameCOMObject: self tlbInterface].
			info := infos at: assoc value.
			(rgMemId at: i) -> info]!

fullNameFor: aString
	^namespaceName isEmpty ifTrue: [aString] ifFalse: [namespaceName , '.' , aString]!

getLibAttr
	"Private - Answer a <TLIBATTR> detailing the library attributes for the receiver
	(its LIBID, version, locale id, some flags, and an enumerator identifying
	the target OS - which will always be Win32 in our case).
	Note that the answer MUST NOT be free'd using ReleaseLibAttr() as it
	is in fact a copy of the TLIBATTR originally supplied by the type lib.
	As this is a fairly small structure copying is fast and avoids us having
	to worry about freeing the structure correctly later with finalization and
	a back pointer to the receiver."

	| libattr answer lib |
	libattr := TLIBATTR newPointer.
	lib := self tlbInterface.
	lib GetLibAttr: libattr.
	answer := libattr copy.
	lib ReleaseTLibAttr: libattr.
	^answer!

hash
	"Answer the <integer> hash value for the receiver."

	^self libid hash!

initializeAfterLoad
	"Ensure that the receiver is registered in the set of installed type libraries
	after loading into the image. We do this simply by causing the library to
	be realized"

	TypeLibs at: self attributes put: self!

initializeAliasMap
	"Empty the receiver's alias map of any aliases previously set up by the user."

	aliasMap := LookupTable new
				at: 'GUID' put: GUID asQualifiedReference;
				at: 'PROPVARIANT' put: VARIANT asQualifiedReference;
				at: 'RemotableHandle' put: Handle asQualifiedReference;
				at: 'FILETIME' put: FILETIME asQualifiedReference;
				yourself	"A lot of libraries pull in GUID it seems - this avoid a guid clash warning"!

interfaces
	"Answer a <sequencedReadableCollection> of all the interfaces 
	(dispatch or vtbl) in the receiver.
	Note that in theory the combined size of the #customInterfaces, 
	#dispatchOnlyInterfaces, and #dualInterfaces should be equal to 
	the size of this collection, however some type libraries contain
	errors such as IUnknown derived interfaces being marked as dual
	(an example is the IRecFields interface in the ADO 2.5 library)."

	^self selectTypes: [:t | | tk | tk := t typekind. tk == TKIND_INTERFACE or: [tk == TKIND_DISPATCH]]!

isInstalled
	"Answer whether the receiver is actually installed (and loadable) on the host machine."

	[self asParameter] on: HRESULTError do: [:e | ^false].
	^true!

isName: aString 
	"Answer whether specified string is the name of a member in the receiver."

	^self tlbInterface isName: aString!

isRegistered
	"Answer whether the receiver is registered on the host machine
	(if not then any components described by this library are probably not useable)."

	^self path notEmpty!

libid
	"Answer the a <GUID> which is the receiver's LIBID (Library ID)."

	^self guid!

loadTypeLib
	"Private - Load and answer the receiver's ITypeLib."

	^ITypeLib fromAttributes: self attributes!

modules
	"Answer a <sequencedReadableCollection> of all the 
	coclasses (component objects) in the receiver."

	^self selectTypeKind: TKIND_MODULE!

namedStructs
	"Answer a <sequencedReadableCollection> of all the named structs (i.e. excluding anonymous
	structs) described in the receiver."

	^self structs reject: [:each | each isAnonymous]!

namedUnions
	"Answer a <sequencedReadableCollection> of all the named unions (i.e. excluding anonymous
	unions) described in the receiver."

	^self unions reject: [:each | each isAnonymous]!

names
	"Answer the 'names' of all the elements in the receiver."

	| lib |
	lib := self tlbInterface.
	^(1 to: self typeInfoCount) collect: [:i | lib nameAt: i]!

namespaceName
	^namespaceName ifNil: [namespaceName := self variableNameFrom: self name]!

namespaceName: aString
	namespaceName := aString!

path
	"Answer the receiver's path if correctly registered, otherwise an empty string."
	
	| attr |
	attr := self attributes.
	^ITypeLib
		queryPath: attr guid 
		major: attr wMajorVerNum 
		minor: attr wMinorVerNum 
		locale: attr lcid
		ifNone: ['']!

realize
	"Private - Load the receiver's ITypeLib."

	tlbInterface := self loadTypeLib!

registration
	"Answers an Association for the receiver as it would appear in
	AXTypeLibraryAnalyzer class>>typeLibRegistrations."

	^self helpstring -> {self guid asString. self versionString}!

reset
	"Clear any cached information such as the list of analyzers. This may be necessary if
	the library is updated without changing its id/version (e.g. during development), but
	some information gathered during previous generation runs (mainly the global bindings
	associated with individual types) will be lost."

	self clearCachedAnalyzers.
	constantsPoolName := nil!

selectTypeKind: typekind
	"Private - Answer a <sequencedReadableCollection> of each of the elements of
	the receiver of the specified <TYPEKIND>."

	^self selectTypes: [:t | t typekind == typekind]!

selectTypes: discriminator
	"Private - Answer a <sequencedReadableCollection> of each of the <AXTypeInfoAnalyzer>
	elements of the receiver for which the <monadicValuable>, discriminator, evaluates to true."

	^self typeAnalyzers select: discriminator
!

setTypeLib: anITypeLib attributes: aTLIBATTR
	"Private - Set the <ITypeLib> which the receiver is wrapping and cache some info
	which will enable a connection to be re-established subsequently. Answer
	the receiver."

	tlbInterface := anITypeLib.
	attributes := aTLIBATTR.
	generationFlags := self defaultGenerationFlags.
	namespaceName := self variableNameFrom: self name.
	self initializeAliasMap!

sourceInterfaces
	"Answer a <collection> of <AXInterfaceTypeAnalyzer>s describing 
	the receiver's source interfaces (a source interface is an outbound 
	interface used to publish events).
	Note: Typically source interfaces will be dispinterfaces (as otherwise they
	are not supported by VB), but this is by convention. ADO2, for example,
	has both pure dispinterface and dual source interfaces."

	| answer |
	answer := Set new.
	self coclasses do: [:each | answer addAll: each sourceInterfaces].
	^answer!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler. The cached analyzers consume a lot of space, so 
	we don't want to include them in the binary file."

	anSTBOutFiler override: typeAnalyzers with: nil.
	super stbSaveOn: anSTBOutFiler.!

structs
	"Answer a <sequencedReadableCollection> of all the 
	records (structures) in the receiver."

	^self selectTypeKind: TKIND_RECORD!

suggestBindingForType: userType
	"Private - Answer an <Association> which is the suggested or actual binding between
	the global name and the global object for the <AXTypeInfoAnalyzer>, userType. 
	If the global has not yet been defined, or alternatively if the analyzer cannot be certain 
	that it matches the type, then the value will be nil (i.e. a suggestion). If the value is nil 
	then the caller should attempt to define the global, and in so doing perform whatever 
	checks and prompts are necessary to avoid overwriting/using the wrong global object.
	The search order is:
		1) List of aliases
		2) Unembellished name as a built-in (e.g. GUID is a frequently used type with a built-in class).
		3) Name embellished with type library prefix (if previously defined, this should find it).
	The search proceeds down the list if the name is not defined, or if there is a GUID mismatch.
	All built-in types are expected to have a GUID, but the null case is handled. If either GUID
	is null then it is not regarded as a mismatch, even if the other is non-null."

	| typeGuid suggestedName nsBinding |
	suggestedName := userType suggestedGlobalName.

	"If its in the alias map, then we answer that regardless - caller should check suitable"
	self aliasMap at: suggestedName asString
		ifPresent: [:alias | ^alias bindingOrNil ifNil: [alias asSymbol -> nil]].

	"Secondly try looking up by GUID as if there is a class with the same GUID then we know it is the right one."
	typeGuid := userType guid.
	(typeGuid notNil and: [typeGuid notNull])
		ifTrue: [(self classBindingForGuid: typeGuid) ifNotNil: [:var | ^var]].
	nsBinding := self namespaceBinding.
	nsBinding notNil ifTrue: [(nsBinding value localBindingFor: suggestedName) ifNotNil: [:var | ^var]].

	"Not currently defined, or defined but _may_ not be correct object, so suggest name"
	^(VariableBinding key: suggestedName value: nil)
		environment: nsBinding;
		yourself!

typeAnalyzerAt: index
	"Answer an <AXTypeInfoAnalyzer> subinstance of the appropriate type
	for the member with the <integer> index."

	^self typeAnalyzers at: index!

typeAnalyzers
	"Private - Answer the <sequencedReadableCollection> of <AXTypeInfoAnalyzer> subinstances
	which wrap the receiver's <ITypeInfo> members.
	Note: These analyzers are held onto to act as a cache only. Any persistent information stored in
	the analyzers must also be maintained in the library (e.g. conflict resolution information, i.e. 
	the unique global names which don't clash, is maintained in the receiver's alias map).
	This cache can be emptied at any time and will be cleared down on image startup (as of
	Dolphin 5.0)."

	typeAnalyzers isNil ifTrue: [self buildTypeAnalyzers].
	^typeAnalyzers
!

typedefs
	"Answer a <sequencedReadableCollection> of all the 
	aliases (typedefs) in the receiver."

	^self selectTypeKind: TKIND_ALIAS!

typeInfoAt: index
	"Private - Answer an <ITypeInfo> for the member of the receiver at the specified
	integer index, resolved to the implementation type if a dual interface."

	^self typeAnalyzers at: index!

typeInfoCount
	"Answer the number of type info's in the receiver."

	^self tlbInterface GetTypeInfoCount!

typeInfoForGuid: guid ifNone: exceptionHandler
	"Private - Answer an <AXTypeInfoAnalyzer> for the member with <GUID>, guid,
	or if there is no such type info in the library the result of evaluating the
	<niladicValuable>, exceptionHandler."

	^TypeInfoAnalyzer
		onTypeInfo: (self tlbInterface getTypeInfoOfGuid: guid ifNone: [^exceptionHandler value])
		typeLib: self!

uninitialize
	"Private - The receiver's global is being uninstalled from the system, tidy up
	anything which might cause embarassment later on."

	self reset.
	libVariableName := nil!

unions
	"Answer a <sequencedReadableCollection> of all the unions described in the receiver."

	^self selectTypeKind: TKIND_UNION!

variableNameFrom: aString
	"Private - Answer a suitable global name based on the <readableString> argument.
	Static variables must start with an uppercase letter, ignoring any leading underscores."

	| i |
	i := aString findFirst: [:e | e ~~ $_].
	^(i == 0 or: [(aString at: i) isUppercase])
		ifTrue: [aString]
		ifFalse: [(aString copyFrom: 1 to: i) asUppercase , (aString copyFrom: i + 1)]!

versionString
	"Answer a version string for the receiver."

	| attr |
	attr := self attributes.
	^'%d.%d' sprintfWith: attr wMajorVerNum with: attr wMinorVerNum!

vtblInterfaces
	"Answer a <collection> of all the early-bound, vtable based, interfaces 
	described by the receiver. This will include dual interfaces."

	^self selectTypes: [:t | t typekind == TKIND_INTERFACE]! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #=!comparing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #aliasMap!accessing!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #at:!accessing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #at:ifAbsent:!accessing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #attributes!accessing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #basicName!accessing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #basicTypeInfoAt:!accessing!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #buildTypeAnalyzers!accessing!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #classBindingForGuid:!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #clearCachedAnalyzers!initializing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #coclasses!enumerating!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #customInterfaces!enumerating!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #defaultGenerationFlags!constants!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #dispatchableInterfaces!enumerating!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #dispinterfaces!enumerating!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #displayOn:!displaying!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #documentation!accessing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #documentationAt:!accessing!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #documentationAt:ifAbsent:!accessing!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #dualInterfaces!enumerating!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #enums!enumerating!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #find:count:!public!searching! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #fullNameFor:!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #getLibAttr!accessing!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #hash!comparing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #initializeAfterLoad!initializing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #initializeAliasMap!initializing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #interfaces!enumerating!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #isInstalled!public!testing! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #isName:!accessing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #isRegistered!public!testing! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #libid!accessing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #loadTypeLib!accessing!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #modules!enumerating!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #namedStructs!enumerating!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #namedUnions!enumerating!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #names!enumerating!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #namespaceName!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #namespaceName:!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #path!accessing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #realize!private!realizing/unrealizing! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #registration!accessing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #reset!initializing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #selectTypeKind:!enumerating!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #selectTypes:!enumerating!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #setTypeLib:attributes:!initializing!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #sourceInterfaces!enumerating!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #stbSaveOn:!binary filing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #structs!enumerating!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #suggestBindingForType:!constants!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #typeAnalyzerAt:!accessing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #typeAnalyzers!accessing!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #typedefs!enumerating!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #typeInfoAt:!accessing!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #typeInfoCount!accessing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #typeInfoForGuid:ifNone:!accessing!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #uninitialize!initializing!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #unions!enumerating!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #variableNameFrom:!accessing!helpers!private! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #versionString!accessing!public! !
!OS.COM.TypeLibraryAnalyzer categoriesFor: #vtblInterfaces!enumerating!public! !

!OS.COM.TypeLibraryAnalyzer class methodsFor!

allOpenableTypeLibs
	"Answer an <sequencedReadableCollection> of all of the instances of the receiver 
	currently registered in this image which are openable on the host machine (some
	may not be registered on this machine if the image was transferred from another
	machine)."

	^TypeLibs asArray select: [:lib | [lib realize. true] on: HRESULTError do: [:ex | false]]!

allTypeLibs
	"Answer an <sequencedReadableCollection> of all of the instances of the receiver 
	currently registered in this image."

	^TypeLibs asArray!

fromRegistration: registration
	"Answer an instance of the receiver loaded from the <TypeLibRegistration>  argument."

	^self
		load: registration libid
		major: registration majorVersion
		minor: registration minorVersion
		locale: NlsConstants.LOCALE_SYSTEM_DEFAULT!

initialize
	"Private - Initialise the receiver's class variables.
		AXTypeLibraryAnalyzer initialize
	"

	SessionManager current 
		when: #sessionStarted
		send: #onStartup
		to: self.
	TypeLibs isNil ifTrue: [TypeLibs := WeakLookupTable new]!

load: libid major: verMajor minor: verMinor locale: locale
	"Answer a new instance of the receiver on the registered type library
	identified by the arguments."

	^self onTypeLib: (ITypeLib load: libid major: verMajor minor: verMinor locale: locale).!

new
	"Answer a new empty instance of the receiver - only really useful as a shell for populating
	in the AXComponentWizard."

	^self basicNew setTypeLib: nil attributes: TLIBATTR new!

onPreStripImage
	"Private -  Assist in the image stripping process by clearning down any
	lazily initialized variables held by the receiver."

	self allTypeLibs do: [:e | e clearCachedAnalyzers]!

onStartup
	"The system is starting: We must clear away all cached analyzers, as unfortunately we cannot guarantee
	their indices will remain the same across different machines as it would appear that even Microsoft
	release new builds of their type libraries without changing the GUID or the type lib version number,
	hence the info. might well be stale and we have no way of knowing. Fortunately the process of building
	the cache is pretty fast (especially in D5)."

	TypeLibs do: [:e | e clearCachedAnalyzers]!

onTypeLib: piTypeLib
	"Answer the shared instance of the receiver for the <ITypeLib>, piTypeLib."

	| libAttr lib |
	libAttr := piTypeLib getLibAttr.
	lib := TypeLibs at: libAttr
				ifAbsent: 
					["Notification signal: 'New type lib opened: ', piTypeLib printString."

					| key |
					key := libAttr copy.
					TypeLibs at: key put: (self basicNew setTypeLib: piTypeLib attributes: key)].
	piTypeLib ReleaseTLibAttr: libAttr.
	^lib!

open: pathName
	"Open the type library at the specified path and answer an instance of the
	receiver on it."

	^self onTypeLib: (ITypeLib open: pathName)!

stbConvertFrom: anSTBClassFormat 
	"Convert from earlier binary filed versions."

	^
	[:data | 
	| converted ver newInstance |
	converted := data.
	ver := anSTBClassFormat version.
	ver < 1 ifTrue: [converted := self stbConvertToVersion1: converted].
	ver < 2 ifTrue: [converted := self stbConvertToVersion2: converted].
	ver < 3 ifTrue: [converted := self stbConvertToVersion3: converted].
	newInstance := self basicNew.
	1 to: converted size
		do: [:i | newInstance instVarAt: i put: (converted at: i)].
	newInstance]!

stbConvertToVersion1: anArray
	"Convert from version 0 instance. - aliasMap and typeAnalyzers instance variables added."

	^anArray , {self new aliasMap. nil}!

stbConvertToVersion2: anArray 
	"Convert from version 1 instance.
	Version 2 refactored to share a common superclass with AXTypeInfoAnalyzer, and some inst. vars pushed up
	causing some inst. var reordering to take place."

	| answer |
	answer := anArray copy.
	answer at: 2 put: (anArray at: 4).
	answer 
		replaceFrom: 3
		to: 4
		with: anArray
		startingAt: 2.
	^answer!

stbConvertToVersion3: anArray 
	"Convert from version 2 instance.
	In version 3 the prefix is replaced with a namespaceName."

	anArray at: 4 put: nil.
	^anArray!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^3!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	TypeLibs := WeakLookupTable new.
	SessionManager current removeEventsTriggeredFor: self! !
!OS.COM.TypeLibraryAnalyzer class categoriesFor: #allOpenableTypeLibs!accessing!public! !
!OS.COM.TypeLibraryAnalyzer class categoriesFor: #allTypeLibs!accessing!public! !
!OS.COM.TypeLibraryAnalyzer class categoriesFor: #fromRegistration:!instance creation!public! !
!OS.COM.TypeLibraryAnalyzer class categoriesFor: #initialize!development!initializing!private! !
!OS.COM.TypeLibraryAnalyzer class categoriesFor: #load:major:minor:locale:!instance creation!public! !
!OS.COM.TypeLibraryAnalyzer class categoriesFor: #new!instance creation!public! !
!OS.COM.TypeLibraryAnalyzer class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!OS.COM.TypeLibraryAnalyzer class categoriesFor: #onStartup!event handling!public! !
!OS.COM.TypeLibraryAnalyzer class categoriesFor: #onTypeLib:!instance creation!public! !
!OS.COM.TypeLibraryAnalyzer class categoriesFor: #open:!instance creation!public! !
!OS.COM.TypeLibraryAnalyzer class categoriesFor: #stbConvertFrom:!binary filing!public! !
!OS.COM.TypeLibraryAnalyzer class categoriesFor: #stbConvertToVersion1:!binary filing!public! !
!OS.COM.TypeLibraryAnalyzer class categoriesFor: #stbConvertToVersion2:!binary filing!public! !
!OS.COM.TypeLibraryAnalyzer class categoriesFor: #stbConvertToVersion3:!binary filing!public! !
!OS.COM.TypeLibraryAnalyzer class categoriesFor: #stbVersion!binary filing!public! !
!OS.COM.TypeLibraryAnalyzer class categoriesFor: #uninitialize!class hierarchy-removing!private! !

