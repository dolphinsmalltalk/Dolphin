"Filed out from Dolphin Smalltalk 7"!

Object subclass: #MethodSpy
	instanceVariableNames: 'spySource methodSourceInterval spySourceInterval activations isLocallyEnabled method context'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodSpy guid: (GUID fromString: '{F9497940-1EEE-11D6-87E4-0010A70883E2}')!
MethodSpy comment: ''!
!MethodSpy categoriesForClass!Unclassified! !
!MethodSpy methodsFor!

<= anSSWSpypoint

	"© 2002 Solutions Software

	Always order by source position"

	^self methodSourcePosition <= anSSWSpypoint methodSourcePosition!

activated

	"© 2002 Solutions Software"

	self activations addLast: Dictionary new!

activationContext

	"Return the context for the current activation"

	^self activations last
!

activationCount

	"Return the number of activations since the last reset"

	^self activations size
!

activations

	"activations stores an OrderedCollection of Dictionaries, 
	providing an individual context for each activation of the receiver"

	^activations
!

activations: anOrderedCollection

	"activations stores an OrderedCollection of Dictionaries, 
	providing an individual context for each activation of the receiver"

	activations := anOrderedCollection
!

at: aKey

	"© 2002 Solutions Software

	Forward to the context"

	^self context at: aKey!

at: aKey put: aValue

	"© 2002 Solutions Software

	Forward to the context"

	^self context at: aKey put: aValue!

context

	"© 2002 Solutions Software

	context stores a Dictionary for arbitary storage by the spySource code.
	This provides the 'context' for a Spy, allowing information to persist across activations.

	The context is generally accessed by sending at: and at:put: directly to the receiver"

	^context!

context: aDictionary

	"© 2002 Solutions Software

	context stores a Dictionary for arbitary storage by the spySource code.
	This provides the 'context' for a Spy, allowing information to persist across activations.

	The context is generally accessed by sending at: and at:put: directly to the receiver"

	context := aDictionary!

