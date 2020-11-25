"Filed out from Dolphin Smalltalk 7"!

AXTypeInfoStructure subclass: #AXMemberDesc
	instanceVariableNames: 'index customAttributes documentation'
	classVariableNames: ''
	poolDictionaries: 'AXAutomationConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
AXMemberDesc guid: (GUID fromString: '{ac5eb94d-60c1-4c16-ae6d-31acf5123eb6}')!
AXMemberDesc isAbstract: true!
AXMemberDesc comment: ''!
!AXMemberDesc categoriesForClass!External-Data-Structured-COM! !
!AXMemberDesc methodsFor!

= comperand
	"Answer whether the receiver is considered equal to the <Object>, comperand."

	^self species == comperand species
		and: [self memid = comperand memid]!

argumentCount
	"Answer the number of parameters to the function described by the receiver.
	Note that this count includes any optional parameters."

	^self cParams!

arguments
	"Answer a <sequencedReadableCollection> containing <ELEMDESC> structures
	describing each of the receiver's parameters."

	^self subclassResponsibility!

argumentTypeNames
	"Answer a <sequencedReadableCollection> containing the type names of
	each of the receiver's parameters.
	N.B. This may cause a large number of classes to be automatically generated!!"

	^self arguments collect: [:e | e typeName]!

basicFree
	customAttributes isNull
		ifFalse: 
			[customAttributes free.
			customAttributes := nil].
	^super basicFree!

basicIdlAttributes
	"Private - Answer a <sequencedReadableCollection> of the string names
	of the various IDL flags assocated with the receiver."

	| answer |
	answer := OrderedCollection new.
	self isBindable ifTrue: [answer add: 'bindable'].
	self isDefaultBind ifTrue: [answer add: 'defaultbind'].
	self isDisplayBind ifTrue: [answer add: 'displaybind'].
	self isHidden ifTrue: [answer add: 'hidden'].
	self isNonBrowsable ifTrue: [answer add: 'nonbrowsable'].
	self isRestricted ifTrue: [answer add: 'restricted'].
	self isRequestEdit ifTrue: [answer add: 'requestedit'].
	self isUIDefault ifTrue: [answer add: 'uidefault'].
	^answer!

classDesc
	"Private - Answer an <Association> between a Dolphin class suitable for representing
	the external type described by the receiver, and the number of indirections
	to the type."

	^self tdesc classDesc!

cParams
	"Private - Answer the number of parameters to the function described by the receiver.
	Implementation Note: Where the receiver describes a variable (property)
	so we are cheating a bit here, however by expanding the common protocol with
	FUNCDESC, we can unify the type-library auto generation code for property
	get/put methods and properties."

	^0!

customAttributes
	"Answer the collection of custom attributes defined on the member. This is a lookup table
	mapping <GUID> attribute id to the attribute value, usally a string."

	^(customAttributes ifNil: [customAttributes := self getAllCustData]) contents!

documentation
	"Answer a four element array containing the documentation for the receiver itself.
	See #documentationAt: for more details."

	documentation isNil ifTrue: [documentation := analyzer documentationForMember: self memid].
	^documentation!

elemDesc
	"Private - Answer an <ELEMDESC> describing the receiver's type."

	^self subclassResponsibility!

flags
	^self subclassResponsibility!

getAllCustData
	^self subclassResponsibility!

hash
	"Answer <integer> hash value for the receiver."

	^self memid hash!

helpstring
	"Answer the documentation string for the receiver, if any."

	^self documentation helpstring!

idlId
	"Private - Answer an IDL-style id attribute description for the receiver."

	^'id(%#010x)' sprintfWith: self memid!

index
	"Private - Answer the receiver's zero-based integer function or variable index within its owning type."

	^index!

isBindable
	"Answer whether the receiver is describing a 'bindable' property."

	"Implementation Note: FUNCFLAG_FBINDABLE and VARFLAG_FBINDABLE have the same value."

	^self flags allMask: FUNCFLAG_FBINDABLE!

isDefaultBind
	"Answer whether the receiver is describing a 'defaultbind' property (i.e. the single, bindable
	property that best describes the object)."

	"Implementation Note: FUNCFLAG_FDEFAULTBIND and VARFLAG_FDEFAULTBIND have the same value."

	^self flags allMask: FUNCFLAG_FDEFAULTBIND!

isDisplayBind
	"Answer whether the receiver is describing a 'displaybind' property (i.e. a property that
	should be displayed to the user as bindable)."

	"Implementation Note: FUNCFLAG_FDISPLAYBIND and VARFLAG_FDISPLAYBIND have the same value."

	^self flags allMask: FUNCFLAG_FDISPLAYBIND!

isHidden
	"Answer whether the receiver is describing a hidden function or variable (i.e. one not
	intended to be advertised to users of macro/scripting languages)."

	"Implementation Note: FUNCFLAG_FHIDDEN and VARFLAG_FHIDDEN have the same value."

	^self flags allMask: FUNCFLAG_FHIDDEN!

