"Filed out from Dolphin Smalltalk 7"!

Object subclass: #GeneralBindingReference
	instanceVariableNames: 'path'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GeneralBindingReference guid: (GUID fromString: '{2d52489e-7275-4df4-9022-294a7b2f9381}')!
GeneralBindingReference isAbstract: true!
GeneralBindingReference comment: 'Abstract superclass of binding references.'!
!GeneralBindingReference categoriesForClass!System-Namespaces! !
!GeneralBindingReference methodsFor!

= anObject
	"Answer whether the receiver and the <Object> argument should be considered equivalent (in this case that they are a reference to the same variable binding)."

	^self species == anObject species and: [self path = anObject path and: [self home = anObject home]]!

asQualifiedReference
	"Answer the <BindingReference> equivalent of the receiver."

	^self!

asString
	"Answer a <readableString> that expresses the receiver as a qualified name in the context of the home namespace."

	| strm |
	strm := String writeStream.
	self displayOn: strm.
	^strm contents!

asSymbol
	"Answer the <symbol> corresponding to the receiver's fully-qualified name."

	^self asString asSymbol!

binding
	"Answer the <VariableBinding> referenced by the receiver (i.e. resolve the variable)."

	^self bindingOrNil ifNil: [NotFoundError signalWith: self]!

bindingOrNil
	"Answer the <VariableBinding> referenced by the receiver (i.e. resolve the variable), or nil if there is no such variable."

	^(self home resolveBindingPath: path) ifNotNil: [:binding | binding targetVariable]!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it (the qualified name)."

	#todo.	"Forward to the home namespace to print complete qualified name"
	path do: [:each | aStream nextPutAll: each] separatedBy: [aStream nextPut: $.]!

hash
	"Answer the <integer> hash value for the receiver."

	| size hash |
	"Hash only the path, as the home is usually Smalltalk"
	size := path size.
	size == 0 ifTrue: [^17171].
	hash := (path at: 1) hash.
	2 to: path size do: [:i | hash := hash hashMultiply + (path at: i) hash].
	^hash!

home
	"Answer the home <Namespace> to which this binding reference is relative."

	^Smalltalk!

ifDefined: aMonadicValuable
	"If the receiver is defined (see #isDefined), then evaluate the <monadicValuable> argument with the value of the resolved variable.
	Answer the result of the evaluation, or nil if the binding is undefined."

	^self bindingOrNil ifNotNil: [:binding | aMonadicValuable value: binding value]!

ifDefined: aMonadicValuable ifNotDefined: aNiladicValuable
	"Answer the result of evaluating either the <monadicValuable> argument, if the receiver is defined (see #isDefined), with the value of the resolved variable, or the result of evaluating the <niladicValuable> argument if the receiver is not defined."

	^self bindingOrNil
		ifNil: [aNiladicValuable value]
		ifNotNil: [:binding | aMonadicValuable value: binding value]!

ifDefinedDo: aMonadicValuable
	"Ugly selector, but for compatibility. Prefer #ifDefined:"

	^self ifDefined: aMonadicValuable!

ifDefinedDo: aMonadicValuable elseDo: aNiladicValuable
	"Ugly selector, but for compatibility. Prefer #ifDefined:ifNotDefined:"

	^self ifDefined: aMonadicValuable ifNotDefined: aNiladicValuable!

isDefined
	"Answer whether the receiver refers to a defined variable."

	^self bindingOrNil notNil!

isPrivate
	"Answer whether the receiver represents a private binding reference that should not be used outside its immediate scope."

	^false!

isWildcard
	"Answer whether the receiver represents a wildcard reference to match all the names in a namespace."

	^false!

path
	"Answer a <sequencedReadableCollection> of <String>, being the component parts of the qualified name in order from the home namespace."

	^path!

path: anArray
	path := anArray!

printOn: aStream
	"Append a text to the <puttableStream> argument representing the receiver in the textual form a developer would want (i.e. as a literal qualified reference)."

	aStream
		nextPutAll: '#{';
		display: self;
		nextPut: $}!

simpleName
	"Answer the unqualified name part of the receiver (the final component of the name)."

	^path last!

storeOn: aStream
	"This should probably store the full path."

	self printOn: aStream!

value
	"Answer the value of the variable named by the receiver. Raise an error if the variable is not defined."

	^self binding value!

valueOrNil
	"Answer the value of the variable named by the receiver, or nil if not defined.
	Note that it will not be possible to define the cases of an undefined variable and a defined variable with value nil."

	^self bindingOrNil ifNotNil: [:binding | binding value]! !
