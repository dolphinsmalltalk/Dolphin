"Filed out from Dolphin Smalltalk 7"!

External.Field subclass: #'External.ScalarField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ScalarField guid: (Core.GUID fromString: '{87b4c4dd-026e-11d3-9fd7-00a0cc3e4a32}')!
External.ScalarField isNonInstantiable: true!
External.ScalarField comment: '<ScalarField> is the abstract class of <ExternalField>s to describe <ExternalStructure> fields of simple scalar types, e.g. ints, boolean, etc.'!
!External.ScalarField categoriesForClass!External-Data-Types! !
!External.ScalarField methodsFor!

accessorMessage
	"Private - Answer the stem of the accessor message used to access the value of the field
	described by the receiver in a structure."

	^self subclassResponsibility!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	This is fixed for ScalarFields."

	^self class byteSize!

valueType
	^Integer! !
!External.ScalarField categoriesFor: #accessorMessage!automatic generation!private! !
!External.ScalarField categoriesFor: #byteSize!constants!private! !
!External.ScalarField categoriesFor: #valueType!automatic generation!constants!development!private! !

!External.ScalarField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A large number of fields are the same size as an integer."

	^VMConstants.IntSize! !
!External.ScalarField class categoriesFor: #byteSize!constants!private! !

