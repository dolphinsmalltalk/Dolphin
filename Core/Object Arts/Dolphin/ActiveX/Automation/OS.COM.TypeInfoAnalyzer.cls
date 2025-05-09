﻿"Filed out from Dolphin Smalltalk"!

OS.COM.TypeInfoObject
	subclass: #'OS.COM.TypeInfoAnalyzer'
	instanceVariableNames: 'typeLib guid index documentation'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'VTtoIDLTypeMap'
				-> #(nil 'short' 'long' 'float' 'double' 'CURRENCY' 'DATE' 'BSTR' 'IDispatch*' 'SCODE' 'VARIANT_BOOL' 'VARIANT' 'IUnknown*' 'DECIMAL' nil 'char' 'BYTE' 'unsigned short' 'unsigned long' '__int64' 'unsigned __int64' 'int' 'unsigned int' 'void' 'HRESULT' '*' 'SAFEARRAY*' '[]' 'typedef' 'LPSTR' 'LPWSTR')
		}!

OS.COM.TypeInfoAnalyzer guid: (Core.GUID fromString: '{c06f3b64-0868-11d3-93af-00a024ca708a}')!

OS.COM.TypeInfoAnalyzer isNonInstantiable: true!

OS.COM.TypeInfoAnalyzer comment: 'AXTypeInfoAnalyzer is a class which wraps an Active-X Automation <ITypeInfo> interface pointer and adds higher level behaviours for analyzing the type information available through that interface.

ITypeInfo itself contains a large number of member functions which allow one to enquire about the structure and attributes of each of the individual elements of a Type Library. Unfortunately it is rather poorly factored in that a single interface is used to describe widely differing objects. We have therefore applied the "Conditional Elimination" refactoring pattern and created a pseudo hierarchy as follows:

- TYPEKIND_ENUM			TKindEnumAnalyzer		an enumerated type
- TYPEKIND_RECORD		TKindRecordAnalyzer	a C-style struct
- TYPEKIND_MODULE		TKindModule			a shared library/DLL of static functions and constants
- TYPEKIND_INTERFACE	TKindInterfaceAnalyzer	a custom COM interface
- TYPEKIND_DISPATCH		TKindDispatchAnalyzer	an Active-X Automation interface
- TYPEKIND_COCLASS		TKindCoclassAnalyzer	an instantiable component class with a CLSID
- TYPEKIND_ALIAS			TKindAliasAnalyzer		a C-style typedef which defines a name for a type
- TYPEKIND_UNION			TKindUnionAnalyzer		a C-style union (struct with overlapping members)

Each subclass contains specific behaviours appropriate for querying relevant information for its particular type kind, and also for generating Smalltalk wrappers for that type.

Instance Variables:
	typeLib 			<AXTypeLibraryAnalyzer>. Owning type library.
	globalBinding	<Association>. The global binding being generated, usually a Class.
	guid			<GUID>. Unique id of type.
	index			<integer> index of the type in the typelib.
	basicName		<readableString> name of the type from the typelib.'!

!OS.COM.TypeInfoAnalyzer categoriesForClass!ActiveX Automation! !

!OS.COM.TypeInfoAnalyzer methodsFor!

= comparand
	"Answer whether the receiver and the <Object>, comparand, 
	are considered equivalent.
	Implementation Note: Two type analyzers are considered equivalent
	if they have the same GUID, or if they are the same indexed item
	from the same type library (not all type infos have a guid)."

	^self == comparand or: [
		comparand class == self class and: [
			comparand guid = self guid and: [
				self guid notNull or:  [
					comparand typeLib = self typeLib and: [comparand index = self index]]]]]!

asImplType
	"Answer the actual implementing type for the receiver (some are pseuds!!)"

	^self!

attributes
	"Answer a <TYPEATTR> detailing the receiver's attributes - may raise an <HRESULTError>.
	Note that this is cached by the ITypeInfo."

	^self tlbInterface attributes!

baseClass
	"Private - Answer the Dolphin class used to represent superclass of the receiver."

	^self subclassResponsibility.!

basicName
	"Private - Answer a <readableString> name for the receiver, retrieved directly
	from the documentation in the type library."

	^self documentation name!