!GeneralBindingReference categoriesFor: #=!comparing!public! !
!GeneralBindingReference categoriesFor: #asQualifiedReference!converting!public! !
!GeneralBindingReference categoriesFor: #asString!converting!public! !
!GeneralBindingReference categoriesFor: #asSymbol!converting!public! !
!GeneralBindingReference categoriesFor: #binding!accessing!public! !
!GeneralBindingReference categoriesFor: #bindingOrNil!accessing!public! !
!GeneralBindingReference categoriesFor: #displayOn:!displaying!public! !
!GeneralBindingReference categoriesFor: #hash!comparing!public! !
!GeneralBindingReference categoriesFor: #home!accessing!public! !
!GeneralBindingReference categoriesFor: #ifDefined:!evaluating!public! !
!GeneralBindingReference categoriesFor: #ifDefined:ifNotDefined:!evaluating!public! !
!GeneralBindingReference categoriesFor: #ifDefinedDo:!evaluating!public! !
!GeneralBindingReference categoriesFor: #ifDefinedDo:elseDo:!evaluating!public! !
!GeneralBindingReference categoriesFor: #isDefined!public!testing! !
!GeneralBindingReference categoriesFor: #isPrivate!public!testing! !
!GeneralBindingReference categoriesFor: #isWildcard!public!testing! !
!GeneralBindingReference categoriesFor: #path!accessing!public! !
!GeneralBindingReference categoriesFor: #path:!initializing!private! !
!GeneralBindingReference categoriesFor: #printOn:!printing!public! !
!GeneralBindingReference categoriesFor: #simpleName!accessing!public! !
!GeneralBindingReference categoriesFor: #storeOn:!public!storing! !
!GeneralBindingReference categoriesFor: #value!accessing!public! !
!GeneralBindingReference categoriesFor: #valueOrNil!accessing!public! !

!GeneralBindingReference class methodsFor!

errorInvalidIdentifier: aString
	^self error: ('Invalid identifier: ''<s>''' expandMacrosWith: aString)!

internQualifiers: aSequencedReadableCollection
	"Private - Convert the argument to an <Array> of <Symbol>, validating that each qualifier (i.e. not including the last part) is valid as part of a static variable name."

	| size path |
	size := aSequencedReadableCollection size.
	size == 0 ifTrue: [^#()].
	path := Array writeStream: size.
	aSequencedReadableCollection
		from: 1
		to: size - 1
		do: 
			[:each |
			(self isValidUnqualifiedName: each) ifFalse: [^self errorInvalidIdentifier: each].
			path nextPut: each asSymbol].
	path nextPut: (aSequencedReadableCollection at: size) asSymbol.
	^path collection!

isQualifiedName: aString
	"Answer whether the argument is probably a qualified name (as opposed to an unqualified, or simple, name)."

	^(aString
		nextIdentityIndexOf: $.
		from: 1
		to: aString size) ~~ 0!

isValidQualifiedName: aString
	"Answer whether the argument is a valid static variable name, qualified or unqualified."

	^(self isQualifiedName: aString)
		ifTrue: [(self splitQualifiedName: aString) allSatisfy: [:each | self isValidUnqualifiedName: each]]
		ifFalse: [self isValidUnqualifiedName: aString]!

isValidUnqualifiedName: aString
	| size |
	size := aString size.
	^size ~~ 0 and: 
			[| first |
			first := aString at: 1.
			"We allow identifiers to start with underscores or any letter. We don't insist on uppercase letters as this is a convention, not a syntax restriction."
			((first == $_ and: [size > 1]) or: [first isLetter])
				and: [aString allSatisfy: [:each | each isAlphaNumeric or: [each == $_]]]]!

path: aSequencedReadableCollection
	"Answer a new instance of the receiver representing the qualified name composed of the <readableString> elements of the argument."

	| path depth |
	path := self internQualifiers: aSequencedReadableCollection.
	depth := path size.
	^depth == 0
		ifTrue: [self basicNew path: #()]
		ifFalse: 
			[| last |
			last := path last.
			(self isValidUnqualifiedName: last)
				ifTrue: 
					[self basicNew
						path: ((depth > 1 and: [path first = 'Smalltalk'])
									ifTrue: [path copyFrom: 2 to: depth]
									ifFalse: [path]);
						yourself]
				ifFalse: [self errorInvalidIdentifier: last]]!

pathString: aString
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument."

	^self path: (self splitQualifiedName: aString)!

simpleName: aString
	"Answer a new instance of the receiver representing the variable with the specified unqualified name."

	^self path: {aString}!

splitQualifiedName: aString
	^aString subStrings: $.! !
!GeneralBindingReference class categoriesFor: #errorInvalidIdentifier:!exceptions!private! !
!GeneralBindingReference class categoriesFor: #internQualifiers:!helpers!private! !
!GeneralBindingReference class categoriesFor: #isQualifiedName:!enquiries!public! !
!GeneralBindingReference class categoriesFor: #isValidQualifiedName:!enquiries!public! !
!GeneralBindingReference class categoriesFor: #isValidUnqualifiedName:!enquiries!public! !
!GeneralBindingReference class categoriesFor: #path:!instance creation!public! !
!GeneralBindingReference class categoriesFor: #pathString:!instance creation!public! !
!GeneralBindingReference class categoriesFor: #simpleName:!instance creation!public! !
!GeneralBindingReference class categoriesFor: #splitQualifiedName:!helpers!public! !

