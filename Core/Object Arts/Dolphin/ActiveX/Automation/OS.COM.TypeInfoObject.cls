"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'OS.COM.TypeInfoObject'
	instanceVariableNames: 'tlbInterface generationFlags binding'
	classVariableNames: 'ClassCommentStyleMap GuidClash HighLevelWrapperStyleMap NamespaceClash SuperclassClash TracingStyleMap'
	imports: #(#{OS.COM.AutomationConstants} #{OS.COM.TypeGenerationFlags})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.TypeInfoObject guid: (Core.GUID fromString: '{27440177-dfab-46d4-bf61-a8fada69a263}')!
OS.COM.TypeInfoObject isNonInstantiable: true!
OS.COM.TypeInfoObject comment: '
	
Instance Variables:
	tlbInterface			<ITypeLib>|<ITypeInfo> COM interface onto type library information relevant to this type element.
	generationFlags		<integer> (or nil) flags from the AXTypeGenerationFlags pool controlling code generation.

Class Variables:
	GuidClash			<WarningSignal> raised when a duplicate GUID belonging to an apparently mismatched class is detected.
	SuperclassClash		<WarningSignal>

'!
!OS.COM.TypeInfoObject categoriesForClass!Kernel-Objects! !
!OS.COM.TypeInfoObject methodsFor!

asParameter
	"Answer the receiver in a form suitable for passing to an external function
	primitive method (see ExternalLibrary and subclasses)."

	^self tlbInterface!

attributes
	"Answer a <TYPEATTR> detailing the receiver's attributes - may raise an <HRESULTError>."

	^self subclassResponsibility!

basicName
	"Private - Answer a <readableString> name for the receiver, retrieved directly
	from the documentation in the type library."

	^self subclassResponsibility!

binding
	"Private - Answer the global binding (or the proposed global binding) for the receiver."

	^self subclassResponsibility!

binding: aVariableBindingOrNil
	binding := aVariableBindingOrNil!

documentation
	"Answer an <AXTypeLibDocumentation> object containing the documentation for this type."

	^self subclassResponsibility!

environment
	"Answer the namespace into which global's representing the receiver's types are/have been generated."

	^self class environment!

free
	"Release the receiver's type library pointer."

	tlbInterface free.
	tlbInterface := nil!

guid
	"Answer the a <GUID> which uniquely identifies the receiver."

	^self attributes guid!

helpfile
	"Answer the path to the receiver's help file."

	^self documentation helpfile!

helpstring
	"Answer the documentation string for the receiver, if any."

	^self documentation helpstring!

isHidden
	"Answer whether the receiver is describing a type which should
	not be displayed in type library browsers."

	^self attributes isHidden!

isNull
	"Answer whether the receiver is a null external data item
	(that is, a null pointer, or a nilled out structure)."

	^tlbInterface isNull!

isRestricted
	"Answer whether the receiver is describing a restricted type (i.e. one not
	intended to be used from macro/scripting languages).
	Applicable to all typekinds."

	^self attributes isRestricted!

name
	"Answer a <readableString> name for the receiver, retrieved from the
	documentation, but potentially with some mangling applied to generate
	a more sensible name (e.g. one more reminiscent of the original IDL)."

	^self basicName!

namespaceBinding
	^self binding environment binding!

newPool: aSymbol
	^self shouldNotImplement!

realize
	"Private - Load the receiver's COM interface from its owning type library."

	^self subclassResponsibility!

resolveExistingPool: aString
	"Private - Attempt to locate an existing constants pool which belongs to the receiver with the <readableString> name argument."

	| env |
	env := self environment.
	^(env localBindingFor: aString)
		ifNil: 
			[(VariableBinding key: aString value: nil)
				environment: env;
				yourself]!

suggestedGlobalName
	"Private - Answer a <readableString> name suggested as the (unprefixed) for a global
	generated to represent the receiver's type."

	^self name!

tlbInterface
	tlbInterface isNull ifTrue: [self realize].
	^tlbInterface!

variableName
	"Answer the name of the generated object which represents the receiver in Smalltalk.
	Implementation Note: If we haven't already got the globalName, then note that we
	don't store it down, but recalculate it each time. This is deliberate: Until we've
	actually generated the global object, we want to allow for changes in the values
	which feed into the name generation algorithm (e.g. the typelib prefix is
	changed)."

	^self binding key! !
!OS.COM.TypeInfoObject categoriesForMethods!
asParameter!converting!public! !
attributes!accessing!public! !
basicName!accessing!private! !
binding!accessing!private! !
binding:!accessing!private! !
documentation!accessing!public! !
environment!constants!public! !
free!public!realizing/unrealizing! !
guid!accessing!public! !
helpfile!accessing!public! !
helpstring!accessing!public! !
isHidden!public!testing! !
isNull!public!testing! !
isRestricted!public!testing! !
name!accessing!public! !
namespaceBinding!accessing!public! !
newPool:!accessing!private! !
realize!private!realizing/unrealizing! !
resolveExistingPool:!private! !
suggestedGlobalName!accessing!private! !
tlbInterface!accessing!private! !
variableName!accessing!public! !
!

