"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.COM.DISPPARAMS'
	instanceVariableNames: 'args vargs dispids'
	classVariableNames: 'ZeroArgs'
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_DISPPARAMS_Size' -> 16r10.
			'_OffsetOf_cArgs' -> 16r8.
			'_OffsetOf_cNamedArgs' -> 16rC.
			'_OffsetOf_rgdispidNamedArgs' -> 16r4.
			'_OffsetOf_rgvarg' -> 16r0
		}!

OS.COM.DISPPARAMS guid: (Core.GUID fromString: '{c06f3b6f-0868-11d3-93af-00a024ca708a}')!

OS.COM.DISPPARAMS comment: 'DISPPARAMS is an <ExternalStructure> to represent the OLE Automation structure DISPPARAMS.

DISPPARAMS is the parameter block used in calls to IDispatch::Invoke. It contains an array of VARIANTARG structures (which are actually represented by the identical <VARIANT> structure in Dolphin), a count of the total number of arguments, an array of the <integer> DISPIDs of the so called "named" arguments, and a count of the number of named arguments in that array. The named arguments are assumed to appear first in the rgvarg array.

In general Dolphin does not use named arguments since these are not terribly well supported by Smalltalk syntax. The exception is for property put invocations, where their use is required.

Apart from the generated accessors for the structure members this class implements convenience methods to make it easy to set up late-bound calls of common types.

Fields:
	rgvarg		<VARIANT*> Array of arguments
	rgdispidNamedArgs	<SDWORD*> Array of ids of named arguments
	cArgs		<DWORD> Total number of named and unnamed arguments (size of rgvarg).
	cNamedArgs	<DWORD> Number of named arguments (size of rgdispidNamedArgs)'!

!OS.COM.DISPPARAMS categoriesForClass!External-Data-Structured-COM! !

!OS.COM.DISPPARAMS methodsFor!

arg: argument
	"Set the receiver's single argument to be the <VARIANT> representation 
	of the <Object>, argument. If the argument is not representable as a VARIANT
	then raise an error."

	args := argument asVariant. 		"Prevent premature GC of VARIANT"
	self rgvarg: args.
	self cArgs: 1!

args: arguments
	"Set the receiver's arguments to be <Array> of <Object> arguments."

	| argc |
	argc := arguments size.
	args := Array new: argc.
	vargs := StructureArray length: argc elementClass: VARIANT.
	"We don't want the StructureArray to free the variants, so set the owner to the array"
	vargs owner: args.
	1 to: argc
		do: 
			[:i |
			| j |
			j := argc - i + 1.
			vargs uncheckedAt: j put: (args at: j put: (arguments at: i) asVariant)].
	self rgvarg: vargs!

cArgs
	"Private - Answer the <Integer> value of the receiver's 'cArgs' field."

	^bytes uint32AtOffset: _OffsetOf_cArgs!

cArgs: anInteger
	"Set the receiver's 'cArgs' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cArgs put: anInteger!

cNamedArgs
	"Private - Answer the <Integer> value of the receiver's 'cNamedArgs' field."

	^bytes uint32AtOffset: _OffsetOf_cNamedArgs!

cNamedArgs: anInteger
	"Set the receiver's 'cNamedArgs' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_cNamedArgs put: anInteger!

names: names named: namedArgs args: unnamedArgs
	"Set the receiver's arguments to be the <sequencedReadableCollection> of named arguments,
	namedArgs, the names (ids) of which are specified in the corresponding positions of the
	<sequencedReadableCollection>, dispids, and the <sequencedReadableCollection> of unnamed
	<Object> arguments, args."

	| argc cNamed cUnnamed |
	cNamed := namedArgs size.
	dispids := Int32Array new: cNamed.
	cUnnamed := unnamedArgs size.
	argc := cNamed + cUnnamed.
	args := Array new: argc.
	vargs := StructureArray length: argc elementClass: VARIANT.
	"#2084: Suppress structure array finalization which would double-free the variants"
	vargs owner: args.

	"Named args can appear in normal order"
	1 to: cNamed
		do: 
			[:i |
			| v |
			dispids at: i put: (names at: i).
			v := (namedArgs at: i) asVariant.
			vargs at: i put: (args at: i put: v)].

	"Unnamed args must appear in reverse order"
	1 to: cUnnamed
		do: 
			[:i |
			| v j |
			v := (unnamedArgs at: i) asVariant.
			j := argc - i + 1.
			vargs at: j put: (args at: j put: v)].
	self rgdispidNamedArgs: dispids.
	self rgvarg: vargs!

