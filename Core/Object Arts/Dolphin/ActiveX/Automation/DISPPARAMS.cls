"Filed out from Dolphin Smalltalk X6.1"!

OLEStructure subclass: #DISPPARAMS
	instanceVariableNames: 'args vargs dispids'
	classVariableNames: 'ZeroArgs'
	poolDictionaries: 'AXAutomationConstants'
	classInstanceVariableNames: ''!
DISPPARAMS guid: (GUID fromString: '{C06F3B6F-0868-11D3-93AF-00A024CA708A}')!
DISPPARAMS comment: 'DISPPARAMS is an <ExternalStructure> to represent the OLE Automation structure DISPPARAMS.

DISPPARAMS is the parameter block used in calls to IDispatch::Invoke. It contains an array of VARIANTARG structures (which are actually represented by the identical <VARIANT> structure in Dolphin), a count of the total number of arguments, an array of the <integer> DISPIDs of the so called "named" arguments, and a count of the number of named arguments in that array. The named arguments are assumed to appear first in the rgvarg array.

In general Dolphin does not use named arguments since these are not terribly well supported by Smalltalk syntax. The exception is for property put invocations, where their use is required.

Apart from the generated accessors for the structure members this class implements convenience methods to make it easy to set up late-bound calls of common types.

Fields:
	rgvarg		<VARIANT*> Array of arguments
	rgdispidNamedArgs	<SDWORD*> Array of ids of named arguments
	cArgs		<DWORD> Total number of named and unnamed arguments (size of rgvarg).
	cNamedArgs	<DWORD> Number of named arguments (size of rgdispidNamedArgs)'!
!DISPPARAMS categoriesForClass!External-Data-Structured-COM! !
!DISPPARAMS methodsFor!

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
	self rgvarg: vargs.
	self cArgs: argc!

cArgs
	"Answer the receiver's cArgs field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cArgs)!

cArgs: anObject 
	"Set the receiver's cArgs field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cArgs) put: anObject!

cNamedArgs
	"Answer the receiver's cNamedArgs field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #cNamedArgs)!

cNamedArgs: anObject 
	"Set the receiver's cNamedArgs field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #cNamedArgs) put: anObject!

names: names named: namedArgs args: unnamedArgs 
	"Set the receiver's arguments to be the <sequencedReadableCollection> of named arguments,
	namedArgs, the names (ids) of which are specified in the corresponding positions of the
	<sequencedReadableCollection>, dispids, and the <sequencedReadableCollection> of unnamed
	<Object> arguments, args."

	| argc cNamed cUnnamed |
	cNamed := namedArgs size.
	dispids := SDWORDArray new: cNamed.
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
	self cNamedArgs: cNamed.
	self rgvarg: vargs.
	self cArgs: argc!

propertyPut: item value: argument
	"Set up the receiver for a subscripted property put operation, with the specified <VARIANT> 
	subscript item and the VARIANT representation of the <Object>, value.
	There is some slight trickiness here as for some reason the property put argument must 
	always be 'named'. As the argument count includes the named arguments it is set to two."

	self args: (Array with: item with: argument).
	dispids := SDWORD fromInteger: DISPID_PROPERTYPUT.
	self rgdispidNamedArgs: dispids.
	self cNamedArgs: 1!

propertyPutValue: argument
	"Set up the receiver for an unsubscripted property put operation to set the value of a property
	to the VARIANT representation of the <Object>, argument.
	There is some slight trickiness here as for some reason the property put argument must always be
	'named'. Note also that the argument count includes the named arguments, so in this case both
	should be one."

	self arg: argument.
	dispids := SDWORD fromInteger: DISPID_PROPERTYPUT.
	self rgdispidNamedArgs: dispids.
	self cNamedArgs: 1!

rgdispidNamedArgs
	"Answer the receiver's rgdispidNamedArgs field as a Smalltalk object."

	^StructureArray 
		fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #rgdispidNamedArgs))
		length: self cNamedArgs
		elementClass: SDWORD!

rgdispidNamedArgs: anObject 
	"Set the receiver's rgdispidNamedArgs field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #rgdispidNamedArgs) put: anObject yourAddress!

rgvarg
	"Answer the receiver's rgvarg field as a Smalltalk object."

	^StructureArray 
		fromAddress: (bytes intPtrAtOffset: 0)
		length: self cArgs
		elementClass: VARIANT!

rgvarg: anObject 
	"Set the receiver's rgvarg field to the value of anObject."

	bytes uintPtrAtOffset: 0 put: anObject yourAddress!

singleArg
	"Answer the single VARIANT parameter - assumes cArgs == 1"

	^VARIANT fromAddress: (bytes intPtrAtOffset: 0)! !
!DISPPARAMS categoriesFor: #arg:!accessing!public! !
!DISPPARAMS categoriesFor: #args:!accessing!public! !
!DISPPARAMS categoriesFor: #cArgs!**compiled accessors**!public! !
!DISPPARAMS categoriesFor: #cArgs:!**compiled accessors**!public! !
!DISPPARAMS categoriesFor: #cNamedArgs!**compiled accessors**!public! !
!DISPPARAMS categoriesFor: #cNamedArgs:!**compiled accessors**!public! !
!DISPPARAMS categoriesFor: #names:named:args:!accessing!public! !
!DISPPARAMS categoriesFor: #propertyPut:value:!accessing!public! !
!DISPPARAMS categoriesFor: #propertyPutValue:!accessing!public! !
!DISPPARAMS categoriesFor: #rgdispidNamedArgs!**compiled accessors**!public! !
!DISPPARAMS categoriesFor: #rgdispidNamedArgs:!**compiled accessors**!public! !
!DISPPARAMS categoriesFor: #rgvarg!**compiled accessors**!public! !
!DISPPARAMS categoriesFor: #rgvarg:!**compiled accessors**!public! !
!DISPPARAMS categoriesFor: #singleArg!accessing!public! !

!DISPPARAMS class methodsFor!

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
		defineField: #rgvarg type: (ConformantStructureArrayPointerField type: VARIANT length: #cArgs);
		defineField: #rgdispidNamedArgs
			type: (ConformantStructureArrayPointerField type: SDWORD length: #cNamedArgs);
		defineField: #cArgs type: DWORDField new;
		defineField: #cNamedArgs type: DWORDField new!

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
!DISPPARAMS class categoriesFor: #defineFields!initializing!public! !
!DISPPARAMS class categoriesFor: #initialize!development!initializing!private! !
!DISPPARAMS class categoriesFor: #uninitialize!initializing!private! !
!DISPPARAMS class categoriesFor: #with:!instance creation!public! !
!DISPPARAMS class categoriesFor: #withArguments:!instance creation!public! !
!DISPPARAMS class categoriesFor: #zeroArgs!instance creation!public! !

