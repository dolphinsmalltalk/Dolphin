"Filed out from Dolphin Smalltalk 7"!

OS.COM.InterfaceImplementation subclass: #'OS.COM.PropertyBag'
	instanceVariableNames: 'propertyTable clsid saveAll clearDirty'
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.PropertyBag guid: (Core.GUID fromString: '{9c956c61-af27-11d3-b376-080046056106}')!
OS.COM.PropertyBag comment: ''!
!OS.COM.PropertyBag categoriesForClass!Unclassified! !
!OS.COM.PropertyBag methodsFor!

asVariant
	"Answer the object value of the receiver wrapped as an <IUnknown> pointer in a <VARIANT>."

	^VARIANT fromUnknown: self load!

inStream: inputStream
	"Private - Read a property bag (previously persisted by this class) from the <gettableStream> argument, 
	inputStream."

	| arrays |
	arrays := Compiler evaluate: inputStream contents.
	arrays isNil ifTrue: [self error: 'Invalid persisted data format'].
	self setProperties: arrays!

load
	"Reconstitute the object in this property bag. Answer the loaded object's <IUnknown>, 
	unless any errors occur in which case an <AXPropertyLoadError> is raised with details.
	Alternatively if the object persisted in the receiver claims that it doesn't support
	<IPersistPropertyBag>, then an E_NOINTERFACE <HRESULTError> is raised."

	| unk |
	unk := IUnknown onCLSID: clsid.
	self restoreInto: unk.
	^unk!

printOn: target indent: tabs 
	"Write the contents of the receiver to the <puttableStream>, target, as  literal array definition which the
	Smalltalk compiler will be able to reconstruct, and which may then be used to rebuild this property bag.
	The <integer>, tabs, specifies the level of nesting, and is useful for producing a prettier output that is
	human-readable."

	| indent |
	target
		crtab: tabs;
		nextPutAll: '#( ';
		display: clsid.
	indent := tabs + 1.
	propertyTable keys asSortedCollection do: 
			[:k | 
			| prop |
			target
				crtab: indent;
				print: k;
				space.
			prop := propertyTable at: k.
			#todo.	"Another type test - need some polymorphic messages"
			(prop isKindOf: self class) 
				ifTrue: [prop printOn: target indent: indent]
				ifFalse: [prop printOn: target]].
	target
		crtab: tabs;
		nextPutAll: ') "End of ';
		display: clsid;
		nextPut: $"!

propertyTable
	"Private - Answer the value of the receiver's ''propertyTable'' instance variable."

	^propertyTable!

propertyTable: anObject
	"Private - Set the value of the receiver's ''propertyTable'' instance variable to the argument, anObject."

	propertyTable := anObject!

Read: pszPropName pVar: pVar pErrorLog: pErrorLog
	"Implement the IPropertyBag::Read() method.
	Note that the pVar argument is really an in-out parameter, since the 'vt' member is expected to
	be set to the type of variant desired, or VT_EMPTY for don't care. This means it should not
	be initialized, and should not be free'd either.

		HRESULT __stdcall Read(
			[in] LPWSTR pszPropName,
			[out] VARIANT* pVar,
			[in] IErrorLog* pErrorLog);
	"

	^
	[| propName prop vt val |
	propName := pszPropName asString.
	prop := propertyTable at: propName ifAbsent: [^E_INVALIDARG	"Unrecognised property name"].
	val := prop asVariant.
	(vt := pVar vt) == VT_EMPTY ifFalse: [val := val changeType: vt].
	"VARIANT>>value: method frees existing content, which we don't want as may not be valid"
	pVar copyBytes: val detach.
	S_OK]
			on: PropertyReadError
			do: 
				[:e |
				pErrorLog notNull
					ifTrue: 
						[| errs |
						errs := e errorLog queryInterface: IEnumErrorInfo
									ifNone: 
										[{IErrorInfo
												source: pszPropName
												description: 'Error loading embedded object property'
												helpContext: 0
												helpFile: ''
												guid: e guid}].
						errs do: [:errInfo | pErrorLog addError: pszPropName pExcepInfo: errInfo excepInfo]].
				e hresult asInteger]
			on: Error
			do: 
				[:e |
				pErrorLog notNull
					ifTrue: 
						[| ex |
						ex := EXCEPINFO new.
						ex description: e description.
						ex scode: e hresult asInteger.
						ex source: pszPropName.
						pErrorLog addError: pszPropName pExcepInfo: ex].
				e hresult asInteger]!

