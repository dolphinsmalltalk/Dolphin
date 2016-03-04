"Filed out from Dolphin Smalltalk 7"!

CompiledMethod variableSubclass: #SpyMethod
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SpyMethod guid: (GUID fromString: '{57E97F41-21F6-11D6-87E5-0010A70883E2}')!
SpyMethod comment: ''!
!SpyMethod categoriesForClass!Unclassified! !
!SpyMethod methodsFor!

asDebugMethod

	"Overriden to construct a debug version of the receiver spyMethod"

	| spyDebugMethod |

	self isDebugMethod ifTrue: [^self].

	spyDebugMethod := self compilerClass compileDebugMethod: self sourceWithSpies in: self methodClass.

	"Copy across some bits we need as we are an unbound method"
	spyDebugMethod
		sourceDescriptor: self sourceDescriptor;
		selector: self selector;
		isPrivate: self isPrivate.

	spyDebugMethod become: (spyDebugMethod asSpyMethodWithSpies: self methodSpies).
	
	^spyDebugMethod 
		sourceDescriptor: self sourceDescriptor;
		spiedMethod: self spiedMethod;
		yourself!

contactSpies

 	self methodSpies do: [ :each | each method: self]!

currentMethod

	^self methodClass compiledMethodAt: self selector!

debugInfo

	"© 2002 Solutions Software

	Always generate the debugInfo for a spy method"

	^self getDebugInfo!

getDebugInfo

	"Overriden to map certain info from the receiver's debugInfo to the actual debugInfo"

	| spyDebugInfo textMap |

	spyDebugInfo := self compilerClass 
		debugInfoFor: self sourceWithSpies
		in: self methodClass 
		debug: self isDebugMethod.

	textMap := spyDebugInfo textMap.

	self methodSpies do: 
		[ :each || spySize |
		spySize := '#thisSpy1 handle. ' size.
		textMap do: 
			[ :assoc || interval |
			interval := assoc value.
			(interval includes: each methodSourcePosition) 
				ifTrue: [interval stop: (interval stop - spySize)]
				ifFalse: [interval start >each methodSourcePosition ifTrue: [assoc value: (interval - spySize)]]]].

	spyDebugInfo textMap: textMap.

	^spyDebugInfo!

hash

	"© 2002 Solutions Software

	Overriden since superclass implementation directly accesses selector"

	^(self selector hash bitShift: 4) bitXor: methodClass hash!

infiltrateWithSpies

	"© 2002 Solutions Software

	Fill out the receiver's frame with the actual spies (replacing #thisSpyX placeholders)"

	1 to: self size do:
		[ :index || entry |
		entry := self at: index. 
		(entry isSymbol and: [entry beginsWith: 'thisSpy']) ifTrue:
			[self at: index put: (self methodSpies at: (entry allButFirst: 7) asNumber)]]!

initSelector

	"© 2002 Solutions Software"

	selector := Array new: 3!

isPrivate
	"Private - Answer whether the receiver is a debug method."

	^self spiedMethod isPrivate!

isPrivate: aBoolean 
	"Private - Set whether the receiver is a private method."

	self spiedMethod isPrivate: aBoolean!

isSpy

	"© 2002 Solutions Software"

	^true!

isUnbound

	"Additionally check for a change of method instance"

	^super isUnbound or: 
		[| current |
		current := self currentMethod.
		current isSpy not or: [self methodSpies ~= current methodSpies]]!

mapDebugInfoFrom: spyInfo to: spiedInfo

	| newMap |

	newMap := spyInfo textMap collect: 
		[ :spyMap | Association key: spyMap key value: (self mapSpyInterval: spyMap value)].

	spiedInfo textMap: newMap!

mapSpyInterval: anInterval

	| stream offset spy spyInterval |

	stream := ReadStream on: self methodSpies.
	offset := 0.

	[stream atEnd 
	ifTrue:
		[true]
	ifFalse:
		[spy := stream next. 
		spyInterval := spy spySourceInterval. 
		spyInterval start >= anInterval start or: [spyInterval includes: anInterval start]]] 
			whileFalse: [offset := offset - spyInterval size].

	^(spyInterval notNil and: [spyInterval includes: anInterval start]) 
		ifTrue: [spy methodSourceInterval]
		ifFalse: [anInterval copy + offset]!

methodSpies

	"© 2002 Solutions Software

	Use embedded storage in selector - cannot add inst vars to CompiledMethod"

	^selector at: 2!

