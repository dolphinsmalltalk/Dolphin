"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SourceFiler
	instanceVariableNames: 'stream evaluationContext flags'
	classVariableNames: 'SourceOnlyMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SourceFiler guid: (GUID fromString: '{847f25f1-cd60-490c-817f-3f0f2cefd567}')!
SourceFiler isAbstract: true!
SourceFiler addClassConstant: 'SourceOnlyMask' value: 16r1!
SourceFiler comment: ''!
!SourceFiler categoriesForClass!Development!System-Support! !
!SourceFiler methodsFor!

atEnd
	"Answer whether the receiver is at the end of its source stream."

	^stream atEnd!

close
	"Close the source stream"

	stream close.
	stream := nil!

cr
	"Emit a line-delimiter to the source stream"

	stream cr!

emitCategoriesOfClass: aClass 
	"Private - Emit a chunk to source stream to reclassify the <Class>, aClass, in all its existing 
	categories."

	^self subclassResponsibility!

emitCategoriesOfMethod: aCompiledMethod 
	"Private - Append an entry to the source stream to reclassify the <CompiledMethod>, 
	aCompiledMethod, in all its current method categories."

	^self subclassResponsibility!

emitCategoriesOfMethods: methods 
	"Emit source that associates the <CompiledMethod>s in the <collection>, methods, with their
	current categories."

	methods do: [:m | self emitCategoriesOfMethod: m]!

emitClassPoolOfClass: aClass
	"Private - Emit initialization expressions for each of the literal constants in the class pool of aClass."

	| literalConstants |
	literalConstants := aClass classPool associations
				select: [:each | each isImmutable and: [each value isLiteral]].
	literalConstants asSortedCollection
		do: [:each | self emitDeclarationForClass: aClass variable: each]!

emitComment: aString 
	"Private - Record aString to the source stream.
	N.B. Logging requests should be directed through the SessionManager."

	^self subclassResponsibility!

emitCommentOfClass: aClass 
	"Private - Emit a chunk which defines the comment for the <Class>, aClass, to source stream."

	^self subclassResponsibility!

emitDeclarationForClass: aClass variable: each
	^self subclassResponsibility!

emitFooterForMethodsOf: aClass 
	"Private - Ends the method definition chunks for aClass onto
	the source stream."

	^self subclassResponsibility!

emitGUIDOfClass: aClass 
	"Private - Emit a GUID definition chunk for the <Class>, aClass, to the source stream."

	^self subclassResponsibility!

emitHeaderForMethodsOf: aClass 
	"Private - Emits a category header for the class, aClass, to the source stream."

	^self subclassResponsibility!

emitMethod: aCompiledMethod 
	"Private - File out the source of the single <CompiledMethod>, aCompiledMethod, to the source stream."

	^self subclassResponsibility!

emitSetBehaviorFlag: flagName forClass: aClass 
	"Private - Emit an attribute for the <Class>, aClass, to define its special behaviour flag named by
	the <Symbol>, flagName."

	^self subclassResponsibility!

