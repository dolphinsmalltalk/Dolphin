"Filed out from Dolphin Smalltalk"!

Database.DBField subclass: #DBFixedSizeField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DBFixedSizeField guid: (GUID fromString: '{c6cf9438-7cb8-4c51-b5a1-f2630c29fb8f}')!

DBFixedSizeField isAbstract: true!

DBFixedSizeField comment: ''!

!DBFixedSizeField categoriesForClass!Unclassified! !

!DBFixedSizeField methodsFor!

bindAsParameter: anInteger of: aDBParameterizedStatement
	"Private - Bind the receiver as the supplier of data for the parameter numbered, anInteger, of aDBParameterizedStatement. For fixed-sized fields, the buffer is bound directly so that data transfer occurs on exec without the need for SQLPutData calls."

	aDBParameterizedStatement dbCheckException: (ODBCLibrary default
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

!DBFixedSizeField categoriesForMethods!
bindAsParameter:of:!operations!private! !
!

