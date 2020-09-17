"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.MethodProtocol'
	instanceVariableNames: 'name comment selectors flags'
	classVariableNames: 'ANSIMask Protocols ReadOnlyMask StubAddedSignal'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.MethodProtocol guid: (Core.GUID fromString: '{87b4c503-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.MethodProtocol comment: 'MethodProtocol is a meta-information class which groups a set of selectors to form a cohesive unit of behavior which is independent of the class hierarchy. A class is said to conform to a MethodProtocol if it implements each of the selectors in the protocol, and if it claims to support the protocol, i.e. implementation of the set of selectors is a necessary but not sufficient condition because the implementation of the selectors must be as specified by the protocol. The precise semantics of the protocol are not formally specified by instances of this class, and cannot be tested by it, therefore if the programmer asserts that a class conforms to a protocol and it implements all the necessary selectors, that is deemed sufficient for conformance. A class automatically conforms to any protocols to which its superclasses conform.

If a method implementing a required protocol selector is removed from a class then the system automatically removes the protocol from the list supported by that class. Conversely if a protocol is extended by the addition of new selectors then this may result in the addition of stub method implementations to all conforming classes which do not currently respond to that selector. These stub methods raise an error when invoked and may be located by browsing the ''not yet implemented'' pseudo-category.

Conformance to a protocol may be tested a run-time by sending the message #conformsToProtocol: to the class. This is akin to send a #respondsTo: message to enquire whether a class understands an individual selector. By maintaining the protocol invariant that all conforming classes must respond to all a protocols selectors the system can perform a very fast conformance test (symbol lookup with in a set, chaining up the class hierarchy).

Each class (ClassDescription) stores a set of the symbolic names of the protocols to which it conforms, excluding those to which its superclasses conform. Testing for protocol conformance (using #conformsToProtocol:) is by symbolic name, and therefore it may be possible to strip the MethodProtocol objects themselves from a run-time application.

It is a good idea to keep protocols small, as this reduces the burden of implementation in a new class (you can quickly add a full set of stub methods in a class by dragging the protocol into the class, or by using the Add/Protocol command, in the Class Hierarchy Browser). You should also avoid extending the system defined protocols: Most of these are as defined by the ANSI Smalltalk Standard.

Instance Variables:
	name	<Symbol>		Unique symbolic name of the protocol (identity)
	comment	<String> or nil.	Description of the protocol (e.g. its specifiction)
	selectors	<IdentitySet>	The set of selectors required by the protocol
	flags	<integer>		Various boolean attributes of the protocol

Class Variables
	Protocols		<IdentityDictionary>	Maps protocol names to instances.
	StubAddedSignal	<NotificationSignal> Resumable signal raised when a stub method is generated.
	ReadOnlyMask	<integer> Masks read-only flag from flags instance variable
	ANSIMask	<integer> Masks ANSI flag from flags instance variable

'!
!Kernel.MethodProtocol categoriesForClass!System-Support! !
!Kernel.MethodProtocol methodsFor!

<= comperand
	"Answer whether the receiver is less than or equal to the <MethodProtocol>,
	comperand. This is to allow protocols to be sorted with the default sort block."

	^self name <= comperand name!

= comperand
	"Answer whether the receiver is considered equal to the <Object>, comperand."

	^self species == comperand species and: [self asSymbol == comperand asSymbol]!

addAllSelectors: newSelectors
	"Add the <collection> of <Symbol>s, newSelectors, to the set of method selectors 
	included in the receiver's protocol. Then ensure that the MethodProtocol invariants are
	maintained by ensuring that all conforming classes can understand the new selectors
	(by adding a dummy implementations if necessary), and that their implementing
	methods are recorded in the protocol."

	| extras |
	extras := newSelectors difference: selectors.
	extras notEmpty
		ifTrue: 
			["Record the additional selectors in the protocol"
			selectors addAll: extras.

			"Ensure all conforming classes implement the newly expanded protocols.
		 Note that it is very important that #behaviors orders superclasses before subclasses"
			self baseBehaviors do: 
					[:e |
					extras do: [:selector | self addClass: e selector: selector].
					"Ensure class marked as changed even if no stub methods added"
					e isChanged: true].

			"Finally inform any observers (browsers) of the change"
			Smalltalk trigger: #protocolUpdated: with: self]!

addClass: class
	"Add the <ClassDescription>, class, to the collection of classes associated with the receiver.
	Including a class in a protocol asserts that the class conforms to the protocol. In
	order to be sure that such is true, we generate default implementations for any
	messages the class does not currently implement."

	(class conformsToProtocol: self)
		ifFalse: 
			[self selectors do: [:s | self addClass: class selector: s].
			class addProtocol: self.

			"We don't need to mark the base classes as having been changed
		in this situation."
			Smalltalk trigger: #protocolUpdated: with: self]!

addClass: behavior selector: selector
	"Private - Add the <symbol>, selector, to the receiver's protocol in the <Behavior>, 
	behavior. i.e. ensure that the behavior can understand the selector by adding
	a dummy implementation if necessary."

	(behavior canUnderstand: selector) ifFalse: [
		self compileStub: selector into: behavior]!

addMethodSilently: method
	"Private - Add the <CompiledMethod>, method, to the collection of methods within 
	the receiver.  As this is a method protocol we must maintain the protocol invariant 
	that all claimed implementors must respond to all the selectors. If the protocol is
	extended by the addition of this method (i.e. its selector is a new one) this may involve
	compiling stub methods into conformant classes. Furthermore we must make sure that
	the class of the method implements the whole protocol."

	(selectors includes: method selector) ifFalse: [
		self addSelector: method selector].
	self addClass: method methodClass!

addProtocol: protocol
	"Add all the selectors in the <MethodProtocol>, protocol, to the set of method 
	selectors included in the receiver's protocol. Then ensure that the MethodProtocol
	invariants are maintained by ensuring that all conforming classes can understand
	the added selectors."

	protocol selectors do: [:each | self addSelector: each ].

	!

addSelector: selector
	"Add the <symbol>, selector, to the set of method selectors included
	in the receiver's protocol. Then ensure that the MethodProtocol invariants are
	maintained by ensuring that all conforming classes can understand the selector
	(by adding a dummy implementation if necessary), and that their implementing
	methods are recorded in the protocol."

	self addAllSelectors: {selector}!

ansi
	"Set the receiver to be marked as an ANSI standard protocol as defined in the American National
	Standard for Information Technology - Programming Languages - Smalltalk, ANSI NCITS 319-1998."

	^self isANSI: true!

asSymbol
	"Answer a <Symbol> which uniquely identifies the receiver."

	^name!

attributes
	"Answer a <collection> of the <Symbol>s specifying attributes of the receiver."

	| attr |
	attr := OrderedCollection new.
	self isANSI ifTrue: [attr addLast: #ansi].
	self isReadOnly ifTrue: [attr addLast: #readOnly].
	^attr!

attributes: attributes
	"Private - Set the attributes of the receiver to those named by the <Array> of <Symbol>s, attributes."

	self attributes asSet = attributes asSet
		ifFalse: 
			[flags := 0.
			attributes do: [:e | self perform: e]]!

baseBehaviors
	"Answer a <collection> of all the <ClassDescription> objects which
	directly conform to the receiver without inheriting such conformance
	from a superclass."

	| conformers |
	conformers := OrderedCollection new.
	Smalltalk allBehaviorsDo: [:c | (c protocolNames includes: name) ifTrue: [conformers add: c]].
	^conformers!

behaviors
	"Answer a <sequencedReadableCollection> of all the <ClassDescription> objects which conform
	to the receiver in class hierarchy order (i.e. superclasses first)."

	| answer |
	answer := OrderedCollection new: 10.
	Smalltalk allBehaviorsDo: [:c | (c conformsToProtocol: self) ifTrue: [answer addLast: c]].
	^answer!

comment
	"Answer a <readableString> describing the the receiver."

	^comment ?? ''!

comment: blah
	"Set the receiver's comment to the <readableString>, blah.
	If blah is empty (or nil) then stored comment is set to nil."

	comment := blah = '' ifFalse: [blah]!

compileStub: selector into: behavior
	"Private - Compile a target implementation method with the identified by the <symbol>,
	selector, into the <ClassDescription>, behavior."

	| target args sig |
	target := String smalltalkWriteStream: 128.
	args := selector argumentCount.
	args == 0
		ifTrue: [target nextPutAll: selector]
		ifFalse: 
			[(args == 1 and: [selector isInfix])
				ifTrue: 
					[target
						nextPutAll: selector;
						nextPutAll: ' operand']
				ifFalse: 
					[| keywords |
					keywords := selector keywords.
					(1 to: keywords size) do: 
							[:i |
							target
								nextPutAll: (keywords at: i);
								space;
								nextPutAll: 'arg';
								display: i]
						separatedBy: [target space]]].
	target
		crtab;
		nextPutAll: '"This is an auto-generated target implementation for the protocol <';
		nextPutAll: self asSymbol;
		nextPut: $>;
		crtab;
		nextPutAll: 'and remains to be correctly implemented."';
		cr;
		crtab;
		nextPutAll: '^Error notYetImplemented'.
	behavior compile: target contents.
	sig := self class stubAddedSignal.
	sig notNil
		ifTrue: 
			[target
				reset;
				nextPutAll: 'Protocol ';
				display: self;
				nextPutAll: ' added stub implementation of new message ';
				print: behavior;
				nextPutAll: '>>';
				print: selector.
			sig signal: target contents with: behavior]!

contents
	"Answer a <collection> of all methods classified under the receiver."

	| foundMethods |
	foundMethods := Set new.
	self behaviors do: [:aBehavior | foundMethods addAll: (self methodsInBehavior: aBehavior)].
	^foundMethods!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		nextPut: $<;
		nextPutAll: name;
		nextPut: $>!

hash
	"Answer the <integer> hash value for the receiver."

	^self asSymbol hash!

includesMethod: method
	"Answer whether the receiver includes the <CompiledMethod>, method,
	which it does if the methods selector is part of the protocol."

	^(method methodClass conformsToProtocol: self) 
		and: [self includesSelector: method selector]!

includesSelector: selector
	"Answer whether the receiver includes the selector represented by the 
	<Symbol>, selector."

	^selectors identityIncludes: selector!

initialize
	"Private - Initialize the receiver."

	selectors := IdentitySet new.
	flags := 0!

isANSI
	"Answer whether the receiver is an ANSI standard protocol."

	^flags allMask: ANSIMask!

isANSI: aBoolean
	"Set whether the receiver is an ANSI standard protocol.
	Note that all ANSI protocols are considered 'ReadOnly' too."

	| newFlags |
	newFlags := aBoolean 
		ifTrue: [flags maskSet: (ANSIMask bitOr: ReadOnlyMask)]
		ifFalse: [flags maskClear: ANSIMask].
	newFlags ~= flags ifTrue: [
		flags := newFlags.
		self protocolUpdated].
!

isReadOnly
	"Answer whether the receiver is a read-only protocol which should not be updated by the tools
	(this is not enforced here)."

	^flags allMask: ReadOnlyMask!

isReadOnly: aBoolean 
	"Set whether the receiver is a read-only protocol."

	self isReadOnly == aBoolean ifTrue: [^self].
	flags := flags mask: ReadOnlyMask set: aBoolean.
	aBoolean ifTrue: [selectors rehash].
	self protocolUpdated!

methodsInBehavior: class
	"Answer all the methods in the <ClassDescription>, class, which are members of the receiver."

	^(class conformsToProtocol: self)
		ifTrue: [class methodDictionary select: [:m | self includesSelector: m selector]]
		ifFalse: [Set new]!

name
	"Answer the unique <readableString> name for the receiver."

	^name!

printOn: aStream
	"Append a representation of the receiver to aStream."

	aStream 
		basicPrint: self;
		display: self!

protocolUpdated
	"Private - Flag the receiver as updated and inform any observers."

	Smalltalk trigger: #protocolUpdated: with: self.
	self updateBaseClasses!

readOnly
	"Set the receiver to be a read-only protocol (i.e. one which has a fixed set of selectors.
	This is not enforced by the #addSelector:, etc, methods of this class, but is expected
	to be respected by the tools."

	^self isReadOnly: true!

removeAllSelectors: selectorsToRemove
	"Remove the <collection> of <symbol>s, selectors, from the set of method selectors included
	in the receiver's protocol. The absence of any of the selectors is ignored. Answer the argument."

	| missing |
	missing := IdentitySet new.
	selectorsToRemove do: [:s | selectors remove: s ifAbsent: [missing add: s]].
	selectorsToRemove size > missing size ifTrue: [self protocolUpdated].
	^selectorsToRemove!

removeClass: class
	"Remove the <ClassDescription>, class, from the classes 'held' by the receiver.
	In the case of a protocol we must remove the protocol from the classes set of
	implemented protocols - note that we cannot do that if the protocol is inherited."

	class removeProtocol: self.
	self protocolUpdated!

removeSelector: selector
	"Remove the <symbol>, selector, from the set of method selectors included
	in the receiver's protocol."

	^self removeSelector: selector ifAbsent: [self errorNotFound: selector]!

removeSelector: selector ifAbsent: exceptionHandler
	"Remove the <symbol>, selector, from the set of method selectors included
	in the receiver's protocol."

	| answer |
	answer := selectors remove: selector ifAbsent: [^exceptionHandler value].
	self protocolUpdated.
	^answer!

rename: newName
	"Rename the protocol to have the new symbolic name, newName.
	N.B. This is not recommended, as there may be symbolic references to the old name."

	| implementors sym |
	implementors := self baseBehaviors.
	sym := newName asSymbol.
	(Protocols includesKey: sym) ifTrue: [self error: 'Duplicate protocol name'].
	implementors do: [:i | i removeProtocol: self].
	Protocols
		removeKey: name;
		at: sym put: self.
	name := sym.
	implementors do: 
			[:i |
			i
				addProtocol: self;
				isChanged: true].
	Smalltalk trigger: #protocolUpdated: with: self!

selectors
	"Answer a <collection> of the selectors which make up the receiver's protocol."

	^selectors!

setName: stem
	"Private - Set the name of the receiver to the <Symbol> equivalent 
	of the <readableString>, stem."

	name := stem asSymbol.
	self initialize!

updateBaseClasses
	"Private - The receiver has changed in such a way that it's
	base classes need to be marked as having been changed."

	self baseBehaviors do: [:each | each isChanged: true]
! !
!Kernel.MethodProtocol categoriesFor: #<=!comparing!public! !
!Kernel.MethodProtocol categoriesFor: #=!comparing!public! !
!Kernel.MethodProtocol categoriesFor: #addAllSelectors:!adding!public! !
!Kernel.MethodProtocol categoriesFor: #addClass:!adding!public! !
!Kernel.MethodProtocol categoriesFor: #addClass:selector:!adding!private! !
!Kernel.MethodProtocol categoriesFor: #addMethodSilently:!adding!private! !
!Kernel.MethodProtocol categoriesFor: #addProtocol:!adding!public! !
!Kernel.MethodProtocol categoriesFor: #addSelector:!adding!public! !
!Kernel.MethodProtocol categoriesFor: #ansi!modes!public! !
!Kernel.MethodProtocol categoriesFor: #asSymbol!converting!public! !
!Kernel.MethodProtocol categoriesFor: #attributes!accessing!public! !
!Kernel.MethodProtocol categoriesFor: #attributes:!accessing!private! !
!Kernel.MethodProtocol categoriesFor: #baseBehaviors!accessing!public! !
!Kernel.MethodProtocol categoriesFor: #behaviors!accessing!public! !
!Kernel.MethodProtocol categoriesFor: #comment!accessing!public! !
!Kernel.MethodProtocol categoriesFor: #comment:!accessing!public! !
!Kernel.MethodProtocol categoriesFor: #compileStub:into:!adding!private! !
!Kernel.MethodProtocol categoriesFor: #contents!enumerating!public! !
!Kernel.MethodProtocol categoriesFor: #displayOn:!displaying!public! !
!Kernel.MethodProtocol categoriesFor: #hash!comparing!public! !
!Kernel.MethodProtocol categoriesFor: #includesMethod:!public!testing! !
!Kernel.MethodProtocol categoriesFor: #includesSelector:!public!testing! !
!Kernel.MethodProtocol categoriesFor: #initialize!initializing!private! !
!Kernel.MethodProtocol categoriesFor: #isANSI!public!testing! !
!Kernel.MethodProtocol categoriesFor: #isANSI:!modes!public! !
!Kernel.MethodProtocol categoriesFor: #isReadOnly!public!testing! !
!Kernel.MethodProtocol categoriesFor: #isReadOnly:!modes!public! !
!Kernel.MethodProtocol categoriesFor: #methodsInBehavior:!enumerating!public! !
!Kernel.MethodProtocol categoriesFor: #name!accessing!public! !
!Kernel.MethodProtocol categoriesFor: #printOn:!printing!public! !
!Kernel.MethodProtocol categoriesFor: #protocolUpdated!private!updating! !
!Kernel.MethodProtocol categoriesFor: #readOnly!modes!public! !
!Kernel.MethodProtocol categoriesFor: #removeAllSelectors:!public!removing! !
!Kernel.MethodProtocol categoriesFor: #removeClass:!public!removing! !
!Kernel.MethodProtocol categoriesFor: #removeSelector:!public!removing! !
!Kernel.MethodProtocol categoriesFor: #removeSelector:ifAbsent:!public!removing! !
!Kernel.MethodProtocol categoriesFor: #rename:!operations!public! !
!Kernel.MethodProtocol categoriesFor: #selectors!accessing!public! !
!Kernel.MethodProtocol categoriesFor: #setName:!accessing!private! !
!Kernel.MethodProtocol categoriesFor: #updateBaseClasses!private!updating! !

!Kernel.MethodProtocol class methodsFor!

allMethodProtocols
	"Answer the a <collection> of all <MethodProtocols>s current registered in the system.
		MethodProtocol allMethodProtocols size
	"

	^Protocols asArray!

existing: protocolName
	"Answer an existing <MethodProtocol> with the specified
	<Symbol> name, protocolName. Signals a NotFound exception
	if protocolName does not specify an existing protocol."

	^Protocols at: protocolName asSymbol.!

exists: protocolName
	"Answer whether the named protocol exists."

	^Protocols includesKey: protocolName asSymbol!

initialize
	"Private - Initialize the receiver's class variables.
		MethodProtocol initialize
	"

	StubAddedSignal := NotificationSignal description: '%1'.
	Protocols isNil ifTrue: [self initializeProtocols].
	ReadOnlyMask := 1.
	ANSIMask := 2!

initializeProtocols
	"Private - Discard all existing protocols."

	Protocols := IdentityDictionary new!

name: protocolName
	"Answer a new or existing <MethodProtocol> with the specified
	<Symbol> name, protocolName."

	| symbol |
	symbol := protocolName asSymbol.
	^Protocols at: symbol ifAbsentPutClean: [self basicNew setName: symbol; yourself]!

new
	"MethodProtocols must be unique for any particular name, and must be instantiated with the #name:
	method."

	^self shouldNotImplement!

purgeUnused
	"Discard all method protocols which are not currently implemented by any class in the system.
	This might take a while.
		MethodProtocol purgeUnused
	"

	| allUsed |
	allUsed := IdentitySet new.
	Smalltalk allBehaviorsDo: [:c | allUsed addAll: c protocols].
	(Protocols difference: allUsed) do: 
			[:p |
			self assert: [p behaviors isEmpty].
			Protocols removeKey: p name]!

removeProtocol: protocolName
	"Remove the <MethodProtocol>, named by the <symbol>, protocolName, from the system."

	| symbol prot |
	symbol := protocolName asSymbol.
	prot := Protocols at: symbol.
	prot baseBehaviors do: [:c | c removeProtocol: prot].
	Protocols removeKey: symbol.
	Smalltalk trigger: #protocolRemoved: with: prot!

separator
	"Private - Answer a Character used to split the individual names in a
	complete category."

	^ $-!

stubAddedSignal
	"Private - Answer the signal which is raised when a stub method is added
	automatically in order to keep a class' protocol implementation complete."

	^StubAddedSignal! !
!Kernel.MethodProtocol class categoriesFor: #allMethodProtocols!accessing!public! !
!Kernel.MethodProtocol class categoriesFor: #existing:!instance creation!public! !
!Kernel.MethodProtocol class categoriesFor: #exists:!public!testing! !
!Kernel.MethodProtocol class categoriesFor: #initialize!development!initializing!private! !
!Kernel.MethodProtocol class categoriesFor: #initializeProtocols!initializing!private! !
!Kernel.MethodProtocol class categoriesFor: #name:!instance creation!public! !
!Kernel.MethodProtocol class categoriesFor: #new!instance creation!public! !
!Kernel.MethodProtocol class categoriesFor: #purgeUnused!operations!public! !
!Kernel.MethodProtocol class categoriesFor: #removeProtocol:!public!removing! !
!Kernel.MethodProtocol class categoriesFor: #separator!constants!private! !
!Kernel.MethodProtocol class categoriesFor: #stubAddedSignal!accessing!private! !