handle

	self isEnabled ifTrue:
		[| process frame tempPool expression |
		self activated. 
		process := Processor activeProcess. 
		frame := process topFrame sender.
		tempPool := PoolDictionary new.
		frame temps do: 
			[ :triplet || index |
			index := triplet third.
			index > 0 ifTrue: 
				[tempPool at: triplet first put: ((frame getOuter: triplet second) at: index)]]. 
		tempPool 
			at: 'thisSpy' put: self;
			at: '_activeProcess' put: process.

		expression := Compiler 
			compileForEvaluation: 
('"Method Spy Activate:"
_activeProcess spy. 

"Method Spy Code:"
', self spySource)
			in: frame receiver class
			evaluationPools: (Array with: tempPool)
			logged: false
			flags: 0. 
		expression method 
			isImmutable: false;
			selector: 'spyIt';
			value: frame receiver withArguments: #()]
!

isEnabled

	"Return a Boolean indicating whether this spy is enabled:
	 - to be enabled, a spy must be locally enabled, plus spies must be enabled globally"

	^self isLocallyEnabled and: [self spyManager areSpiesEnabled]!

isExisting

	"Does this spy exist in its method?"

	^self method isSpy and: [self method methodSpies identityIncludes: self]!

isLocallyEnabled

	"© 2002 Solutions Software

	isLocallyEnabled stores a Boolean indicating whether this particular spy is enabled
	(c.f. isEnabled)"

	^isLocallyEnabled!

isLocallyEnabled: aBoolean

	"© 2002 Solutions Software

	isLocallyEnabled stores a Boolean indicating whether this particular spy is enabled
	(c.f. isEnabled)"

	isLocallyEnabled := aBoolean
!

isSimpleHalt

	^self spySource = self class simpleHaltSource!

isVirgin

	"© 2002 Solutions Software

	Has this spy been activated previously?"

	^self activationCount <= 1!

method

	"method stores the CompiledMethod which the receiver spies on"

	^method!

method: aCompiledMethod

	"method stores the CompiledMethod which the receiver spies on"

	method := aCompiledMethod!

methodSourceInterval

	"© 2002 Solutions Software

	methodSourceInterval stores the Interval range within which the receiver's 
	spySource 'exists' in the host CompiledMethod's sourceString.

	The significant factor is the start of this Interval; the length is purely for IDE use"

	^methodSourceInterval!

methodSourceInterval: anInterval

	"© 2002 Solutions Software

	methodSourceInterval stores the Interval range within which the receiver's 
	spySource 'exists' in the host CompiledMethod's sourceString.

	The significant factor is the start of this Interval; the length is purely for IDE use"

	methodSourceInterval := anInterval!

methodSourcePosition

	"© 2002 Solutions Software"

	^self methodSourceInterval start!

parseTree

	^SmalltalkParser parseExpression: self spySource in: self method methodClass!

publishedAspects

	^super publishedAspects"
		add: 
			(Aspect name: #spySource 
					presenterBlock: 
						(MessageSend 
							receiver: TextPresenter 
							selector: #create:in:on:
							arguments: #('Static text' nil nil)) 
					editBlock: 
						(MessageSend
							receiver: self
							selector: #editAndRecompileIn:
							arguments: #(nil)));
		yourself"!

reset

	"© 2002 Solutions Software"

	self 
		activations: OrderedCollection new;
		isLocallyEnabled: true;
		context: Dictionary new!

scintillaIndicator: anInteger

	^ScintillaIndicator
		styleName: (self isLocallyEnabled ifTrue: [#SpyEnabled] ifFalse: [#SpyDisabled])
		range: (self methodSourceInterval + anInteger)
		tag: self sourceTip!

sourceTip

	^(self spySource, '

Activations: ', self activationCount displayString) reject: [ :e | e = Character cr]!

spyManager
	^MethodSpyManager current!

spySource

	"© 2002 Solutions Software

	spySource stores the source code String which forms this spypoint"

	^spySource!

spySource: aString

	"© 2002 Solutions Software

	spySource stores the source code String which forms this spypoint"

	spySource := aString!

spySourceAt: aPosition spyCount: anInteger

	"© 2002 Solutions Software"

	| stream countName source |

	countName := '#thisSpy', anInteger printString.

	stream := WriteStream on: (String new: spySource size).

	stream 
		nextPutAll: countName;
		nextPutAll: ' handle. '.

	source := stream contents.

	self spySourceInterval: (aPosition to: (aPosition + (source size - 1))).

	^source
!

spySourceForTest

	"Return the receiver's source code in a format which can be tested for compilation failures"

	| tree stream countName source |

	tree := [SmalltalkParser parseExpression: spySource] on: Error do: [ :exc | exc return: nil].

	"Unspecified problem; return a value which will throw an appropriate compilation error"
	tree isNil ifTrue: [^'<error>'].

	"Rename the thisSpy pseudo special symbol so code will compile"
	(ParseTreeRewriter rename: 'thisSpy' to: '#thisSpy') executeTree: tree.

	^tree formattedCode!

spySourceInterval

	"© 2002 Solutions Software

	spySourceInterval stores the Interval range of the receiver's spySource
	when the full source (including all spies) of the associated SSWSpyMethod is displayed"

	^spySourceInterval!

spySourceInterval: anInterval

	"© 2002 Solutions Software

	spySourceInterval stores the Interval range of the receiver's spySource
	when the full source (including all spies) of the associated SSWSpyMethod is displayed"

	spySourceInterval := anInterval!

toggleLocallyEnabled

	self isLocallyEnabled: (self isLocallyEnabled not)! !
!MethodSpy categoriesFor: #<=!comparing!public! !
!MethodSpy categoriesFor: #activated!actions!public! !
!MethodSpy categoriesFor: #activationContext!accessing!public! !
!MethodSpy categoriesFor: #activationCount!accessing!public! !
!MethodSpy categoriesFor: #activations!accessing!public! !
!MethodSpy categoriesFor: #activations:!accessing!public! !
!MethodSpy categoriesFor: #at:!accessing!public! !
!MethodSpy categoriesFor: #at:put:!accessing!public! !
!MethodSpy categoriesFor: #context!accessing!public! !
!MethodSpy categoriesFor: #context:!accessing!public! !
!MethodSpy categoriesFor: #handle!accessing!public! !
!MethodSpy categoriesFor: #isEnabled!public!testing! !
!MethodSpy categoriesFor: #isExisting!public!testing! !
!MethodSpy categoriesFor: #isLocallyEnabled!accessing!public! !
!MethodSpy categoriesFor: #isLocallyEnabled:!accessing!public! !
!MethodSpy categoriesFor: #isSimpleHalt!public!testing! !
!MethodSpy categoriesFor: #isVirgin!public!testing! !
!MethodSpy categoriesFor: #method!accessing!public! !
!MethodSpy categoriesFor: #method:!accessing!public! !
!MethodSpy categoriesFor: #methodSourceInterval!accessing!public! !
!MethodSpy categoriesFor: #methodSourceInterval:!accessing!public! !
!MethodSpy categoriesFor: #methodSourcePosition!accessing!public! !
!MethodSpy categoriesFor: #parseTree!accessing!public! !
!MethodSpy categoriesFor: #publishedAspects!actions!public! !
!MethodSpy categoriesFor: #reset!actions!public! !
!MethodSpy categoriesFor: #scintillaIndicator:!accessing!public! !
!MethodSpy categoriesFor: #sourceTip!accessing!public! !
!MethodSpy categoriesFor: #spyManager!accessing!public! !
!MethodSpy categoriesFor: #spySource!accessing!public! !
!MethodSpy categoriesFor: #spySource:!accessing!public! !
!MethodSpy categoriesFor: #spySourceAt:spyCount:!accessing!public! !
!MethodSpy categoriesFor: #spySourceForTest!accessing!public! !
!MethodSpy categoriesFor: #spySourceInterval!accessing!public! !
!MethodSpy categoriesFor: #spySourceInterval:!accessing!public! !
!MethodSpy categoriesFor: #toggleLocallyEnabled!actions!public! !

!MethodSpy class methodsFor!

icon

	^SSWDevelopmentIconLibrary default methodSpy!

new

	"© 2002 Solutions Software"

	^super new
		reset;
		yourself!

newInstanceAspect: aSymbol class: aspectClass 
	^aspectClass name: aSymbol presenterBlock: [:p :m | MethodSpyPresenter createIn: p on: m]!

newSimpleHalt

	^self new
		spySource: self simpleHaltSource;
		yourself!

publishedAspectsOfInstances

	^super publishedAspectsOfInstances
		add: (Aspect integer: #activationCount);
		add: (Aspect boolean: #isLocallyEnabled);
		add: (Aspect collection: #activations);
		add: (Aspect dictionary: #context);
		yourself!

simpleHaltSource

	^'self halt.'! !
!MethodSpy class categoriesFor: #icon!constants!development!instance creation!public! !
!MethodSpy class categoriesFor: #new!instance creation!public! !
!MethodSpy class categoriesFor: #newInstanceAspect:class:!constants!development!instance creation!public! !
!MethodSpy class categoriesFor: #newSimpleHalt!instance creation!public! !
!MethodSpy class categoriesFor: #publishedAspectsOfInstances!constants!development!instance creation!public! !
!MethodSpy class categoriesFor: #simpleHaltSource!constants!development!instance creation!public! !