isNonBrowsable
	"Answer whether the receiver is describing a 'non-browsable' property. Oddly this doesn't
	mean that the method should not be displayed in type library browsers, but that it shouldn't
	be shown in inspectors."

	"Implementation Note: FUNCFLAG_FNONBROWSABLE and VARFLAG_FNONBROWSABLE have the same value."

	^self flags anyMask: FUNCFLAG_FNONBROWSABLE!

isReadOnly
	"Answer whether this object describes a read-only member."

	^true!

isRequestEdit
	"Answer whether the receiver is describing a 'requestedit' property (i.e. one that causes a
	call to IPropertyNotifySink::OnRequestEdit when one attemps to change its value)."

	^self subclassResponsibility!

isRestricted
	"Answer whether the receiver is describing a restricted function (i.e. one not
	intended to be used from macro/scripting languages)."

	^self subclassResponsibility!

isSource
	"Answer whether the receiver is describing a function that returns an object, or 
	a variable that holds an object, that is a source of events."

	"Implementation Note: FUNCFLAG_FSOURCE and VARFLAG_FSOURCE have the same value."

	^self flags allMask: FUNCFLAG_FSOURCE!

isUIDefault
	"Answer whether the receiver is describing the default member for display in the UI."

	"Implementation Note: FUNCFLAG_UIDEFAULT and VARFLAG_UIDEFAULT have the same value."

	^self flags allMask: FUNCFLAG_FUIDEFAULT!

isValueProperty
	"Answer whether the receiver describes a method for getting or setting the default 
	(DISPID_VALUE) property."

	^self memid == DISPID_VALUE!

memid
	"Answer the receiver's memid field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

name
	"Answer the name of the variable described by the receiver."

	^self documentation name!

setAnalyzer: anAXTypeInfoAnalyzer index: anInteger
	analyzer := anAXTypeInfoAnalyzer.
	index := anInteger!

tdesc
	"Private - Answer a TYPEDESC describing the type of the receiver. For a function this is the
	return type, for a variable the type of the variable. N.B. The return type of a function is
	the type of the argument marked with the 'retval' attribute in the IDL, or, if there is no
	retval argument, the return type of the function (usually HRESULT)."

	^self elemDesc tdesc! !
!AXMemberDesc categoriesFor: #=!comparing!public! !
!AXMemberDesc categoriesFor: #argumentCount!accessing!public! !
!AXMemberDesc categoriesFor: #arguments!accessing!public! !
!AXMemberDesc categoriesFor: #argumentTypeNames!accessing!public! !
!AXMemberDesc categoriesFor: #basicFree!private!realizing/unrealizing! !
!AXMemberDesc categoriesFor: #basicIdlAttributes!printing-IDL!private! !
!AXMemberDesc categoriesFor: #classDesc!accessing!private! !
!AXMemberDesc categoriesFor: #cParams!accessing!private! !
!AXMemberDesc categoriesFor: #customAttributes!accessing!public! !
!AXMemberDesc categoriesFor: #documentation!accessing!public! !
!AXMemberDesc categoriesFor: #elemDesc!accessing!private! !
!AXMemberDesc categoriesFor: #flags!accessing!private! !
!AXMemberDesc categoriesFor: #getAllCustData!accessing!private! !
!AXMemberDesc categoriesFor: #hash!comparing!public! !
!AXMemberDesc categoriesFor: #helpstring!accessing!public! !
!AXMemberDesc categoriesFor: #idlId!printing-IDL!private! !
!AXMemberDesc categoriesFor: #index!accessing!private! !
!AXMemberDesc categoriesFor: #isBindable!public!testing! !
!AXMemberDesc categoriesFor: #isDefaultBind!public!testing! !
!AXMemberDesc categoriesFor: #isDisplayBind!public!testing! !
!AXMemberDesc categoriesFor: #isHidden!public!testing! !
!AXMemberDesc categoriesFor: #isNonBrowsable!public!testing! !
!AXMemberDesc categoriesFor: #isReadOnly!public!testing! !
!AXMemberDesc categoriesFor: #isRequestEdit!public!testing! !
!AXMemberDesc categoriesFor: #isRestricted!public!testing! !
!AXMemberDesc categoriesFor: #isSource!public!testing! !
!AXMemberDesc categoriesFor: #isUIDefault!public!testing! !
!AXMemberDesc categoriesFor: #isValueProperty!public!testing! !
!AXMemberDesc categoriesFor: #memid!accessing!public! !
!AXMemberDesc categoriesFor: #name!accessing!public! !
!AXMemberDesc categoriesFor: #setAnalyzer:index:!accessing!initializing!private! !
!AXMemberDesc categoriesFor: #tdesc!accessing!private! !