methodSpies: anOrderedCollection

	"© 2002 Solutions Software

	Use embedded storage in selector - cannot add inst vars to CompiledMethod"

	selector at: 2 put: anOrderedCollection!

parseTree
	"© 2002 Solutions Software

	Overriden to use the SpyParser"

	^(SmalltalkSpyParser parseMethod: self getSource in: self methodClass)
		methodSpies: self methodSpies;
		yourself!

recompile

	self beSpiedOnByAll: self methodSpies!

recompileWithSpy: aMethodSpy

	(self methodSpies includes: aMethodSpy)
		ifTrue: [self recompile]
		ifFalse: [self beSpiedOnBy: aMethodSpy]!

removeAllSpies

	self methodClass methodDictionary at: self selector put: self spiedMethod.
	self methodSpyManager spiesCompiledIn: 
			(CompilationResult new 
				method: self spiedMethod; 
				oldMethod: self;
				yourself)!

removeSpy: aMethodSpy

	self methodSpies size = 1 ifTrue: [^self removeAllSpies].

	self beSpiedOnByAll: 
		(self methodSpies copy
			remove: aMethodSpy;
			yourself)!

selector

	"© 2002 Solutions Software

	Overriden since we 'borrow' the selector inst var for methodSpies/spiedMethod"

	^selector at: 1!

selector: aSymbol

	"© 2002 Solutions Software

	Overriden since we 'borrow' the selector inst var for methodSpies/spiedMethod"

	selector at: 1 put: aSymbol asSymbol!

sourceDescriptor

	"Override to check whether this message is sent from unbound
	 - need to force unbound for comparisons of CompiledMethod with SpyMethod"

	^Processor activeProcess topFrame sender method == (CompiledMethod compiledMethodAt: #isUnbound)
		ifTrue: [0]
		ifFalse: [super sourceDescriptor]!

sourceWithSpies

	"© 2002 Solutions Software"

	^self sourceWithSpies: self methodSpies!

spiedMethod

	"© 2002 Solutions Software

	Use embedded storage in selector - cannot add inst vars to CompiledMethod"

	^selector at: 3!

spiedMethod: anSSWSpyMethod

	"© 2002 Solutions Software

	Use embedded storage in selector - cannot add inst vars to CompiledMethod"

	selector at: 3 put: anSSWSpyMethod! !
!SpyMethod categoriesFor: #asDebugMethod!development!private! !
!SpyMethod categoriesFor: #contactSpies!compiling!public! !
!SpyMethod categoriesFor: #currentMethod!accessing!public! !
!SpyMethod categoriesFor: #debugInfo!compiling!public! !
!SpyMethod categoriesFor: #getDebugInfo!development!private! !
!SpyMethod categoriesFor: #hash!comparing!public! !
!SpyMethod categoriesFor: #infiltrateWithSpies!compiling!public! !
!SpyMethod categoriesFor: #initSelector!compiling!initializing!public! !
!SpyMethod categoriesFor: #isPrivate!private!testing! !
!SpyMethod categoriesFor: #isPrivate:!accessing!private! !
!SpyMethod categoriesFor: #isSpy!public!testing! !
!SpyMethod categoriesFor: #isUnbound!public!testing! !
!SpyMethod categoriesFor: #mapDebugInfoFrom:to:!development!private! !
!SpyMethod categoriesFor: #mapSpyInterval:!development!private! !
!SpyMethod categoriesFor: #methodSpies!accessing!public! !
!SpyMethod categoriesFor: #methodSpies:!accessing!public! !
!SpyMethod categoriesFor: #parseTree!accessing!public! !
!SpyMethod categoriesFor: #recompile!compiling!public! !
!SpyMethod categoriesFor: #recompileWithSpy:!compiling!public! !
!SpyMethod categoriesFor: #removeAllSpies!compiling!public! !
!SpyMethod categoriesFor: #removeSpy:!compiling!public! !
!SpyMethod categoriesFor: #selector!accessing!public! !
!SpyMethod categoriesFor: #selector:!accessing!public! !
!SpyMethod categoriesFor: #sourceDescriptor!accessing!public! !
!SpyMethod categoriesFor: #sourceWithSpies!accessing!public! !
!SpyMethod categoriesFor: #spiedMethod!accessing!public! !
!SpyMethod categoriesFor: #spiedMethod:!accessing!public! !

!SpyMethod class methodsFor!

new: anInteger

	"© 2002 Solutions Software

	Overriden to initialize the 'borrowed' selector inst var"

	^(super new: anInteger)
		initSelector;
		yourself! !
!SpyMethod class categoriesFor: #new:!public! !

