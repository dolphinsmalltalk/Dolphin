"Filed out from Dolphin Smalltalk"!

Model subclass: #ValueModel
	instanceVariableNames: 'settingValue comparisonPolicy'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ValueModel guid: (GUID fromString: '{87b4c66e-026e-11d3-9fd7-00a0cc3e4a32}')!

ValueModel isAbstract: true!

ValueModel comment: 'ValueModel is an abstract class whose subclasses provide the capability to adapt the protocol of a subject object to a simple <value> protocol. The intention is to allow general purpose objects, such as <views>, to interact with more specific objects, by providing an adapted layer between them. A client of a <valueModel> can set the value of the subject using a #value: message and similarly the value can be retrieved by sending #value:. 

An additional benefit is that <valueModel>s trigger a #value change notification whenever  the value is modified. This allows <valueModel>s to share data with several observers following the standard Observer pattern.  All <valueModel>s hold a <ComparisonPolicy> which determines when to trigger an update notification that the value has changed. By default, a change is notified when an attempt is made to set the value to a new one which is not equal to the existing value. 
 
The most commonly used subclass of ValueModel is ValueHolder whose instances wrap a subject object and use this as the value. 

Instance Variables:
	comparisonPolicy	<ComparisonPolicy> for determining whether a new value is different from the existing value
'!

!ValueModel categoriesForClass!MVP-Models! !

!ValueModel methodsFor!

aspectAdaptorClass
	^ValueModelAspectAdaptor!

asValue
	"Answer the receiver as a ValueModel"

	^self!

canGet
	"Private - Answer whether the receiver can be read using #value."

	^true!

canSet
	"Private - Answer whether the receiver can be set using #value:."

	^true!

comparisonPolicy
	"Answer the ComparisonPolicy for the receiver. This is used
	to determine whether a value has actually been changed and
	therefore whether dependents should be informed of the event"

	^comparisonPolicy!

comparisonPolicy: aComparisonPolicy
	"Sets the comparison policy to be used by the receiver.
	This is used to determine whether a value has actually been 
	changed and therefore whether dependents should be informed 
	of the event"

	comparisonPolicy := aComparisonPolicy!

defaultComparisonPolicy
	"Private - Answer the default comparison policy to use for the receiver.
	By default we don't want to trigger change notifications if the values are equal"

	^SearchPolicy equality!

initialize
	"Private - Initialize the receiver with a default comparison policy that
	always considers new values as different from existing ones"

	super initialize.
	self comparisonPolicy: self defaultComparisonPolicy.
	settingValue := false.!

notifyChanged
	"Private - The receiver's value has changed. Notify observers appropriately"

	settingValue ifFalse: [ self trigger: #valueChanged ]
!

printOn: aStream
	"Append the ASCII representation of the receiver to aStream as a developer would wish to see it."

	super printOn: aStream.
	aStream nextPut: $(.
	aStream print: self value.
	aStream nextPut: $).!

setValue: newValue
	"Private - Set the value of the receiver to be the <Object> newValue
	without notifying dependents of the change."

	^self subclassResponsibility!

value
	"Answer the <Object> value of the receiver."

	^self subclassResponsibility!

value: anObject 
	"Assigns the value for the receiver and notify dependents if it
	has changed according to our comparisonPolicy"

	(self comparisonPolicy compare: self value with: anObject) ifTrue: [^self].
	
	[settingValue := true.
	self setValue: anObject] ensure: [settingValue := false].
	self notifyChanged! !

!ValueModel categoriesForMethods!
aspectAdaptorClass!constants!private! !
asValue!converting!public! !
canGet!private!testing! !
canSet!private!testing! !
comparisonPolicy!accessing!public! !
comparisonPolicy:!accessing!public! !
defaultComparisonPolicy!initializing!private! !
initialize!initializing!private! !
notifyChanged!operations!private! !
printOn:!printing!public! !
setValue:!accessing!private! !
value!accessing!public! !
value:!accessing!public! !
!

ValueModel methodProtocol: #value attributes: #(#readOnly) selectors: #(#value #value:)!
ValueModel methodProtocol: #valueModel attributes: #(#readOnly) selectors: #(#value #value:)!

!ValueModel class methodsFor!

comparisonPolicy: aComparisonPolicy
	"Answer a new instance of the receiver with the specified comparison
	policy and a 'nil' initial value."

	^(self new)
		comparisonPolicy: aComparisonPolicy;
		yourself!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

stbConvertFrom: anSTBClassFormat
	"Convert from earlier version models.
	2: Added 'settingValue' instance variable."

	| ver |
	ver := anSTBClassFormat version.
	ver == 1
		ifTrue: 
			[^
			[:data |
			(Array new: self instSize)
				at: 1 put: (data at: 1);
				at: 2 put: false;
				replaceFrom: 3
					to: data size + 1
					with: data
					startingAt: 2;
				becomeA: self]].
	ver == 0
		ifTrue: 
			[^
			[:data |
			(Array new: self instSize)
				at: 2 put: false;
				replaceFrom: 3
					to: data size + 2
					with: data
					startingAt: 1;
				becomeA: self]].
	^super stbConvertFrom: anSTBClassFormat!

stbVersion
	"Answer the current binary filer version number for instances of the receiver.
		0: comparisonPolicy
		1: events comparisonPolicy
		2: events settingValue comparisonPolicy
	"

	^2! !

!ValueModel class categoriesForMethods!
comparisonPolicy:!instance creation!public! !
icon!constants!public! !
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
!