binding
	"Private - Answer the global binding (or the proposed global binding) for the receiver.
	Notes: 
	1) The global binding is not saved down until actually generated as we want
	to keep in step with any changes in the class library prefix.
	2) If we find that the global binding is outdated (i.e. the global no longer exists), then 
	we must reset."

	binding notNil
		ifTrue: 
			["Find or clear (if removed) the current binding"
			self binding: (self environment localBindingFor: binding key)].
	^binding ifNil: [self suggestedBinding]!

classDesc
	"Private - Answer an <association> between a Dolphin class suitable for representing
	the external type described by the receiver, and the number of indirections
	to the type."

	^(VARIANT classForVT: self vt) -> 0!

constants
	"Answer <sequencedReadableCollection> of VARDESCs describing the 
	member variables of the receiver's structure (assumes it is a structure -
	if it isn't the collection will be empty)."

	^self variables select: [:each | each isSymbolicConstant]!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self name!

documentation
	"Answer an <AXTypeLibDocumentation> object containing the documentation for this type."

	^documentation ifNil: [documentation := self documentationForMember: MEMBERID_NIL]!

documentationForMember: memid
	"Answer an <AXTypeLibDocumentation> object containing the documentation for the 
	element of the receiver identified by the <MEMBERID>, memid. Note that this
	differs from ITypeLib, where indices are used to access the elements.
	The method may raise an HRESULTError, or a NotFoundError if the memid 
	is not recognised. Refer to the SDK help for further possible error conditions."

	^self documentationForMember: memid ifAbsent: [self errorNotFound: memid]!

documentationForMember: memid ifAbsent: exceptionHandler
	"Answer an <AXTypeLibDocumentation> object containing the documentation for the 
	element of the receiver identified by the <MEMBERID>, memid. Note that this
	differs from ITypeLib, where indices are used to access the elements.
	If the member is not found, then answers the result of evaluating the <niladicValuable>
	exceptionHandler.
	The method may raise an HRESULTError, e.g. if the index is out of range. Refer
	to the SDK help for further possible error conditions."

	| bstrName bstrDocString dwHelpContext answer hr |
	bstrName := BSTR basicNew.
	bstrDocString := BSTR basicNew.
	dwHelpContext := UInt32Bytes new.
	hr := self tlbInterface
				GetDocumentation: memid
				pBstrName: bstrName
				pBstrDocString: bstrDocString
				pdwHelpContext: dwHelpContext
				pBstrHelpFile: nil.
	hr < 0
		ifTrue: 
			[hr = AutomationErrors.TYPE_E_ELEMENTNOTFOUND ifTrue: [^exceptionHandler value].
			^HRESULTError signalWith: hr].
	answer := TypeLibDocumentation new
				name: bstrName asUtf16String
				helpstring: bstrDocString asUtf16String
				helpcontext: dwHelpContext asInteger
				helpfile: ''.
	bstrName basicFree.
	bstrDocString basicFree.
	^answer!

environment
	"Answer the namespace into which global representing the receiver type will be/has been generated."

	^self typeLib environment!

ephemeralFunctionsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the functions described by the receiver, passing a FUNCDESC for each. The valuable must not capture the <FUNDESC>s it is passed, because they are only valid for the duration of the evaluation, being explicitly free'd as soon as the valuable returns. This is for the purpose of avoiding the creation of finalizable garbage. If there is a need to capture the <FUNCDESC>s, use either #functionsDo: or #functions."

	| itypeinfo |
	itypeinfo := self tlbInterface.
	^1 to: self functionCount
		do: 
			[:i |
			| funcdesc |
			funcdesc := (itypeinfo getFuncDesc: i - 1)
						setAnalyzer: self index: i - 1;
						yourself.
			aMonadicValuable value: funcdesc.
			funcdesc free]!

fullyQualifiedName
	"Private - Answer the unique name for the receiver (assuming its library name is unique)
	according to the informal COM naming convention."

	^self typeLib name, '.', self name.
!

funcDescAt: anInteger
	"Private - Answer a FUNCDESC for the function in the receiver at the specified one-based
	<integer> index."

	| funcIndex |
	funcIndex := anInteger - 1.
	^(self tlbInterface getFuncDesc: funcIndex)
		setAnalyzer: self index: funcIndex;
		yourself!

