"Filed out from Dolphin Smalltalk 7"!

OS.COM.APIInfoAnalyzer subclass: #'OS.COM.TKindModuleAnalyzer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.TKindModuleAnalyzer guid: (Core.GUID fromString: '{c06f3b7f-0868-11d3-93af-00a024ca708a}')!
OS.COM.TKindModuleAnalyzer comment: 'TKindModuleAnalyzer is a class which wraps an OLE Automation <ITypeInfo> interface pointer that describes a ''module'' (a DLL containing exported functions). It adds higher level behaviours for analyzing the type information associated with that DLL.

As of Dolphin 4.0 TKindModuleAnalyzer now provides for the automatic generation of an ExternalLibrary subclass with appropriate Smalltalk wrapper methods for the module.

Although this facility would appear to be of limited use, since very few modules are described with IDL and thus have type libraries available, it is quite easy to build a type library by pasting appropriate parts of the module''s C header file into an IDL file (which needs a library statement) and then running MIDL against it. Indeed this is usually the best option when faced with having to define a large ExternalLibrary. There are also various type libraries which have been constructed for popular modules (including much of the Win32 API) in order to ease the use of these libraries of functions from VB.'!
!OS.COM.TKindModuleAnalyzer categoriesForClass!ActiveX Automation! !
!OS.COM.TKindModuleAnalyzer methodsFor!

baseClass
	"Private - Answer the Dolphin class used to represent superclass of the receiver."

	^DynamicLinkLibrary!

dllNameIfNone: exceptionHandler
	"Answer the name of the DLL associated with the receiver."

	^(self getDllEntry: (self functions at: 1 ifAbsent: [^exceptionHandler value])) first!

getDllEntry: funcDesc
	"Private - Answer an array of info. about a member of the receiver."

	| pBstrDllName pBstrName pwOrdinal answer |
	pBstrDllName := BSTR new.
	pBstrName := BSTR new.
	pwOrdinal := DWORDBytes new.
	self tlbInterface
		GetDllEntry: funcDesc memid
		invkind: funcDesc invkind
		pBstrDllName: pBstrDllName
		pBstrName: pBstrName
		pwOrdinal: pwOrdinal.
	answer := {pBstrDllName asString. pBstrName asString. pwOrdinal value}.
	pBstrDllName free.
	pBstrName free.
	^answer!

includeIDLInClassComment
	^false!

suggestedGlobalName
	"Private - Answer a <readableString> name suggested as the (unprefixed) for a global
	generated to represent the receiver's type."

	^self name, 'Library'! !
!OS.COM.TKindModuleAnalyzer categoriesFor: #baseClass!constants!private! !
!OS.COM.TKindModuleAnalyzer categoriesFor: #dllNameIfNone:!accessing!public! !
!OS.COM.TKindModuleAnalyzer categoriesFor: #getDllEntry:!accessing!private! !
!OS.COM.TKindModuleAnalyzer categoriesFor: #includeIDLInClassComment!constants!private! !
!OS.COM.TKindModuleAnalyzer categoriesFor: #suggestedGlobalName!accessing!private! !

!OS.COM.TKindModuleAnalyzer class methodsFor!

typekind
	"Private - Answer the Automation TYPEKIND associated with the receiver."
	
	^TKIND_MODULE! !
!OS.COM.TKindModuleAnalyzer class categoriesFor: #typekind!constants!private! !

