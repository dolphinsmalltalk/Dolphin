"Filed out from Dolphin Smalltalk"!

UI.ValueAdaptor
	subclass: #'Tools.AspectAccessor'
	instanceVariableNames: 'aspectDescriptor'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.AspectAccessor guid: (Core.GUID fromString: '{87b4c67b-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.AspectAccessor comment: 'Part of the PublishedAspectInspector framework. This is a <ValueAspectAdaptor> on a particular aspect of an object. It also holds an <Aspect> that describes the aspect so that sufficient information is available to be able to display or edit it within a presenter UI. An AspectAccessor instance is also capable of knowing it''s "parent" accessor. This allows instances to be manipulated by an <AspectAccessorTreeModel>.

Instance Variables:
	aspectDescriptor	<Aspect> the descriptor for the aspect being accessed.
	parentAccessor	<AspectAccessor> the parent accessor or nil.
'!
!Tools.AspectAccessor categoriesForClass!MVP-Models! !
!Tools.AspectAccessor methodsFor!

<= anAspectAccessor
	"Answer whether the receiver is 'less than' anAspectAccessor.
	By implementing this method, we enable AspectAccessor objects to be stored
	in a SortedCollection with the default sort block."

	^self aspectDescriptor <= anAspectAccessor aspectDescriptor!

= comperand
	"Answer whether the receiver is considered equal to the <Object>, comperand."

	^self == comperand or: 
			[self species == comperand species 
				and: [self aspectDescriptor = comperand aspectDescriptor and: [self subject == comperand subject]]]!

aspectDescriptor
	"Private - Answer the Aspect descriptor of the receiver"

	^aspectDescriptor!

aspectDescriptor: anObject
	aspectDescriptor := anObject!

aspectDisplayOn: aStream
  	"Private - Append a single-line textual representatin of the receiver to the <puttableStream>
  	argument in a form that a user viewing the receiver as the value of a published aspect would 
  	like to see it. In this case we want to display the accessort itself, and not its subject, as otherwise
	 we could get into an infinite loop in some circumstances such as inspecting the main UI process
	(an AspectAccessor in use in the inspector could be on the stack)."
  
  	self basicPrintOn: aStream!

canEdit
	"Private - Answer true if the receiver can be edited"

	^self canSet and: [self aspectDescriptor canEdit or: [self yourselfAspect canEdit]]!

canGet
	"Private - Answer whether the receiver can be read using #value."

	^self aspectDescriptor canReadFrom: self subject!

canImmediateAction
	"Private - Answer whether the receiver can be immediately actioned."

	^self aspectDescriptor canImmediateAction!

canNil
	"Private - Answer whether the receiver can be nulled."

	^self canSet and: [self aspectDescriptor isNullable]!

canReset
	"Private - Answer whether the receiver can be nulled or reset to its default."

	^self canSet and: [aspectDescriptor isNullable or: [aspectDescriptor defaultValue notNil]]!

canSet
	"Private - Answer whether the receiver can be set using #value:."

	^self aspectDescriptor canWriteInto: self subject!

defaultComparisonPolicy
	"Private - Answer the default comparison policy to use for the receiver.
	By default always want to trigger change notifications"

	^SearchPolicy never!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that a development user might want to see."

	self aspectDescriptor displayAspectText: self subject on: aPuttableStream!

editedValue: anObject
	"Private - For immutable aspects we must ensure that the value we are editing is not the same as 
	 that in the subject, so when saving back a changed value from the editor's model 
	we may need to copy."

	self value: (self isMutable ifTrue: [anObject] ifFalse: [anObject copy])!

editUsing: aPresenter
	"Perform an edit action on the receiver using the aspect descriptors edit block and
	using aPresenter supplied."

	| yourselfAspect |
	self aspectDescriptor canEdit ifTrue: [^self aspectDescriptor editBlock value: aPresenter].
	yourselfAspect := self yourselfAspect.
	yourselfAspect canEdit ifTrue: [yourselfAspect editBlock value: aPresenter]!

getMutableValue
	"Private - For immutable objects we must edit a copy of the aspect value"

	^self isMutable ifTrue: [self value] ifFalse: [self value copy]!

hash
	"Answer the <Integer> hash value for the receiver."

	^(self aspectDescriptor hash bitShift: 1) bitXor: self subject hash!

immediateActionUsing: aPresenter 
	"Perform an immediate action on the receiver using the aspect descriptors immediate action block and
	using aPresenter supplied."

	^self aspectDescriptor immediateActionBlock value: aPresenter!

isMutable
	^self aspectDescriptor isMutable!

isReadable
	^aspectDescriptor isReadable!

key
	^self name!

name
	"Answer the <readableString> that describes the receiver's aspect"

	^self aspectDescriptor nameIn: self subject!

objectRef
	"Private - Answer an association to used when the value of the receiver is dragged as an #ObjectRef"

	^self objectRefName -> self value!

objectRefName
	"Private - Answer name to use when the value of the receiver is dragged as an #ObjectRef"

	^self aspectDescriptor objectRefName: self subject!

selectIn: anInspector
	anInspector selectAspect: self!

setSubject: anObject aspectDescriptor: anAspectDescriptor
	"Private - Sets the subject object and its aspect that is being interfaced
	to by the receiver"

	self initialize.
	subject := anObject.
	aspectDescriptor := anAspectDescriptor!

setValue: anObject
	"Private - Assigns the value for the receiver without notifying 
	dependents of the change"

	self aspectDescriptor writeInto: self subject value: anObject!

typeIcon
	^aspectDescriptor icon!

typeImage
	^self typeIcon ifNotNil: [:icon | icon imageIndex]!

value
	"Answers the <Object> value of the receiver.
	If an exception is raised attempting to access the value, then answer that instead."

	^self aspectDescriptor readFrom: self subject!

valueDebugText
	^[self value debugPrintString] on: Error
		do: 
			[:ex |
			String smalltalkWriteStream
				nextPutAll: 'an invalid ';
				print: aspectDescriptor;
				nextPutAll: ' {';
				nextPutAll: ex description;
				nextPut: $}]!