functionCount
	^self attributes cFuncs!

functions
	"Answer a <sequencedReadableCollection> of FUNCDESC structures describing the
	methods in the receiver (assumes it is an interface). If the receiver is not of a TYPEKIND
	which holds functions, then the resulting collection will be empty."

	^(1 to: self functionCount) collect: [:i | self funcDescAt: i]!

functionsByName
	"Answer a <LookupTable> of FUNCDESC structures keyed by function name describing the methods
	in the receiver (assumes it is an interface). If the receiver is not of a TYPEKIND which
	holds functions, then the resulting collection will be empty."

	| answer |
	answer := LookupTable new.
	self functionsDo: [:each | answer at: each name put: each].
	^answer!

functionsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the functions described by the receiver, passing a FUNCDESC for each."

	^1 to: self functionCount do: [:i | aMonadicValuable value: (self funcDescAt: i)]!

generateVariableDefinition: aVariableBinding
	"Private - Generate a minimal definition of the receiver which will enable it to be seen,
	if not heard, in the development environment."

	^self error: 'Unable to define new shared variable ', aVariableBinding printString!

getImplTypeInfoAt: subscript 
	"Answer an <AXInterfaceTypeInfo> describing the interface with the one-based <integer> 
	index, subscript, in the receiver - this will be an implemented interface in the case of a 
	coclass, or an inherited interface in the case of an interface. The index 0 is used as a 
	special case to access the dual interface associated with a dispinterface, if any."

	| implType |
	implType := self class onTypeInfo: (self tlbInterface getImplTypeInfoAt: subscript).
	self assert: [implType == implType asImplType].
	^implType!

getNamesOfMember: memid count: cMaxNames 
	"Private - Answer an array containing the names of the member of the
	receiver identified by the <MEMBERID>, memid."

	^self tlbInterface getNamesOfMember: memid count: cMaxNames!

getRefType: href
	"Private - Retrieve another ITypeInfo referenced by the receiver as the HREFTYPE, href.
	Implementation Note: Attempts to resolve to the actual implementation type."

	| refTypeInfo refType |
	refTypeInfo := self tlbInterface getRefTypeInfo: href.
	refType := (self class onTypeInfo: refTypeInfo) asImplType.
	refTypeInfo free.
	^refType!

guid
	"Answer the guid associated with the receiver."

	guid isNil ifTrue: [guid := super guid].
	^guid!

hasConstantsGeneratedAs: aNamespace
	^self constants allSatisfy: 
			[:each |
			| var |
			var := aNamespace localBindingFor: each name capitalized.
			var notNil and: [var value = each value]]!

hasFunctions
	"Answer whether the receiver defines any functions."

	^self attributes cFuncs ~~ 0!

hash
	"Answer the <integer> hash value for the receiver."

	^self guid hash!

idOfName: name ifAbsent: exceptionHandler 
	"Answer the <integer> DISPID of the member named by the <readableString>
	argument, name, in the receiver."

	^self tlbInterface idOfName: name ifAbsent: exceptionHandler!

includeIDLInClassComment
	^true!

index
	"Answer the receiver's one-based integer index within its owning type library."

	^index!

isDispatchable
	"Answer whether the receiver is derived directly or indirectly from IDispatch."

	^self attributes isDispatchable

!

isDual
	"Answer whether the receiver is a dual interface."

	^false

!

isEnum
	"Answer whether the receiver describes an enumeration."

	^false!

isGeneratedAs: aClass
	^self hasFunctions not
		or: [aClass methodDictionary notEmpty or: [aClass class methodDictionary notEmpty]]!

isHidden
	"Answer whether the receiver is describing a type which should
	not be displayed in type library browsers.
	Applicable to all typekinds."

	^self tlbInterface isHidden!

isStructure
	"Answer whether the receiver describes a struct or union type."

	^false!

isUnion
	"Answer whether the receiver describes a union."

	^false!

isVariableDefined
	"Answer whether a global has already been defined for the receiver."

	| class |
	class := self binding value.
	^class notNil and: 
			[class class isMeta and: 
					[class guid = self guid or: 
							[| nsName |
							nsName := self typeLib namespaceName.
							class fullyQualifiedReference = nsName or: [class environment fullyQualifiedReference = nsName]]]]!