propertyPut: item value: argument
	"Set up the receiver for a subscripted property put operation, with the specified <VARIANT> 
	subscript item and the VARIANT representation of the <Object>, value.
	There is some slight trickiness here as for some reason the property put argument must 
	always be 'named'. As the argument count includes the named arguments it is set to two."

	self args: {item. argument}.
	dispids := Int32 fromInteger: DISPID_PROPERTYPUT.
	self rgdispidNamedArgs: dispids.
	self cNamedArgs: 1!

propertyPutValue: argument
	"Set up the receiver for an unsubscripted property put operation to set the value of a property
	to the VARIANT representation of the <Object>, argument.
	There is some slight trickiness here as for some reason the property put argument must always be
	'named'. Note also that the argument count includes the named arguments, so in this case both
	should be one."

	self arg: argument.
	dispids := Int32 fromInteger: DISPID_PROPERTYPUT.
	self rgdispidNamedArgs: dispids.
	self cNamedArgs: 1!

rgdispidNamedArgs
	"Answer the <Int32Array> value of the receiver's 'rgdispidNamedArgs' field."

	^Int32Array fromAddress: (bytes intPtrAtOffset: _OffsetOf_rgdispidNamedArgs)
		length: self cNamedArgs!

rgdispidNamedArgs: anInt32Array
	"Set the receiver's 'rgdispidNamedArgs' field to the value of the argument, anInt32Array"

	bytes uintPtrAtOffset: _OffsetOf_rgdispidNamedArgs put: anInt32Array yourAddress.
	self cNamedArgs: anInt32Array size!

rgvarg
	"Answer the <StructureArray> value of the receiver's 'rgvarg' field."

	^StructureArray
		fromAddress: (bytes intPtrAtOffset: _OffsetOf_rgvarg)
		length: self cArgs
		elementClass: VARIANT!

rgvarg: aStructureArray
	"Set the receiver's 'rgvarg' field to the value of the argument, aStructureArray"

	bytes uintPtrAtOffset: _OffsetOf_rgvarg put: aStructureArray yourAddress.
	self cArgs: aStructureArray size!

singleArg
	"Answer the single VARIANT parameter - assumes cArgs == 1"

	^VARIANT fromAddress: (bytes intPtrAtOffset: _OffsetOf_rgvarg)! !

!OS.COM.DISPPARAMS categoriesForMethods!
arg:!accessing!public! !
args:!accessing!public! !
cArgs!**compiled accessors**!private! !
cArgs:!**compiled accessors**!private! !
cNamedArgs!**compiled accessors**!private! !
cNamedArgs:!**compiled accessors**!private! !
names:named:args:!accessing!public! !
propertyPut:value:!accessing!public! !
propertyPutValue:!accessing!public! !
rgdispidNamedArgs!**compiled accessors**!public! !
rgdispidNamedArgs:!**compiled accessors**!public! !
rgvarg!**compiled accessors**!public! !
rgvarg:!**compiled accessors**!public! !
singleArg!accessing!public! !
!

!OS.COM.DISPPARAMS class methodsFor!

byteSize
	^_DISPPARAMS_Size!

defineFields
	"Define the fields of the DISPPARAMSstructure.

		DISPPARAMS compileDefinition.

		typedef struct  tagDISPPARAMS
		{
			/* [size_is] */ VARIANTARG __RPC_FAR *rgvarg;
			/* [size_is] */ DISPID __RPC_FAR *rgdispidNamedArgs;
			UINT cArgs;
			UINT cNamedArgs;
	    } DISPPARAMS;
	"

	self
		defineField: #rgvarg
			type: (StructureArrayPointerField type: VARIANT
					arrayLength: (ConformantArrayFieldLength lengthField: #cArgs));
		defineField: #rgdispidNamedArgs
			type: (ArrayPointerField type: Int32Array
					arrayLength: (ConformantArrayFieldLength lengthField: #cNamedArgs));
		defineField: #cArgs type: UInt32Field new beNonBrowsable;
		defineField: #cNamedArgs type: UInt32Field new beNonBrowsable!

getFieldNames
	^#(#rgvarg #rgdispidNamedArgs #cArgs #cNamedArgs)!

initialize
	"Private - Initialize the receiver's class variables.
		DISPPARAMS new
	"

	ZeroArgs := self new!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	ZeroArgs := nil!

with: arg
	"Answer an instance of the receiver with the single <variantCompatible>
	parameter, arg."

	^self new
		arg: arg;
		yourself!

withArguments: args
	"Answer an instance of the receiver with parameters from the
	<sequencedReadableCollection> of <variantCompatible> objects,
	args."

	^self new
		args: args;
		yourself!

zeroArgs
	"Answer an instance of the receiver suitable for passing to Invoke() where there
	are no arguments."

	^ZeroArgs! !

!OS.COM.DISPPARAMS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
with:!instance creation!public! !
withArguments:!instance creation!public! !
zeroArgs!instance creation!public! !
!