emitSpecialBehaviourAttributesOfClass: aClass
	"Private - Emit attributes for the <Class>, aClass, to define its special behaviour flags."

	#(#isIndirection #isNullTerminated)
		do: [:flagName | (aClass perform: flagName) ifTrue: [self emitSetBehaviorFlag: flagName forClass: aClass]].
	"We only emit the #isAbstract flag if the class has been explicitly marked non-instantiable, not just because it answers true to #isAbstract."
	aClass isNonInstantiable ifTrue: [self emitSetBehaviorFlag: #isAbstract forClass: aClass]!

evaluationContext
	^evaluationContext!

evaluationContext: anObject
	evaluationContext := anObject!

fileIn
	"File in the expressions/definitions from receiver's source stream, which is
	expected to be in the receiver's format. Any methods that fail to compile are stubbed 
	with instances of <CompileFailedMethod> and errors are logged to the Transcript."

	^self subclassResponsibility!

fileOutAllMethodsOfBehavior: aClassDescription 
	"Emit definitions of all methods in the <ClassDescription> argument, aClassDescription,
	to the source stream."

	self fileOutMessages: aClassDescription selectors ofBehavior: aClassDescription.
	self isSourceOnly 
		ifFalse: [self fileOutProtocols: aClassDescription protocols ofBehavior: aClassDescription]!

fileOutBasicDefinitionOfClass: aClass 
	"Print a definition of the <Class>, aClass, to the source stream."

	^self subclassResponsibility!

fileOutBinaryGlobal: anAssociation 
	"File out the text representation of the non-<sourceObject>
	which is the value of the <Association>, anAssociation, to the
	source stream. The key of the association is the global name."

	^self subclassResponsibility!

fileOutExpression: aString
	"Append an immediate expression evaluation to the the source stream."

	^self subclassResponsibility!

fileOutPoolDictionary: aPoolDictionary 
	"Append a definition of the <PoolDictionary> (or <PoolConstantsDictionary>, aPoolDictionary,
	to the source stream. The definition should be sufficient to recreate a copy  of the dictionary."

	^self subclassResponsibility!

fileOutProtocols: aCollection ofBehavior: aClassDescription 
	"File out the <MethodProtocol>s in the <collection>, aCollection, to the source stream,
	associating them with the <ClassDescription>, aClassDescription."

	^self subclassResponsibility!

fileOutResource: aResourceIdentifier 
	"Append a definition of the resource identified by the <ResourceIdentifier>, aResourceIdentifer,
	to the source stream. The definition should be sufficient to recreate a copy  of the resource."

	^self subclassResponsibility!

flush
	"Flush the source stream."

	stream flush!

getSourceFromDescriptor: sourceDescriptor
	"Answer the <readableString> source corresponding to the specified <integer> 
	descriptor, sourceDescriptor, from the receiver's source stream."

	^self subclassResponsibility!

isSourceOnly
	^flags anyMask: SourceOnlyMask!

isSourceOnly: aBoolean
	flags := flags mask: SourceOnlyMask set: aBoolean!

setStream: aPuttableStream
	stream := aPuttableStream.
	flags := 0!

setToEnd
	"Seek to the end of the source stream."

	stream setToEnd!

sourcePositionFromDescriptor: sourceObject
	"Private - Answer the offset from the start of the source file at which the chunk containing
	the source code whose location is described by, sourceDescriptor, can be found.
	If sourceObject is not an Integer, then an error will result."

	^sourceObject bitShift: -4!

storeCommentString: aString forClass: aClass
	"Save the <readableString>, aString, as the comment text for the 
	<Class>, aClass, to the receiver's source stream encoding the position and 
	index into the class' source descriptor so that the comment may be retrieved later."

	^self subclassResponsibility!

storeCommentString: aString forPackage: aPackage
	"Save the <readableString>, aString, as the comment text for the <Package>, aPackage, to the
	receiver's source stream encoding the position and index into the package's source
	descriptor so that the comment may be retrieved later."

	^self subclassResponsibility!

storeSource: aString for: aSourceObject
	"Private - Store the <readableString>, aString, as the source text for the <sourceObject>,
	aSourceObject, updating its source descriptor."

	^self subclassResponsibility!

storeSourceString: aString forMethod: aCompiledMethod 
	"Save the <readableString>, aString, as the source text for the 
	<CompiledMethod>, aCompiledMethod, to the receiver's source stream
	encoding the position and index into the methods source descriptor so that 
	the source may be retrieved later."

	^self subclassResponsibility!

stream
	"Private - Answer the value of the receiver's ''stream'' instance variable."

	^stream! !
!SourceFiler categoriesFor: #atEnd!public!testing! !
!SourceFiler categoriesFor: #close!operations!public! !
!SourceFiler categoriesFor: #cr!accessing!public! !
!SourceFiler categoriesFor: #emitCategoriesOfClass:!private!source filing! !
!SourceFiler categoriesFor: #emitCategoriesOfMethod:!private!source filing! !
!SourceFiler categoriesFor: #emitCategoriesOfMethods:!private!source filing! !
!SourceFiler categoriesFor: #emitClassPoolOfClass:!private!source filing! !
!SourceFiler categoriesFor: #emitComment:!operations-logging!private! !
!SourceFiler categoriesFor: #emitCommentOfClass:!private!source filing! !
!SourceFiler categoriesFor: #emitDeclarationForClass:variable:!private!source filing! !
!SourceFiler categoriesFor: #emitFooterForMethodsOf:!private!source filing! !
!SourceFiler categoriesFor: #emitGUIDOfClass:!private!source filing! !
!SourceFiler categoriesFor: #emitHeaderForMethodsOf:!private!source filing! !
!SourceFiler categoriesFor: #emitMethod:!private!source filing! !
!SourceFiler categoriesFor: #emitSetBehaviorFlag:forClass:!private!source filing! !
!SourceFiler categoriesFor: #emitSpecialBehaviourAttributesOfClass:!private!source filing! !
!SourceFiler categoriesFor: #evaluationContext!accessing!public! !
!SourceFiler categoriesFor: #evaluationContext:!accessing!public! !
!SourceFiler categoriesFor: #fileIn!public!source filing! !
!SourceFiler categoriesFor: #fileOutAllMethodsOfBehavior:!public!source filing! !
!SourceFiler categoriesFor: #fileOutBasicDefinitionOfClass:!public!source filing! !
!SourceFiler categoriesFor: #fileOutBinaryGlobal:!public!source filing! !
!SourceFiler categoriesFor: #fileOutExpression:!public!source filing! !
!SourceFiler categoriesFor: #fileOutPoolDictionary:!public!source filing! !
!SourceFiler categoriesFor: #fileOutProtocols:ofBehavior:!public!source filing! !
!SourceFiler categoriesFor: #fileOutResource:!public!source filing! !
!SourceFiler categoriesFor: #flush!operations!public! !
!SourceFiler categoriesFor: #getSourceFromDescriptor:!public!source filing! !
!SourceFiler categoriesFor: #isSourceOnly!accessing!public! !
!SourceFiler categoriesFor: #isSourceOnly:!accessing!public! !
!SourceFiler categoriesFor: #setStream:!initializing!private! !
!SourceFiler categoriesFor: #setToEnd!positioning!public! !
!SourceFiler categoriesFor: #sourcePositionFromDescriptor:!private!source filing! !
!SourceFiler categoriesFor: #storeCommentString:forClass:!public!source filing! !
!SourceFiler categoriesFor: #storeCommentString:forPackage:!public!source filing! !
!SourceFiler categoriesFor: #storeSource:for:!private!source filing! !
!SourceFiler categoriesFor: #storeSourceString:forMethod:!public!source filing! !
!SourceFiler categoriesFor: #stream!accessing!private! !

!SourceFiler class methodsFor!

initialize
	self addClassConstant: 'SourceOnlyMask' value: 1.!

on: aWriteStream 
	"Answer a new instance of the receiver for filing out source code onto the 
	<puttableStream> argument."

	^(self new)
		setStream: aWriteStream;
		yourself! !
!SourceFiler class categoriesFor: #initialize!class initialization!development!public! !
!SourceFiler class categoriesFor: #on:!instance creation!public! !