nameOfID: memid
	"Answer a <readableString> name for the member of the 
	receiver identified by the <MEMBERID>, memid. Note that this
	differs from ITypeLib, where indices are used to access the elements.
	We can use this as the reverse mapping to GetIDsOfNames."

	^self nameOfID: memid ifAbsent: [self errorNotFound: memid]!

nameOfID: memid ifAbsent: exceptionHandler 
	"Answer a <readableString> name for the member of the 
	receiver identified by the <MEMBERID>, memid, of if there is no
	such member the result of evaluating the niladicValuable, exceptionHandler."

	^self tlbInterface nameOfID: memid ifAbsent: exceptionHandler!

nameSansTag
	"Private - Answer a <readableString> name for the receiver, retrieved from the
	documentation, without any leading underscore/tag prefix
	which probably wasn't present in the original IDL."

	| name |
	name := self basicName.
	^name first = $_ 
		ifTrue: [name allButFirst]
		ifFalse: 
			[(name beginsWith: 'tag') ifTrue: [name allButFirst: 3] ifFalse: [name]]!

programObject
	"Answer the program object (typically a class) that the receiver has generated/would generate.
	N.B. This will cause the object to be generated, if it hasn't been already!!"

	| var value |
	var := self binding.
	(value := var value) isNil ifTrue: [value := self generateVariableDefinition: var].
	^value!

realize
	"Private - Load the receiver's ITypeInfo from its owning type library."

	(typeLib isNil or: [index isNil]) ifTrue: [^self error: 'Unable to restore type info.'].
	self setTypeInfo: (typeLib basicTypeInfoAt: index)
!

realTypeInfo
	^self!

releaseFuncDesc: aFUNCDESC
	tlbInterface isNull ifFalse: [tlbInterface ReleaseFuncDesc: aFUNCDESC]!

releaseTypeAttr: aTYPEATTR
	tlbInterface isNull ifFalse: [tlbInterface ReleaseTypeAttr: aTYPEATTR]!

releaseVarDesc: aVARDESC
	tlbInterface isNull ifFalse: [tlbInterface ReleaseVarDesc: aVARDESC]!

setTypeInfo: anITypeInfo
	"Private - Set the value of the receiver's <ITypeInfo> instance variable to the argument."

	(tlbInterface := (anITypeInfo queryInterface: ITypeInfo2) ?? anITypeInfo) attributes analyzer: self!

setTypeInfo: anITypeInfo typeLib: anAXTypeLibraryAnalyzer index: anInteger 
	"Private - Initialize the receiver's identity instance variables."

	self setTypeInfo: anITypeInfo.
	typeLib := anAXTypeLibraryAnalyzer.
	index := anInteger.
!

suggestedBinding
	"Private - Answer an <Association> for the global binding (or the proposed global binding) 
	for the receiver, on the assumption that it doesn't currently have a binding."

	^self typeLib suggestBindingForType: self!

targetOfType: aTYPEDESC
	^aTYPEDESC!

tdesc
	^self attributes tdesc!

typeFlags
	"Answer the receiver's type flags (from the TYPEFLAGS enumeration)."

	^self attributes wTypeFlags!

typekind
	"Answer the Automation TYPEKIND associated with the receiver."
	
	^self class typekind!

typeLib
	"Answer a <AXTypeLibraryAnalyzer> on the receiver's containing type library."

	typeLib isNil ifTrue: [typeLib := TypeLibraryAnalyzer onTypeLib: tlbInterface typeLib].
	^typeLib!

typeName
	"Answer the Dolphin external type name for the receiver."

	^self classDesc key typeName!

varDescAt: anInteger
	"Private - Answer a VARDESC for the member variable of the receiver's structure
	at the specified index."

	| varIndex |
	varIndex := anInteger - 1.
	^(self tlbInterface getVarDesc: varIndex)
		setAnalyzer: self index: varIndex;
		yourself!

variableName: aString
	"Private - Set the static variable name to be used for the receiver when generated."

	self binding: ((self environment localBindingFor: aString)
				ifNil: 
					[(VariableBinding key: aString value: nil)
						environment: self environment;
						yourself])!

