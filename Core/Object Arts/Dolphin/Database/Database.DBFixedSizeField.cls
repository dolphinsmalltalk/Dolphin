"Filed out from Dolphin Smalltalk"!

Database.DBField
	subclass: #'Database.DBFixedSizeField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBFixedSizeField guid: (Core.GUID fromString: '{c6cf9438-7cb8-4c51-b5a1-f2630c29fb8f}')!

Database.DBFixedSizeField isNonInstantiable: true!

Database.DBFixedSizeField comment: ''!

!Database.DBFixedSizeField methodsFor!

bindAsParameter: anInteger of: aDBParameterizedStatement
	"Private - Bind the receiver as the supplier of data for the parameter numbered, anInteger, of aDBParameterizedStatement. For fixed-sized fields, the buffer is bound directly so that data transfer occurs on exec without the need for SQLPutData calls."

	aDBParameterizedStatement dbCheckException: (OS.ODBCLibrary default
				sqlBindParameter: aDBParameterizedStatement allocatedHandle
				parameterNumber: anInteger
				inputOutputType: column parameterType
				valueType: buffer dbInterchangeType
				parameterType: column type
				columnSize: column precision
				decimalDigits: column scale
				parameterValuePtr: buffer
				bufferLength: buffer byteSize
				strLenOrIndPtr: lengthBuf)
		function: 'SQLBindParameter'! !

!Database.DBFixedSizeField categoriesForMethods!
bindAsParameter:of:!operations!private! !
!