restoreInto: anIUnknown 
	"Configure the COM object, anIUnknown, with the properties in this bag.
	If any errors occur an <AXPropertyLoadError> is raised with details, or if
	the object persisted in the receiver claims that it doesn't support <IPersistPropertyBag>, 
	then an E_NOINTERFACE <HRESULTError> is raised."

	| ipb hr log |
	ipb := anIUnknown queryInterface: IPersistPropertyBag
				ifNone: [^HRESULTError signalWith: E_NOINTERFACE].
	log := (PropertyBagErrorLog new)
				guid: clsid;
				yourself.
	hr := ipb Load: (self queryInterface: IPropertyBag)
				pErrorLog: (log queryInterface: IErrorLog).
	log notEmpty ifTrue: [^PropertyReadError signalWith: log].
	hr < 0 ifTrue: [^ipb hresultError: hr].
	ipb free!

save: unkObject clearDirty: aBoolean
	"Save the object with <IUnknown>, unkObject, to this property bag, optionally clearing the object's
	dirty flag depending on the value of the <boolean> 2nd argument. If the object does not implement
	<IPersistPropertyBag>, then raise an E_NOINTERFACE <HRESULTError> exception. Any existing 
	contents in this property bag are lost. Only the properties which differ from defaults are saved."

	^self save: unkObject clearDirty: aBoolean saveAll: false!

save: unkObject clearDirty: clearDirtyBoolean saveAll: saveAllBoolean
	"Save the object with <IUnknown>, unkObject, to this property bag, optionally clearing the object's
	dirty flag depending on the value of the <boolean> 2nd argument. If the object does not implement
	<IPersistPropertyBag>, then raise an E_NOINTERFACE <HRESULTError> exception. Any existing 
	contents in this property bag are lost."

	| ipb |
	propertyTable := LookupTable new: 15.
	ipb := unkObject queryInterface: IPersistPropertyBag
				ifNone: [^HRESULTError signalWith: E_NOINTERFACE].
	clsid := ipb clsid.
	ipb
		Save: (IPropertyBag on: self implementor: self)
		fClearDirty: (clearDirty := clearDirtyBoolean)
		fSaveAllProperties: (saveAll := saveAllBoolean).
	ipb free!

setProperties: array
	"Private - Recursively add the properties defined in the <Array>, array, to receiver's <LookupTable>.
	The format is a simple one where the first element is the ProgId or CLSID (as a string) and subsequent
	elements are property names and value pairs. Where nested arrays are encountered in the array (which
	must be in value positions), a new property bag is embedded, and this message recursively sent to it.
	Answers the receiver."

	propertyTable := LookupTable new.
	clsid := CLSID fromString: (array basicAt: 1).
	2 to: array basicSize
		by: 2
		do: 
			[:i |
			| propValue |
			propValue := array basicAt: i + 1.
			propertyTable at: (array basicAt: i)
				put: (propValue class == Array
						ifTrue: [PropertyBag new setProperties: propValue]
						ifFalse: [propValue])].
	^self!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver."

	^{IPropertyBag}!

Write: pszPropName pVar: pVar
	"Implement the IPropertyBag::Write() method by saving the property to the receiver's
	propertyTable. If the property is an object, then a nested <AXPropertyBag> is created
	and saved into the table. Note that this means that any nested objects must also support
	<IPersistPropertyBag> at present.

		HRESULT __stdcall Write(
			[in] LPWSTR pszPropName,
			[in] VARIANT* pVar);
	"

	| hr |
	hr := S_OK.
	propertyTable 
		at: pszPropName asString 
		put: (pVar isObject
				ifTrue: [self class new save: pVar value clearDirty: clearDirty saveAll: saveAll]
				ifFalse: [pVar value]).
	^hr! !
!OS.COM.PropertyBag categoriesFor: #asVariant!converting!public! !
!OS.COM.PropertyBag categoriesFor: #inStream:!accessing!public! !
!OS.COM.PropertyBag categoriesFor: #load!operations!public! !
!OS.COM.PropertyBag categoriesFor: #printOn:indent:!printing!public! !
!OS.COM.PropertyBag categoriesFor: #propertyTable!accessing!private! !
!OS.COM.PropertyBag categoriesFor: #propertyTable:!accessing!private! !
!OS.COM.PropertyBag categoriesFor: #Read:pVar:pErrorLog:!COM Interfaces-IPropertyBag!public! !
!OS.COM.PropertyBag categoriesFor: #restoreInto:!operations!public! !
!OS.COM.PropertyBag categoriesFor: #save:clearDirty:!operations!public! !
!OS.COM.PropertyBag categoriesFor: #save:clearDirty:saveAll:!operations!public! !
!OS.COM.PropertyBag categoriesFor: #setProperties:!helpers!private! !
!OS.COM.PropertyBag categoriesFor: #supportedInterfaces!constants!public! !
!OS.COM.PropertyBag categoriesFor: #Write:pVar:!COM Interfaces-IPropertyBag!public! !

OS.COM.PropertyBag methodProtocol: #IPropertyBag attributes: #(#readOnly) selectors: #(#Read:pVar:pErrorLog: #Write:pVar:)!