variables
	"Answer <sequencedReadableCollection> of VARDESCs describing the 
	member variables of the object described by the receiver. The collection will
	be empty if this message is sent to an inappropriate typekind."

	^(1 to: self attributes cVars) collect: [:i | self varDescAt: i]!

vt
	"Answer a variant type code (a member of VARENUM) which describes the type
	of variant which can be used to represent an object of the type described by
	the receiver."

	^VT_USERDEFINED! !

!OS.COM.TypeInfoAnalyzer categoriesForMethods!
=!comparing!public! !
asImplType!converting!public! !
attributes!accessing!public! !
baseClass!constants!private! !
basicName!accessing!private! !
binding!accessing!private! !
classDesc!constants!private! !
constants!enumerating!public! !
displayOn:!displaying!public! !
documentation!accessing!public! !
documentationForMember:!accessing!public! !
documentationForMember:ifAbsent:!accessing!public! !
environment!constants!public! !
ephemeralFunctionsDo:!public! !
fullyQualifiedName!constants!private! !
funcDescAt:!accessing!private! !
functionCount!public! !
functions!enumerating!public! !
functionsByName!enumerating!public! !
functionsDo:!enumerating!public! !
generateVariableDefinition:!private! !
getImplTypeInfoAt:!accessing!public! !
getNamesOfMember:count:!accessing!private! !
getRefType:!accessing!private! !
guid!accessing!public! !
hasConstantsGeneratedAs:!private!testing! !
hasFunctions!public!testing! !
hash!comparing!public! !
idOfName:ifAbsent:!accessing!public! !
includeIDLInClassComment!constants!private! !
index!constants!public! !
isDispatchable!public!testing! !
isDual!public!testing! !
isEnum!public!testing! !
isGeneratedAs:!private!testing! !
isHidden!public!testing! !
isStructure!public!testing! !
isUnion!public!testing! !
isVariableDefined!public!testing! !
nameOfID:!accessing!public! !
nameOfID:ifAbsent:!accessing!public! !
nameSansTag!accessing!private! !
programObject!accessing!public! !
realize!private!realizing/unrealizing! !
realTypeInfo!accessing!public! !
releaseFuncDesc:!private!realizing/unrealizing! !
releaseTypeAttr:!private!realizing/unrealizing! !
releaseVarDesc:!private!realizing/unrealizing! !
setTypeInfo:!accessing!private! !
setTypeInfo:typeLib:index:!accessing!private! !
suggestedBinding!accessing!private! !
targetOfType:!private! !
tdesc!accessing!constants!public! !
typeFlags!accessing!public! !
typekind!constants!public! !
typeLib!accessing!public! !
typeName!constants!public! !
varDescAt:!accessing!private! !
variableName:!initializing!private! !
variables!accessing!public! !
vt!constants!public! !
!

!OS.COM.TypeInfoAnalyzer class methodsFor!

initialize
	"Private - Initialize class variables of the receiver.
		self initialize
	"

	self addClassConstant: 'VTtoIDLTypeMap' value: self vtToIDLTypeMap!

onTypeInfo: piTypeInfo
	"Answer a sub-instance of the receiver of an appropriate class to wrap
	the <ITypeInfo>, piTypeInfo, referencing the correct unique <AXTypeLibraryAnalyzer>
	instance that represents its containing type library."

	| contain answer lib |
	contain := piTypeInfo libraryAndIndex.
	lib := contain key.
	answer := (TypeLibraryAnalyzer onTypeLib: lib) typeAnalyzerAt: contain value.
	lib free.
	^answer!

onTypeInfo: piTypeInfo typeLib: anAXTypeLibraryAnalyzer 
	"Private - Answer a sub-instance of the receiver of an appropriate class to wrap
	the <ITypeInfo>, piTypeInfo, owned by the <AXTypeLibraryAnalyzer>, typeLib.
	Note: This should only be called from the owning type library - use #onTypeInfo:
	instead."

	^self 
		onTypeInfo: piTypeInfo
		typeLib: anAXTypeLibraryAnalyzer
		index: piTypeInfo index!