valueIcon
	self canGet ifFalse: [^Icon question].
	^[self value icon] on: Error do: [:ex | self icon]!

valueImage
	^[self valueIcon ifNotNil: [:icon | icon imageIndex]] on: Error do: [:ex | -1]!

valueNameInfo
	"Answer a string that can be used in an info tip to describe the receiver"

	| stream |
	stream := String smalltalkWriteStream: 40.
	[self aspectDescriptor displayAspectInfoOf: self subject on: stream] on: Error
		do: [:ex | stream basicPrint: ex].
	^stream contents!

valueNameOnly
	| stream |
	stream := String smalltalkWriteStream: 40.
	
	[self aspectDescriptor displayAspectNameOf: self subject on: stream.
	self] on: Error
			do: [:ex | stream basicPrint: ex].
	^stream contents!

valueText
	| stream |
	stream := String smalltalkWriteStream: 40.
	[self displayOn: stream] on: Error do: [:ex | stream basicPrint: ex].
	^stream contents!

valueTextOnly
	"Answer a <String> that represents the value of the receiver. One might have thought this should be called #valueText but this selector has previously been used to answer a String containing name=value. We retain the latter for compatibility and introduce this method."

	| stream |
	stream := LimitedWriteStream
				over: (String writeStream: 32)
				limit: 3000
				limitBlock: [:s | ^s contents , ' … etc …'].
	stream locale: Locale smalltalk.
	[self aspectDescriptor displayAspectValueOf: self subject on: stream] on: Error
		do: [:ex | stream basicPrint: ex].
	^stream contents!

yourselfAspect
	"Answers the AspectAccessor for the #yourself published aspect of the 
	receiver's value."

	^self value publishedAspects at: #yourself! !
!Tools.AspectAccessor categoriesForMethods!
<=!comparing!public! !
=!comparing!public! !
aspectDescriptor!accessing!private! !
aspectDescriptor:!accessing!private! !
aspectDisplayOn:!private! !
canEdit!operations!public! !
canGet!public!testing! !
canImmediateAction!public!testing! !
canNil!public!testing! !
canReset!public!testing! !
canSet!public!testing! !
defaultComparisonPolicy!initializing!private! !
displayOn:!displaying!public! !
editedValue:!accessing!private! !
editUsing:!operations!public! !
getMutableValue!public! !
hash!comparing!public! !
immediateActionUsing:!operations!public! !
isMutable!accessing!public! !
isReadable!public! !
key!public! !
name!accessing!public! !
objectRef!accessing!private! !
objectRefName!accessing!public! !
selectIn:!event handling!private! !
setSubject:aspectDescriptor:!initializing!private! !
setValue:!accessing!private! !
typeIcon!accessing!public! !
typeImage!accessing!public! !
value!accessing!public! !
valueDebugText!accessing!public! !
valueIcon!accessing!public! !
valueImage!accessing!public! !
valueNameInfo!accessing!public! !
valueNameOnly!accessing!public! !
valueText!accessing!public! !
valueTextOnly!accessing!public! !
yourselfAspect!accessing!public! !
!

!Tools.AspectAccessor class methodsFor!

new
	"Private - An instance of this class requires parameters"

	^self shouldNotImplement!

subject: anObject aspect: anAspect
	"Answers an instance of the receiver that is an interface onto
	aAspect of anObject"

	^self basicNew
		setSubject: anObject aspectDescriptor: anAspect;
		yourself! !
!Tools.AspectAccessor class categoriesForMethods!
new!instance creation!private! !
subject:aspect:!instance creation!public! !
!