onTypeInfo: piTypeInfo typeLib: anAXTypeLibraryAnalyzer index: anInteger 
	"Private - Answer a sub-instance of the receiver of an appropriate class to wrap
	the <ITypeInfo>, piTypeInfo, owned by the <AXTypeLibraryAnalyzer>, typeLib.
	Note: This should only be called from the owning type library - use #onTypeInfo:
	instead."

	^((self typeKindToClassMap at: piTypeInfo typekind + 1) new)
		setTypeInfo: piTypeInfo
			typeLib: anAXTypeLibraryAnalyzer
			index: anInteger;
		yourself!

stbConvertFrom: anSTBClassFormat 
	"Convert from earlier binary filed versions."

	^
	[:data | 
	| converted ver newInstance |
	converted := data.
	ver := anSTBClassFormat version.
	ver < 1 ifTrue: [converted := self stbConvertToVersion1: converted].
	newInstance := self basicNew.
	1 to: converted size do: [:i | newInstance instVarAt: i put: (converted at: i)].
	newInstance]!

stbConvertToVersion1: anArray 
	"Convert from version 0 instance.
	Version 1 refactored to share a common superclass with AXTypeLibraryAnalyzer, and some inst. vars pushed up
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

stbVersion
	^1!

typekind
	"Answer the Automation TYPEKIND associated with the receiver."
	
	^self subclassResponsibility!

typeKindToClassMap
	"Private - Answer a map between TKIND_XXX enumeration members and the appropriate subclass
	to use to wrap an ITypeInfo of that typekind."

	^##((Array new: 8)
		at: TKIND_ENUM + 1 put: TKindEnumAnalyzer;
		at: TKIND_RECORD + 1 put: TKindRecordAnalyzer;
		at: TKIND_MODULE + 1 put: TKindModuleAnalyzer;
		at: TKIND_INTERFACE + 1 put: TKindInterfaceAnalyzer;
		at: TKIND_DISPATCH + 1 put: TKindDispatchAnalyzer;
		at: TKIND_COCLASS + 1 put: TKindCoclassAnalyzer;
		at: TKIND_ALIAS + 1 put: TKindAliasAnalyzer;
		at: TKIND_UNION + 1 put: TKindUnionAnalyzer;
		yourself)!

vtToIDLTypeMap
	^(Array new: VT_LPWSTR)
		at: VT_BOOL put: 'VARIANT_BOOL';
		at: VT_BSTR put: 'BSTR';
		at: VT_CARRAY put: '[]';
		at: VT_CY put: 'CURRENCY';
		at: VT_DATE put: 'DATE';
		at: VT_DECIMAL put: 'DECIMAL';
		at: VT_DISPATCH put: 'IDispatch*';
		at: VT_ERROR put: 'SCODE';
		at: VT_HRESULT put: 'HRESULT';
		at: VT_I1 put: 'char';
		at: VT_I2 put: 'short';
		at: VT_I4 put: 'long';
		at: VT_I8 put: '__int64';
		at: VT_INT put: 'int';
		at: VT_LPSTR put: 'LPSTR';
		at: VT_LPWSTR put: 'LPWSTR';
		at: VT_PTR put: '*';
		at: VT_R4 put: 'float';
		at: VT_R8 put: 'double';
		at: VT_SAFEARRAY put: 'SAFEARRAY*';
		at: VT_UINT put: 'unsigned int';
		at: VT_UI1 put: 'BYTE';
		at: VT_UI2 put: 'unsigned short';
		at: VT_UI4 put: 'unsigned long';
		at: VT_UI8 put: 'unsigned __int64';
		at: VT_UNKNOWN put: 'IUnknown*';
		at: VT_USERDEFINED put: 'typedef';
		at: VT_VARIANT put: 'VARIANT';
		at: VT_VOID put: 'void';
		yourself! !

!OS.COM.TypeInfoAnalyzer class categoriesForMethods!
initialize!initializing!private! !
onTypeInfo:!instance creation!public! !
onTypeInfo:typeLib:!instance creation!private! !
onTypeInfo:typeLib:index:!instance creation!private! !
stbConvertFrom:!binary filing!public! !
stbConvertToVersion1:!binary filing!public! !
stbVersion!binary filing!constants!public! !
typekind!constants!public! !
typeKindToClassMap!constants!private! !
vtToIDLTypeMap!initializing!private! !
!

